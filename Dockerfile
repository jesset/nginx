FROM ubuntu:latest as builder

# RUN sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
        apt-get -y install \
        wget unzip patch make git gcc build-essential bc \
        libpcre2-dev libpcre3-dev zlib1g-dev

WORKDIR /build
COPY . .
RUN ./configure && make -j`nproc`
RUN apt clean && rm -r /var/lib/apt/lists/*



# Executable image
FROM ubuntu:latest

# copy bin && conf
COPY --from=builder /build/objs/nginx /nginx

WORKDIR /
EXPOSE 80
CMD ["/nginx", "-V"]
