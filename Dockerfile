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

# Create user and group first to leverage Docker layer caching
RUN groupadd -g $GID $USER && \
  useradd -m -u $UID -g $GID -s /bin/zsh $USER && \
  echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Update system and install packages in a single layer
RUN pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  # Essential system packages
  base-devel \
  sudo \
  openssh \
  curl \
  wget \
  git \
  # Shell and terminal tools
  zsh \
  bash-completion \
  tmux \
  # Text editors
  vim \
  neovim \
  # Development tools
  python \
  python-pip \
  nodejs \
  npm \
  yarn \
  # System utilities
  man-db \
  net-tools \
  iputils \
  procps-ng \
  which \
  htop \
  tree \
  # Modern CLI tools
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
  # Clean package cache to reduce image size
  pacman -Scc --noconfirm && \
  # Remove unnecessary files
  rm -rf /var/cache/pacman/pkg/* \
  /tmp/* \
  /var/tmp/*

# Switch to non-root user early
USER $USER
WORKDIR /home/$USER

# Set up user configuration directories
RUN mkdir -p /home/$USER/.config \
  /home/$USER/workspace

# Configure Neovim
RUN git clone --depth=1 --branch=main \
  https://github.com/ccarvalho-eng/lazyvim-configs.git \
  /home/$USER/.config/nvim

# Configure Starship prompt with proper multiline TOML
RUN cat <<EOF > /home/$USER/.config/starship.toml
format = "\$all\$character"

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
EOF

# Configure Zsh with aliases, starship init and environment variables
RUN echo '# Starship prompt' >> /home/$USER/.zshrc && \
  echo 'eval "$(starship init zsh)"' >> /home/$USER/.zshrc && \
  echo '' >> /home/$USER/.zshrc && \
  echo '# Environment' >> /home/$USER/.zshrc && \
  echo 'export TERM=xterm-256color' >> /home/$USER/.zshrc && \
  echo 'export EDITOR=nvim' >> /home/$USER/.zshrc && \
  echo '' >> /home/$USER/.zshrc && \
  echo '# Aliases' >> /home/$USER/.zshrc && \
  echo 'alias ls="exa --icons"' >> /home/$USER/.zshrc && \
  echo 'alias ll="exa -l --icons"' >> /home/$USER/.zshrc && \
  echo 'alias la="exa -la --icons"' >> /home/$USER/.zshrc && \
  echo 'alias cat="bat"' >> /home/$USER/.zshrc && \
  echo 'alias find="fd"' >> /home/$USER/.zshrc && \
  echo 'alias grep="rg"' >> /home/$USER/.zshrc

# Set working directory for development
WORKDIR /home/$USER/workspace

# Health check to ensure the container is working properly
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD zsh -c 'echo "Container health check"' || exit 1

# Use exec form for better signal handling
CMD ["/bin/zsh"]

# Metadata
LABEL maintainer="archlinux.pagan639@passmail.net" \
  description="Arch Linux development environment with modern CLI tools" \
  version="1.0"
