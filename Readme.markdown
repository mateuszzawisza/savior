[![Build Status](https://secure.travis-ci.org/mateuszzawisza/savior.png)](http://travis-ci.org/mateuszzawisza/savior)

Savior
==

Savior is a ruby library (gem) that provides easy to setup MySQL database backups to Amazon AWS S3

Installation
==

    gem install savior


Setup and run
==

To run you can use the executable:

    savior -c path/to/config.yml


Config file is a simple YAML file:

    :database:
      :user: myuser
      :database_name: production_db
      :password: super_secret
    :storage:
      :access_key_id: 123123123
      :secret_access_key: abcabcabcabc
      :bucket_name: aws-s3-bucket-name



Gem is in very early stage and needs a lot of improvements but should work.

