#!/usr/bin/env zsh

echo "Instalando herramientas adicionales con Homebrew..."
brew install zsh-autosuggestions zsh-syntax-highlighting eza zoxide

# Agregar configuraciones de plugins al .zshrc si no existen ya
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

source ~/.zshrc
