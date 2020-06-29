FROM golang as gotools
RUN go get github.com/cortesi/modd/cmd/modd
RUN go get github.com/cortesi/devd/cmd/devd

FROM rust as rusttools
RUN git clone https://github.com/defcube/defparallel.git; cd defparallel; cargo build --release

FROM ubuntu as devbox
WORKDIR /app
RUN apt-get update
RUN apt-get install npm openjdk-11-jdk -y
ENV PATH="/app/node_modules/.bin:/app/defdev/internal/:${PATH}"
COPY --from=gotools /go/bin/* /usr/local/bin/
COPY --from=rusttools /defparallel/target/release/defparallel /usr/local/bin
EXPOSE 80
