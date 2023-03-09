## chunks

Split a given list into N chunks
for workload distributed parallelization.

Types:

- chunks (`function list, ints.positive -> listOf (listOf Any)`):

  - (`list`):
    List to split into chunks.
  - (`ints.positive`):
    Number of chunks to create from list.

Example:

```nix
{
  chunks,
  inputs,
  makeDerivation,
  makeDerivationParallel,
}: let
numbers = [0 1 2 3 4 5 6 7 8 9];
myChunks =  chunks numbers 3; # [[0 1 2 3] [4 5 6] [7 8 9]]

buildNumber = n: makeDerivation {
  name = "build-number-${n}";
  env.envNumber = n;
  builder = ''
    echo "$envNumber"
    touch "$out"
  '';
};
in
  makeDerivationParallel {
    dependencies = builtins.map buildNumber (inputs.nixpkgs.lib.lists.elemAt myChunks 0);
    name = "build-numbers-0";
  }
```

## calculateCvss3

Calculate [CVSS3](https://www.first.org/cvss/v3.0/specification-document)
score and severity for a
[CVSS3 Vector String](https://www.first.org/cvss/v3.0/specification-document#Vector-String).

Types:

- calculateCvss3 (`function str -> package`):

  - (`str`):
    CVSS3 Vector String
    to calculate.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makeScript
, calculateCvss3
, ...
}:
makeScript {
  replace = {
    __argCalculate__ = calculateCvss3
      "CVSS:3.0/S:C/C:H/I:H/A:N/AV:P/AC:H/PR:H/UI:R/E:H/RL:O/RC:R/CR:H/IR:X/AR:X/MAC:H/MPR:X/MUI:X/MC:L/MA:X";
  };
  entrypoint = ''
    cat "__argCalculate__"
  '';
  name = "example";
}
```

```bash
$ m . /example

    {"score": {"base": 6.5, "temporal": 6.0, "environmental": 5.3}, "severity": {"base": "Medium", "temporal": "Medium", "environmental": "Medium"}}
```

## makeSslCertificate

Self sign certificates
by using the `openssl req` command,
then using `openssl x509`
to print out the certificate
in text form.

Types:

- makeSslCertificate (`function { ... } -> package`):

  - days (`ints.positive`): Optional.
    Ammount of days to certify the certificate for.
    Defaults to `30`.
  - keyType (`str`): Optional.
    Defines the key type for the certificate
    (option used for the `-newkey` option on the `req` command).
    It uses the form `rsa:nbits`, where `nbits` is the number of bits.
    Defaults to `rsa:4096`.
  - name (`str`):
    Custom name to assign to the build step, be creative, it helps in debugging.
  - options (`listOf (listOf str)`):
    Contains a list of options to create the certificate with your own needs.
    Here you can use the same options used with `openssl req`.

Example:

```nix
# /path/to/my/project/makes/example/main.nix
{ makeScript
, makeSslCertificate
, ...
}:
let
  sslCertificate = makeSslCertificate {
    name = "name-example";
    options = [
      [ "-subj" "/CN=localhost" ]
    ];
  };
in
makeScript {
  replace = {
    __argSslCertificate__ = sslCertificate;
  };
  entrypoint = ''
    cat "__argSslCertificate__"
  '';
  name = "example";
}

```

```bash
$ m . /example

    -----BEGIN PRIVATE KEY-----
    MIIJQwIBADANBgkqhkiG9w0BAQEFAASCCS0wggkpAgEAAoICAQDQ/tFdIW3kL1IJ
    hjD11ZTTDvMXlO+Zm3Oc3Z67Kb9llNpdgyDXBXyFriAfDsDAw/Hrp7zSqzNMT5Qh
    fc1OFhM2ICuPaFCQONKsOulo3LhdjXfSDuvu1k0XMF0cDOVwhQkxYdsE9/jZQUSi
    CB4I2A8LLnkMvZ+ANJIFzjkxey2A+v3KMeE5aw2PLqj8H+jAuxM56fCgFrXhhmPh
    U6HNlhf+dvaV/PHjpr66HJf8gF/DwhzQ+ppYbVsBnuvzmiTz/dix9wu7m3/RxVIM
    OwEPcZU2VCXT2MCtXKd6H+h8vEdx1xrLYRTWUhrOnNgNrblXhlpo0frI6XloujR3
    o5x18/GjCht6gx3D/ze+g6bhgGVUxMIMuM5uCLyOxCG/M23WaAZVOgseqnggCVP7
    MA/c7sd+cIWfS5Yi04G0vXkiQDUMOhRIZM2CFKr6Lyi6hdU2bUkx9gWSQWPMcwko
    kFRkv1UpzWMfD8nMphuWwMJZckNDrmUb4kK8bfum/Q+9/EYNREEpDxz6OUNezjbq
    g5r8lFNcfmAySZXFGSZdANS+u1CpcyWzMtgUIvjtANeqjJw+zOMqQBBeSROpgusY
    z9N8G3ZPkArIKTpKRpPdwfIPCALd5ZLrdZAJMuPTHBFGRn/oxWg/zHNYBkLTiPAJ
    R9V8mz4Q59WFoF92vNmPVp1bcBtqjQIDAQABAoICAETZjXNWzfL8O9RzZrG1+N9G
    74J3SC+cbIvi3qXd7PW0AfQIfMsZPZp0cJSKsalPY+U0Txo/2BhtpukZnob48r9D
    /dWykcfRUGX4ymgHPp1jO3PyAnueEatv/Vx+Sx+0VAD2scaDQnGf9NJERlC3jM0s
    NCikV2VO7EQJWgIZCDaTeQQhRoc54y+mOXlFsdG8T2smzGSQ1r5DHahfetBVf/YO
    jtF+kNlkVzTMsq02RVYiHogh5rL246I3Dpgj0cSnfbmzHyRg58zdalgpIAJMctGB
    Cy0tHNx/x5SN6nMdO5QfPu59PvYT+kzSksJ+1q4kzqf1dN63O43qudooBiU9hf6N
    RrocVXwr/vXyo78gOKN706guxf5VP3+4ldeV5AP2tCSEsI0D2H/Mbt3PlLce6zxc
    BMb6lpM6XddMXkqU993ewhMqRMvvSuqNXuHp6dYmt76v0yL3GwaB3rqt1BtwPwOx
    TNmoP4wcoAjKL1Q66cIFW9oZT+XuxZFn57Ch6hrxNLKzEOgtbGtuCNuCQoDVBWX5
    CLj2Oh+rK9v0Zmz4NNNDsmY3m3ViMQz4i52PuChtm3E/2dR1GsoQsy8Js3IWC9g+
    Kr7cGyL3KcOVc7snx6d6CRqKaZTsiDOX5GlQbHb3KKUAVJlGB37rXITy/yFnPffz
    Rv91dVb/RFucmagBDUABAoIBAQD5A3+sHjQYgQI10ceiqEDqzqyjAog4Jg91Qt8M
    qII8fUZC2yUF2kyHYeokEr4LXiYSS5GvNJ0Fm8BF4/ShuRECkU+tG73Y8JMChjfD
    CU89d0G4X2I6AZShOAaWd4ypW5CsoVC7fa5Jzbd/C8RucXDJlZQlpl0Dr4VEs53Y
    +a6uSmw4EPMTTrCLH2bqWXLuW3reaZM38QrbLhk5kZRTYvo2YOdmfscFop4TbEJF
    qpOA0E2N5iWUnU4K6fVcBKIycsz2Ao9D1Jk1NzZGxvcvc0YxjoBSyqLZOZ9Z3Wh7
    YkfyUs4TuaEHP6/JxGBWTs7jmKdigeFfsNYRS8BFdSs3jsgBAoIBAQDW2+TkJBm2
    oXbTIuNSoYxdJocdScktLAfVH+YzrSQ78dbSs5hcVwS0WugD30Fr1n0cZ7EttbZE
    FF5ZxzqHVV0mrMH64OiuhVTW6bXzlJ+V6bs4Sq/fL/iiEIoNm5D2GNrWbcYEIJ8h
    Fj6QOyp8VnkAfLmYTb5ohlNQVZLr8IMpeTF4vQUCkP9umtn0S+lp8ZXNy6yTNSay
    mqxbZ0pju79nk+W99TapM4FNXLoHjtkqBVu4XYlS4qX8gd1plMzZdSvUW8fWjUhR
    BvbW+dqxCuryBjbHkB7rl3dSFFvl8I3JPy4fiIkHln3OEe0Cpas/IrTY+xshA3kt
    kMNE+3SO50KNAoIBAQDF0Wi4dBoQqVP3K1r7tcw0fNEagmVyrZG0JtaI+MjVgvOx
    IuSLfLs1Baz60UTWRQnbmNr4I8Tl8rBRFWF+pEWGE6gHLjWoRJ2U8MkVkKy5eKbl
    8ChZSm4nkRlyqTA+TjZlXZWEDLjLerheHhwDXO0rxz80la/owKQPSt2Hw/poDUlh
    VN21pdqL+vtICp1KC7RVQeupEjz8l+eEG0mI4OVDE8JgYzB6IpCPf346V+Lr/w7N
    Plr2b+zSsL+xRSERELAQc0IasaawZtcgbOlrcZj+v2Tj4IR0KtmTi1d4RUBAmlWJ
    x/rLhmWA1RdvGRY0Kk427FT9Lr8waEwrIYSekzgBAoIBACEDjLoZafIMAUwT8kYC
    GKU/hEdVzRmpyFJRIngSRJ0JXe7mNaUKoehsh3YA2faN8I9qx2i0oRr43j6BRFcD
    INsOdIfuAxK93flf09tnnNXWIjRWFYv/vP55+Bx7KN0HmKiWGXUM5iaZWmejD7Yn
    O1R91a63U2iQK0EOxRKH1D+NJbLdqGVqjjUaih7lgyoKOvByOUQtSJLs/UrWJjII
    6TIrIYP8p7d7+IRAmT0MEAZK6Hr9tFoOBV81PSY5/Pf07xUkPSKUduYsYcVKgvXt
    LYiet9AWLwoYLfdotW4xdjfUA2xI+HU4BICjdH2RoyyCUrN8cgCyne4IblitIo3K
    rwkCggEBAN0xdTlbZEI/r1O3iDNJXcXJg3HUMj78pz7c32ROMS2iwsQTyj+IHui8
    0J2FOdZ8TUlgoBfi3C1Y2NyNdyAJ3jiHnCrQz/sqTRYGds+aALfw1YZZuonUXAwc
    OxCZcMowzTvx5iCcaCY9jsdrr4TYGWSf2wmzSD87EYqNKLTd4asOCILatTWMw0AR
    xBHKugWHSokf9SNzirqxSNeqjjepMTA95LRiijKQAu9yhj0Zs35EUIu88KA5PZ4q
    0+URRTIuCtyjKBFC5qBhvbWzKe46hSy6OPyJFPgyo4OCC0NkesLQKcJwfTckK8Ne
    mSjLja2l8YqKkXqV6P3R6wVLMvCoCao=
    -----END PRIVATE KEY-----

```

## sublist

Return a sublist of a given list using a starting and an ending index.

Types:

- sublist (`function list, ints.positive, ints.positive -> listOf Any`):

  - (`list`):
    List to get sublist from.
  - (`ints.positive`):
    Starting list index.
  - (`ints.positive`):
    Ending list index.

Example:

```nix
{
  sublist,
}: let
  list = [0 1 2 3 4 5 6 7 8 9];
  sublist = sublist list 3 5; # [3 4]
in {
  inherit sublist;
}
```
