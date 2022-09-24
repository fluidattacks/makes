<!--
SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors

SPDX-License-Identifier: MIT
-->

# Software Assurance

This is what user can expect from Makes in terms of security:

- The Makes CLI application is free of known security vulnerabilities.

  - The dependencies of the Makes CLI application
    are free of known security vulnerabilities.

    - [Dependabot alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts)
      are enabled for the repository.

      Proof:

      - As a project maintainer,
        you can see if Dependabot is enabled
        [here](https://github.com/fluidattacks/makes/security/dependabot).
      - As an external user,
        there is no way to verify
        if Dependabot is enabled
        because the configuration page for this
        is only available to repository maintainers.
        However,
        it is possible to see the pull requests created by the bot,
        for example:
        [PR 927](https://github.com/fluidattacks/makes/pull/927).
        Additionally,
        an external user could check
        if there has been Dependabot pull requests recently
        by checking the
        [pull requests history](https://github.com/fluidattacks/makes/pulls).
        It is important to note
        that if no recent pull requests exist
        it may mean
        that no known security vulnerabilities have been found,
        and not necessarily that this claim is false.

<!--  -->

## References

- Rhodes, T. , Boland Jr., F. , Fong, E. and Kass, M. (2009),
  Software Assurance Using Structured Assurance Case Models,
  NIST Interagency/Internal Report (NISTIR),
  National Institute of Standards and Technology,
  Gaithersburg, MD, [online],
  https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=902688
  (Accessed September 23, 2022)
