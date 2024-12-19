{ makeScript, __nixpkgs__, ... }: {
  jobs."/tests/commitlint" = makeScript {
    name = "commitlint";
    entrypoint = ''
      pushd tests/commitlint

      commit_hash="$(git --no-pager log --pretty=%h origin/main..HEAD)"

      info "Linting commit $commit_hash"
      git log -1 --pretty=%B $commit_hash | commitlint --parser-preset ./parser.js --config ./config.js
    '';
    searchPaths.bin = [ __nixpkgs__.commitlint __nixpkgs__.git ];
  };
}
