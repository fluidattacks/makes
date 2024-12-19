{
  pipelines.example = {
    gitlabPath = "/tests/pipelines/.gitlab-ci.yaml";
    jobs = [ { output = "/lintNix"; } { output = "/formatNix"; } ];
  };
}
