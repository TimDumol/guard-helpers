require 'guard/guard'

# Copyright (c) 2010-2012 Michael Kessler
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# Collects console and system notification methods and enhances them with
# some color information.
module ::Guard::Helpers::Formatter class << self

  # Print an info message to the console.
  #
  # @param [String] message the message to print
  # @param [Hash] options the output options
  # @option options [Boolean] :reset reset the UI
  #
  def info(message, options = { })
    ::Guard::UI.info(message, options)
  end

  # Print a debug message to the console.
  #
  # @param [String] message the message to print
  # @param [Hash] options the output options
  # @option options [Boolean] :reset reset the UI
  #
  def debug(message, options = { })
    ::Guard::UI.debug(message, options)
  end

  # Print a red error message to the console.
  #
  # @param [String] message the message to print
  # @param [Hash] options the output options
  # @option options [Boolean] :reset reset the UI
  #
  def error(message, options = { })
    ::Guard::UI.error(color(message, ';31'), options)
  end

  # Print a green success message to the console.
  #
  # @param [String] message the message to print
  # @param [Hash] options the output options
  # @option options [Boolean] :reset reset the UI
  #
  def success(message, options = { })
    stamped_message = "#{Time.now.strftime('%r')} #{message}"
    ::Guard::UI.info(color(stamped_message, ';32'), options)
  end

  # Outputs a system notification.
  #
  # @param [String] message the message to print
  # @param [Hash] options the output options
  # @option options [Symbol, String] :image the image to use, either :failed, :pending or :success, or an image path
  # @option options [String] :title the title of the system notification
  #
  def notify(message, options = { })
    ::Guard::Notifier.notify(message, options)
  end

  private

  # Print a info message to the console.
  #
  # @param [String] text the text to colorize
  # @param [String] color_code the color code
  #
  def color(text, color_code)
    ::Guard::UI.send(:color_enabled?) ? "\e[0#{ color_code }m#{ text }\e[0m" : text
  end

end
  end
