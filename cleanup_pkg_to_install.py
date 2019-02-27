# use this script to sort and uniq the list of packages to install
pkg = []
with open("pkg_to_install") as f:
    for line in f:
        line = line.strip()
        pkg.extend(line.split(" "))
pkg = sorted(set(pkg))
with open("pkg_to_install", "w") as f:
    f.write("\n".join(pkg))
    f.write("\n")