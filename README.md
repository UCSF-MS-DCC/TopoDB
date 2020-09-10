# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# TopoDB
# Language requirements
TopoDB requires Ruby version >= 2.5.2. We recommend using [rbenv](https://github.com/rbenv/rbenv) to install and manage Ruby versions.
# Database requirements
TopoDB is configured to use MySQL as the database component. Download and install MySQL prior to installing TopoDB on your system [here](https://dev.mysql.com/downloads/). 

Open the mysql shell and create a user and password for TopoDB to use to connect:
```mysql> CREATE USER 'topo'@'localhost' IDENTIFIED BY 'password';```

Create a database named topo_dev:
```mysql> CREATE DATABASE 'topo_database';```
Give the TopoDB user account all permissions on that database:
```mysql> GRANT ALL PRIVILEGES ON topo_database.* TO 'topo'@'localhost';```

# Download the repo
git clone --branch distribution https://github.com/UCSF-MS-DCC/TopoDB;

add the following to your local ENV:


initialize the database:
rails db:migrate

create a sample dataset:
rails db:seed

start the application:
rails s
