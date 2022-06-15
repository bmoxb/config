local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path
    })
end

return require('packer').startup(function(use)
    use 'preservim/nerdtree'

    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    vim.g.airline_theme = 'angr'
    vim.g['airline#extensions#tabline#enabled'] = 1

    use 'ntpeters/vim-better-whitespace'

    use 'tpope/vim-surround'

    use 'junegunn/fzf'

    use 'folke/trouble.nvim'
    require"trouble".setup {}
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'j-hui/fidget.nvim'
    require"fidget".setup {}
    -- use 'kosayoda/nvim-lightbulb'
    use 'm-demare/hlargs.nvim'
    use 'neovim/nvim-lspconfig'
    use {'nvim-treesitter/nvim-treesitter'}--, config = 'vim.cmd("TSUpdate")'}
    use 'simrat39/rust-tools.nvim'
    use 'weilbith/nvim-code-action-menu'
    vim.g.code_action_menu_window_border = 'single'
    use 'williamboman/nvim-lsp-installer'

    local opts = {
        -- rust-tools options
        tools = {
            autoSetHints = true,
            hover_with_actions = true,
            inlay_hints = {
                show_parameter_hints = true,
                parameter_hints_prefix = "",
                other_hints_prefix = ""
            }
        },

        server = {
            settings = {
                ["rust-analyzer"] = {
                    assist = {
                        importEnforceGranularity = true,
                        importPrefix = "crate"
                    },
                    cargo = {allFeatures = true},
                    checkOnSave = {
                        -- default: `cargo check`
                        command = "clippy"
                    }
                },
                inlayHints = {
                    lifetimeElisionHints = {
                        enable = true,
                        useParameterNames = true
                    }
                }
            }
        }
    }
    require('rust-tools').setup(opts)

    vim.cmd[[
        nnoremap <silent> <c-]>     <cmd>lua vim.lsp.buf.definition()<CR>
        nnoremap <silent> <c-k>     <cmd>lua vim.lsp.buf.signature_help()<CR>
        nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
        nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
        nnoremap <silent> gc        <cmd>lua vim.lsp.buf.incoming_calls()<CR>
        nnoremap <silent> gd        <cmd>lua vim.lsp.buf.type_definition()<CR>
        nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
        nnoremap <silent> gn        <cmd>lua vim.lsp.buf.rename()<CR>
        nnoremap <silent> gs        <cmd>lua vim.lsp.buf.document_symbol()<CR>
        nnoremap <silent> gw        <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    ]]

    require('lspconfig').gopls.setup {
        cmd = {'gopls'},
        settings = {
            gopls = {
                analyses = {
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true
                },
                gofumpt = true,
                staticcheck = true,
                usePlaceholders = true
            }
        },
        on_attach = on_attach
    }

    require('lspconfig').pyright.setup {}
    require('lspconfig').clangd.setup {}

    local cmp = require('cmp')
    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end
        },
        mapping = {
            ['<Up>'] = cmp.mapping.select_prev_item(),
            ['<Down>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            })
        },
        sources = {
            {name = 'nvim_lsp'}, {name = 'vsnip'}, {name = 'path'},
            {name = 'buffer'}, {name = 'nvim_lsp_signature_help'}
        }
    })

    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "bash", "c", "cpp", "cmake", "css", "dockerfile", "go", "gomod", "gowork",
            "hcl", "help", "html", "http", "javascript", "json", "lua", "make",
            "markdown", "python", "regex", "ruby", "rust", "toml", "vim",
            "yaml", "zig", "java", "haskell"
        },
        highlight = {enable = true},
        rainbow = {enable = true, extended_mode = true, max_file_lines = nil}
    }
    require('hlargs').setup()

    if packer_bootstrap then require('packer').sync() end
end)
