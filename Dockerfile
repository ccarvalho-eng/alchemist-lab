# Base image: bleeding edge
FROM archlinux:latest

# Don’t ask questions while installing
ENV LANG=C.UTF-8
ENV TERM=xterm-256color

# System upgrade + base tools
RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  base-devel \
  git \
  vim \
  curl \
  wget \
  sudo \
  openssh \
  man-db \
  bash-completion \
  net-tools \
  iputils \
  procps-ng \
  which \
  python \
  python-pip \
  nodejs \
  npm \
  yarn \
  tmux

# Add user (non-root dev)
ARG USER=dev
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $USER && \
  useradd -m -u $UID -g $GID -s /bin/bash $USER && \
  echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set workdir and switch to user
WORKDIR /home/$USER/workspace
USER $USER

# Optional: copy your dotfiles or setup scripts
# COPY .dotfiles /home/$USER/.dotfiles
# RUN /home/$USER/.dotfiles/install.sh

# Entrypoint: drop you into bash
CMD ["/bin/bash"]
