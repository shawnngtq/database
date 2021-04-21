#!/usr/bin/bash

# ensure java version at least 11
echo "$(java --version)"
# install javac
sudo yum install java-devel
# set JAVA_HOME
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.9.11-9.fc33.x86_64" >> .bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> .bashrc
echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" >> .bashrc

# add neo4j key
sudo rpm --import https://debian.neo4j.com/neotechnology.gpg.key
# include neo4j config
sudo bash -c 'cat <<EOF >  /etc/yum.repos.d/neo4j.repo
[neo4j]
name=Neo4j RPM Repository
baseurl=https://yum.neo4j.com/stable
enabled=1
gpgcheck=1
EOF'
# install neo4j ce
sudo yum install neo4j-4.2.2
# check neo4j version and edition
rpm -qa | grep neo
# start neo4j
sudo neo4j start
sudo neo4j status
# connecting to and configuring neo4j
# login using default administrative neo4j user and neo4j password combination
cypher-shell
