#!/usr/bin/env zsh

# Instalación de zsh-autosuggestions
brew install zsh-autosuggestions
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

# Instalación de zsh-syntax-highlighting
brew install zsh-syntax-highlighting
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
source ~/.zshrc

# Instalación de eza
brew install eza

# Instalación de zoxide
brew install zoxide

# Descargar el archivo .zshrc desde GitHub
echo "Descargando archivo .zshrc desde GitHub..."
curl -fsSL https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/zsh/.zshrc -o ~/.zshrc

# Recargar .zshrc para aplicar todos los cambios
source ~/.zshrc

echo "Configuración completada."
