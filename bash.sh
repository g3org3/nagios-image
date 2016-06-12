docker exec -it `docker-compose ps | grep nagios_1 | awk '{print $1}'` bash
