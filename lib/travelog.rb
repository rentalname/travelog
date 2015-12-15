require "travelog/version"

module Travelog
  class Diff
    attr_reader :append, :delete

    def initialize
      @delete = {}
      @append = {}
    end

    ADD_LINE = /^\+\s*([\w-]+)\s\(([\d\.]+)\)/
    DEL_LINE = /^-\s*([\w-]+)\s\(([\d\.]+)\)/
    def <<(line)
      case line.strip
      when ADD_LINE
        append_set($1, $2)
      when DEL_LINE
        delete_set($1, $2)
      end
    end

    def report
      puts "***** CHANGED GEM'S *****"
      (append.keys & delete.keys).each do |k|
        puts "#{k} #{append[k]}(was #{delete[k]})"
      end

      puts
      puts "***** INSTALLED GEM'S *****"
      (append.keys - delete.keys).each do |k|
        puts "#{k} #{append[k]}"
      end

      puts
      puts "***** UNINSTALLED GEM'S *****"
      (delete.keys - append.keys).each do |k|
        puts "#{k} #{delete[k]}"
      end
    end

    private
    def append_set(name, version)
      append[name] = version
    end

    def delete_set(name, version)
      delete[name] = version
    end
  end
end
