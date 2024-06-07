# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Home
  home = {
    username = "rstasta";
    homeDirectory = "/home/rstasta";

    # Dotfiles
    file = {
      "${config.home.homeDirectory}/.config/monitors.xml" = {
        source = ../dotfiles/system/monitors.xml;
      };
      "${config.home.homeDirectory}/.config/rofi" = {
        source = ../dotfiles/rofi;
        recursive = true;
      };
      "${config.home.homeDirectory}/.config/variety/variety.conf" = {
        source = ../dotfiles/variety/variety.conf;
      };
      "${config.home.homeDirectory}/.config/autostart/variety.desktop" = {
        source = ../dotfiles/variety/variety.desktop;
      };
    };

    # Packages
    packages = with pkgs; [
      gnome.gnome-tweaks
      jetbrains.webstorm
      variety
    ];
  };

  # Programs
  programs = {
    home-manager.enable = true;
    git.enable = true;
    neovim.enable = true;
    firefox.enable = true;
    gh.enable = true;
    rofi.enable = true;
    fish = {
      enable = true;
      functions = {
        fish_greeting = {
          body = "";
        };
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ../dotfiles/starship/starship.toml);
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "None";
          startup_mode = "Maximized";
        };
      };
    };
  };

  # dconf
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "cz" ]) (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "mouse";
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-to-workspace-1 = [ "<Super>plus" ];
      switch-to-workspace-2 = [ "<Super>ecaron" ];
      switch-to-workspace-3 = [ "<Super>scaron" ];
      switch-to-workspace-4 = [ "<Super>ccaron" ];
      close = [ "<Super>c" ];
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "alacritty";
      name = "Open Alacritty";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>d";
      command = "rofi -show drun -normal-window";
      name = "Open Rofi";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
