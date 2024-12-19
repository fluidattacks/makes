{ fromYaml, makeTemplate, ... }:
let
  testFile = fromYaml (builtins.readFile ./test.yaml);
  testString = testFile.testTitle;
in {
  jobs."/tests/makeTemplate" = makeTemplate {
    replace = {
      __argFirst__ = "aaaaaaaaa";
      __argSecond__ = "bbbb";
      __argThird__ = testString;
    };
    name = "test-make-template";
    template = ./template.txt;
  };
}
