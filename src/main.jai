#import "Basic";
#import "SDL";
#import "GL";

#load "source/hexcube.jai";
#load "source/camera.jai";

RESOLUTION_FACTOR := 80.0;
ENGINE_RUNNING := true;

main :: () {
  // Engine variables initialization
  WINDOW_WIDTH      := 16 * RESOLUTION_FACTOR;
  WINDOW_HEIGHT     := 9  * RESOLUTION_FACTOR;

  // Enter - exit messages
  print("Hello, Merchant Adventurers!\n");
  defer print("Everything went well, goodbye...\n");

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

  defer SDL_DestroyWindow(window);
  defer SDL_Quit();

  // Counters
  perf_freq := SDL_GetPerformanceFrequency();

  perf_counter_end_frame : u64 = 0;
  while ENGINE_RUNNING {
    // Input checking - Should we do it before or after calculating the delta time?
    event : SDL_Event;

    while SDL_PollEvent(*event) {
      if event.type == {
        case SDL_QUIT;
          ENGINE_RUNNING = false;
        case SDL_KEYDOWN;
          if event.key.keysym.sym == SDLK_ESCAPE ENGINE_RUNNING = false;
        }
    }

    // Counters
    perf_counter_start_frame := SDL_GetPerformanceCounter();
    perf_delta := perf_counter_start_frame - perf_counter_end_frame;
    frame_time := cast(float) perf_delta / cast(float) perf_freq;

    // Delaying the frame... is this a good tactic?
    if frame_time >= 0.0 && frame_time <= 16.7 {
      SDL_Delay(cast(u32) (16.7 - frame_time));
    }

    // Simulation delta time
    perf_delta = SDL_GetPerformanceCounter() - perf_counter_end_frame;
    delta_time := cast(float) perf_delta / cast(float) perf_freq;
    // print("%\n", delta_time);

    // Clear per-frame allocations
    reset_temporary_storage();
    
    // Frame end time
    perf_counter_end_frame = SDL_GetPerformanceCounter();
  }
}
