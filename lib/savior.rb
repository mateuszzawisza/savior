load  "lib/savior/database.rb"
load  "lib/savior/storage.rb"

class Savior
  # load db configuration
  def database(options)
    @db = Savior::Database.new(options)
  end

  # load aws configuration
  def storage(options)
    @storage =  Savior::Storage.new(options)
  end

  def save
    check_configuration
    @db.create_snapshot
    @storage.upload_file
    @storage.cleanup_old_snapshots
    @db.cleanup_temporary_files
  end

  private
    def check_configuration
      raise "Database configuration not set" unless @db
      raise "Storage configuration not set" unless @storage
    end
  #EOF private
end
