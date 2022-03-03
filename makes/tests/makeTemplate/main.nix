{ makeTemplate
, ...
}:
makeTemplate {
  replace = {
    __argFirst__ = "aaaaaaaaa";
    __argSecond__ = "bbbb";
    __argThird__ = "ccc";
  };
  name = "test-make-template";
  template = ./template.txt;
}
