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

baremetal:
	sudo apt-get update
	sudo apt-get install -y less vim make git screen tmux curl tar wget unzip zip
	mkdir ~/installs && cp bootsrap.sh ~/installs && cd ~/installs
	wget http://cs.cornell.edu/~dadams39/protobuf-java-3.0.0.jar
	wget http://cs.cornell.edu/~dadams39/protobuf-python-3.0.0.tar.gz
	wget http://cs.cornell.edu/~dadams39/protoc-3.0.0-linux-x86_64.zip
	wget http://cs.cornell.edu/~dadams39/protoc-gen-javalite-3.0.0-linux-x86_64.zip
	wget http://cs.cornell.edu/~dadams39/jdk-11.0.2_linux-x64_bin.tar.gz
	# Install Java
	mkdir /opt/jdk && tar -zxf jdk-11.0.2_linux-x64_bin.tar.gz -C /opt/jdk \
	&& update-alternatives --install /usr/bin/java java /opt/jdk/jdk-11.0.2/bin/java 100 \
	&& update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk-11.0.2/bin/javac 100 \
	&& java -version
	# Install Protoc (restart back in installs)
	cd ~/installs/
	unzip protoc-3.0.0-linux-x86_64.zip -d protoc3 \
	&& mv protoc3/bin/* /usr/local/bin/ \
	&& mv protoc3/include/* /usr/local/include/ \
	&& ln -s /protoc3/bin/protoc /usr/bin/protoc
	cp protobuf-java-3.0.0.jar /opt/jdk
	## Install Protobuf submodules
	unzip protoc-gen-javalite-3.0.0-linux-x86_64.zip -d proto_lite \
	&& mv proto_lite/bin/* /usr/local/bin/
	tar -xvf protobuf-python-3.0.0.tar.gz
	cd protobuf-3.0.0/python && python setup.py build \
	&& python setup.py install && pip install cryptography && pip3 install factory_boy
	## Step 6: Install Gradle
	cd ~/installs/
	curl -s "https://get.sdkman.io" | bash
	bash bootstrap.sh

clean:
	-docker ps -a -q | xargs docker rm
	-docker image prune
