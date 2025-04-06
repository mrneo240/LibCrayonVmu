# Compiler and flags
CC = kos-cc
CFLAGS = -g3 -Wall -Wextra -Wformat=2 -fno-common -c -Iinclude/crayon_vmu
AR = kos-ar
ARFLAGS = rcs

# Library name
LIB_NAME = crayonvmu
LIB_FILE = lib/lib$(LIB_NAME).a
LIB_DIR = lib
BUILD_DIR = build

# Source files
SRCS = src/savefile.c src/setup.c
OBJS = $(SRCS:src/%.c=$(BUILD_DIR)/%.o)

# Default target
all: $(LIB_DIR) $(LIB_FILE) 

# Ensure the build and lib directories exist
$(BUILD_DIR) $(LIB_DIR):
	mkdir -p $@

# Rule to create object files in the build directory
$(BUILD_DIR)/%.o: src/%.c $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

# Rule to create the static library
$(LIB_FILE): $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

# Clean up
clean:
	rm -rf $(BUILD_DIR) $(LIB_DIR)

.PHONY: all clean
