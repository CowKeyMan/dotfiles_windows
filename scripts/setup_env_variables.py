import winreg
import os

# Define the variable you want to create or change
new_key_pairs = {
    "CC": "clang",
    "CXX": "clang++",
}

new_path_values = [
    r"%USERPROFILE%\AppData\Local\mise\shims"
]

def add_to_list(lst: str, new_values: list[str]):
    items = lst.split(';')
    for v in new_values:
        if v not in items:
            items.append(v)
    return ';'.join(items)

# Open the Environment key in the current user hive
with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment", 0, winreg.KEY_ALL_ACCESS) as key:
    path = winreg.QueryValueEx(key, "PATH")[0]
    winreg.SetValueEx(key, "PATH", 0, winreg.REG_SZ, add_to_list(path, new_path_values))

    for k, v in new_key_pairs.items():
        winreg.SetValueEx(key, k, 0, winreg.REG_SZ, v)

print("Successfully set environment variables")
