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