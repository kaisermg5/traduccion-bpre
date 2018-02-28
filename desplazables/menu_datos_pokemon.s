
.align 2
label_0xf00000::
.incbin "build/build/desplazables/interfaz_datos_pokemon.4bpp.lz"

.org 0xf20
label_0xf00f20::
.string "Naturaleza {BYTE_F7} . Conseguido\nen {BYTE_F7}Á con {BYTE_F9}È {BYTE_F7}À.$$"

label_0xf00f4b::
.string "NO TIENE$"

label_0xf00f54::
.string "INFO. POKéMON$"

label_0xf00f62::
.string "HABIL. POKéMON$"

label_0xf00f71::
.string "MOV. POKéMON$"

label_0xf00f98::
.string "SIG. NIVEL$"
