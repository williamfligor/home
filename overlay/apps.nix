self: super:
let
  installApp = import ../lib/installApp.nix super;
in
{
  rectangle = installApp rec {
    pname = "Rectangle";
    appname = "Rectangle";
    version = "12Feb2021";
    description = "Window Organization";
    homepage = "https://github.com/rxhanson/Rectangle/";
    src = {
      url = "https://github.com/rxhanson/Rectangle/releases/download/v0.53/Rectangle0.53.dmg";
      sha256 = "759e614c00668cdb0ae00acccbd1dbe7484291bd97ec5722c74520c537ba4273";
    };
  };

}
