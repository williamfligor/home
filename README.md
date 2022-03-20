## MacOS

```bash
echo "" > /tmp/nix.conf
echo "trusted-users = root $USER" >> /tmp/nix.conf

sh <(curl -L https://nixos.org/nix/install) \
    --no-channel-add \
    --nix-extra-conf-file /tmp/nix.conf

# Disable spotlight indexing of /nix to speed up performance
sudo mdutil -i off /nix

nix-channel --add https://nixos.org/channels/nixos-21.11 nixpkgs
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update

git clone <> ~/.config/nixpkgs/

export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
```

## Linux

```bash
sh <(curl -L https://nixos.org/nix/install) \
    --no-daemon \
    --no-channel-add

nix-channel --add https://nixos.org/channels/nixos-21.11 nixpkgs
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update

git clone <> ~/.config/nixpkgs/

export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
```

### When MacOS isn't finding Nix binaries

Add

```bash
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

to `/etc/zshenv`
