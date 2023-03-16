## cache

Configure caches to read,
and optionally a [Cachix](https://cachix.org/) cache for reading and writting.

Types:

- cache:
  - extra: (attrsOf (cacheExtra))
  - readNixos (`bool`): Optional.
    Set to `true` in order to add https://cache.nixos.org as a read cache.
    Defaults to `true`.
- cacheExtra:
  - enable (`str`): Read from cache.
    is read on the server.
  - pubKey (`str`): Public key of the cache server.
  - token (`str`): The name of the environment variable that contains the
    token to push the cache.
  - type: (`enum [cachix]`): Binary cache type.
    Can be [Cachix](https://docs.cachix.org/).
  - url (`str`):
    URL of the cache.
  - write (`bool`): Enable pushing derivations to the cache. Requires `token`.

Required environment variables:

- `CACHIX_AUTH_TOKEN`: API token of the Cachix cache.
  - For Public caches:
    If not set the cache will be read, but not written to.
  - For private caches:
    If not set the cache won't be read, nor written to.

Example:

=== "makes.nix"

    ```nix
    {
      cache = {
        readNixos = true;
        extra = {
          main = {
            enable = true;
            pubKey = "makes.cachix.org-1:zO7UjWLTRR8Vfzkgsu1PESjmb6ymy1e4OE9YfMmCQR4=";
            token = "CACHIX_AUTH_TOKEN";
            type = "nixos";
            url = "https://makes.cachix.org?priority=2";
            write = true;
          };
        };
      };
    }
    ```

### Configuring trusted-users

If you decided to go
with a Multi-user installation
when installing Nix,
you will have to take additional steps
in order to make the cache work.

As the Multi-user installation
does not trust your user by default,
you will have to add yourself
to the `trusted-users` in the
[Nix Configuration File](https://www.mankier.com/5/nix.conf).
