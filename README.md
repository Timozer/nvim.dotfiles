# Requirements

- neovim 0.9.1+

# Neovim Install

```
wget https://github.com/neovim/neovim/releases/download/v0.9.1/nvim-linux64.tar.gz
tar xf nvim-linux64.tar.gz
sudo mv nvim-linux64 /opt
echo "PATH=${PATH}:/opt/nvim-linux64/bin" >> ~/.bashrc
```

# Install

Clone this config into neovim config dir:
```sh
git clone https://github.com/Timozer/nvim.dotfiles ~/.config/nvim
```
Then open nvim to install plugins:
```sh 
nvim
```

# ThirdParties

https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md

https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main

https://github.com/neovim/neovim/pull/16600

https://github.com/windwp/nvim-autopairs

https://github.com/folke/snacks.nvim
