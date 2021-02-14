# Based on 20.04 LTS
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yq update
RUN apt-get -y upgrade
RUN apt-get -yq --no-install-suggests --no-install-recommends install ocaml
RUN apt-get -yq --no-install-suggests --no-install-recommends install menhir
RUN apt-get -yq --no-install-suggests --no-install-recommends install llvm 
RUN apt-get -yq --no-install-suggests --no-install-recommends install llvm-dev
RUN apt-get -yq --no-install-suggests --no-install-recommends install m4
RUN apt-get -yq --no-install-suggests --no-install-recommends install git
RUN apt-get -yq --no-install-suggests --no-install-recommends install aspcud
RUN apt-get -yq --no-install-suggests --no-install-recommends install ca-certificates
RUN apt-get -yq --no-install-suggests --no-install-recommends install python2.7 
RUN apt-get -yq --no-install-suggests --no-install-recommends install pkg-config 
RUN apt-get -yq --no-install-suggests --no-install-recommends install cmake
RUN apt-get -yq --no-install-suggests --no-install-recommends install opam
RUN apt-get -yq --no-install-suggests --no-install-recommends install vim


# RUN ln -s /usr/bin/lli-10 /usr/bin/lli
# RUN ln -s /usr/bin/llc-10 /usr/bin/llc

# Run eval $(opam env)
RUN opam init -yq --disable-sandboxing --reinit
RUN opam install -yq llvm.10.0.0
RUN opam install -yq ocamlfind

WORKDIR /root

ENTRYPOINT ["opam", "config", "exec", "--"]

CMD ["bash"]
