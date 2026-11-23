{
  pkgs,
  ...
}:
let

  qf-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "qf-nvim";
    version = "2024-01-24";
    src = pkgs.fetchFromGitHub {
      owner = "ten3roberts";
      repo = "qf.nvim";
      rev = "c16efebc2a4967251d34630c7f5beee25ca8a9ba";
      sha256 = "sha256-FPKCOTR6iZtNGSZ7DAorNpveJ9EABgoG4+ITfxoQRhU=";
    };
    doCheck = false;
    meta.homepage = "https://github.com/ten3roberts/qf.nvim";
  };

  vim-cutlass = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-cutlass";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "svermeulen";
      repo = "vim-cutlass";
      rev = "7afd649415541634c8ce317fafbc31cd19d57589";
      sha256 = "sha256-j5W9q905ApDf3fvCIS4UwyHYnEZu5Ictn+6JkV/xjig=";
    };
    meta.homepage = "https://github.com/svermeulen/vim-cutlass";
  };

  vim-ipmotion = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-ipmotion";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "justinmk";
      repo = "vim-ipmotion";
      rev = "74762a4fae452766e462ca563c169f781971bad9";
      sha256 = "sha256-+giBR41RdCwhCPII1ru2ROX08be540M00KQeOqbS4sc=";
    };
    meta.homepage = "https://github.com/justinmk/vim-ipmotion";
  };

  vim-shot-f = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-shot-f";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "deris";
      repo = "vim-shot-f";
      rev = "eea71d2a1038aa87fe175de9150b39dc155e5e7f";
      sha256 = "sha256-iAPvIs/lhW+w5kFTZKaY97D/kfCGtqKrJVFvZ8cHu+c=";
    };
    meta.homepage = "https://github.com/deris/vim-shot-f";
  };

  vim-yoink = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-yoink";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "svermeulen";
      repo = "vim-yoink";
      rev = "89ed6934679fdbc3c20f552b50b1f869f624cd22";
      sha256 = "sha256-ekGKOYzmdaMqAun/3fRGlhA7bLKuhzsXsEcFNukgFWU=";
    };
    meta.homepage = "https://github.com/svermeulen/vim-yoink";
  };
in
{
  plugins = with pkgs.vimPlugins; [
    # mono repos
    snacks-nvim
    mini-nvim

    # basics
    vim-matchup
    vim-cutlass
    vim-shot-f
    vim-ipmotion

    friendly-snippets

    blink-cmp
    blink-ripgrep-nvim

    # visuals
    # TODO: look at https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-statusline.md
    # TODO: snacks-notify
    lualine-nvim
    onedark-nvim

    # text manipulation
    sideways-vim
    vim-subversive
    vim-yoink
    vim-abolish
    camelcasemotion
    # TODO: get a dial.nvim alternative
    dial-nvim

    # situational
    yazi-nvim
    # add https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
    todo-comments-nvim
    qf-nvim

    # giveitashot
    # add https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md
    # add https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md
    # TODO: look at minimax distro https://github.com/nvim-mini/MiniMax
    # TODO: look at lazyvim distro https://github.com/LazyVim/LazyVim
  ];

  extraConfig =
    "\n\n"
    + builtins.readFile ./lua/snacks.lua
    + builtins.readFile ./lua/basics.lua
    + builtins.readFile ./lua/cmp.lua
    + builtins.readFile ./lua/visuals.lua
    + builtins.readFile ./lua/situational.lua
    + builtins.readFile ./lua/text_manipulation.lua
    + builtins.readFile ./lua/giveitashot.lua
    + builtins.readFile ./lua/after.lua;
}
