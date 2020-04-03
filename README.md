Install docker
configure docker log rotation
install git and tools
install kodi
  - https://www.raspberrypi.org/forums/viewtopic.php?t=251645
  - https://github.com/graysky2/kodi-standalone-service/blob/master/init/kodi.service


transmission clean torrent script
move .kodi home to external drive
backup strategy
trash movies


```
$ git clone https://github.com/belerophon/personal-srv-orchestration.git
$ cd personal-srv-orchestration
$ git submodule init
$ git submodule update
$ cp jackett.env.example jackett.env
$ cp nginx-nextcloud-fpm-front.env.example nginx-nextcloud-fpm-front.env
$ cp postgres.env.example postgres.env
$ cp radarr.env.example radarr.env
$ cp sonarr.env.example sonarr.env
$ cp transmission.env.example transmission.env
$ cp .env.example .env
$ #
$ # Edit all *.env files according to your own specifications
$ # ...
$ sudo docker-compose -f docker-compose-arm64v8.yml up -d
```
