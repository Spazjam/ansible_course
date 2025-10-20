#!/bin/bash

# Ensure the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with sudo. Please run 'sudo ./$(basename "$0")'"
  exit 1
fi

# Prompt for the new username
read -p "Enter the new username: " new_username

# Prompt for the public SSH key
read -p "Enter the new user's public SSH key: " public_key

# Check if the user already exists to prevent errors
if id -u "$new_username" >/dev/null 2>&1; then
    echo "User '$new_username' already exists. Skipping user creation."
else
    # Create the new user with a home directory
    adduser -m -G sudo --gecos "" "$new_username"
    echo "User '$new_username' created."
fi

# Create the .ssh directory and authorized_keys file
ssh_dir="/home/$new_username/.ssh"
auth_keys_file="$ssh_dir/authorized_keys"

mkdir -p "$ssh_dir"
touch "$auth_keys_file"

# Add the public key to authorized_keys
# The '>>' appends the key, so it works even if the file is not empty
echo "$public_key" >> "$auth_keys_file"

# Set correct permissions and ownership
chown -R "$new_username:$new_username" "$ssh_dir"
chmod 700 "$ssh_dir"
chmod 600 "$auth_keys_file"

echo "SSH setup complete for user '$new_username'."
echo "The public key has been added and permissions have been configured."
