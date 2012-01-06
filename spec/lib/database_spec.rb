require 'spec_helper'

describe Savior::Database do

  subject do
    Savior::Database.new(
      :user => "testuser",
      :host => "db.example.com",
      :password => "SuperSecret",
      :database_name => "test_database"
    )
  end

  describe "#initialize" do

    let(:credentials) { subject.instance_variable_get("@credentials") }

    it "sets database credentials" do
      credentials.should_not be_nil
    end

    it "sets user name" do
      credentials[:user].should eq("testuser")
    end

    it "sets password" do
      credentials[:password].should eq("SuperSecret")
    end

    context "host is not given" do
      subject do
        Savior::Database.new
      end

      it "sets host to default" do
        credentials[:host].should eq("localhost")
      end
    end

    context "host is given" do
      subject do
        Savior::Database.new(:host => "db.example.com")
      end

      it "sets host" do
        credentials[:host].should eq("db.example.com")
      end
    end

    it "sets database name" do
      credentials[:database_name].should eq("test_database")
    end

    context "port is not set" do
      subject do
        Savior::Database.new
      end

      it "sets database port to default" do
        credentials[:port].should eq("3306")
      end
    end

    context "port is set" do
      subject do
        Savior::Database.new(:port => "1234")
      end

      it "sets database port to given value" do
        credentials[:port].should eq("1234")
      end
    end
  end

  describe "#create_snapshot" do
    let(:credentials) { subject.instance_variable_get("@credentials") }

    let :db_snapshot_file do
      "#{credentials[:database_name]}_snapshot_#{Time.now.strftime("%Y%m%d%H%M%S")}.sql"
    end

    let :mysql_options do
      "-u #{credentials[:user]} -h #{credentials[:host]} -p#{credentials[:password]} " +
        "-P #{credentials[:port]} #{credentials[:database_name]} > #{db_snapshot_file}"
    end

    let(:popen_mock) { double("popen") }

    before(:each) do
      IO.stub(:popen).and_yield(popen_mock)
      popen_mock.stub(:puts)
      popen_mock.stub(:gets)
      popen_mock.stub(:close_write)
    end

    it "invokes IO.popen" do
      IO.should_receive(:popen).with("mysqldump","r+")
      subject.create_snapshot
    end

    it "invokes IO.popen block" do
      popen_mock.should_receive(:puts).with(mysql_options)
      subject.create_snapshot
    end


    it "creates database snapshot file" do
      pending("should this be tested?")
      File.exist?(db_snapshot_file).should be_true
    end
  end

  describe "cleanup_temporary_files" do
    it "removes temporary snapshot files"
  end
end
