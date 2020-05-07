FROM fedora:32

RUN curl -o /usr/local/bin/bazel -Ls https://github.com/bazelbuild/bazelisk/releases/download/v1.4.0/bazelisk-linux-amd64 && \
    chmod +x /usr/local/bin/bazel

RUN mkdir /work
WORKDIR /work

RUN  dnf -y upgrade --refresh && \
     dnf -y install which git make clang ninja-build \
            autoconf automake libtool cmake python2 \
            patch lld libatomic libstdc++-static && \
     dnf -y clean all

RUN ln -s /usr/bin/python2 /usr/bin/python

ENV CC=clang CXX=clang++ USER=user HOME=/home/user
RUN mkdir -p /home/user && chmod 777 /home/user

ADD update-deps.sh /usr/local/bin/update-deps.sh
ENTRYPOINT /usr/local/bin/update-deps.sh

# build this image:
# docker build -t jwendell/bazel-container-image:latest .

# run this image:
# cd into proxy dir
# docker run --rm -it -v $(pwd):/work -u $(id -u):$(id -g) jwendell/bazel-container-image
# when it finishes, run git status and inspect the changed files
