#-------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error La variable de entorno DEVKITARM no está definida)
endif

include $(DEVKITARM)/base_tools

#-------------------------------------------------------------------------------
# Tools
PREPROC := herramientas/preproc
SCANINC := herramientas/scaninc
GFX := herramientas/gbagfx

GENERADOR_INC := herramientas/generador_inc.sh


MKDIR_P := mkdir -p
RM_F := rm -f

#-------------------------------------------------------------------------------


BUILD := build
SOBREESCRITURAS := sobreescrituras
DESPLAZABLES := desplazables
OBJETO_LINKEADO := $(BUILD)/linkeado.o
TODO_INCLUIDO := $(BUILD)/todo_incluido
ROM_BASE := rom.gba
ROM_PARCHEADO := parcheado.gba

export ARMIPS ?= armips
export LD := $(PREFIX)ld

export ASFLAGS := -mthumb

export ARMIPS_FLAGS := -strequ rom_parcheado $(ROM_PARCHEADO) -strequ todas_las_sobreescrituras $(TODO_INCLUIDO) \
								-strequ objeto_desplazable $(OBJETO_LINKEADO)



#-------------------------------------------------------------------------------
	
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
getdeps=$(if $(strip $(wildcard $1)),$(shell $(SCANINC) $1),)

ASM_DESPLAZABLE := $(call rwildcard,$(DESPLAZABLES),*.s)
OBJETOS_DESPLAZABLES := $(ASM_DESPLAZABLE:%.s=$(BUILD)/%.o)

SRC_SOBREESCRITURAS :=  $(call rwildcard,$(SOBREESCRITURAS),*.s)
SOBREESCRITURAS_PREPROCESADAS := $(SRC_SOBREESCRITURAS:%.s=$(BUILD)/%.inc)


#-------------------------------------------------------------------------------

.PHONY: all clean

all: $(ROM_BASE) 


again: delete_rom all

$(ROM_BASE): $(TODO_INCLUIDO) $(OBJETO_LINKEADO)
	$(ARMIPS) main.s -strequ rom_base $@ $(ARMIPS_FLAGS)

clean:
	$(RM_F) -r $(BUILD) $(ROM_PARCHEADO)

$(TODO_INCLUIDO): $(SOBREESCRITURAS_PREPROCESADAS)
	@$(MKDIR_P) $(@D)
	$(GENERADOR_INC) $^ > $@

$(OBJETO_LINKEADO): $(OBJETOS_DESPLAZABLES) 
	$(LD) -r -o $@ $^ 



.SECONDEXPANSION:
.PRECIOUS: $(BUILD)/%.4bpp $(BUILD)/%.gbapal $(BUILD)/%.lz $(BUILD)/%.8bpp

$(BUILD)/%.4bpp: %.png
	@$(MKDIR_P) $(@D)
	$(GFX) $< $@
$(BUILD)/%.8bpp: %.png
	@$(MKDIR_P) $(@D)
	$(GFX) $< $@
$(BUILD)/%.gbapal: %.pal
	@$(MKDIR_P) $(@D)
	$(GFX) $< $@
$(BUILD)/%.lz: %
	@$(MKDIR_P) $(@D)
	$(GFX) $< $@

$(BUILD)/%.o: %.s $$(call getdeps,%.s)
	@$(MKDIR_P) $(@D)
	$(PREPROC) $< charmap.txt | $(AS) $(ASFLAGS) -o $@ 

$(BUILD)/%.inc: %.s $$(call getdeps,%.s)
	@$(MKDIR_P) $(@D)
	$(PREPROC) $< charmap.txt > $@ 


	
	
	

