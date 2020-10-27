########################################
# Makefile for basic STM32F4xx project
# Created on 2020-10-27 by sdiemert
########################################

########################################
# Define toolchain
########################################
CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
CP=arm-none-eabi-objcopy
SF=st-flash

########################################
# Define project specific details
########################################
TARGET=blink
PROJ_SRC=src
PROJ_INC=inc
PROJ_DEV=device
HAL_SRC=lib/STM32F4xx_HAL_Driver/Src

########################################
# Define source files for the project
# 
# All new files added to the project must
# be listed here
########################################
SRCS = $(PROJ_SRC)/main.c \
	   $(PROJ_DEV)/startup_stm32f401retx.s \
	   $(PROJ_SRC)/stm32f4xx_it.c \
	   $(PROJ_SRC)/system_stm32f4xx.c

########################################
# Define where to look for .h files
########################################
INC_DIRS = lib/STM32F4xx_HAL_Driver/Inc/ \
		   lib/CMSIS/Device/ST/STM32F4xx/Include/ \
		   lib/CMSIS/Include/ \
		   $(PROJ_SRC)/ \
		   $(PROJ_INC)/

INCLUDE = $(addprefix -I,$(INC_DIRS))

########################################
# Define HAL source dependencies
########################################
EXT_SRCS = $(HAL_SRC)/stm32f4xx_hal.c \
		   $(HAL_SRC)/stm32f4xx_hal_rcc.c \
		   $(HAL_SRC)/stm32f4xx_hal_gpio.c \
		   $(HAL_SRC)/stm32f4xx_hal_cortex.c \
		   $(HAL_SRC)/stm32f4xx_hal_exti.c

# get the .o files for the sources
EXT_OBJ = $(EXT_SRCS:.c=.o)

########################################
# Define flags for compilation
########################################

# this selects the specific board, must be given
DEFS = -DSTM32F401xE

CFLAGS = -std=gnu99 -g -O0 -Wall
CFLAGS += -mlittle-endian -mthumb -mthumb-interwork -mcpu=cortex-m4
CFLAGS += --specs=nosys.specs

LSCRIPT = device/stm32f401re_flash.ld
LFLAGS += -T$(LSCRIPT)

all: $(TARGET)

$(TARGET): $(TARGET).elf

$(TARGET).elf: $(SRCS) $(EXT_OBJ)
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) $(LFLAGS) $^ -o $@
	$(CP) -O ihex $(TARGET).elf   $(TARGET).hex
	$(CP) -O binary $(TARGET).elf $(TARGET).bin

%.o: %.c
	$(CC) -c -o $@ $(INCLUDE) $(DEFS) $(CFLAGS) $^

clean:
	rm -rf *.o *.elf *.bin *.hex

flash:
	$(SF) write $(TARGET).bin 0x8000000
