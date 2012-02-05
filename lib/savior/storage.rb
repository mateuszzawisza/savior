class Savior
  class Storage
    def initialize(options={})
      default_options = {
        :access_key_id     => ENV['AMAZON_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY'],
        :backups_bucket    => nil,
        :db_snapshot_file  => nil
      }
      @options = default_options.merge(options)
      @s3 = AWS::S3.new(
        :access_key_id     => @options[:access_key_id],
        :secret_access_key => @options[:secret_access_key]
      )
    end

    def upload_file(db_snapshot_file)
      s3_snapshot_object = @s3.bucket[@options[:backups_bucket]].
        objects[db_snapshot_file]
      s3_snapshot_object.write(File.read(db_snapshot_file))
    end
  end
end
