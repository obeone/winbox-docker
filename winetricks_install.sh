#!/bin/sh
# Create and switch to a temporary directory writeable by current user. See:
#   https://www.tldp.org/LDP/abs/html/subshells.html
cd "$(mktemp -d)" || exit 1

# Use a BASH "here document" to create an updater shell script file.
# See:
#   https://www.tldp.org/LDP/abs/html/here-docs.html
# >  outputs stdout to a file, overwriting any pre-existing file
# << takes input, directly from the script itself, till the second '_EOF_SCRIPT' marker, as stdin
# the cat command hooks these 2 streams up (stdin and stdout)
###### create update_winetricks START ########
cat > update_winetricks <<_EOF_SCRIPT
#!/bin/sh

# Create and switch to a temporary directory writeable by current user. See:
#   https://www.tldp.org/LDP/abs/html/subshells.html
cd "\$(mktemp -d)"

# Download the latest winetricks script (master="latest version") from Github.
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

# Mark the winetricks script (we've just downloaded) as executable. See:
#   https://www.tldp.org/LDP/GNU-Linux-Tools-Summary/html/x9543.htm
chmod +x winetricks

# Move the winetricks script to a location which will be in the standard user PATH. See:
#   https://www.tldp.org/LDP/abs/html/internalvariables.html
 mv winetricks /usr/bin

# Download the latest winetricks BASH completion script (master="latest version") from Github.
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion

# Move the winetricks BASH completion script to a standard location for BASH completion modules. See:
#   https://www.tldp.org/LDP/abs/html/tabexpansion.html
 mv winetricks.bash-completion /usr/share/bash-completion/completions/winetricks

# Download the latest winetricks MAN page (master="latest version") from Github.
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.1

# Move the winetricks MAN page to a standard location for MAN pages. See:
#   https://www.pathname.com/fhs/pub/fhs-2.3.html#USRSHAREMANMANUALPAGES
 mv winetricks.1 /usr/share/man/man1/winetricks.1
_EOF_SCRIPT
###### create update_winetricks FINISH ########

# Mark the update_winetricks script (we've just written out) as executable. See:
#   https://www.tldp.org/LDP/GNU-Linux-Tools-Summary/html/x9543.htm
chmod +x update_winetricks

# We must escalate privileges to root, as regular Linux users do not have write access to '/usr/bin'.
 mv update_winetricks /usr/bin/

