# buildsystem-ubuntu1604

Based on:
* https://github.com/4lex4/scantailor-libs-build
* https://github.com/westonsteimel/docker-boost/blob/master/1.66.0/alpine/3.8/Dockerfile
* https://dl.bintray.com/boostorg/release/1.66.0/source/
* https://waqarrashid33.blogspot.com/2017/12/installing-boost-166-in-ubuntu-1604.html

To build:
 docker build . -t scantailorbuild --network=host

Optionally add --no-cache


