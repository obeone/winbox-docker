# Winbox in docker

Use Mikrotik's Winbox with your browser !

Using [KasmVNC](https://github.com/kasmtech/KasmVNC), this docker starts Winbox with Wine and make it avaiable in any browser.

## Using

```sh
docker run -d --shm-size=512m -p 6901:6901 -e VNC_PW=password -v winbox_wine:/home/kasm_user/.wine obebete/winbox:latest
```

You can access it at the address https://localhost:6901 with user `kasm_user` and password `password`.

It's not mandatory to mount (or bind) the volume, but it save initial configuration of Wine (which can take a while) and your winbox sessions
