# Alchemist Lab

A comprehensive Elixir development environment using Docker with modern CLI tools, PostgreSQL database, and optimized developer experience.

## Features

### Development Environment

- **Elixir 1.18.2** with Erlang OTP 27.2
- **PostgreSQL 17** with persistent data storage
- **Node.js LTS** (latest) with npm and yarn
- **Neovim** (latest) with LazyVim configuration
- **Modern CLI Tools**: ripgrep, bat, exa, fzf, lazygit, and more
- **Zsh with Oh My Zsh** and useful plugins
- **Starship prompt** for beautiful terminal experience

### Database

- PostgreSQL 17 Alpine with persistent volumes
- Pre-configured connection environment variables
- Accessible on `localhost:5432` from host
- Default credentials: `postgres/postgres`

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Git

### Setup

1. Clone the repository:

```bash
git clone <repository-url>
cd alchemist-lab
```

2. Build and start the environment:

```bash
./bin/rebuild.sh
```

3. The container will automatically start with:
   - Working directory: `/home/workspace`
   - Your projects mounted at: `/home/workspace/projects`
   - PostgreSQL running and accessible

### Scripts

- `./bin/rebuild.sh` - Rebuild container with cache and enter shell
- `./bin/setup.sh` - Initial setup script
- `./bin/start.sh` - Start existing containers

## Database Configuration

### Environment Variables

The following environment variables are available in the container:

```bash
DATABASE_URL=postgres://postgres:postgres@postgres:5432/dev
PGHOST=postgres
PGUSER=postgres
PGPASSWORD=postgres
PGDATABASE=dev
```

### Connecting from Elixir Apps

Add to your `config/dev.exs`:

```elixir
config :your_app, YourApp.Repo,
  username: System.get_env("PGUSER", "postgres"),
  password: System.get_env("PGPASSWORD", "postgres"),
  hostname: System.get_env("PGHOST", "localhost"),
  database: System.get_env("PGDATABASE", "dev"),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

## CLI Tools Available

### Modern Replacements

- `rg` (ripgrep) - Fast text search
- `bat` - Cat with syntax highlighting
- `exa` - Modern ls replacement
- `fd` - Fast find alternative
- `fzf` - Fuzzy finder
- `zoxide` - Smart cd command
- `delta` - Git diff viewer

### Development Tools

- `lazygit` - Git TUI
- `gh` - GitHub CLI
- `psql` - PostgreSQL client
- `bottom` - System monitor
- `dust` - Disk usage analyzer
- `tokei` - Code statistics

## Directory Structure

```
alchemist-lab/
├── bin/                    # Utility scripts
│   ├── rebuild.sh         # Rebuild and enter container
│   ├── setup.sh           # Initial setup
│   └── start.sh           # Start containers
├── docker/                # Docker configuration
│   ├── Dockerfile         # Main development image
│   └── docker-compose.yml # Services configuration
├── .config/               # Configuration files
│   ├── nvim/             # Neovim configuration
│   ├── starship/         # Shell prompt config
│   ├── lazygit/          # Git TUI config
│   └── zsh/              # Shell configuration
└── README.md             # This file
```

## Usage Examples

### Start a New Elixir Project

```bash
# Inside the container
cd projects
mix new my_app --sup
cd my_app
mix deps.get
mix ecto.create  # Database will be created in PostgreSQL
```

### Database Operations

```bash
# Connect to PostgreSQL
psql

# Run migrations
mix ecto.migrate

# Reset database
mix ecto.reset
```

### Git Operations with LazyGit

```bash
# Open LazyGit TUI
lazygit
```

## Customization

### Adding New Tools

Edit `docker/Dockerfile` to add additional packages or tools.

### Shell Configuration

Modify `.config/zsh/.zshrc` to customize your shell experience.

### Database Configuration

Update `docker/docker-compose.yml` to modify PostgreSQL settings.

## Troubleshooting

### Container Issues

```bash
# Rebuild from scratch
docker-compose -f docker/docker-compose.yml down
docker-compose -f docker/docker-compose.yml build --no-cache
```

### Database Connection Issues

```bash
# Check PostgreSQL is running
docker ps
# Connect to database manually
psql -h localhost -U postgres -d dev
```

### Permission Issues

Ensure your user ID matches the container user (default: 1000).

## Contributing

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Test with `./bin/rebuild.sh`
5. Submit a pull request
