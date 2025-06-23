#! /usr/bin/env bash

WALL_PATH="$HOME/nixos/wallpapers"
HYPR_PATH="$HOME/nixos/dotfiles/hyprland/dot-config/hypr"

if [[ $(hostname) == "desktop-t9" ]]; then
  hyprpaper --config "$HYPR_PATH/hyprpaper_t9.conf"
elif [[ -f "$WALL_PATH/current.png" ]]; then
  hyprpaper --config "$HYPR_PATH/hyprpaper_png.conf"
elif [[ -f "$WALL_PATH/current.jpg" ]]; then
  hyprpaper --config "$HYPR_PATH/hyprpaper_jpg.conf"
elif [[ -f "$WALL_PATH/current.jpeg" ]]; then
  hyprpaper --config "$HYPR_PATH/hyprpaper_jpeg.conf"
fi
