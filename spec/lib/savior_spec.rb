require "spec_helper"

describe Savior do
  let(:db_options) do
    {
      :user => "testuser",
      :host => "db.example.com",
      :password => "SuperSecret",
      :database_name => "test_database"
    }
  end

  let(:storage_options) do
    {
      :backups_bucket => "production-snapshots"
    }
  end

  describe "#database" do
    it "invokes Savior::Database.new with options" do
      Savior::Database.should_receive(:new).with(db_options)
      subject.database(db_options)
    end
  end

  describe "#storage" do
    it "invokes Savior::Storage.new with options" do
      Savior::Storage.should_receive(:new).with(storage_options)
      subject.storage(storage_options)
    end
  end

  describe "#save" do
    context "with no database configuration set" do
      it "raises error if @database is not set" do
        lambda { subject.save }.should raise_error(
          RuntimeError,
          "Database configuration not set"
        )
      end
    end

    context "with no storage configuration set" do
      before(:each) do
        subject.database(db_options)
      end

      it "raises error if @storage is not set" do
        lambda { subject.save }.should raise_error(
          RuntimeError,
          "Storage configuration not set"
        )
      end
    end

    context "with configuration set" do
      let(:db_snapshot_file_path) {"db_snapshot_file_path"}
      let(:database_mock) do
        double( "Database", { :create_snapshot => db_snapshot_file_path })
      end

      let(:storage_mock) do
        double("Storage", { :upload_file => true, :cleanup_old_snapshots => true })
      end

      before(:each) do
        Savior::Database.stub(:new).and_return(database_mock)
        Savior::Storage.stub(:new).and_return(storage_mock)
        subject.database(db_options)
        subject.storage(storage_options)
      end

      it "invokes Savior::Database#create_snapshot" do
        database_mock.should_receive(:create_snapshot)
        subject.save
      end

      it "invokes Savior::Storage#upload_file" do
        storage_mock.should_receive(:upload_file).with(db_snapshot_file_path, true)
        subject.save
      end
    end
  end
end
