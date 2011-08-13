module Roomer
  module Helpers
    module GeneratorHelper
      # Prints an error message and exits
      # TODO: Implement colors
      # @example exit_out_and_exit("Error message")
      # @param [String] message string declaring the message
      def error_out_and_exit(message)
        # color = Thor::Shell::Color.new
        # color.set_color(message,Thor::Shell::Color::RED,true)
        puts message
        exit
      end

      # Prints an info message
      # TODO: Implement colors
      # @example info_message("Success")
      # @param [String] message string declaring the message
      def info_message(message)
        # color = Thor::Shell::Color.new
        # color.set_color(message,Thor::Shell::Color::BLUE,true)
        puts message
      end
    end
  end
end


