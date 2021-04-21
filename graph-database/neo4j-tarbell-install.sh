#!/usr/bin/bash

# ensure java version at least 11
echo "$(java --version)"
# install javac
sudo yum install java-devel
# set JAVA_HOME
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.9.11-9.fc33.x86_64" >> .bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> .bashrc
echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" >> .bashrc

# download neo4j ce from https://neo4j.com/download-center/#community
wget https://neo4j.com/artifact.php?name=neo4j-community-4.2.3-unix.tar.gz -O ~/Downloads/neo4j-community-4.2.3-unix.tar.gz
# checksum
sha256sum ~/Downloads/neo4j-community-4.2.3-unix.tar.gz
# mv tar to home directory
mv ~/Downloads/neo4j-community-4.2.3-unix.tar.gz $HOME
# extract package
tar -xf neo4j-community-4.2.3-unix.tar.gz
# start neo4j in background process
bash $HOME/neo4j-community-4.2.3/bin/neo4j start

# download cypher shell from https://neo4j.com/download-center/#community
wget https://dist.neo4j.org/cypher-shell/cypher-shell-4.2.2.zip?_ga=2.262970188.1398020941.1611822666-1579295603.1611822663 -O ~/Downloads/cypher-shell-4.2.2.zip
# move cypher shell zip to home dir
mv ~/Downloads/cypher-shell-4.2.2.zip $HOME
# extract cypher shell
unzip cypher-shell-4.2.2.zip
# start shell
$HOME/cypher-shell/cypher-shell
