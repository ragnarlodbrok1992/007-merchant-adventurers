#import "Basic";
#import "Compiler";
#import "File";
#import "File_Utilities";
#import "String";

OUTPUT_EXECUTBLAE_NAME := "merchant-adventurers";
SDL_DLL_PATH := "D:/Jai/modules/SDL/windows/SDL2.dll";

#run {
  set_build_options_dc(.{do_output = false});

  build_output_directory := "build";
  resources_output_directory := "build";

  make_directory_if_it_does_not_exist(build_output_directory, recursive = true);
  make_directory_if_it_does_not_exist(resources_output_directory, recursive = true);

  w := compiler_create_workspace("Target workspace");
  options := get_build_options(w);

  options.output_executable_name = OUTPUT_EXECUTBLAE_NAME;
  options.output_path = build_output_directory;

  set_build_options(options, w);

  compiler_begin_intercept(w);
  add_build_file("src/main.jai", w);

  // Copying SDL2.dll
  copy_file(SDL_DLL_PATH, join(build_output_directory, "/SDL2.dll"));

  while true {
    message := compiler_wait_for_message();

    if message.kind == {
      case .ERROR;
        exit(1);
      case .COMPLETE;
        break;
    }
  }
  compiler_end_intercept(w);
}
