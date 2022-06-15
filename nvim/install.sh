echo "Copying configuration files to ~/.config/nvim"
cp -r nvim ~/.config/nvim
apt remove -y vim

echo "Downloading binary"
cd /tmp
wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.tar.gz
echo "Extracting binary"
tar -xf nvim-linux64.tar.gz

echo "Moving binary to /usr/local/bin"
mv nvim-linux64/bin/nvim /usr/local/bin/vim

// TODO: Install plugins!
