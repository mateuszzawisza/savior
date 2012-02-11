require File.join(File.dirname(__FILE__), "savior/database.rb")
require File.join(File.dirname(__FILE__), "savior/storage.rb")

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
    db_snapshot_file = @db.create_snapshot
    @storage.upload_file(db_snapshot_file, true)
  end

  private
    def check_configuration
      raise "Database configuration not set" unless @db
      raise "Storage configuration not set" unless @storage
    end
  #EOF private
end
