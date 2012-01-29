class Savior
  class Database
    def initialize(options = {})
      default_options = {
        :user => nil,
        :password => nil,
        :host => "localhost",
        :port => "3306",
        :database_name => nil,
      }
      @credentials = default_options.merge(options)
    end

    def create_snapshot
      db_snapshot_file = set_db_snapshot_file_name
      IO.popen("mysqldump","r+") do |pipe|
        pipe.puts "#{mysql_command_line_options}"
        pipe.close_write
        pipe.gets
      end
      db_snapshot_file
    end

    def cleanup_temporary_files
    end

    private
      def mysql_command_line_options
        cli_options = []
        cli_options << "-u #{@credentials[:user]}"
        cli_options << "-h #{@credentials[:host]}"
        cli_options << "-p#{@credentials[:password]}" if @credentials[:password]
        cli_options << "-P #{@credentials[:port]}"
        cli_options << "#{@credentials[:database_name]}"
        cli_options << "--single-transaction"
        cli_options.join(" ")
      end

      def set_db_snapshot_file_name
        "#{@credentials[:database_name]}_" +
          "snapshot_#{Time.now.strftime("%Y%m%d%H%M%S")}.sql"
      end
    #EOF private
  end
end
