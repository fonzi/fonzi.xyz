<p align="center">
  <a href="https://fonzi.xyz"><img src="fonzi.gif"/></a>
</p>

## Summary

A simple, minimal personal page. Written in pure HTML and CSS. Used as a way to blog with RSS and keep technology I've encountered and found and used.
Also a personal play site in order to learn more about the basic building blocks of the internet. Everyone likes using high level technology. Not enough
are trying to learn lower level basics.  


### Notes
#### Searx
Searx instance is installed on the server. 
searx conf files locations at `/home/debian/searx/` (main branch) personal settings at `/etc/searx` and automated at `/usr/local/searx/`
nginx conf files locations at `/etc/nginx/default.d/*` & at `etc/nginx/sites-enabled/*`

To update:

`cd /home/debian/searx/` <---- initial location then the automated process does the rest

`sudo -H ./utils/searx.sh update searx` (cds into `/usr/local/searx/` then spits out conf files to `/etc/searx/`)

`sudo -H ./utils/filtron.sh update filtron`

`sudo -H ./utils/morty.sh update morty`

`sudo -H service uwsgi restart searx`
for more go here : https://searx.github.io/searx/admin/update-searx.html?highlight=update


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