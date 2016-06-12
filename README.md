# Nagios

## Install docker
```sh
sudo apt-get update
wget -qO- https://get.docker.com/ | sh
```

## Usage

### Start
```sh
$ docker run -d --name nagios_server -p 80:80 g3org3/nagios
```

### Set password
```sh
$ docker exec -it nagios_server bash
root@2c6241d7c62e:/var/local# ./init.sh
New password:
Re-type new password:
Adding password for user nagiosadmin
Starting nagios: done.
root@2c6241d7c62e:/var/local# exit
exit
$
```
