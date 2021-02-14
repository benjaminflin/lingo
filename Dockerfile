# Based on 20.04 LTS
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yq update && \
    apt-get -y upgrade && \
    apt-get -yq --no-install-suggests --no-install-recommends install \
        ocaml \ 
        menhir \
        llvm \
        llvm-dev \
        m4 \
        git \
        aspcud \
        ca-certificates \
        python2.7 \
        pkg-config \
        cmake \ 
        opam \ 
        vim


# RUN ln -s /usr/bin/lli-10 /usr/bin/lli
# RUN ln -s /usr/bin/llc-10 /usr/bin/llc

RUN opam init -yq --disable-sandboxing --reinit
RUN opam install -yq \
    llvm.10.0.0 \
    ocaml

WORKDIR /root

ENTRYPOINT ["opam", "config", "exec", "--"]

CMD ["bash"]
