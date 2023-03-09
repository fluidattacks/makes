## makePythonVersion

Get a specific Python interpreter.

Types:

- makePythonVersion (`function str -> package`):

  - (`enum ["3.8" "3.9" "3.10" "3.11"]`):
    Python version of the interpreter to return.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makePythonVersion
, makeScript
, ...
}:
makeScript {
  entrypoint = ''
    python --version
  '';
  name = "example";
  searchPaths = {
    bin = [ (makePythonVersion "3.8") ];
  };
}
```

```bash
$ m . /example

    Python 3.8.9
```

## makePythonPypiEnvironment

Create a virtual environment
where a provided set of Python packages
from [PyPi](https://pypi.org/)
is installed.

Pre-requisites: [Generating a sourcesYaml](#makepythonlock)

Types:

- makePythonPypiEnvironment (`function { ... } -> package`):

  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - searchPathsBuild (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`
    and used while installing the Python dependencies.
    Defaults to `makeSearchPaths`'s defaults.
  - searchPathsRuntime (`asIn makeSearchPaths`): Optional.
    Arguments here will be passed as-is to `makeSearchPaths`
    and propagated to the runtime environment.
    Defaults to `makeSearchPaths`'s defaults.
  - sourcesYaml (`package`):
    `sources.yaml` file
    computed as explained in the pre-requisites section.

  For building a few special packages you may need to boostrap
  dependencies in the build environment.
  The following flags are available for convenience:

  - withCython_0_29_24 (`bool`): Optional.
    Bootstrap cython 0.29.24 to the environment
    Defaults to `false`.
  - withNumpy_1_24_0 (`bool`): Optional.
    Bootstrap numpy 1.24.0 to the environment
    Defaults to `false`.
  - withSetuptools_57_4_0 (`bool`): Optional.
    Bootstrap setuptools 57.4.0 to the environment
    Defaults to `false`.
  - withSetuptoolsScm_5_0_2 (`bool`) Optional.
    Bootstrap setuptools-scm 5.0.2 to the environment
    Defaults to `false`.
  - withSetuptoolsScm_6_0_1 (`bool`) Optional.
    Bootstrap setuptools-scm 6.0.1 to the environment
    Defaults to `false`.
  - withWheel_0_37_0 (`bool`): Optional.
    Bootstrap wheel 0.37.0 to the environment
    Defaults to `false`.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ inputs
, makePythonPypiEnvironment
, projectPath
, ...
}:
makePythonPypiEnvironment {
  name = "example";
  # If some packages require compilers to be built,
  # you can provide them like this:
  searchPathsBuild = {
    bin = [ inputs.nixpkgs.gcc ];
  };
  # You can propagate packages to the runtime environment if needed, too
  searchPathsRuntime = {
    bin = [ inputs.nixpkgs.htop ];
  };
  sourcesYaml = projectPath "/makes/example/sources.yaml";
  # Other packages require a few bootstrapped dependencies,
  # enable them like this:
  withCython_0_29_24 = true;
  withSetuptools_57_4_0 = true;
  withSetuptoolsScm_6_0_1 = true;
  withWheel_0_37_0 = true;
}
```

`sourcesYaml` is generated like this:

```bash
$ cat /path/to/my/project/makes/example/dependencies.yaml

  Django: "3.2.6"

$ m github:fluidattacks/makes@23.04 /utils/makePythonLock \
    3.8 \
    /path/to/my/project/makes/example/dependencies.yaml \
    /path/to/my/project/makes/example/sources.yaml

  # ...

$ cat /path/to/my/project/makes/example/sources.yaml

  closure:
    asgiref: 3.4.1
    django: 3.2.6
    pytz: "2021.1"
    sqlparse: 0.4.1
  links:
    - name: Django-3.2.6-py3-none-any.whl
      sha256: 04qzllkmyl0g2fgdab55r7hv3vqswfdv32p77cgjj3ma54sl34kz
      url: https://pypi.org/packages/py3/D/Django/Django-3.2.6-py3-none-any.whl
    - name: Django-3.2.6.tar.gz
      sha256: 08p0gf1n548fjba76wspcj1jb3li6lr7xi87w2xq7hylr528azzj
      url: https://pypi.org/packages/source/D/Django/Django-3.2.6.tar.gz
    - name: pytz-2021.1-py2.py3-none-any.whl
      sha256: 1607gl2x9290ks5sa6dvqw9dgg1kwdf9fj9xcb9jw19nfwzcw47b
      url: https://pypi.org/packages/py2.py3/p/pytz/pytz-2021.1-py2.py3-none-any.whl
    - name: pytz-2021.1.tar.gz
      sha256: 1nn459q7zg20n75akxl3ljkykgw1ydc8nb05rx1y4f5zjh4ak943
      url: https://pypi.org/packages/source/p/pytz/pytz-2021.1.tar.gz
    - name: sqlparse-0.4.1-py3-none-any.whl
      sha256: 1l2f616scnhbx7nkzvwmiqvpjh97x11kz1v1bbqs3mnvk8vxwz01
      url: https://pypi.org/packages/py3/s/sqlparse/sqlparse-0.4.1-py3-none-any.whl
    - name: sqlparse-0.4.1.tar.gz
      sha256: 1s2l0jgi1v7rk7smzb99iamasaz22apfkczsphn3ci4wh8pgv48g
      url: https://pypi.org/packages/source/s/sqlparse/sqlparse-0.4.1.tar.gz
    - name: asgiref-3.4.1-py3-none-any.whl
      sha256: 052j8715bw39iywciicgfg5hxnsgmyvv7cg7fdb1fvwfj2m43hgz
      url: https://pypi.org/packages/py3/a/asgiref/asgiref-3.4.1-py3-none-any.whl
    - name: asgiref-3.4.1.tar.gz
      sha256: 1saqgpgbdvb8awzm0f0640j0im55hkrfzvcw683cgqw4ni3apwaf
      url: https://pypi.org/packages/source/a/asgiref/asgiref-3.4.1.tar.gz
  python: "3.8"
```
