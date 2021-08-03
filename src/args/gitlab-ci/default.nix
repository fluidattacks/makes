{
  rules = {
    branchMaster = {
      "if" = "$CI_COMMIT_BRANCH != \"master\"";
      "when" = "never";
    };
    notSchedules = {
      "if" = "$CI_PIPELINE_SOURCE == \"schedule\"";
      "when" = "never";
    };
    notTriggers = {
      "if" = "$CI_PIPELINE_SOURCE == \"trigger\"";
      "when" = "never";
    };
    titleMatching = pattern: {
      "if" = "$CI_COMMIT_TITLE =~ /${pattern}/";
    };
  };
}
