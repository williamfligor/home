self: super:
let
  installApp = import ../lib/installApp.nix super;
  installZipApp = import ../lib/installZipApp.nix super;
in
{
  alfred = installApp rec {
    pname = "Alfred";
    appname = "Alfred 4";
    version = "4.3.2";
    build = "1221";
    description = "Alfred for Mac";
    homepage = "https://www.alfredapp.com";
    src = {
      url = "https://cachefly.alfredapp.com/Alfred_${version}_${build}.dmg";
      sha256 = "0zlnzrzg3kxxvh6nr7nyhcfk84k5xqnwrm3v6595mydg084f0rai";
    };
  };

  macpass = installZipApp rec {
    pname = "MacPass";
    appname = "MacPass";
    version = "0.7.12";
    description = "MacOS KeyPassX Port";
    homepage = "https://macpass.org";
    src = {
      url = "https://github.com/MacPass/MacPass/releases/download/0.7.12/MacPass-0.7.12.zip";
      sha256 = "1gikixbrz1pvyjspp62msdmhjdy1rfkx8jhy7rajjr8bzm8pzpmc";
    };
  };

  rectangle = installApp rec {
    pname = "Rectangle";
    appname = "Rectangle";
    version = "12Feb2021";
    description = "Window Organization";
    homepage = "https://github.com/rxhanson/Rectangle/";
    src = {
      url = "https://github.com/rxhanson/Rectangle/releases/download/v0.43/Rectangle0.43.dmg";
      sha256 = "020sf87xxgxzv6a935q3fj67hldk0c1i9iycx9bl9spf44ijjcmc";
    };
  };

}
