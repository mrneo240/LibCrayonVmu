TARGET_LIB ?= libcrayon_vmu.a

BUILD_DIR ?= build
SRC_DIRS ?= src

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INCS = include
INC_DIRS :=  $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS)) $(addprefix -I,$(INCS))

IAN_CFLAGS = -fno-gcse -ffast-math -fomit-frame-pointer
KOS_CFLAGS = -Os -fomit-frame-pointer -ml -m4-single-only -I/opt/toolchains/dc/kos/include -I/opt/toolchains/dc/kos/kernel/arch/dreamcast/include -I/opt/toolchains/dc/kos/addons/include -I/opt/toolchains/dc/kos/../kos-ports/include -D_arch_dreamcast -D_arch_sub_pristine -fno-strict-aliasing

BASE_CFLAGS = -DDC -Wshadow -Wstrict-aliasing=0 -ffunction-sections -fdata-sections
DEBUG_CFLAGS = $(BASE_CFLAGS) -DDEBUG
RELEASE_CFLAGS = $(BASE_CFLAGS) $(IAN_CFLAGS) -ffast-math -funsafe-math-optimizations
GCC5_FLAGS =
GCCVERSIONGTEQ4 := $(shell expr `sh-elf-gcc -dumpversion | cut -f1 -d.` \>= 5)

ifeq "$(GCCVERSIONGTEQ4)" "1"
    GCC5_FLAGS += -mfsca -mfsrra -mlra
endif

CFLAGS = $(RELEASE_CFLAGS) $(GCC5_FLAGS) -Wall -Wextra -std=gnu99
CC = sh-elf-gcc
AR = sh-elf-ar

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP

default: $(BUILD_DIR)/$(TARGET_LIB)

all: $(BUILD_DIR)/$(TARGET_LIB) example

lib: $(BUILD_DIR)/$(TARGET_LIB)

$(BUILD_DIR)/$(TARGET_LIB): $(OBJS)
	@echo -e "\n+  $@"
	@$(AR) rcs $@ $(OBJS)
	@$(MKDIR_P) $(dir $@) lib
	@$(CP_U) $@ lib

$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

$(BUILD_DIR)/%.c.o: %.c
	@echo "> $@"
	@$(MKDIR_P) $(dir $@)
	@$(CC) $(CPPFLAGS) $(CFLAGS) $(KOS_CFLAGS) $(LDFLAGS) -x c -c $< -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	@$(MKDIR_P) $(dir $@)
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(KOS_CFLAGS) $(LDFLAGS) -c $< -o $@

vmu_example:
	@$(MAKE) -C example all

.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)/src

-include $(DEPS)

MKDIR_P ?= mkdir -p
CP_U ?= cp -u
