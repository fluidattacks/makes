attrset: name: default:
if builtins.hasAttr name attrset then builtins.getAttr name attrset else default
