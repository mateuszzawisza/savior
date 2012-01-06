module Savior
  class Savior
    def initialize
      # load db configuration
      @db = Savior::Database.new(
        :host => host,
        :user => user,
        :password => password,
        :database_name => database_name
      )
      # load aws configuration
      @storage = Savior::Storage.new
    end

    def save
      @db.save
      @storage.upload_file
      @storage.cleanup_old_files
      @db.cleanup_temporary_files
    end
  end
end
