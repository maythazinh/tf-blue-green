#!/bin/bash
yum update -y
yum install httpd -y
echo "<h1>Hello from Green Environment</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd



# #!/bin/bash
# set -e  # Exit on error

# # Log output for debugging
# exec > /var/log/user-data.log 2>&1
# echo "Starting user-data script for Green instance"

# # Update and install httpd
# yum update -y || { echo "Failed to update packages"; exit 1; }
# yum install httpd -y || { echo "Failed to install httpd"; exit 1; }

# # Create index.html with green background (simplified HTML)
# cat << EOF > /var/www/html/index.html
# <!DOCTYPE html>
# <html>
# <head>
#   <title>Green Environment</title>
#   <style>
#     body {
#       background-color: green;
#       color: white;
#       text-align: center;
#       padding-top: 50vh;
#       font-family: Arial, sans-serif;
#     }
#   </style>
# </head>
# <body>
#   <h1>Hello from Green</h1>
# </body>
# </html>
# EOF

# # Set file ownership and permissions
# chown apache:apache /var/www/html/index.html || { echo "Failed to set ownership"; exit 1; }
# chmod 644 /var/www/html/index.html || { echo "Failed to set permissions"; exit 1; }

# # Restore SELinux context if enabled
# restorecon -Rv /var/www/html || { echo "Failed to restore SELinux context"; exit 1; }

# # Start and enable httpd
# systemctl start httpd || { echo "Failed to start httpd"; exit 1; }
# systemctl enable httpd || { echo "Failed to enable httpd"; exit 1; }

# echo "User-data script completed successfully"
