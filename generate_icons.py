#!/usr/bin/env python3
"""
Samposhi Farm Automation — TWA Icon & Splash Asset Generator
Generates all Android mipmap densities and splash drawables for the TWA project.
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path

TWA_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = TWA_DIR.parent
SRC_ICON = PROJECT_ROOT / "SamposhiFarm_PWA" / "icons" / "icon-512.png"
if not SRC_ICON.exists():
    SRC_ICON = PROJECT_ROOT / "SamposhiFarm_AndroidApp" / "MobileApp_v2" / "icons" / "icon-512.png"

TENSORBOT_LOGO = PROJECT_ROOT / "SamposhiFarm_PWA" / "icons" / "tensorbot-logo.png"

RES_DIR = TWA_DIR / "app" / "src" / "main" / "res"

def log(msg):
    print(f"[\033[92mICON\033[0m] {msg}")

def error(msg):
    print(f"[\033[91mERROR\033[0m] {msg}", file=sys.stderr)

def generate_icons():
    if not SRC_ICON.exists():
        error(f"Source icon not found at: {SRC_ICON}")
        return False

    log(f"Using source icon: {SRC_ICON}")

    icon_specs = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }

    has_sips = shutil.which("sips") is not None

    for folder_name, size in icon_specs.items():
        folder = RES_DIR / folder_name
        folder.mkdir(parents=True, exist_ok=True)
        out_square = folder / "ic_launcher.png"
        out_round = folder / "ic_launcher_round.png"

        if has_sips:
            subprocess.run(["sips", "-z", str(size), str(size), str(SRC_ICON), "--out", str(out_square)],
                           stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
            shutil.copy2(out_square, out_round)
        else:
            try:
                from PIL import Image
                with Image.open(SRC_ICON) as img:
                    resized = img.resize((size, size), Image.Resampling.LANCZOS)
                    resized.save(out_square)
                    resized.save(out_round)
            except ImportError:
                shutil.copy2(SRC_ICON, out_square)
                shutil.copy2(SRC_ICON, out_round)

        log(f"  ✓ Created {folder_name} icon ({size}x{size} px)")

    # Also copy 512px icon into drawable for TWA splash & notification
    drawable_dir = RES_DIR / "drawable"
    drawable_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(SRC_ICON, drawable_dir / "ic_launcher_foreground.png")
    shutil.copy2(SRC_ICON, drawable_dir / "twa_icon_512.png")

    if TENSORBOT_LOGO.exists():
        shutil.copy2(TENSORBOT_LOGO, drawable_dir / "tensorbot_logo.png")

    log("Launcher icons & splash drawables generated successfully.")
    return True

if __name__ == "__main__":
    generate_icons()
