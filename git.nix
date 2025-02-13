{ config, pkgs, ... }:

{
  programs.git = {
    enable=true;
    config = {
      init.defaultBranch = "main";
      user = {
        name = "Tom Britton";
        email = "britton.tm@gmail.com";
      };
      alias = {
        lg = "log --color --graph --pretty=format: '%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"; 
      };
    };
  };
}
