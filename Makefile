DOCKER_NETWORK=panicboat

init:
	@if [ -z "`docker network ls | grep ${DOCKER_NETWORK}`" ]; then docker network create ${DOCKER_NETWORK}; fi
	docker-compose build --no-cache
	docker-compose up -d db
	docker-compose run app rake db:create
	docker-compose run app rake db:migrate
	docker-compose run app rake db:migrate RAILS_ENV=test

up:
	docker-compose up -d

bash:
	docker-compose exec app bash

mysql:
	docker-compose exec db bash -c 'mysql -h localhost -u root -ppassword advertisements'

down:
	docker-compose down

spec:
	docker-compose run app rake test

clean:
	docker system prune -f -a --volumes
