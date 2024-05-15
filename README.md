# TinyPong
### Tiny ping pong game, just 942 bytes and 50 lines of code! 
![video](https://github.com/Ztry8/TinyPong/blob/main/assets/video.gif)  

The game is written in C99 using the [WASM-4](https://main--wasm4.netlify.app/).  
The main game file is written in 50 lines of code, but the [last 50 line is empty](https://stackoverflow.com/questions/72271/no-newline-at-end-of-file-compiler-warning)

To compile, you need: [WASI_SDK](https://github.com/WebAssembly/wasi-sdk) [make](https://www.gnu.org/software/make/manual/make.html) [WASM-4](https://main--wasm4.netlify.app/docs/getting-started/setup):
```
git clone https://github.com/Ztry8/TinyPong
cd TinyPong
make
cd build
w4 bundle cart.wasm --title "TinyPong" --html index.html
```
Then, open index.html
