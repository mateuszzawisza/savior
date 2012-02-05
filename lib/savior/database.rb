class Savior
  class Database
    def initialize(options = {})
      default_options = {
        :user          => nil,
        :password      => nil,
        :host          => "localhost",
        :port          => "3306",
        :database_name => nil,
      }
      options        = default_options.merge(options)
      @user          = options[:user]
      @password      = options[:password]
      @host          = options[:host]
      @port          = options[:port]
      @database_name = options[:database_name]
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
        cli_options << "-u #{@user}"
        cli_options << "-h #{@host}"
        cli_options << "-p#{@password}" if @password
        cli_options << "-P #{@port}"
        cli_options << "#{@database_name}"
        cli_options << "--single-transaction"
        cli_options.join(" ")
      end

      def set_db_snapshot_file_name
        "#{@database_name}_" +
          "snapshot_#{Time.now.strftime("%Y%m%d%H%M%S")}.sql"
      end
    #EOF private
  end
end
