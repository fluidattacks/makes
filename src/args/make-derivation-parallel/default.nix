{ toFileJson, ... }:
{ dependencies, name, }:
toFileJson "make-derivation-parallel-for-${name}" dependencies
