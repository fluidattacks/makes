{
  rules = {
    always = { "when" = "always"; };
    branch = branch: {
      "if" = ''$CI_COMMIT_BRANCH != "${branch}"'';
      "when" = "never";
    };
    branchNot = branch: {
      "if" = ''$CI_COMMIT_BRANCH == "${branch}"'';
      "when" = "never";
    };
    notMrs = {
      "if" = ''$CI_PIPELINE_SOURCE == "merge_request_event"'';
      "when" = "never";
    };
    notSchedules = {
      "if" = ''$CI_PIPELINE_SOURCE == "schedule"'';
      "when" = "never";
    };
    notTriggers = {
      "if" = ''$CI_PIPELINE_SOURCE == "trigger"'';
      "when" = "never";
    };
    schedules = {
      "if" = ''$CI_PIPELINE_SOURCE != "schedule"'';
      "when" = "never";
    };
    titleMatching = pattern: { "if" = "$CI_COMMIT_TITLE =~ /${pattern}/"; };
    varIsDefined = var: {
      "if" = "\$${var} == null";
      "when" = "never";
    };
  };
}
