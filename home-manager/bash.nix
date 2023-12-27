{ libs, pkgs, ... }:
{
  programs.bash = {
    enable = true;

    initExtra = ''
      eval `ssh-agent` >/dev/null
      trap "ssh-agent -k" EXIT
    export PS1='\[\033[0m\]~ $(t="$(echo -ne $?)" ;printf "%s%3d" "$(if [ $t != 0 ]; then echo -ne "\[\033[01;31m\]"; else echo -ne "\[\033[01;32m\]"; fi)" "$t") \[\033[01;32m\][\u@\h\[\033[01;37m\] \W$(if t=$(git branch --show-current 2>/dev/null); then echo " \[\033[2;91m\]\[\033[1;31m\]$t$(if [ ! -z "$(git diff)" ]; then echo " \[\033[33m\]"$(git diff --stat | tail -n 1| sed "s/[a-z ()]//g;s/[0-9][0-9]*,//g;s/\([0-9]*\)\([+-]\)/\2\1/g"); fi;)"; fi)$([ -z "$IN_NIX_SHELL" ] || echo " \[\033[34m\] \[\]")\[\033[01;32m\]]\$\[\033[00;1;3m\] '
    '';

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      copy = "xsel -b <";

      cdr = "if gitpath=`git rev-parse --show-toplevel`; then cd $gitpath; fi";
      vim = "nvim";
    };
  };
}
