# Configuración de Corne Keyboard

Este es un readme con toda la info sobre mi teclado, incluyendo las capas (layers),
funciones, todos, etc.

## FEATURES TO ADD

- [ ] Agregar home row mods a capa de simbolos para que se pueda usar bien cuando se este en word.

- [ ] Agregar una nueva capa para poner acentos (y la ñ) independientemente del SO. Esta se activaría al dejar presionado cualquiera de la teclas `esc` o `bscp`. En la misma estaría agregando los comandos de nvim para usarlos en cualquier app fuera de nvim, dígase por ejemplo en google docs. para moverme al final de la línea, borrar una tecla, borrar por palabra, o en MAC borrar toda la línea.

- [ ] Probar con `hyper` y si no con `Win + ctrl`

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

## grok

```c
// === TABLA DE PARES UNICODE (minúscula, mayúscula) ===
const uint32_t PROGMEM unicode_map[] = {
    [0] = 0x00E1, 0x00C1,  // á Á
    [1] = 0x00F3, 0x00D3,  // ó Ó
    [2] = 0x00E9, 0x00C9,  // é É
    [3] = 0x00FA, 0x00DA,  // ú Ú
    [4] = 0x00ED, 0x00CD,  // í Í
    [5] = 0x00E0, 0x00C0,  // à À
    [6] = 0x00F2, 0x00D2,  // ò Ò
    [7] = 0x00E8, 0x00C8,  // è È
    [8] = 0x00F9, 0x00D9,  // ù Ù
    [9] = 0x00EC, 0x00CC,  // ì Ì
    [10] = 0x00E4, 0x00C4, // ä Ä
    [11] = 0x00F6, 0x00D6, // ö Ö
    [12] = 0x00FC, 0x00DC, // ü Ü
    [13] = 0x00EF, 0x00CF, // ï Ï
    [14] = 0x00F1, 0x00D1  // ñ Ñ
};

// === CAPA 4 (con UP()) ===
[4] = LAYOUT_split_3x6_3(
      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
      XXXXXXX, UP(0), UP(1), UP(2), UP(3), UP(4),                            UP(5), UP(6), UP(7), UP(8), UP(9), XXXXXXX,
      XXXXXXX, UP(10), UP(11), UP(12), UP(13), XXXXXXX,                     XXXXXXX, UP(14), XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
                                          _______, TO(0), _______,       _______, _______, KC_BSPC
),
```

## deepseek

```c
[4] = LAYOUT_split_3x6_3(
  XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
  XXXXXXX, UP(0x00E1, 0x00C1), UP(0x00F3, 0x00D3), UP(0x00E9, 0x00C9), UP(0x00FA, 0x00DA), UP(0x00ED, 0x00CD),  UP(0x00E0, 0x00C0), UP(0x00F2, 0x00D2), UP(0x00E8, 0x00C8), UP(0x00F9, 0x00D9), UP(0x00EC, 0x00CC), XXXXXXX,
  UP(0x00E4, 0x00C4), UP(0x00F6, 0x00D6), UP(0x00FC, 0x00DC), UP(0x00EF, 0x00CF), XXXXXXX, XXXXXXX,              XXXXXXX, UP(0x00F1, 0x00D1), XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
                                        _______, _______, _______,       _______, _______, LT(4, KC_BSPC)
),
```
