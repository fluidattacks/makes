const HEADERLENGTHMAX = 60;
const LINELENGTHMAX = 72;
const BODYLENGTHMIN = 15;

module.exports = {
  parserPreset: "./parser.js",
  rules: {
    // Body
    "body-leading-blank": [2, "always"], // blank line between header and body
    "body-empty": [2, "never"], // body cannot be empty
    "body-max-line-length": [2, "always", LINELENGTHMAX], // body lines max chars LINELENGTHMAX
    "body-min-length": [2, "always", BODYLENGTHMIN], // body more than BODYLENGTHMIN chars

    // Footer
    "footer-leading-blank": [2, "always"], // blank line between body and footer
    "footer-max-line-length": [2, "always", LINELENGTHMAX], // footer lines max chars LINELENGTHMAX

    // Header
    "header-case": [2, "always", "lower-case"], // header lower case
    "header-max-length": [2, "always", HEADERLENGTHMAX], // header max chars HEADERLENGTHMAX

    // Scope
    "scope-empty": [2, "never"], // scope always
    "scope-enum": [
      2,
      "always",
      [
        "front", // Front-End change
        "back", // Back-End change
        "infra", // Infrastructure change
        "conf", // Configuration files change
        "build", // System component change (ci, scons, webpack...)
        "job", // asynchronous or schedule tasks (backups, maintainance...)
        "cross", // Mix of two or more scopes
        "doc", // Documentation only changes
      ],
    ],

    // Subject (commit title without type and scope)
    "subject-case": [2, "always", "lower-case"], // subject lower-case
    "subject-empty": [2, "never"], // subject always

    // Type
    "type-empty": [2, "never"], //type always
    "type-enum": [
      2,
      "always",
      [
        "feat", // New feature
        "perf", // Improves performance
        "fix", // Bug fix
        "rever", // Revert to a previous commit in history
        "style", // Do not affect the meaning of the code (formatting, etc)
        "refac", // Neither fixes a bug or adds a feature
        "test", // Adding missing tests or correcting existing tests
      ],
    ],
  },
};
