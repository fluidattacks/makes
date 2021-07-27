{ makeSearchPaths
, ...
}:
{ node
, nodeModules
}:
makeSearchPaths {
  bin = [ node ];
  nodeBin = [ nodeModules ];
  nodeModule = [ nodeModules ];
}
