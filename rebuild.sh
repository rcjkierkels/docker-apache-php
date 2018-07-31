docker-compose stop
docker-compose rm
docker-compose build --no-cache
docker-compose up -d
docker ps
docker exec -it httpd_noveesoft-apache-php_1 bash
