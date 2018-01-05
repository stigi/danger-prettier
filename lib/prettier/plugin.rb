require "mkmf"

module Danger
  # Ensure files have been formatted with [Prettier](https://prettier.io/)
  #
  # @example Ensure files have been formatted
  #
  #          prettier.check
  #
  # @example Only check files that changed
  #
  #          prettier.filtering = true
  #          prettier.check
  #
  # @example Supply custom path to executable and config file
  #
  #          prettier.config_file = path/to/.prettierrc.json
  #          prettier.executable_path = path/to/bin/prettier
  #          prettier.check
  #
  # @example Supply custom file regex
  #
  #          prettier.file_regex = /\.jsx?$/
  #          prettier.check
  #
  # @see  Jacob Friedmann/danger-prettier
  # @tags lint, prettier, javascript, css
  #
  class DangerPrettier < Plugin
    # A path to prettiers's config file
    # @return [String]
    attr_accessor :config_file

    # A path to prettier's executable
    # @return [String]
    attr_accessor :executable_path

    # File matching regex
    # @return [Regex]
    attr_accessor :file_regex

    # Enable file filtering-only show messages within changed files.
    # @return [Boolean]
    attr_accessor :filtering

    # Checks javascript files for Prettier compliance.
    # Generates `errors` based on file differences from prettier.
    #
    # @return  [void]
    #
    def check
      check_results
        .reject { |r| r.length.zero? }
        .map { |r| send_comment r }
    end

    private

    # Get prettier's bin path
    #
    # return [String]
    def prettier_path
      local = executable_path ? executable_path : "./node_modules/.bin/prettier"
      File.exist?(local) ? local : find_executable("prettier")
    end

    # Get prettier' file pattern regex
    #
    # return [String]
    def matching_file_regex
      file_regex ? file_regex : /.js$/
    end

    # Get lint result regards the filtering option
    #
    # return [Hash]
    def check_results
      bin = prettier_path
      raise "prettier is not installed" unless bin
      return run_check(bin, ".") unless filtering
      ((git.modified_files - git.deleted_files) + git.added_files)
        .select { |f| f[matching_file_regex] }
        .map { |f| f.gsub("#{Dir.pwd}/", "") }
        .map { |f| run_check(bin, f) }
    end

    # Run prettier aginst a single file.
    #
    # @param   [String] bin
    #          The binary path of prettier
    #
    # @param   [String] file
    #          File to be checked
    #
    # return [Hash]
    def run_check(bin, file)
      command = "#{bin} --list-different"
      command << " --config #{config_file}" if config_file
      result = `#{command} #{file}`
      result
    end

    # Send comment with danger's fail method.
    #
    # @return [void]
    def send_comment(results)
      dir = "#{Dir.pwd}/"
      results.each do |r|
        filename = results["filePath"].gsub(dir, "")
        fail("File not formatted with Prettier", file: filename, line: 0)
      end
    end
  end
end
