#!/bin/bash

# Run as the root user.
apt install vim sudo &&
update-alternatives --set editor /usr/bin/vim
echo ""
echo "Debian Setup Complete!"
echo "Ready to add sudo users with visudo."
