FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl gnupg ca-certificates build-essential

# JVM
RUN curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list
RUN apt-get update && apt install -y zulu21-jdk

RUN mkdir -p /opt/bazelisk
WORKDIR /opt/bazelisk
RUN curl -L -o bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-amd64 && chmod u+x bazelisk
ENV PATH=$PATH:/opt/bazelisk
# get bazelisk to download bazel
RUN bazelisk version

RUN mkdir -p /opt/rootcanal
WORKDIR /opt/rootcanal

COPY /BUILD* /WORKSPACE ./
RUN ls
# do initial bazel downloading
RUN bazelisk build :rootcanal

COPY / .

RUN bazelisk build :rootcanal
