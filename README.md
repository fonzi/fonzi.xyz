<p align="center">
  <a href="https://fonzi.xyz"><img src="fonzi.gif"/></a>
</p>

## Summary

A simple, minimal personal page. Written in pure HTML and CSS. Used as a way to blog with RSS and keep technology I've encountered and found and used.
Also a personal play site in order to learn more about the basic building blocks of the internet. Everyone likes using high level technology. Not enough
are trying to learn lower level basics.  


### Notes
#### Searx
SearXNG runs as a Docker container (`searxng/searxng:latest`), not the old bare-metal `searx.sh`/filtron/morty setup described previously.

- Container name: `searxng`
- Config/data (bind-mounted): `/opt/searxng` on host → `/etc/searxng` in container — this is where `settings.yml` and the secret key persist across updates/recreates
- Listens on `127.0.0.1:8080` (not exposed externally); a reverse proxy in front handles TLS and forwards `https://searx.fonzi.xyz` to it

To update:

```bash
docker pull searxng/searxng:latest
docker stop searxng
docker rm searxng
docker run -d --name searxng --restart unless-stopped \
  -p 127.0.0.1:8080:8080 \
  -e BASE_URL=https://searx.fonzi.xyz/ \
  -e SECRET_KEY="$(openssl rand -hex 32)" \
  -v /opt/searxng:/etc/searxng \
  searxng/searxng:latest
```

For more: https://docs.searxng.org/admin/installation-docker.html

#### Website
Website Html files are located at `/var/www/*`
To Update just do a `git pull`

## Hugo workflow (prod-like local testing)

Use these commands to build exactly like production and preview locally without Hugo dev-mode URL rewriting.

Build production output:

`make prod-build`

Serve that output locally:

`make prod-serve`

Open: `http://localhost:4173`

Notes:

- `prod-build` writes output to `.dist-prod/`.
- `prod-serve` is a plain static server, so you test the exact built files.
- `prod-preview` runs build + serve in one command.

## What to push to this repo

Push source files and config:

- `content/`
- `layouts/`
- `static/`
- `assets/`
- `config.toml`
- `themes/` (or the theme submodule reference if you use submodules)
- `Makefile`
- `README.md`

Do not push generated build output:

- `.dist-prod/`
- `public/`
- `resources/_gen/`
- `.hugo_build.lock`

This repository now includes `.gitignore` entries for those generated files.