{
  pipelines = {
    example = {
      gitlabPath = "/tests/pipelines/.gitlab-ci.yaml";
      jobs = [
        {
          output = "/lintNix";
          args = [ ];
        }
        {
          output = "/helloWorld";
          args = [ "1" "2" "3" ];
        }
      ];
    };
  };
}
