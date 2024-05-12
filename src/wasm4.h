#pragma once
#define WASM_EXPORT(name) __attribute__((export_name(name)))
#define WASM_IMPORT(name) __attribute__((import_name(name)))

WASM_EXPORT("start") void start(void);
WASM_EXPORT("update") void update(void);

#define SCREEN_SIZE 160

#define DRAW_COLORS ((unsigned short*)0x14)
#define GAMEPAD1 ((const unsigned char*)0x16)
#define GAMEPAD2 ((const unsigned char*)0x17)

#define BUTTON_UP 64
#define BUTTON_DOWN 128

WASM_IMPORT("oval")
void oval (signed x, signed y, unsigned width, unsigned height);

WASM_IMPORT("rect")
void rect (signed x, signed y, unsigned width, unsigned height);

WASM_IMPORT("text")
void text (const char* text, signed x, signed y);

WASM_IMPORT("tone")
void tone (unsigned frequency, unsigned duration, unsigned volume, unsigned flags);

#define TONE_PULSE1 0
