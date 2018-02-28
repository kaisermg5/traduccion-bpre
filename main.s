

.definelabel espacio_libre, 0x8f00000


.gba
.thumb
.open rom_base,rom_parcheado,0x8000000

.include todas_las_sobreescrituras


.org espacio_libre
.importobj objeto_desplazable

.close
