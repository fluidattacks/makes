## calculateScorecard

Calculate your remote repository [Scorecard](https://github.com/ossf/scorecard).
This module is only
available for [GitHub](https://github.com) projects at the moment.

Pre-requisites:

1. To run this module you need to set up a valid `GITHUB_AUTH_TOKEN` on your
    target repository. You can set this up in your CI or locally to run this
    check on your machine.

Types:

- checks (`listOf str`): Optional,
    defaults to all the checks available for Scorecard:

    ```nix
    [
      "Branch-Protection"
      "Fuzzing"
      "License"
      "SAST"
      "Binary-Artifacts"
      "Dependency-Update-Tool"
      "Pinned-Dependencies"
      "CI-Tests"
      "Code-Review"
      "Contributors"
      "Maintained"
      "Token-Permissions"
      "Security-Policy"
      "CII-Best-Practices"
      "Dangerous-Workflow"
      "Packaging"
      "Signed-Releases"
      "Vulnerabilities"
    ]
    ```

- format (`str`): Optional, defaults to JSON. This is the format which
    the scorecard will be printed. Accepted values are: `"default"` which is an
    `ASCII Table` and JSON.
- target (`str`): Mandatory, this is the repository url where you want to run
    scorecard.

Example:

=== "makes.nix"

    ```nix
    {
      calculateScorecard = {
        checks = [ "SAST" ];
        enable = true;
        format = "json"
        target = "github.com/fluidattacks/makes";
      };
    }
    ```

=== "Invocation"

    ```bash
    m . /calculateScorecard
    ...
    [INFO] Calculating Scorecard
    {
      "date": "2022-02-28",
      "repo": {
        "name": "github.com/fluidattacks/makes",
        "commit": "739dcdc0513c29de67406e543e1392ea194b3452"
      },
      "scorecard": {
        "version": "4.0.1",
        "commit": "c60b66bbc8b85286416d6ab9ae9324a095e66c94"
      },
      "score": 5,
      "checks": [
        {
          "details": [
            "Warn: 16 commits out of 30 are checked with a SAST tool",
            "Warn: CodeQL tool not detected"
          ],
          "score": 5,
          "reason": "SAST tool is not run on all commits -- score normalized to 5",
          "name": "SAST",
          "documentation": {
            "url": "https://github.com/ossf/scorecard/blob/c60b66bbc8b85286416d6ab9ae9324a095e66c94/docs/checks.md#sast",
            "short": "Determines if the project uses static code analysis."
          }
        }
      ],
      "metadata": null
    }
    [INFO] Aggregate score: 5
    ```
