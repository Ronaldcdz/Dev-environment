# Configuración de Corne Keyboard

Este es un readme con toda la info sobre mi teclado, incluyendo las capas (layers),
funciones, todos, etc.

## FEATURES TO ADD

- [ ] Agregar una nueva capa para poner acentos (y la ñ) independientemente del SO. Esta se activaría al dejar presionado cualquiera de la teclas `esc` o `bscp`. En la misma estaría agregando los comandos de nvim para usarlos en cualquier app fuera de nvim, dígase por ejemplo en google docs. para moverme al final de la línea, borrar una tecla, borrar por palabra, o en MAC borrar toda la línea.

- [ ] Usar ambos "super" para mover ventanas a otros workspaces, el izquierdo será encargado de moverse dentro del workspace, dígase izquierda, derecha, arriba, abajo, "]" para pasar a la siguiente app dentro del stack "}" para ir a la siguiente app. El "super" derecho será para moverse entre los workspaces, pausar, detener, desagrupar, etc. Y ambos "super" será para mover ventanas a diferentes workspaces. Tambien puedo usar las teclas de `esc` o `bscp`. para mover entre workspaces

- [ ] Cambiar komorebi para que del lado izquierdo se use el "super" y del derecho se use "super + capslock" para evitar usar capas. (tener en cuenta el "space" para cambiar de layot tile a layout float).
- [ ] Agregar "**\_\_**" para todos los botones del pulgar en capa 1 y 2.
- [ ] Agregar boton de macro para repetir lo mismo que acabo de hacer en el keyboard.

## Copiar y hacer en la Mac

```pwsh
qmk new-keymap -kb crkbd/rev1 -km ronald
```

```pwsh
cd ~/qmk_firmware/keyboards/crkbd/keymaps/ronald
```
