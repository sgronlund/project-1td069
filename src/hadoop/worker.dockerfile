FROM ubuntu:22.04
COPY *.xml config/
COPY *.sh config/
RUN apt-get update && \ 
    apt-get -y upgrade && \
    apt install -y openjdk-8-jdk-headless && \ 
    apt install -y scala  && \
    apt install -y wget && \ 
    apt install -y screen && \
    apt install -y python3 && \
    apt install -y sudo && \ 
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz && \
    tar xvf hadoop-3.3.4.tar.gz && \
    mv hadoop-3.3.4 hadoop && \
    mkdir hadoop/namenode && \
    mkdir hadoop/datanode && \
    mkdir hadoop/logs && \ 
    cp config/*.xml hadoop/etc/hadoop/
EXPOSE 9870/tcp 
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
RUN /config/resolve-host.sh
CMD /hadoop/bin/hdfs datanode

