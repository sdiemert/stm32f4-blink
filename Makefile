CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
CP=arm-none-eabi-objcopy
SF=st-flash

PROJ_NAME=blink

PROJ_SRC=src
STM_SRC=lib/STM32F4xx_HAL_Driver/Src

vpath %.c %(PROJ_SRC)
vpath %.c %(STM_SRC)

SRCS = src/main.c \
	device/startup_stm32f401retx.s \
	src/stm32f4xx_it.c \
	src/system_stm32f4xx.c

EXT_SRCS = $(STM_SRC)/stm32f4xx_hal.c \
		   $(STM_SRC)/stm32f4xx_hal_rcc.c \
		   $(STM_SRC)/stm32f4xx_hal_gpio.c \
		   $(STM_SRC)/stm32f4xx_hal_cortex.c \
		   $(STM_SRC)/stm32f4xx_hal_exti.c

EXT_OBJ = $(EXT_SRCS:.c=.o)

INC_DIRS = lib/STM32F4xx_HAL_Driver/Inc/ \
		   lib/CMSIS/Device/ST/STM32F4xx/Include/ \
		   lib/CMSIS/Include/ \
		   $(PROJ_SRC)/

INCLUDE = $(addprefix -I,$(INC_DIRS))

DEFS = -DSTM32F401xE

CFLAGS = -std=gnu99 -g -O0 -Wall
CFLAGS += -mlittle-endian -mthumb -mthumb-interwork -mcpu=cortex-m4
CFLAGS += --specs=nosys.specs

LSCRIPT = device/stm32f401re_flash.ld
LFLAGS += -T$(LSCRIPT)

all: $(PROJ_NAME)

$(PROJ_NAME): $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS) $(EXT_OBJ)
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) $(LFLAGS) $^ -o $@
	$(CP) -O ihex $(PROJ_NAME).elf   $(PROJ_NAME).hex
	$(CP) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

%.o: %.c
	$(CC) -c -o $@ $(INCLUDE) $(DEFS) $(CFLAGS) $^


clean:
	rm -rf *.o *.elf *.bin *.hex

flash:
	$(SF) write $(PROJ_NAME).bin 0x8000000
