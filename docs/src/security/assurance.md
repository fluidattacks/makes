# Software Assurance

This is what user can expect from Makes in terms of security,
the notation is that of a _Structured Assurance Case Model_[^1].

- The Makes CLI application is free of known security vulnerabilities.

    - The Python code of the Makes CLI application
        is free of known security vulnerabilities.

        - [SonarCloud](https://sonarcloud.io/)
            reviews every pull request.

            Proof:

            - You can check the
                [SonarCloud pull requests list for Makes](https://sonarcloud.io/project/pull_requests_list?id=fluidattacks_makes)

            - You can check the
                [pull requests history](https://github.com/fluidattacks/makes/pulls)
                and see if the latest pull requests
                have a comment
                from SonarCloud.
                For example:
                [PR 925, Comment 1256837172](https://github.com/fluidattacks/makes/pull/925#issuecomment-1256837172)

        - Vulnerabilities count on [SonarCloud](https://sonarcloud.io/) is zero.

            Proof:

            - Visit the [SonarCloud dashboard](https://sonarcloud.io/project/overview?id=fluidattacks_makes).
                The vulnerabilities count should be zero.

    - The dependencies of the Makes CLI application
        are free of known security vulnerabilities.

        - [Fluid Attacks Continuous Hacking](https://fluidattacks.com/services/continuous-hacking/)
            tool is enabled for the repository.

        Proof:

        - You can check the Fluid Attacks [Certificate](https://res.cloudinary.com/fluid-attacks/image/upload/v1711043976/makes/security-cert.pdf)

## References

[^1]:

Rhodes, T. , Boland Jr., F. , Fong, E. and Kass, M. (2009),
Software Assurance Using Structured Assurance Case Models,
NIST Interagency/Internal Report (NISTIR),
National Institute of Standards and Technology,
Gaithersburg, MD, [online],
https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=902688
(Accessed September 23, 2022)
