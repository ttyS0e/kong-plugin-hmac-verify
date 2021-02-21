-- schema.lua
local typedefs = require "kong.db.schema.typedefs"


return {
  name = "hmac-verify",
  fields = {
    {
      consumer = typedefs.no_consumer
    },
    {
      protocols = typedefs.protocols_http
    },
    {
      config = {
        type = "record",
        fields = {
          {
            hmac_secret = {
              type = "string",
            },
          },
          {
            incoming_signature_header = {
              type = "string",
            },
          },
        },
      },
    },
  },
}
