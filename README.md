# buildsystem-ubuntu1604

Based on:
* https://github.com/4lex4/scantailor-libs-build
* https://github.com/westonsteimel/docker-boost/blob/master/1.66.0/alpine/3.8/Dockerfile
* https://dl.bintray.com/boostorg/release/1.66.0/source/
* https://waqarrashid33.blogspot.com/2017/12/installing-boost-166-in-ubuntu-1604.html

To build an image:
 docker build . -t scantailorbuild --network=host

Optionally add --no-cache

To extract deb-file from this container:
 docker cp scantailorbuild:/usr/src/myapp/scantailor-advanced/build/scantailor-advanced-1.0.16-Linux.deb ./

where ./ is a path to the file on a host system
