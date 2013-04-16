# Starter code that can be included into a Guard plugin
module ::Guard::Helpers::Starter

  ## Helper methods

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
  # Detects the output directory for each CoffeeScript file. Builds
  # the product of all watchers and assigns to each directory
  # the files to which it belongs to.
  #
  # @param [Array<Guard::Watcher>] watchers the Guard watchers in the block
  # @param [Array<String>] files the CoffeeScript files
  # @param [Hash] options the options for the execution
  # @option options [String] :output the output directory
  # @option options [Boolean] :shallow do not create nested directories
  #
  def detect_nested_directories(watchers, files, options)
    return { options[:output] => files } if options[:shallow]

    directories = { }

    watchers.product(files).each do |watcher, file|
      if matches = file.match(watcher.pattern)
        target = matches[1] ? File.join(options[:output], File.dirname(matches[1])).gsub(/\/\.$/, '') : options[:output] || File.dirname(file)
        if directories[target]
          directories[target] << file
        else
          directories[target] = [file]
        end
      end
    end

    directories
  end
  # End of copyrighted code

  # The filename of the target file
  def target_filename(directory, file)
    File.join(directory, File.basename(file))
  end

  # The action to be performed on a file (e.g., compilation)
  def act_on(directory, file)
    raise NotImplementedError.new('act_on not implemented')
  end

  # Informs the user of an error
  def error(message, path)
    message = "#{self.class.name} ERROR: #{path} with error '#{message}'"
    Formatter.error message
    Formatter.notify message, :image => :failed
  end

  # Informs the user that an action has succeeded.
  def notify(path, action="COMPILED")
    message = if paths.length <= 8
                "#{self.class.name} #{action}: #{paths.join(', ')}" 
              else 
                "#{self.class.name} #{action}: #{paths[0..7].join(', ')}, and others." 
              end
    Formatter.success message
    Formatter.notify message, :image => :success
  end


  ## Defaults
  # Calls #run_all if the :all_on_start option is present.
  def start
    run_all if options[:all_on_start]
  end

  # Call #run_on_change for all files which match this guard.
  def run_all
    run_on_changes(Watcher.match_files(self, Dir.glob('**{,/*/**}/*').uniq.compact))
  end

  # The default action when a path is removed is to remove the matching
  # compiled file
  def run_on_removals(paths)
    paths = paths.select {|path| not options[:exclude] =~ path and File.file? path}

    directories = detect_nested_directories(watchers, paths, options)
    removed = []

    directories.each do |directory, files|
      files.each do |file|
        begin
          File.delete file
          removed << file
        rescue Error::ENOENT
          # Ignore
        end
      end
    end
    if removed.length > 0
      notify(removed, "REMOVED")
    end
  end
  
  # Run `act_on` on each file that is watched
  def run_on_changes(paths)
    paths = paths.select {|path| not options[:exclude] =~ path and File.file? path}

    directories = detect_nested_directories(watchers, paths, options)
    written = []

    directories.each do |directory, files|
      files.each do |file|
        begin
          act_on(directory, file)
          written << file
        rescue Exception => e
          error(e.message, file)
          throw :task_has_failed
        end
      end
    end
    if written.length > 0
      notify(written)
    end
  end
end
