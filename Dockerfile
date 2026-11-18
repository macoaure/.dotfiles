FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
      zsh git stow curl base-devel sudo \
      bash && \
    pacman -Scc --noconfirm

# bats-core + libraries
RUN git clone --depth 1 https://github.com/bats-core/bats-core.git /opt/bats-core && \
    /opt/bats-core/install.sh /usr/local && \
    git clone --depth 1 https://github.com/bats-core/bats-support.git /opt/bats-support && \
    git clone --depth 1 https://github.com/bats-core/bats-assert.git /opt/bats-assert

RUN useradd -m -s /bin/zsh testuser && \
    echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER testuser
WORKDIR /home/testuser/.dotfiles

COPY --chown=testuser:testuser . .

ENTRYPOINT ["bats", "--recursive", "tests/"]
