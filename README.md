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

Close the mysql shell


# Download the repo
```git clone --branch distribution https://github.com/UCSF-MS-DCC/TopoDB;```

# Initialize the database:
```rails db:migrate```

# To create a sample dataset:
```rails db:seed```

# Start the application:
```rails s```

in the address bar of a web browser enter localhost:3000 to access TopoDB

# Authentication
Creating the sample data set will also create an administrator-level account that you may use to log into TopoDB. See the seed.rb file for the username and password. Once logged in as the administrator it is recommended that you create new users to handle day-to-day activities in the application. It's also recommended that you change the Administrator account password. Both of these activities can be done either directly in the users database table, or through the included rails admin feature, available in the main navigation bar.

