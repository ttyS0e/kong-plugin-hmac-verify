# Kong Gateway Plugin - HMAC Verification

This is a Kong plugin that is attached to **routes**. It will verify the HMAC signature of the incoming HTTP body, and reject the message if the verification fails.

This allows you to use Kong as a webhook gateway for e.g. GitHub, preventing the need to open a private CI/CD server to the WWW and reducing network attack surface.

## Installation

Assuming you have Kong Enterprise >2.2 installed already, you need only clone this repository at the **main** head and run :

```sh
luarocks make
```

This will install the plugin into the Lua packages root, and so if running containerised Kong should be executed during the container build process, or as a pre-entrypoint command.

See rockspec for required packages, if building manually.

## Usage

POST the plugin configuration to your Kong admin API, for example:

```
{
    "enabled": true,
    "protocols": [
        "http",
        "https"
    ],
    "name": "hmac-verify",
    "route": {
        "id": "01234567-89ab-cdef-ghij-klmnopqrstuv"
    },
    "config": {
        "hmac_secret": "0123456789abcdefghijklmnopqrstuvwxyz0123",
        "incoming_signature_header": "X-Hub-Signature-256"
    }
}
```

**That's it** - you will get a 401 code for Unauthorized if any request on that route does not contain a valid header that matches the HMAC signature of the body. Otherwise, the request will pass through unmodified.

## Supported Signature Algorithms

Currently, the algorithm support is limited to:

* sha256
