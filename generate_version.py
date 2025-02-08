import re

with open("pubspec.yaml", "r") as file:
    for line in file:
        match = re.search(r"version:\s*(.*)", line)
        if match:
            with open("web/version.txt", "w") as version_file:
                version_file.write(match.group(1))
            break
