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

      # Convince rules_go to use /bin/bash and not a NixOS store bash which has
      # no idea how to resolve other things in the nix store once PATH is
      # stripped by (host_)action_env.
      export BAZEL_SH=/bin/bash

      exec bash --noprofile --norc
    '';
in
(pkgs.buildFHSUserEnv {
  name = "monogon-nix";
  targetPkgs = pkgs: with pkgs; [
    git
    bazel_6
  ];
  runScript = wrapper;
}).env
