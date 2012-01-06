module Savior
  class Database
    def initialize(options = {})
      default_options = {
        :host => "localhost",
        :port => "3306"
      }
      @credentials = default_options.merge(options)
    end

    def create_snapshot
      IO.popen("mysqldump","r+") do |pipe|
        pipe.puts "#{mysql_command_line_options} > #{db_snapshot_file}"
        pipe.close_write
        pipe.gets
      end
    end

    def cleanup_temporary_files
    end

    private
      def mysql_command_line_options
        cli_options = []
        cli_options << "-u #{@credentials[:user]}"
        cli_options << "-h #{@credentials[:host]}"
        cli_options << "-p#{@credentials[:password]}"
        cli_options << "-P #{@credentials[:port]}"
        cli_options << "#{@credentials[:database_name]}"
        cli_options.join(" ")
      end

      def db_snapshot_file
        "#{@credentials[:database_name]}_" +
        "snapshot_#{Time.now.strftime("%Y%m%d%H%M%S")}.sql"
      end
    #EOF private
  end
end
