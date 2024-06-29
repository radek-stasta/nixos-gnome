# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  customPython = pkgs.python3.withPackages (ps: with ps; [
    ps.beautifulsoup4
    ps.selenium
  ]);
in
{
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
      "${config.home.homeDirectory}/.config/variety/variety.conf" = {
        source = ../dotfiles/variety/variety.conf;
      };
      "${config.home.homeDirectory}/.config/conky" = {
        source = ../dotfiles/conky;
        recursive = true;
      };
      "${config.home.homeDirectory}/.config/autostart/variety.desktop" = {
        source = ../dotfiles/autostart/variety.desktop;
      };
      "${config.home.homeDirectory}/.config/autostart/blur-my-shell.desktop" = {
        source = ../dotfiles/autostart/blur-my-shell.desktop;
      };
      "${config.home.homeDirectory}/.config/autostart/steam-charts.desktop" = {
        source = ../dotfiles/autostart/steam-charts.desktop;
      };
      "${config.home.homeDirectory}/.config/autostart/conky.desktop" = {
        source = ../dotfiles/autostart/conky.desktop;
      };

      # Theme
      "${config.home.homeDirectory}/.themes/orchis-dark-nord" = {
        source = ../dotfiles/orchis-dark-nord;
        recursive = true;
      };
      "${config.home.homeDirectory}/.config/gtk-4.0" = {
        source = ../dotfiles/orchis-dark-nord/gtk-4.0;
        recursive = true;
      };
    };

    # Packages
    packages = with pkgs; [
      blender
      conky
      customPython
      gimp
      gnome.gnome-tweaks
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.ddterm
      gnomeExtensions.fullscreen-avoider
      gnomeExtensions.vitals
      google-chrome
      ios-webkit-debug-proxy
      jetbrains.webstorm
      killall
      kodi
      libimobiledevice
      libreoffice-fresh
      lutris
      nodePackages.nodejs
      nodePackages.grunt-cli
      nodePackages."@angular/cli"
      nordzy-cursor-theme
      nordzy-icon-theme
      ntfs3g
      protonup-qt
      sassc
      spotify
      steam
      subversion
      variety
      wine-staging
      wowup-cf
    ];
  };

  # Programs
  programs = {
    home-manager.enable = true;
    git.enable = true;
    neovim.enable = true;
    firefox.enable = true;
    gh.enable = true;
    fish = {
      enable = true;
      functions = {
        fish_greeting = {
          body = "";
        };
      };
      shellAliases = {
        "nixos-flake" = "nix flake update ~/nixos/";
        "nixos-rebuild" = "sudo nixos-rebuild switch --flake ~/nixos/#nixos";
        "nixos-rebuild-test" = "sudo nixos-rebuild test --flake ~/nixos/#nixos";
        "nixos-collect-garbage" = "sudo nix-collect-garbage --delete-older-than 7d";
        "file-sizes" = "du -ah -d 1 2>/dev/null | sort -h";
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ../dotfiles/starship/starship.toml);
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
      button-layout = "close,minimize,maximize:appmenu";
    };
    "org/gnome/shell" = {
      last-selected-power-profile = "performance";
      favorite-apps = [
        "google-chrome.desktop"
        "webstorm.desktop"
        "steam.desktop"
      ];
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
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
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>q" ];
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    # Extensions
    "org/gnome/shell" = {
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "dash-to-dock@micxgx.gmail.com"
          "Vitals@CoreCoding.com"
          "blur-my-shell@aunetx"
          "ddterm@amezin.github.com"
          "fullscreen-avoider@noobsai.github.com"
        ];
    };
    "com/github/amezin/ddterm" = {
      ddterm-toggle-hotkey = [ "F9" ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      disable-overview-on-startup = true;
      hot-keys = false;
      show-trash = false;
      show-show-apps-button = false;
      multi-monitor = true;
      transparency-mode = "DYNAMIC";
    };
    "com/github/amezin/ddterm" = {
      panel-icon-type = "none";
    };
    "org/gnome/shell/extensions/vitals" = {
      position-in-panel = 0;
      icon-style = 1;
      show-gpu = true;
      hot-sensors = [
        "_processor_usage_"
        "_memory_allocated_"
        "_storage_free_"
        "__network-rx_max__"
        "_gpu#1_memory_usage_"
        "_temperature_processor_0_"
      ];
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      pipelines = with lib.hm.gvariant; [
        (mkDictionaryEntry [
          "pipeline_default"
          (mkValue [
            (mkDictionaryEntry [
              "name"
              (mkVariant "Default")
            ])
            (mkDictionaryEntry [
              "effects"
              (mkVariant [
                (mkVariant [
                  (mkDictionaryEntry [
                    "type"
                    (mkVariant "native_static_gaussian_blur")
                  ])
                  (mkDictionaryEntry [
                    "id"
                    (mkVariant "effect_000000000000")
                  ])
                  (mkDictionaryEntry [
                    "params"
                    (mkVariant [
                      (mkDictionaryEntry [
                        "radius"
                        (mkVariant 30)
                      ])
                      (mkDictionaryEntry [
                        "brightness"
                        (mkVariant 0.59999999999999998)
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
        (mkDictionaryEntry [
          "pipeline_default_rounded"
          (mkValue [
            (mkDictionaryEntry [
              "name"
              (mkVariant "Default rounded")
            ])
            (mkDictionaryEntry [
              "effects"
              (mkVariant [
                (mkVariant [
                  (mkDictionaryEntry [
                    "type"
                    (mkVariant "native_static_gaussian_blur")
                  ])
                  (mkDictionaryEntry [
                    "id"
                    (mkVariant "effect_000000000001")
                  ])
                  (mkDictionaryEntry [
                    "params"
                    (mkVariant [
                      (mkDictionaryEntry [
                        "radius"
                        (mkVariant 30)
                      ])
                      (mkDictionaryEntry [
                        "brightness"
                        (mkVariant 0.59999999999999998)
                      ])
                    ])
                  ])
                ])
                (mkVariant [
                  (mkDictionaryEntry [
                    "type"
                    (mkVariant "corner")
                  ])
                  (mkDictionaryEntry [
                    "id"
                    (mkVariant "effect_000000000002")
                  ])
                  (mkDictionaryEntry [
                    "params"
                    (mkVariant [
                      (mkDictionaryEntry [
                        "radius"
                        (mkVariant 24)
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
        (mkDictionaryEntry [
          "pipeline_transparent"
          (mkValue [
            (mkDictionaryEntry [
              "name"
              (mkVariant "Transparent")
            ])
            (mkDictionaryEntry [
              "effects"
              (mkVariant [
                (mkVariant [
                  (mkDictionaryEntry [
                    "type"
                    (mkVariant "color")
                  ])
                  (mkDictionaryEntry [
                    "id"
                    (mkVariant "effect_000000000003")
                  ])
                ])
              ])
            ])
          ])
        ])
      ];
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      pipeline = "pipeline_transparent";
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      pipeline = "pipeline_default_rounded";
      override-background = false;
    };

    # Theme
    "org/gnome/shell/extensions/user-theme" = {
      name = "orchis-dark-nord";
    };
    "org/gnome/desktop/interface" = {
      gtk-theme = "orchis-dark-nord";
      icon-theme = "Nordzy-green-dark";
      cursor-theme = "Nordzy-cursors";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
