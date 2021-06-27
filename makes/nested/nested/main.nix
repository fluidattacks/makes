{ makeEntrypoint
, ...
}:
makeEntrypoint {
  entrypoint = "echo Hello from Makes!";
  name = "c";
}
