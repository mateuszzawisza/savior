require "aws"

class Savior
  class Storage
    def initialize(options={})
      @access_key_id = options[:access_key_id] || ENV['AMAZON_ACCESS_KEY_ID']
      @secret_access_key = options[:secret_access_key] || ENV['AMAZON_SECRET_ACCESS_KEY']
      @bucket_name = options[:bucket_name]
      @s3 = AWS::S3.new(
        :access_key_id     => @access_key_id,
        :secret_access_key => @secret_access_key
      )
    end

    def upload_file(db_snapshot_file, remove_temp_file = false)
      s3_snapshot_object = @s3.buckets[@bucket_name].
        objects[db_snapshot_file]
      s3_snapshot_object.write(File.read(db_snapshot_file))
      if remove_temp_file
        File.delete(db_snapshot_file)
      end
    end
  end
end
