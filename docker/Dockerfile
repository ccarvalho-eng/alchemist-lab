# ==============================================================================
# Elixir Development Environment Docker Image
# ==============================================================================
# This Dockerfile creates a comprehensive development environment for Elixir
# projects with modern CLI tools, editors, and shell configuration.
#
# Build arguments:
#   - USER: Development user name (default: dev)
#   - UID: User ID for host compatibility (default: 1000)
#   - GID: Group ID for host compatibility (default: 1000)
#   - GIT_USER_NAME: Git username for commits
#   - GIT_USER_EMAIL: Git email for commits
#
# Usage:
#   docker build --build-arg GIT_USER_NAME="Your Name" \
#                --build-arg GIT_USER_EMAIL="you@example.com" \
#                -t elixir-dev .
# ==============================================================================

# Stage 1: Rust Builder
# ------------------------------------------------------------------------------
# Build modern CLI tools written in Rust for better performance
FROM rust:1.89-bullseye AS rust-builder

# Install build dependencies for Rust tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    cmake \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install modern CLI tools written in Rust
# - bottom: System monitor (htop alternative)
# - du-dust: du alternative with better visualization  
# - procs: ps alternative with modern output
# - tokei: Code statistics tool
# - hyperfine: Command-line benchmarking tool
# Install each individually and continue on failure
RUN cargo install bottom || true
RUN cargo install du-dust || true  
RUN cargo install procs || true
RUN cargo install tokei || true
RUN cargo install hyperfine || true

# Install lazygit (Go-based tool) using GitHub releases
# Note: lazygit is written in Go, not Rust, so we install it separately
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && install lazygit /usr/local/bin \
    && rm lazygit.tar.gz lazygit

# Stage 2: Main Development Environment
# ------------------------------------------------------------------------------
# Use Elixir 1.18.2 with Erlang OTP 27.2 on Debian Bookworm
FROM hexpm/elixir:1.18.2-erlang-27.2-debian-bookworm-20250113-slim

# Environment Variables
# ------------------------------------------------------------------------------
ENV LANG=C.UTF-8 \
    TERM=xterm-256color \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Build Arguments
# ------------------------------------------------------------------------------
ARG USER=dev
ARG UID=1000
ARG GID=1000
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

# Install System Dependencies
# ------------------------------------------------------------------------------
# Core system tools and development dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    zsh \
    tmux \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    yarn \
    vim \
    neovim \
    man-db \
    net-tools \
    iputils-ping \
    procps \
    htop \
    tree \
    bash-completion \
    fonts-powerline \
    libncurses5-dev \
    libncursesw5-dev \
    libtinfo-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Modern CLI Tools (Debian packages)
# ------------------------------------------------------------------------------
# These are additional modern CLI tools available through apt
# - fzf: Fuzzy finder
# - ripgrep: Fast text search
# - bat: Cat with syntax highlighting
# - exa: Modern ls replacement
# - fd-find: Fast find alternative
# - jq: JSON processor
# - httpie: HTTP client
# - direnv: Environment variable manager
# - zoxide: Smart cd command
RUN apt-get update && apt-get install -y --no-install-recommends \
    fzf \
    ripgrep \
    bat \
    exa \
    fd-find \
    jq \
    httpie \
    direnv \
    zoxide \
    && rm -rf /var/lib/apt/lists/*

# Install git-delta from GitHub releases
# ------------------------------------------------------------------------------
RUN DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*') \
    && curl -Lo delta.tar.gz "https://github.com/dandavison/delta/releases/latest/download/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
    && tar xf delta.tar.gz --strip-components=1 \
    && install delta /usr/local/bin \
    && rm delta.tar.gz

# Install GitHub CLI
# ------------------------------------------------------------------------------
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy Rust CLI Tools from Builder Stage
# ------------------------------------------------------------------------------
# Copy all binaries from cargo bin directory (those that installed successfully)
COPY --from=rust-builder /usr/local/cargo/bin/ /usr/local/bin/
COPY --from=rust-builder /usr/local/bin/lazygit /usr/local/bin/lazygit

# User Setup
# ------------------------------------------------------------------------------
# Create development user with sudo privileges
RUN groupadd -g $GID $USER \
    && useradd -m -u $UID -g $GID -s /bin/zsh -d /home/$USER $USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER \
    && chmod 440 /etc/sudoers.d/$USER \
    && chown -R $USER:$USER /home/$USER

# Switch to development user
USER $USER
WORKDIR /home/workspace

# Shell Configuration
# ------------------------------------------------------------------------------
# Install Starship prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install Oh-My-Zsh with useful plugins
# - zsh-autosuggestions: Suggests commands as you type
# - zsh-syntax-highlighting: Highlights commands as you type
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone https://github.com/zsh-users/zsh-autosuggestions.git \
       ${ZSH_CUSTOM:-/home/$USER/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
       ${ZSH_CUSTOM:-/home/$USER/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Copy Configuration Files
# ------------------------------------------------------------------------------
COPY --chown=$USER:$USER .config/nvim /home/$USER/.config/nvim
COPY --chown=$USER:$USER .config/starship/starship.toml /home/$USER/.config/starship.toml
COPY --chown=$USER:$USER .config/lazygit/config.yml /home/$USER/.config/lazygit/config.yml
COPY --chown=$USER:$USER .config/zsh/.zshrc /home/$USER/.zshrc

# Create Projects Directory
# ------------------------------------------------------------------------------
RUN mkdir -p /home/$USER/projects \
    && mkdir -p /home/workspace/projects \
    && chown -R $USER:$USER /home/workspace

# Git Configuration
# ------------------------------------------------------------------------------
# Configure Git if user details are provided
RUN if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then \
        git config --global user.name "$GIT_USER_NAME" \
        && git config --global user.email "$GIT_USER_EMAIL"; \
    fi

# Health Check
# ------------------------------------------------------------------------------
# Simple health check to ensure container is responsive
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD zsh -c 'echo "Container health check"' || exit 1

# Default Command
# ------------------------------------------------------------------------------
# Start interactive Zsh shell
CMD ["/bin/zsh"]
