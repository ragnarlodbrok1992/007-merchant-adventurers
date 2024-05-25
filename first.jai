#import "Basic";
#import "Compiler";
#import "File";
#import "File_Utilities";

OUTPUT_EXECUTBLAE_NAME := "merchant-adventurers";

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
