# If you're on NixOS, use me! `nix-shell --pure`.
{ sources ? import third_party/nix/sources.nix }:
let
  pkgs = import sources.nixpkgs { };
  wrapper = with pkgs; writeScript "wrapper.sh"
    ''
      # Fancy colorful PS1 to make people notice easily they're in the Monogon Nix shell.
      PS1='\[\033]0;\u/monogon:\w\007\]'
      if type -P dircolors >/dev/null ; then
        PS1+='\[\033[01;35m\]\u/monogon\[\033[01;36m\] \w \$\[\033[00m\] '
      fi
      export PS1

      # Use Nix-provided cert store.
      export NIX_SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"

      # Let some downstream machinery know we're on NixOS. This is used mostly to
      # work around Bazel/NixOS interactions.
      export MONOGON_NIXOS=yep

      # Convince rules_go to use /bin/bash and not a NixOS store bash which has
      # no idea how to resolve other things in the nix store once PATH is
      # stripped by (host_)action_env.
      export BAZEL_SH=/bin/bash

      # Allow passing a custom command via env since nix-shell doesn't support
      # this yet: https://github.com/NixOS/nix/issues/534
      if [ ! -n "$COMMAND" ]; then
          COMMAND="bash --noprofile --norc"
      fi
      exec $COMMAND
    '';
in
(pkgs.buildFHSUserEnv {
  name = "monogon-nix";
  targetPkgs = pkgs: with pkgs; [
    git
    bazel_6
    openjdk21
  ];
  runScript = wrapper;
}).env
