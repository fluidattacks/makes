{ makeScript, ... }: {
  jobs."/tests/makeScript" = makeScript {
    entrypoint = "echo A script with a help, call with --help or -h to see it!";
    name = "help";
    help = ./README.md;
  };
}
