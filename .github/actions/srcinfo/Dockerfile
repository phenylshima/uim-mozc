FROM docker.io/library/archlinux:base-devel

RUN pacman -Syu --needed --noconfirm pacman-contrib namcap git sudo

RUN groupadd -g 1001 runner && \
    useradd -m -u 1001 -g runner runner && \
    echo 'runner ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

WORKDIR /home/runner
USER runner  

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
