ifndef WASI_SDK_PATH
$(error Download the WASI SDK (https://github.com/WebAssembly/wasi-sdk) and set $$WASI_SDK_PATH)
endif

CC = "$(WASI_SDK_PATH)/bin/clang" --sysroot="$(WASI_SDK_PATH)/share/wasi-sysroot"

# Compilation flags
CFLAGS = -std=c99 -pedantic -W -Wall -Wextra -Werror -Wno-unused -Wconversion -Wsign-conversion -MMD -MP -fno-exceptions -DNDEBUG -Oz -flto

# Linker flags
LDFLAGS = -Wl,-zstack-size=14752,--no-entry,--import-memory -mexec-model=reactor \
	-Wl,--initial-memory=65536,--max-memory=65536,--stack-first -Wl,--strip-all,--gc-sections,--lto-O3 -Oz

OBJECTS = $(patsubst src/%.c, build/%.o, $(wildcard src/*.c))
DEPS = $(OBJECTS:.o=.d)

ifeq '$(findstring ;,$(PATH))' ';'
    DETECTED_OS := Windows
else
    DETECTED_OS := $(shell uname 2>/dev/null || echo Unknown)
    DETECTED_OS := $(patsubst CYGWIN%,Cygwin,$(DETECTED_OS))
    DETECTED_OS := $(patsubst MSYS%,MSYS,$(DETECTED_OS))
    DETECTED_OS := $(patsubst MINGW%,MSYS,$(DETECTED_OS))
endif

ifeq ($(DETECTED_OS), Windows)
	MKDIR_BUILD = if not exist build md build
	RMDIR = rd /s /q
else
	MKDIR_BUILD = mkdir -p build
	RMDIR = rm -rf
endif

all: build/cart.wasm

build/cart.wasm: $(OBJECTS)
	$(CC) -o $@ $(OBJECTS) $(LDFLAGS)

build/%.o: src/%.c
	@$(MKDIR_BUILD)
	$(CC) -c $< -o $@ $(CFLAGS)

.PHONY: clean
clean:
	$(RMDIR) build

-include $(DEPS)