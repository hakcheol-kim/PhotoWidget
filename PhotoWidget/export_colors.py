import os
import json

def hex_to_rgba_components(hex_string):
    hex_string = hex_string.lstrip("#")
    r = int(hex_string[0:2], 16) / 255.0
    g = int(hex_string[2:4], 16) / 255.0
    b = int(hex_string[4:6], 16) / 255.0
    a = int(hex_string[6:8], 16) / 255.0 if len(hex_string) == 8 else 1.0
    return r, g, b, a

def make_colorset(name, appearances, output_dir):
    colorset_path = os.path.join(output_dir, f"{name}.colorset")
    os.makedirs(colorset_path, exist_ok=True)

    colors = []
    for appearance, color_value in appearances.items():
        r, g, b, a = hex_to_rgba_components(color_value)
        color_entry = {
            "idiom": "universal",
            "color": {
                "color-space": "srgb",
                "components": {
                    "red": f"{r:.3f}",
                    "green": f"{g:.3f}",
                    "blue": f"{b:.3f}",
                    "alpha": f"{a:.3f}"
                }
            }
        }
        if appearance == "dark":
            color_entry["appearances"] = [{"appearance": "luminosity", "value": "dark"}]
        colors.append(color_entry)

    contents = {
        "info": {"version": 1, "author": "xcode"},
        "colors": colors
    }

    with open(os.path.join(colorset_path, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)

def export_to_xcassets(json_file, output_path):
    with open(json_file, "r") as f:
        data = json.load(f)

    for color_name, modes in data["color"].items():
        appearances = {}
        if "light" in modes:
            appearances["light"] = modes["light"]["value"]
        if "dark" in modes:
            appearances["dark"] = modes["dark"]["value"]
        normalized_name = color_name.replace(" ", "_").replace("(", "").replace(")", "")
        make_colorset(normalized_name, appearances, output_path)

if __name__ == "__main__":
    export_to_xcassets("colors.json", "./Assets.xcassets/Colors/")

