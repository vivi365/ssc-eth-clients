# local repreproduces
from ubuntu:bionic

RUN apt-get update && apt-get install gcc-multilib git ca-certificates wget -yq --no-install-recommends
RUN git clone --branch master https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git fetch

RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
	export PATH=$PATH:/usr/local/go/bin 

RUN cd go-ethereum && git checkout 2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1 && \
	CGO_ENABLED=1 CI=true TRAVIS=true TRAVIS_COMMIT="2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1" /usr/local/go/bin/go run ./build/ci.go install ./cmd/geth/
RUN cd go-ethereum/build/bin && strip geth && strip --remove-section .note.go.buildid geth && strip --remove-section .note.gnu.build-id geth
RUN	md5sum go-ethereum/build/bin/geth > md5-1.txt && mv go-ethereum/build/bin/geth geth-1

RUN cd go-ethereum && git checkout 2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1 && \
	CGO_ENABLED=1 CI=true TRAVIS=true TRAVIS_COMMIT="2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1" /usr/local/go/bin/go run ./build/ci.go install ./cmd/geth/
RUN cd go-ethereum/build/bin && strip geth && strip --remove-section .note.go.buildid geth && strip --remove-section .note.gnu.build-id geth
RUN	md5sum go-ethereum/build/bin/geth > md5-2.txt && mv go-ethereum/build/bin/geth geth-2

RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.13.14-2bd6bd01.tar.gz && tar -xvf geth-linux-amd64-1.13.14-2bd6bd01.tar.gz && \
	cd geth-linux-amd64-1.13.14-2bd6bd01 && strip geth && strip --remove-section .note.go.buildid geth && strip --remove-section .note.gnu.build-id geth && \
	md5sum geth > /md5-bundle.txt && mv geth /geth-bundle

# docker build -t <imgname> . (rel path)
# docker run -it <imgname> /bin/bash