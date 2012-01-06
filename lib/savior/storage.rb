module Savior
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

    def upload_file
      s3_snapshot_object = @s3.bucket[@options[:backups_bucket]].
        objects[@options[:db_snapshot_file]]
      s3_snapshot_object.write(File.read(@options[:db_snapshot_file]))
    end

    # keep:
    #  - 24 hourly
    #  - 7 daily
    #  - 4 weekly
    #  - infinite monthly
    def cleanup_old_snapshots
    end
  end
end
