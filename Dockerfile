FROM --platform=linux/amd64 debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# --- Core desktop + tools ---
RUN apt update && apt install -y --no-install-recommends \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server novnc websockify \
    dbus-x11 x11-utils x11-xserver-utils x11-apps \
    sudo xterm vim net-tools curl wget git tzdata ca-certificates \
    firefox-esr xubuntu-icon-theme \
 && apt clean && rm -rf /var/lib/apt/lists/* \
 && touch /root/.Xauthority

# --- Optional Peppermint look (wallpapers, theme) ---
# RUN apt update && apt install -y peppermint-icons peppermint-backgrounds && apt clean

EXPOSE 5901 6080

CMD bash -c '\
  vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
  openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out /root/self.pem -keyout /root/self.pem && \
  websockify -D --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901 && \
  tail -f /dev/null'
