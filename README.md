# TopoDB
# Language requirements
TopoDB requires Ruby version >= 2.5.2, Ruby on Rails version >= 5.2.0, and bundler version 2.0 . We recommend using [rbenv](https://github.com/rbenv/rbenv) to install and manage Ruby gems. 
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

# CD into the TopoDB directory and install the application gems
```bundle install```

# Initialize the database
```rails db:migrate```

# Create a sample dataset
```rails db:seed```

# Start the application
```rails s```

in the address bar of a web browser enter http://localhost:3000 to access TopoDB

# Authentication
Log in as the admin user that was created as part of the sample data set: email: admin@topodb.topo, password: admin123 . 
Once logged in as the administrator it is strongly recommended that you create new users to handle day-to-day activities in the application. It's also recommended that you change the Administrator account password. Both of these activities can be done either directly in the users database table, or through the included rails admin feature, available in the main navigation bar.

# Permissions
TopoDB has three pre-defined types of account permissions: Admin, editor, and normal. Normal users have read-only access to mouse, cage, and experiment data and may not enter, delete, or update data. Editors may read as well as enter, update, or delete mice, cage, and experiment data. Admins have all of the privileges of editors and may also access the rails admin interface to create or remove users as well as change users' permissions. 

To add or remove a user's permissions, first access the Administration panel from the main navbar:
![README_1](https://github.com/UCSF-MS-DCC/TopoDB/blob/master/app/assets/images/topo_readme_1.png)


Next, select Users in the menu on the left:


![README 2](https://github.com/UCSF-MS-DCC/TopoDB/blob/master/app/assets/images/topo_readme_2.png)

Click the pencil icon on the row of the user to be edited:


![README 3](https://github.com/UCSF-MS-DCC/TopoDB/blob/master/app/assets/images/topo_readme_3.png)


To make a user an admin, change the admin field to true. To remove these privileges, change the fields to false. The default level of permissions (read-only) does not require changes to a User account field.

# Using TopoDB
## Navigation
