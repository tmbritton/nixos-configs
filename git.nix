{ config, pkgs, ... }:

{
  programs.git = {
    enable=true;
    config = {
      core = {
        editor = "vim";
      };
      init.defaultBranch = "main";
      user = {
        name = "Tom Britton";
        email = "britton.tm@gmail.com";
      };
      pull = {
        rebase = true;
      };
      alias = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"; 
      };
    };
  };
}
