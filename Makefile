ifndef WASI_SDK_PATH
$(error Download the WASI SDK (https://github.com/WebAssembly/wasi-sdk) and set $$WASI_SDK_PATH)
endif

CC = "$(WASI_SDK_PATH)/bin/clang" --sysroot="$(WASI_SDK_PATH)/share/wasi-sysroot"

WASM_OPT = wasm-opt
WASM_OPT_FLAGS = -Oz --zero-filled-memory --strip-producers

# Compilation flags
CFLAGS = -W -Wall -Wextra -std=c99 -pedantic -Werror -pedantic-errors -MMD -MP -fno-exceptions
CFLAGS += -DNDEBUG -Oz -flto

# Linker flags
LDFLAGS = -Wl,-zstack-size=14752,--no-entry,--import-memory -mexec-model=reactor \
	-Wl,--initial-memory=65536,--max-memory=65536,--stack-first
LDFLAGS += -Wl,--strip-all,--gc-sections,--lto-O3 -Oz

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

ifeq (, $(shell command -v $(WASM_OPT)))
	@echo Tip: $(WASM_OPT) was not found. Install it from binaryen for smaller builds!
else
	$(WASM_OPT) $(WASM_OPT_FLAGS) $@ -o $@
endif

# Compile C sources
build/%.o: src/%.c
	@$(MKDIR_BUILD)
	$(CC) -c $< -o $@ $(CFLAGS)

.PHONY: clean
clean:
	$(RMDIR) build

-include $(DEPS)
