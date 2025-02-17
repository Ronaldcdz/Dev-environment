#!/usr/bin/env zsh

echo "Instalando herramientas adicionales con Homebrew..."
brew install zsh-autosuggestions zsh-syntax-highlighting eza zoxide

# Agregar configuraciones de plugins al .zshrc si no existen ya
if ! grep -q "zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
fi

if ! grep -q "zsh-syntax-highlighting.zsh" "$HOME/.zshrc"; then
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
fi
