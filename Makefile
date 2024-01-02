# Sources:
# - https://www.gnu.org/software/make/manual/html_node/index.html
# - https://stackoverflow.com/questions/30573481/how-to-write-a-makefile-with-separate-source-and-header-directories
# - https://www.cs.princeton.edu/courses/archive/fall23/cos217/lectures/07_Building.pdf

# Directories
SRC_DIR     := src
INCLUDE_DIR := include
LIB_DIR     := lib
OBJ_DIR     := obj
BIN_DIR     := bin

# Files
EXE := $(BIN_DIR)/main
SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC))

# Compiler settings
CC     := gcc
CFLAGS := -std=c17 -g -O2
CPPFLAGS := -I$(INCLUDE_DIR) -MMD -MP
LDFLAGS  := -L$(LIB_DIR)
LDLIBS   :=

# GCC-supported safety flags
CFLAGS += \
 -Werror -Wall -Wextra -Wpedantic -Wformat=2 -Wformat-overflow=2             \
 -Wformat-truncation=2 -Wformat-security -Wnull-dereference                  \
 -Wstack-protector -Wtrampolines -Walloca -Wvla -Warray-bounds=2             \
 -Wimplicit-fallthrough=3 -Wtraditional-conversion -Wshift-overflow=2        \
 -Wcast-qual -Wstringop-overflow=4 -Wconversion -Warith-conversion           \
 -Wlogical-op -Wduplicated-cond -Wduplicated-branches -Wformat-signedness    \
 -Wshadow -Wstrict-overflow=4 -Wundef -Wstrict-prototypes -Wswitch-default   \
 -Wswitch-enum -Wstack-usage=1000000 -Wcast-align=strict                     \
 -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fstack-clash-protection       \
 -fPIE -fsanitize=bounds -fsanitize-undefined-trap-on-error -Wl,-z,relro     \
 -Wl,-z,now -Wl,-z,noexecstack -Wl,-z,separate-code

# Clang-supported safety flags
# CFLAGS += \
#  -Werror -Walloca -Wcast-qual -Wconversion -Wformat=2  -Wformat-security     \
#  -Wnull-dereference -Wstack-protector -Wvla -Warray-bounds                   \
#  -Warray-bounds-pointer-arithmetic -Wassign-enum -Wbad-function-cast         \
#  -Wconditional-uninitialized -Wconversion -Wfloat-equal                      \
#  -Wformat-type-confusion -Widiomatic-parentheses -Wimplicit-fallthrough      \
#  -Wloop-analysis -Wpointer-arith -Wshift-sign-overflow -Wshorten-64-to-32    \
#  -Wswitch-enum -Wtautological-constant-in-range-compare                      \
#  -Wunreachable-code-aggressive -Wthread-safety -Wthread-safety-beta -Wcomma  \
#  -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fsanitize=bounds              \
#  -fsanitize-undefined-trap-on-error

.PHONY: build run clean

build: $(EXE)

run: build
	./$(EXE)
clean:
	@rm -rf --preserve-root=all $(BIN_DIR) $(OBJ_DIR)

$(EXE): $(OBJ) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

-include $(OBJ:.o=.d)
