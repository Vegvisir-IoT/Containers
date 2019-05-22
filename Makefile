setup:
	sudo apt-get update && sudo apt-get upgrade --yes
	sudo apt-get install docker.io
	sudo usermod -a -G docker $(USER)
	sudo chmod 666 /var/run/docker.socket
	sudo chmod 666 /var/run/docker.sock
	sudo service docker restart

server:
	docker run --rm -ti -p 9191:9191 dadams39/demo ./gradlew run 
client:
	docker run --rm -ti -p 9000:9000 dadams39/demo python app/src/main/python/client.py

clean:
	-docker ps -a -q | xargs docker rm
	-docker image prune
