package = "hmac-verify"
version = "dev-1"
source = {
   url = "https://github.com/ttyS0e/kong-plugin-hmac-verify"
}
description = {
   homepage = "https://github.com/ttyS0e/kong-plugin-hmac-verify",
   license = "GNU GENERAL PUBLIC LICENSE VERSION 2"
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.hmac-verify.handler"] = "kong/plugins/hmac-verify/handler.lua",
      ["kong.plugins.hmac-verify.schema"] = "kong/plugins/hmac-verify/schema.lua"
   }
}
