#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Define colors for output using tput for better compatibility
PINK=$(tput setaf 204)
PURPLE=$(tput setaf 141)
GREEN=$(tput setaf 114)
ORANGE=$(tput setaf 208)
BLUE=$(tput setaf 75)
YELLOW=$(tput setaf 221)
RED=$(tput setaf 196)
NC=$(tput sgr0) # No Color

# Ronaldcdz Dev-environment logo with pink color (adapted from original)
logo='
                      ░░░░░░      ░░░░░░                      
                    ░░░░░░░░░░  ░░░░░░░░░░                    
                  ░░░░░░░░░░░░░░░░░░░░░░░░░░                  
                ░░░░░░░░░░▒▒▒▒░░▒▒▒▒░░░░░░░░░░                
              ░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░              
  ▒▒        ░░░░░░▒▒▒▒▒▒▒▒▒▒██▒▒██▒▒▒▒▒▒▒▒▒▒░░░░░░        ▒▒  
▒▒░░    ░░░░░░░░▒▒▒▒▒▒▒▒▒▒████▒▒████▒▒▒▒▒▒▒▒▒▒░░░░░░░░    ░░▒▒
▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒
██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒██████▓▓██▒▒██████▒▒▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
  ████▒▒▒▒▒▒████▒▒▒▒██████████  ██████████▒▒▒▒████▒▒▒▒▒▒▒▒██  
    ████████████████████████      ████████████████████████    
      ██████████████████              ██████████████████      
          ██████████                      ██████████          
'
# Display logo and title
echo -e "${PINK}${logo}${NC}"
echo -e "${PURPLE}Welcome to the Ronaldcdz Dev-environment Auto Config!${NC}"

sudo -v

while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Function to prompt user for input with a select menu
select_option() {
  local prompt_message="$1"
  shift
  local options=("$@")
  PS3="${ORANGE}$prompt_message${NC} "
  select opt in "${options[@]}"; do
    if [ -n "$opt" ]; then
      echo "$opt"
      break
    else
      echo -e "${RED}Invalid option. Please try again.${NC}"
    fi
  done
}

# Function to prompt user for input with a default option
prompt_user() {
  local prompt_message="$1"
  local default_answer="$2"
  read -p "$(echo -e ${BLUE}$prompt_message [$default_answer]${NC}) " user_input
  user_input="${user_input:-$default_answer}"
  echo "$user_input"
}

# Function to display a spinner
spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Function to check and create directories if they do not exist
ensure_directory_exists() {
  local dir_path="$1"
  if [ ! -d "$dir_path" ]; then
    echo -e "${YELLOW}Directory $dir_path does not exist. Creating...${NC}"
    mkdir -p "$dir_path"
  else
    echo -e "${GREEN}Directory $dir_path already exists.${NC}"
  fi
}

# Function to run commands with optional suppression of output
run_command() {
  local command=$1
  if [ "$show_details" = "Yes" ]; then
    eval $command
  else
    eval $command &>/dev/null
  fi
}

# Function to detect if the system is Arch Linux
is_arch() {
  if [ -f /etc/arch-release ]; then
    return 0
  else
    return 1
  fi
}

# Function to install basic dependencies
install_dependencies() {
  if is_arch; then
    run_command "sudo pacman -Syu --noconfirm"
    run_command "sudo pacman -S --needed --noconfirm base-devel curl file git wget unzip fontconfig"
    run_command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    run_command ". $HOME/.cargo/env"
  else
    run_command "sudo apt-get update"
    run_command "sudo apt-get install -y build-essential curl file git unzip fontconfig"
    run_command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    run_command ". $HOME/.cargo/env"
  fi
}

install_homebrew_with_progress() {
  local install_command="$1"

  echo -e "${YELLOW}Installing Homebrew...${NC}"

  if [ "$show_details" = "No" ]; then
    # Run installation in the background and show progress
    (eval "$install_command" &>/dev/null) &
    spinner
  else
    # Run installation normally
    eval "$install_command"
  fi
}

# Function to install Homebrew if not installed
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}Homebrew is not installed. Installing Homebrew...${NC}"

    if [ "$show_details" = "No" ]; then
      # Show progress bar while installing Homebrew
      install_homebrew_with_progress "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
      spinner
    else
      # Install Homebrew normally
      run_command "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi

    # Add Homebrew to PATH based on OS
    if [ "$os_choice" = "mac" ]; then
      run_command "(echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> $USER_HOME/.zshrc)"
      run_command "(echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> $USER_HOME/.bashrc)"
      run_command "mkdir -p $USER_HOME/.config/fish"
      run_command "(echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> $USER_HOME/.config/fish/config.fish)"
      run_command "eval \"\$(/opt/homebrew/bin/brew shellenv)\""
    elif [ "$os_choice" = "linux" ]; then
      run_command "(echo 'eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"' >> ~/.zshrc)"
      run_command "(echo 'eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"' >> ~/.bashrc)"
      run_command "mkdir -p ~/.config/fish"
      run_command "(echo 'eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"' >> ~/.config/fish/config.fish)"
      run_command "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
    fi
  else
    echo -e "${GREEN}Homebrew is already installed.${NC}"
  fi
}

# Function to update or replace a line in a file
update_or_replace() {
  local file="$1"
  local search="$2"
  local replace="$3"

  if grep -q "$search" "$file"; then
    awk -v search="$search" -v replace="$replace" '
    $0 ~ search {print replace; next}
    {print}
    ' "$file" >"${file}.tmp" && mv "${file}.tmp" "$file"
  else
    echo "$replace" >>"$file"
  fi
}

# Ask if the user wants to see detailed output
show_details="Yes"

# Ask for the operating system
os_choice=$(select_option "Which operating system are you using? " "mac" "linux")

if [ "$os_choice" != "mac" ]; then
  # Install basic dependencies with progress bar
  echo -e "${YELLOW}Installing basic dependencies...${NC}"
  if [ "$show_details" = "No" ]; then
    install_dependencies &
    spinner
  else
    install_dependencies
  fi
else
  if xcode-select -p &>/dev/null; then
    echo -e "${GREEN}Xcode is already installed.${NC}"
  else
    run_command "xcode-select --install"
  fi
  run_command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
  run_command ". $HOME/.cargo/env"
fi

# Function to clone repository with progress bar
clone_repository_with_progress() {
  local repo_url="$1"
  local clone_dir="$2"
  local progress_duration=$3

  echo -e "${YELLOW}Cloning repository...${NC}"

  if [ "$show_details" = "No" ]; then
    # Run clone command in the background and show progress
    (git clone "$repo_url" "$clone_dir" &>/dev/null) &
    spinner "$progress_duration"
  else
    # Run clone command normally
    git clone "$repo_url" "$clone_dir"
  fi
}

# Step 1: Clone the Repository
echo -e "${YELLOW}Step 1: Clone the Repository${NC}"
if [ -d "Dev-environment" ]; then
  echo -e "${GREEN}Repository already cloned. Overwriting...${NC}"
  rm -rf "Dev-environment"
fi
clone_repository_with_progress "https://github.com/Ronaldcdz/Dev-environment.git" "Dev-environment" 20
cd Dev-environment || exit

# Install Homebrew if not installed
install_homebrew

# Shared Steps (macOS or Linux)

# Function to install shell or plugins with progress bar
install_shell_with_progress() {
  local name="$1"
  local install_command="$2"

  echo -e "${YELLOW}Installing $name...${NC}"
  if [ "$show_details" = "No" ]; then
    (eval "$install_command" &>/dev/null) &
    spinner
  else
    eval "$install_command"
  fi
}

set_as_default_shell() {
  local name="$1"

  echo -e "${YELLOW}Setting default shell to $name...${NC}"
  local shell_path
  shell_path=$(which "$name") # Obtener el camino completo del shell

  if [ -n "$shell_path" ]; then
    sudo sh -c "grep -Fxq \"$shell_path\" /etc/shells || echo \"$shell_path\" >> /etc/shells"

    sudo chsh -s "$shell_path" "$USER"

    if [ "$SHELL" != "$shell_path" ]; then
      echo -e "${RED}Error: Shell did not change. Please check manually.${NC}"
      echo -e "${GREEN}Command: sudo chsh -s $shell_path \$USER ${NC}"
    else
      echo -e "${GREEN}Shell changed to $shell_path successfully.${NC}"
    fi
  else
    echo -e "${RED}Shell $name not found.${NC}"
  fi
}

echo -e "${YELLOW}Step 2: Install and Configure Zsh${NC}"
shell_choice="zsh"
install_shell_with_progress "zsh" "brew install zsh carapace zoxide atuin"

install_shell_with_progress "zsh" "brew install zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete" ""

echo -e "${YELLOW}Configuring Zsh...${NC}"

mkdir -p ~/.cache/carapace
mkdir -p ~/.local/share/atuin

# Idempotent copy of zsh configs from your repo
if [ ! -f ~/.zshrc ] || [ ! -L ~/.zshrc ]; then
  ln -sf "$(pwd)/dotfiles/zsh/.zshrc" ~/.zshrc
else
  echo -e "${GREEN}.zshrc already exists (idempotent skip).${NC}"
fi

if [ ! -f ~/.p10k.zsh ] || [ ! -L ~/.p10k.zsh ]; then
  ln -sf "$(pwd)/dotfiles/zsh/.p10k.zsh" ~/.p10k.zsh
else
  echo -e "${GREEN}.p10k.zsh already exists (idempotent skip).${NC}"
fi

# PowerLevel10K Configuration
echo -e "${YELLOW}Configuring PowerLevel10K...${NC}"
run_command "brew install powerlevel10k"

# Function to install dependencies with progress bar
install_dependencies_with_progress() {
  local install_command="$1"

  echo -e "${YELLOW}Installing dependencies...${NC}"

  if [ "$show_details" = "No" ]; then
    # Run installation in the background and show progress
    (eval "$install_command" &>/dev/null) &
    spinner
  else
    # Run installation normally
    eval "$install_command"
  fi
}

# Dependencies Install
echo -e "${YELLOW}Step 3: Installing Additional Dependencies...${NC}"

if [ "$os_choice" = "linux" ]; then
  if ! is_arch; then
    # Combine the update and upgrade commands for progress (only if not Arch Linux)
    install_dependencies_with_progress "sudo apt-get update && sudo apt-get upgrade -y"
  fi
fi

# Function to install window manager with progress bar
install_window_manager_with_progress() {
  local install_command="$1"

  echo -e "${YELLOW}Installing window manager...${NC}"

  if [ "$show_details" = "No" ]; then
    # Run installation in the background and show progress
    (eval "$install_command" &>/dev/null) &
    spinner
  else
    # Run installation normally
    eval "$install_command"
  fi
}

# Install Tmux (fixed to tmux only)
echo -e "${YELLOW}Step 4: Install and Configure Tmux${NC}"
wm_choice="tmux"
if ! command -v tmux &>/dev/null; then
  if [ "$show_details" = "Yes" ]; then
    install_window_manager_with_progress "brew install tmux"
  else
    run_command "brew install tmux"
  fi
else
  echo -e "${GREEN}Tmux is already installed.${NC}"
fi

echo -e "${YELLOW}Configuring Tmux...${NC}"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  if [ "$show_details" = "Yes" ]; then
    install_window_manager_with_progress "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
  else
    run_command "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
  fi
else
  echo -e "${GREEN}Tmux Plugin Manager is already installed.${NC}"
fi

run_command "mkdir -p ~/.tmux"

# Idempotent symlink for tmux config
if [ ! -f ~/.tmux.conf ] || [ ! -L ~/.tmux.conf ]; then
  ln -sf "$(pwd)/dotfiles/tmux/.tmux.conf" ~/.tmux.conf
else
  echo -e "${GREEN}.tmux.conf already exists (idempotent skip).${NC}"
fi

echo -e "${YELLOW}Installing Tmux plugins...${NC}"
SESSION_NAME="plugin-installation"

# Check if session already exists and kill it if necessary
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
  echo -e "${YELLOW}Session $SESSION_NAME already exists. Killing it...${NC}"
  tmux kill-session -t $SESSION_NAME
fi

# Create a new session in detached mode with the specified name
tmux new-session -d -s $SESSION_NAME 'source ~/.tmux.conf; tmux run-shell ~/.tmux/plugins/tpm/bin/install_plugins'

# Check if the user wants to see details
if [ "$show_details" = "Yes" ]; then
  # Use a loop to show progress (adjust as needed)
  while tmux has-session -t $SESSION_NAME 2>/dev/null; do
    echo -n "."
    sleep 1
  done
  echo -e "\n${GREEN}Tmux plugins installation complete!${NC}"
else
  # Wait for a few seconds to ensure the installation completes
  while tmux has-session -t $SESSION_NAME 2>/dev/null; do
    sleep 1
  done

  echo -e "${GREEN}Tmux plugins installation complete!${NC}"
fi

# Ensure the tmux session is killed
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
  tmux kill-session -t $SESSION_NAME
fi

# Neovim Configuration
echo -e "${YELLOW}Step 5: Install and Configure Neovim${NC}"
install_nvim=$(select_option "Do you want to install Neovim?" "Yes" "No")

if [ "$install_nvim" = "Yes" ]; then

  # Check if Node.js is installed
  if ! command -v node &>/dev/null; then
    echo -e "${YELLOW}Node.js is not installed. Installing with Homebrew...${NC}"
    run_command "brew install node"
  else
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}Node.js is already installed: $NODE_VERSION${NC}"
  fi
  
  install_dependencies_with_progress "brew install nvim git gcc fzf fd ripgrep coreutils bat curl lazygit tree-sitter"

  echo -e "${YELLOW}Configuring Neovim...${NC}"
  ensure_directory_exists ~/.config/nvim

  # Idempotent symlink for nvim config (whole directory)
  if [ ! -d ~/.config/nvim ] || [ ! -L ~/.config/nvim ]; then
    ln -sf "$(pwd)/dotfiles/nvim" ~/.config/nvim
  else
    echo -e "${GREEN}~/.config/nvim already exists (idempotent skip).${NC}"
  fi

fi

# Clean up: Remove the cloned repository
sudo chown -R $(whoami) $(brew --prefix)/*
echo -e "${YELLOW}Cleaning up...${NC}"
cd ..
run_command "rm -rf Dev-environment"

set_as_default_shell "$shell_choice"

echo -e "${GREEN}Configuration complete. Restarting shell...${NC}"
echo -e "${GREEN}If it doesn't restart, restart your terminal.${NC}"

exec $shell_choice
