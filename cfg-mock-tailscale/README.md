# Mock Tailscale
Pretends to be Tailscale. Used for testing purposes.

## Setup
Specify the following environment variables:

|Variable|Example|Description|
|-|-|-|
|`TS_NET`|`pug-universe`|Specify the Tailscale network to mock. Is suffixed by `.ts.net`.|

## Usage

This image registers four resolvable addresses:

|Record type|Name|Value|
|-|-|-|
|`A`|`apple.${TS_NET}`|`100.64.0.101`|
|`AAAA`|`apple.${TS_NET}`|`fd7a:115c:a1e0:ab12::1`|
|`A`|`banana.${TS_NET}`|`100.64.0.102`|
|`AAAA`|`banana.${TS_NET}`|`fd7a:115c:a1e0:ab12::2`|
|`A`|`orange.${TS_NET}`|`100.64.0.103`|
|`AAAA`|`orange.${TS_NET}`|`fd7a:115c:a1e0:ab12::3`|
|`A`|`pear.${TS_NET}`|`100.64.0.104`|
|`AAAA`|`pear.${TS_NET}`|`fd7a:115c:a1e0:ab12::4`|
