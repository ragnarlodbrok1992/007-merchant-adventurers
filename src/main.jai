#import "Basic";
#import "SDL";
#import "GL";

RESOLUTION_FACTOR := 80.0;
ENGINE_RUNNING := true;

main :: () {
  // Engine variables initialization
  WINDOW_WIDTH      := 16 * RESOLUTION_FACTOR;
  WINDOW_HEIGHT     := 9  * RESOLUTION_FACTOR;

  // Enter - exit messages
  print("Hello, Merchant Adventurers!");
  defer print("Everything went well, goodbye...");

  // Initialization of SDL - right now we're initializing everything
  if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
    print("SDL_Init Error: %\n", to_string(SDL_GetError()));
    return;
  }

  // Create a window
  window := SDL_CreateWindow("Merchant Adventurers",
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    (xx WINDOW_WIDTH), (xx WINDOW_HEIGHT),
    SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);

  if (!window) {
    print("SDL_CreateWindow Error: %\n", to_string(SDL_GetError()));
    return;
  }

  // Create a GL renderer context
  sdl_gl_context := SDL_GL_CreateContext(window);
  if (!sdl_gl_context) {
    print("SDL_GL_CreateContext Error: %\n", to_string(SDL_GetError()));
    return;
  }
}
