dotfilesDir: (
  let 
    subdirs = map 
      (subdir: dotfilesDir + "/${subdir}")
      (lib.mapAttrsToList (name: value: name) (readDir dotfilesDir));
    # subdirs = "test";
      #(lib.mapAttrsToList (name: value: name) (builtins.readDir dotfilesDir));
      #
    recursivelyLink = (dir: set:
      builtins.mapAttrs (name: type:
        if !isNull (builtins.match ".*\.link-target.*" name) then
          #builtins.trace "test"
          {
            "${replaceStrings ["dot-" ".link-target"] ["." ""] dir}".source = lib.file.mkOutOfStoreSymlink (dotfilesDir + "/${dir}");
          }
        else if type == "directory" then
          #builtins.trace "test3"
          mkMerge [set (recursivelyLink (dir + "/${name}") set)]
        else
          {}
      ) (builtins.readDir dir)
    );
  in
    mkMerge (map (recursivelyLink dir {}) subdirs);
);
