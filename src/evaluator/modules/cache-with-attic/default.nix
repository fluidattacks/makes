# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{listOptional, ...}: {
  config,
  lib,
  ...
}: {
  options = {
    cacheWithAttic = {
      readAndWrite = {
        enable = lib.mkOption {
          default = false;
          type = lib.types.bool;
        };
        name = lib.mkOption {
          type = lib.types.str;
        };
        url = lib.mkOption {
            type = lib.types.str;
        };
        token = lib.mkOption {
            type= lib.types.str;
        };
        pubKey = lib.mkOption {
          type = lib.types.str;
        };
        priority = lib.mkOption {
          type = lib.type.int;
          default = 10;
        };
      };
    };
  };
  config = {
    config = {
      cacheWithAttic = builtins.concatLists [
        (listOptional config.cacheWithAttic.readAndWrite.enable {
          name= config.cacheWithAttic.readAndWrite.name;
          url= config.cacheWithAttic.readAndWrite.url;
          token= config.cacheWithAttic.readAndWrite.token;
          pubKey= config.cacheWithAttic.readAndWrite.pubKey;
          type = "attic";
        })
      ];
    };
  };
}
