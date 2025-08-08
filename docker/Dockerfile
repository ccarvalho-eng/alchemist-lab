FROM archlinux:latest

# Set environment variables
ENV LANG=C.UTF-8 \
  TERM=xterm-256color \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

# Build arguments with defaults
ARG USER=dev
ARG UID=1000
ARG GID=1000
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

# Create user and group first to leverage Docker layer caching
RUN groupadd -g $GID $USER && \
  useradd -m -u $UID -g $GID -s /bin/zsh -d /home/workspace $USER && \
  echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Update system and install packages
RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  base-devel \
  sudo \
  openssh \
  curl \
  wget \
  git \
  zsh \
  bash-completion \
  tmux \
  vim \
  neovim \
  python \
  python-pip \
  nodejs \
  npm \
  yarn \
  man-db \
  net-tools \
  iputils \
  procps-ng \
  which \
  htop \
  tree \
  starship \
  fzf \
  ripgrep \
  bat \
  exa \
  fd \
  jq \
  git-delta \
  httpie \
  direnv \
  lazygit && \
  pacman -Scc --noconfirm && \
  rm -rf /var/cache/pacman/pkg/* /tmp/* /var/tmp/*

# Copy configuration files (as root)
COPY .config/nvim /home/workspace/.config/nvim
COPY .config/starship/starship.toml /home/workspace/.config/starship.toml
COPY .config/lazygit/config.yml /home/workspace/.config/lazygit/config.yml
COPY .config/zsh/.zshrc /home/workspace/.zshrc

# Fix ownership of copied config files (as root)
RUN chown -R $USER:$USER /home/workspace/.config /home/workspace/.zshrc

# Switch to non-root user
USER $USER
WORKDIR /home/workspace

# Set up user configuration directories
RUN mkdir -p /home/workspace/projects

# Configure Git with build args
RUN if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then \
      git config --global user.name "$GIT_USER_NAME" && \
      git config --global user.email "$GIT_USER_EMAIL"; \
    fi

# Set working directory for development
WORKDIR /home/workspace

# Health check to ensure the container is working properly
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD zsh -c 'echo "Container health check"' || exit 1

# Use exec form for better signal handling
CMD ["/bin/zsh"]

# Metadata
LABEL maintainer="archlinux.pagan639@passmail.net" \
  description="Arch Linux development environment with modern CLI tools" \
  version="1.0"
