#!/usr/bin/env zsh

# Descargar el archivo .p10k.zsh desde GitHub a la ruta de Powerlevel10k
# echo "Descargando archivo .p10k.zsh desde GitHub..."
# curl -fsSL https://raw.githubusercontent.com/Dev-environment/main/dotfiles/zsh/.p10k.zsh -o "$(brew --prefix)/share/powerlevel10k/.p10k.zsh"


# Instalación de Powerlevel10k
echo "Instalando Powerlevel10k..."
brew install powerlevel10k
  echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
  echo "Tema Powerlevel10k agregado a .zshrc."
# Verificar si el tema ya está en .zshrc
# if ! grep -q "powerlevel10k.zsh-theme" ~/.zshrc; then
#   echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
#   echo "Tema Powerlevel10k agregado a .zshrc."
# else
#   echo "Powerlevel10k ya está configurado en .zshrc."
# fi


# Recargar .zshrc para aplicar el tema y el archivo .p10k.zsh
source ~/.zshrc

echo "Configuración de Powerlevel10k completada."
