# $Id$

require 'logging/appenders/io'

module Logging::Appenders

  # This class provides an Appender that can write to a File.
  #
  class File < ::Logging::Appenders::IO

    # call-seq:
    #    File.new( name, :filename => 'file' )
    #    File.new( name, :filename => 'file', :truncate => true )
    #    File.new( name, :filename => 'file', :layout => layout )
    #
    # Creates a new File Appender that will use the given filename as the
    # logging destination. If the file does not already exist it will be
    # created. If the :truncate option is set to +true+ then the file will
    # be truncated before writing begins; otherwise, log messages will be
    # appened to the file.
    #
    def initialize( name, opts = {} )
      @fn = opts.delete(:filename) || opts.delete('filename')
      raise ArgumentError, 'no filename was given' if @fn.nil?

      mode = opts.delete(:truncate) || opts.delete('truncate')
      mode = mode ? 'w' : 'a'

      if ::File.exist?(@fn)
        if not ::File.file?(@fn)
          raise ArgumentError, "#{@fn} is not a regular file"
        elsif not ::File.writable?(@fn)
          raise ArgumentError, "#{@fn} is not writeable"
        end
      elsif not ::File.writable?(::File.dirname(@fn))
        raise ArgumentError, "#{::File.dirname(@fn)} is not writable"
      end

      super(name, ::File.new(@fn, mode), opts)
    end

  end  # class FileAppender
end  # module Logging::Appenders

# EOF