# stack-coredns

The `joris.internal` nameservers are best described as a "composed DNS resolver". The intented use of these nameservers is to function as DNS resolvers that can be used to resolve internal services and devices while also remaining capable of resolving public domain names without any extra configuration being necessary.

## Examples
Some examples of the domains that are intended to be specifically resolvable by this project:

- `example` / `example.joris.internal`[^1] / `example.devices.joris.internal`
    - Resolves to the Tailscale IP of the device called `example`.
    - These are backed by the local MagicDNS daemons running on the nameserver machines.
- `myservice` / `myservice.joris.internal`[^1] / `myservice.services.joris.internal`
    - Resolves to the Tailscale IP of the device that is hosting the service called `myservice`.
    - These domains are actually backed by the `*.services.joris.me` public DNS records, which is managed using Cloudflare DNS. This makes it incredibly easy to add, change or remove such associations.
- `google.com` => Resolves as normal via Cloudflare DNS-over-TLS.

[^1]: When a device and a service have the same name, the **service** takes precedence. This is to ensure that services remain reachable at all times.

# In this repository
In this repository, you will find multiple Dockerfiles and Corefiles used to configure CoreDNS, for both testing and production.

## [corends](coredns/README.md)
This is the base CoreDNS image with some additional plugins installed required for a full deployment. It comes with a rudimentary [Corefile](/dns-base/Corefile) configured with the [whoami](https://coredns.io/plugins/whoami/) plugin. More information in the corresponding [README](coredns/README.md).

## cfg-mock-cloudflare
This is a configuration based on the `coredns` image defined in this repository. It mimicks the behavior of the public [Cloudflare resolver](https://1.1.1.1/) for the purposes of testing the [cfg-prod](#cfg-prod) below. **Used for testing purposes only.**

## cfg-mock-tailscale
This image is also based on `dns-base`, but instead pretends to be a local [Tailscale](https://tailscale.net/) [MagicDNS](https://tailscale.com/kb/1081/magicdns/) daemon.

It can resolve domains in the form of `deviceX.network-name.ts.net`, where:
- `X` is either `1`, `2` or `3`;
- `network-name` is replaced with the name of the Tailnet that is being mocked. The `TS_ENV` environment variable is used for specifying this upon startup.

## cfg-prod
As the name suggests, this is the full production delegating DNS resolver, performing all necessary transformations and delegating to the [dns-mock-cloudflare](#dns-mock-cloudflare) and [dns-mock-tailscale](#dns-mock-tailscale) resolvers when applicable.

# DNS resolution

The DNS resolution process works as follows. Each line is basically a pattern matching expression.
If the requested URL does not 

- `somename`:
    - Transformed to `somename.joris`,
    - Forwarded internally.
- `somename.joris` is handled **with fallthrough** if the first option does not resolve:
    1. Attempt to resolve **as a service**:
        - Transformed to `somename.services.joris`;
        - Forwarded internally;
        - Results are transformed back.
    2. Attempt to resolve **as a device**:
        - Transformed to `somename.devices.joris`;
        - Forwarded internally;
        - Results are transformed back.
- `somename.services.joris`:
    - Transformed to `somename.services.joris.me`;
    - Forwarded to **Cloudflare**;
    - Results are transformed back.
- `somename.devices.joris`:
    - Transformed to `somename.<network-name>.ts.net`,
    - Forwarded to local Tailscale MagicDNS daemon,
    - Response is converted back to `somename.devices.joris` upon receiving a result.
- All other cases:
    - Forwarded to **Cloudflare** as-is.
