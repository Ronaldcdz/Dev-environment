#!/usr/bin/env zsh

echo "Instalando herramientas adicionales con Homebrew..."
brew postinstall gcc
brew install zsh-autosuggestions 
brew install zsh-syntax-highlighting 
brew install eza 
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
sudo mv ~/.local/bin/zoxide /usr/local/bin/

# Agregar configuraciones de plugins al .zshrc si no existen ya
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

source ~/.zshrc
