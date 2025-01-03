#!/bin/bash

# Exit on error
set -e

# Update package list and install Node.js and npm if not installed
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install pnpm if not installed
if ! command -v pnpm &> /dev/null; then
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    source ~/.bashrc
fi

# Navigate to the application directory
cd /var/www/frontdeskcontrol

# Pull the latest changes
git pull origin main

# Install dependencies
pnpm install

# Build the application
pnpm build

# Install and setup Nginx if not already done
if ! command -v nginx &> /dev/null; then
    sudo apt-get install -y nginx
fi

# Create Nginx configuration if it doesn't exist
if [ ! -f /etc/nginx/sites-available/frontdeskcontrol ]; then
    sudo tee /etc/nginx/sites-available/frontdeskcontrol > /dev/null <<EOF
server {
    listen 80;
    server_name www.frontdeskcontrol.com frontdeskcontrol.com;

    root /var/www/frontdeskcontrol/build;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~* \.(?:ico|css|js|gif|jpe?g|png)$ {
        expires 30d;
        add_header Pragma public;
        add_header Cache-Control "public";
    }
}
EOF

    # Create symbolic link
    sudo ln -sf /etc/nginx/sites-available/frontdeskcontrol /etc/nginx/sites-enabled/
    
    # Remove default nginx site
    sudo rm -f /etc/nginx/sites-enabled/default
fi

# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

echo "Deployment completed successfully!"
