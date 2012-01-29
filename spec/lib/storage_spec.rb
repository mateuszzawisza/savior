require "spec_helper"

describe Savior::Storage do
  before(:each) do
    ENV['AMAZON_ACCESS_KEY_ID']     = 'abcdefghijklmnop'
    ENV['AMAZON_SECRET_ACCESS_KEY'] = '1234567891012345'
  end

  subject do
    Savior::Storage.new(
      :backups_bucket => "production-snapshots",
      :db_snapshot_file => "production-snapshot-123123123"
    )
  end

  let(:s3) { subject.instance_variable_get("@s3") }
  let(:options) { subject.instance_variable_get("@options") }

  describe "#initialize" do

    it "initializes AWS::S3 instance" do
      s3.should be_a_kind_of(AWS::S3)
    end

    context "AWS keys environment variables set" do
      it "sets access_key_id from environment variable" do
        s3.config.access_key_id.should eq('abcdefghijklmnop')
      end

      it "sets secret_access_key from environment variable" do
        s3.config.secret_access_key.should eq('1234567891012345')
      end
    end

    context "AWS keys passed as an options" do
      subject do
        Savior::Storage.new(
          :access_key_id => "zxcvbnmsdfghjk",
          :secret_access_key => "0987654321"
        )
      end

      it "sets access_key_id from environment variable" do
        s3.config.access_key_id.should eq('zxcvbnmsdfghjk')
      end

      it "sets secret_access_key from environment variable" do
        s3.config.secret_access_key.should eq('0987654321')
      end
    end

    it "sets backups_bucket option" do
      options[:backups_bucket].should eq("production-snapshots")
    end

    it "sets db_snapshot_file option" do
      options[:db_snapshot_file].should eq("production-snapshot-123123123")
    end

  end

  describe "#upload_file" do
    let(:bucket_mock) { double("bucket_mock", :[] => objects_mock) }
    let(:objects_mock) { double("objects_mock").as_null_object }
    let(:file) { double("file").as_null_object }

    before(:each) do
      s3.stub(:bucket).and_return(bucket_mock)
      File.stub(:read).and_return("test file")
    end

    it "invokes aws::s3#write method" do
      s3.should_receive(:bucket)
      subject.upload_file(file)
    end
  end

  describe "#cleanup_old_snapshots" do
    it "invokes aws::s3#remove method"
    it "removes no more then 24 last hourly snapshots"
    it "removes no more then 7 last daily snapshots"
    it "removes no more then 4 last weekly snapshots"
    it "does not remove monthly snapshots"
  end
end
