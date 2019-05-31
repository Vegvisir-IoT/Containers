#  Vegvisir-IoT :: Containers
## Docker Container for Vegvisir IoT Documentation
###  OS: Ubuntu 16.04
###  gcc: default 5, but all versions up to 7 installed
###  Java: 11
###  Python: 3.5

#### Overview
The directory contains the components necessary to build the docker container
`dadams39/demo` which is used for the creation and testing of our server end
Vegvisir protocols. The container itself can be instantiated on a machine if
you have docker installed. If you do not have docker installed, please visit
the appropriate website to have it installed. If you would want to be able
to build the container from scractch yourself you will need the following
files:

- protobuf-java-3.0.0.jar
- protoc-3.0.0-linux-x86_64.zip
- Python-3.5.6.tgz 
- protoc-gen-javalite-3.0.0-linux-x86_64.zip
- protobuf-python-3.0.0.tar.gz
- jdk-11.0.2_linux-x64_bin.tar.gz

* Protobuf files can be found @ https://github.com/protocolbuffers/protobuf/releases
* All the packages, save Python, can be downloaded executing `$ make download ` 

These changes are reflected in the .gitignore file.
#### How to Run the protobuf compilations
-  Python
   `$ protoc -I=$SRC_DIR --python_out=$DST_DIR /path/to/.proto `
-  Java
   `$ protoc -I=$SRC_DIR --python_out=$DST_DIR /path/to/.proto `
-  ProtoLite
   `$ protoc --javalite_out=$DST_DIR /path/to/.proto `

#### Set-up Container Dependencies
- `$ make`

#### Recreate Environment on baremetal machine
- `$ make baremetal`

- `$ make cloud` to be used in Emulab environment where certain packages have
already been downloaded
#### How to Run a server with port exposed...
- `$ make server`
#### How to run a client
- `$ make client`
- When prompted: Use the ip address of the host machine

NOTE: The containers can communicate from container to container
