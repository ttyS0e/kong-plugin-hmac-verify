local BasePlugin = require "kong.plugins.base_plugin"
local to_hex = require("resty.string").to_hex

local CustomHandler = BasePlugin:extend()

CustomHandler.VERSION  = "1.0.0"
CustomHandler.PRIORITY = 10

local function split_string(inputstr, sep)
  if sep == nil then
    sep = "="
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local function return_unauthorised(err_message)
  return kong.response.error(401, err_message, nil)
end

function CustomHandler:new()
  CustomHandler.super.new(self, "hmac-verify")
end

function CustomHandler:access(config)
  CustomHandler.super.access(self)
  kong.log.debug("Configured header name -> " .. config.incoming_signature_header)

  -- try to get incoming header, as configured
  local incoming_sig_full = kong.request.get_header(config.incoming_signature_header)

  if incoming_sig_full == nil then
    -- obfuscate reasoning for 401
    return_unauthorised("Security header is missing")
  end

  -- validate
  kong.log.debug("Incoming sig header -> " .. incoming_sig_full)
  local incoming_sig_split = split_string(incoming_sig_full, "=")
  if table.getn(incoming_sig_split) ~= 2 then
    return return_unauthorised("Bad security header formatting")
  end

  -- this is super prototype, only support sha256 as known secure algorithm
  if incoming_sig_split[1] ~= "sha256" then
    return return_unauthorised("Unsupported or insecure hash algorithm in signature")
  end
  
  -- sig the request
  local get_raw_body = kong.request.get_raw_body
  local d, err = require("resty.openssl.hmac").new(config.hmac_secret, incoming_sig_split[1])
  d:update(get_raw_body())
  local body_sig, err = d:final()
  body_sig = to_hex(body_sig)

  -- compare the output to the http header
  if incoming_sig_split[2] ~= body_sig then
    return_unauthorised("Invalid signature")
  end

  return
end

return CustomHandler
