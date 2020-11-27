DOCKER_NETWORK=panicboat
CONTAINER_NAME=advertisements
DATABASE_NAME=advertisements

init:
	@if [ -z "`docker network ls | grep ${DOCKER_NETWORK}`" ]; then docker network create ${DOCKER_NETWORK}; fi
	docker-compose build --no-cache
	docker-compose up -d xray
	docker-compose up -d db
	docker-compose run ${CONTAINER_NAME} rake db:create
	docker-compose run ${CONTAINER_NAME} rake db:migrate
	docker-compose run ${CONTAINER_NAME} rake db:migrate RAILS_ENV=test

seed:
	docker-compose run ${CONTAINER_NAME} rake db:seed

up:
	docker-compose up -d

bash:
	docker-compose exec ${CONTAINER_NAME} bash

mysql:
	docker-compose exec db bash -c 'mysql -h localhost -u root -ppassword ${DATABASE_NAME}'

down:
	docker-compose down

spec:
	docker-compose run ${CONTAINER_NAME} rake test

clean:
	docker system prune -f -a --volumes
