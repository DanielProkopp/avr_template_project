BIN=avr_blink
CC=avr-gcc
OBJCOPY=avr-objcopy

PROGRAMMER_TOOL=avrispmkII
PROGRAMMER_PORT=usb
MCU=m32u4
CC_MCU=atmega32u4
CFLAGS= -Os -DF_CPU=16000000UL -mmcu=$(CC_MCU)

SRC_DIR=src
INC_DIR=inc
BIN_DIR=bin

SRCS=$(wildcard $(SRC_DIR)/*.c)
OBJS=$(patsubst $(SRC_DIR)/%.c, $(BIN_DIR)/%.o, $(SRCS))

.PHONY: all clean flash debug

$(BIN_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

all: $(BIN_DIR)/$(BIN).hex

$(BIN_DIR)/$(BIN).hex: $(BIN_DIR)/$(BIN).elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

$(BIN_DIR)/$(BIN).elf: $(OBJS)
	$(CC) -o $@ $^

flash:
	avrdude -p $(MCU) -c $(PROGRAMMER_TOOL) -P $(PROGRAMMER_PORT) -U flash:w:$(BIN_DIR)/$(BIN).hex

fuse_write:
	avrdude -p $(MCU) -c $(PROGRAMMER_TOOL) -P $(PROGRAMMER_PORT) -U lfuse:w:0x5e:m -U hfuse:w:0x99:m -U efuse:w:0xf3:m

fuse_read:
	avrdude -p $(MCU) -c $(PROGRAMMER_TOOL) -P $(PROGRAMMER_PORT) -U lfuse:r:-:h -U hfuse:r:-:h -U efuse:r:-:h




clean:
	rm $(BIN_DIR)/*
