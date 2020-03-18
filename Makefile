setup:
	sudo apt-get update && sudo apt-get upgrade --yes
	sudo apt-get install docker.io
	sudo usermod -aG docker ${USER}
	#sudo chmod 666 /var/run/docker.socket
	sudo chmod 666 /var/run/docker.sock
	sudo service docker restart

server:
	docker run --rm -ti -p 9191:9191 dadams39/demo ./gradlew run 
client:
	docker run --rm -ti -p 9000:9000 dadams39/demo python app/src/main/python/client.py

download:
	mkdir ~/installs
	cd ~/installs && wget http://cs.cornell.edu/~dadams39/protobuf-python-3.0.0.tar.gz && \
	wget http://cs.cornell.edu/~dadams39/protoc-3.0.0-linux-x86_64.zip

cloud:
	sudo apt-get update && sudo apt-get upgrade --yes
	sudo apt-get install -y less vim make git screen tmux curl tar wget unzip zip
	sudo apt-get install -y python-setuptools && sudo apt-get install -y python3-setuptools
	sudo easy_install pip && sudo easy_install3 pip
	bash cloud.sh
	sudo pip install cryptography && sudo pip3 install factory_boy
	# Gradle Installation
	curl -s "https://get.sdkman.io" | bash
	bash bootstrap.sh

baremetal:  download cloud
	echo "BareMetal installed successfully"
clean:
	-docker ps -a -q | xargs docker rm
	-docker image prune
