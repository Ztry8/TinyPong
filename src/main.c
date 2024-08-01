#include <stdlib.h>
#include "wasm4.h"
#define WIDTH 5
#define HEIGHT 15
#define BALL_SIZE 5

char* itoa(unsigned char val) {
	static char buf[32] = {0}; unsigned char i = 30;
	for(; val && i; --i, val /= 10) buf[i] = "0123456789abcdef"[val%10];
	return &buf[i+1];
}

char paddles_collision(short y1, short y2, short ball_x, short ball_y) { 
    if (ball_x < WIDTH && ball_y < y2 + HEIGHT && ball_y + BALL_SIZE > y2) return 1;
    else if (ball_x + BALL_SIZE > SCREEN_SIZE-WIDTH && ball_y < y1 + HEIGHT && ball_y + BALL_SIZE > y1) return -1;
    return 0;
}

void update(void) {
    static short ball_x = SCREEN_SIZE/2, ball_y = SCREEN_SIZE/2, dir_x = 1, dir_y = 1, y1 = SCREEN_SIZE/2, y2 = SCREEN_SIZE/2;
    unsigned char gamepad1 = *GAMEPAD1;

    if (gamepad1 & BUTTON_UP && y1 > 0) y1 -= 2;
    else if (gamepad1 & BUTTON_DOWN && y1+HEIGHT < SCREEN_SIZE) y1 += 2;
    y2 = ball_y;

    char dir_now = paddles_collision(y1, y2, ball_x, ball_y);
    if (dir_now) dir_x = dir_now, tone(2000, 5, 100, TONE_PULSE1), dir_y = dir_now * (rand()%2 ? -1 : 1);
    ball_x += dir_x; ball_y += dir_y;

    static unsigned char score1 = 0, score2 = 0;
    if (ball_y > SCREEN_SIZE || ball_y < 0) tone(2000, 5, 100, TONE_PULSE1), dir_y *= -1;
    if (ball_x < 0 || ball_x > SCREEN_SIZE) {
        ball_x = SCREEN_SIZE/2; ball_y = SCREEN_SIZE/2;
        tone(1000, 5, 100, TONE_PULSE1);
        dir_x *= -1;
        if (ball_x < 0) score1++;
        else score2++;
    }

    *DRAW_COLORS = 0x04;
    text(score2 == 0 ? "0" : itoa(score2), 70, 0);
    text(score1 == 0 ? "0" : itoa(score1), 85, 0);
    rect(SCREEN_SIZE/2, 0, 2, SCREEN_SIZE);

    *DRAW_COLORS = 0x32;
    oval(ball_x, ball_y, BALL_SIZE, BALL_SIZE);
    rect(0, y2, WIDTH, HEIGHT);
    rect(SCREEN_SIZE-WIDTH, y1, WIDTH, HEIGHT);
}
