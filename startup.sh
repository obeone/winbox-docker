#! /bin/bash
if [ -f /config/private-cert.pem ]; then
  cp /config/private-cert.pem /home/kasm-user/.vnc/self.pem
fi
FREETYPE_PROPERTIES="truetype:interpreter-version=35" wine64 /opt/winbox/winbox64.exe
