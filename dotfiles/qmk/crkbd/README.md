# Configuración de Corne Keyboard

Este es un readme con toda la info sobre mi teclado, incluyendo las capas (layers),
funciones, todos, etc.

## FEATURES TO ADD

- [x] Agregar en neovim en modo Insertar un keymap como "C-v" para que haga "C-r + *" pegar y seguir en modo insert.
- [x] Agregar macros para "ctrl + z", "ctrl + x", "ctrl + c", "ctrl + v"
- [x] Cambiar "\_" por "-" && "++" por sus default los que vienen que hay que darles al shift para pulsarlos.
- [x] Reducir el tiempo que dura el flow tap para poder acceder a los modifiers sin tener que esperar tanto.

- [x] Doble tap en el botón de los pulgares que cambia a la capa 2(botón derecho)
      cambiará a la capa (layer 2) para evitar tener que dar al botón ubicado en
      la parte superior derecha. [Info aquí sobre TT-layer](https://docs.qmk.fm/feature_layers).

- [x] Agregar una función que permita el comportamiento por default de cuando se presionan
      la capa (layer 1) y capa (layer 2) muestre la capa (layer 3)

- [x] Agregar home-row mods que cuando se toque ejecute la letra "u" pero si se deja pulsado
      que devuelva "shft". Pero si se deja presionado sin pulsar ninguna otra tecla devuelva "u" a expeción de la tecla space.
- [x] Agregar en la tecla (spc) junto con Win, Ctrl + Alt para komorebi

## Copiar y hacer en la Mac

```pwsh
qmk new-keymap -kb crkbd/rev1 -km ronald
```

```pwsh
cd ~/qmk_firmware/keyboards/crkbd/keymaps/ronald
```
