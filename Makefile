# Binaries
CC = arm-none-eabi-gcc

# Directories
SRC_DIR = src
OBJ_DIR = obj
INC_DIR = inc
DEB_DIR = debug
SUP_DIR = startup

# Files
SRC := $(wildcard $(SRC_DIR)/*.c)
SRC += $(wildcard $(SUP_DIR)/*.c)
OBJ := $(patsubst $(SRC_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(SRC))
OBJ := $(patsubst $(SUP_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(OBJ))
LD  := $(wildcard $(SUP_DIR)/*.ld)
INTERFACE_PATH = /usr/share/openocd/scripts/interface/stlink-v2.cfg
TARGET_PATH = /usr/share/openocd/scripts/target/stm32f4x.cfg

# Flags
MARCH = cortex-m4
CFLAGS = -g -Wall -Wextra -mcpu=$(MARCH) -mthumb -I./$(INC_DIR)
LFLAGS = -nostdlib -T $(LD) -Wl,-Map=$(DEB_DIR)/main.map 

# TARGETS
TARGET = $(DEB_DIR)/main.elf

all: $(OBJ) $(TARGET)

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c | mk_obj_dir
	$(CC) $(CFLAGS) -c -o $@ $^

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SUP_DIR)/%.c | mk_obj_dir
	$(CC) $(CFLAGS) -c -o $@ $^

$(TARGET) : $(OBJ) | mk_deb_dir
	$(CC) $(LFLAGS) -o $@ $^

flash:
	openocd -f $(INTERFACE_PATH) -f $(TARGET_PATH) &
	gdb-multiarch $(TARGET) -x $(SUP_DIR)/init.gdb
	pkill openocd

mk_obj_dir:
	mkdir -p $(SRC_DIR)/$(OBJ_DIR)

mk_deb_dir:
	mkdir -p $(DEB_DIR)

clean:
	rm -rf $(SRC_DIR)/$(OBJ_DIR) $(DEB_DIR)

.PHONY = clean mk_deb_dir mk_obj_dir flash
