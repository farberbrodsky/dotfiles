vim.call('plug#begin', '~/.config/nvim/plugged')

-- Helper functions
function for_hjkl(f)
    hjkl = {'h', 'j', 'k', 'l'}
    for i = 1, #hjkl do
        f(hjkl[i])
    end
end

function add_plugin(s)
    vim.cmd ('Plug \'' .. s .. '\'')
end

-- List of plugins
add_plugin 'rakr/vim-one'                    -- Atom One Light theme
add_plugin 'vim-airline/vim-airline'         -- Airline status line
add_plugin 'vim-airline/vim-airline-themes'  -- ...
add_plugin 'yggdroot/indentline'             -- Indentation line
add_plugin 'roryokane/detectindent'          -- Detect indentation
add_plugin 'ryanoasis/vim-devicons'          -- Icons for NERDTree and airline
-- add_plugin 'rrethy/vim-illuminate'          -- Highlight the word under the cursor
add_plugin 'tpope/vim-fugitive'              -- Fugitive, git with :Git
add_plugin 'scrooloose/nerdtree'             -- The tree file viewer sidebar
add_plugin 'tpope/vim-obsession'             -- Save session automatically by using :Obsess - then, nvim -S Session.vim
add_plugin 'phaazon/hop.nvim'                -- Like EasyMotion
add_plugin 'ctrlpvim/ctrlp.vim'              -- Ctrl-P for fuzzy file search

vim.cmd "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}" -- Treesitter
add_plugin 'nvim-treesitter/nvim-treesitter-textobjects'              -- Treesitter text objects
add_plugin 'HiPhish/nvim-ts-rainbow2'                                 -- Treesitter rainbow parentheses

vim.cmd "Plug 'neoclide/coc.nvim', {'branch': 'release'}"             -- CoC

vim.call('plug#end')

-- Navigation keybindings
-- CTRL-H,J,K,L move between windows
for_hjkl(function (c) vim.keymap.set('n', '<C-' .. c .. '>', '<C-w><C-' .. c .. '>', { silent = true }) end)

-- Terminal bindings
-- Create a vertical split for a terminal without numbering, with <C-t>
vim.keymap.set('n', '<C-t>', ':vsplit<Enter><C-l>:set nonumber<Enter>:set norelativenumber<Enter>:terminal<Enter>i', { silent = true, remap=true })
-- Automatically enter terminal when focused
vim.api.nvim_create_autocmd({'BufWinEnter', 'WinEnter'}, {
    pattern = {'term://*'},
    command = 'startinsert'
})
-- Leave terminal without a weird key combination
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { remap = true })
-- Also allow modifying windows without manually exiting terminal insert mode
vim.keymap.set('t', '<C-w>', '<Esc><C-w>', { remap = true })
-- CTRL-H,J,K,L move between windows - in terminals
for_hjkl(function (c) vim.keymap.set('t', '<C-' .. c .. '>', '<Esc><C-' .. c .. '>', { remap = true }) end)

-- Search vim settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Unset the "last search pattern" register by hitting return
vim.keymap.set('n', '<CR>', function() vim.api.nvim_command('let @/ = ""') end)

-- Tab vim settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true

-- Copy and paste from system clipboard
vim.keymap.set('v', '<C-c>', '"+y', { silent = true })
vim.keymap.set('v', '<C-x>', '"+c', { silent = true })
vim.keymap.set('v', '<C-v>', 'c<Esc>"+p', { silent = true })
vim.keymap.set('n', '<C-v>', '"+p', { silent = true })
vim.keymap.set('i', '<C-v>', '<Esc>"+pa', { silent = true })

-- Misc vim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.g.markdown_fenced_languages = {'c', 'python'}


-- Plugins


-- CoC

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
-- keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})


-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})


-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local opts = {silent = true, nowait = true}
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for apply code actions at the cursor position.
keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply code actions affect whole buffer.
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- Remap keys for applying codeActions to the current buffer
keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Run the Code Lens actions on the current line
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

-- Remap <M-j> and <M-k> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
keyset("n", "<M-j>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<M-j>"', opts)
keyset("n", "<M-k>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<M-k>"', opts)
keyset("i", "<M-j>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<M-k>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<M-j>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<M-j>"', opts)
keyset("v", "<M-k>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<M-k>"', opts)

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add airline support
vim.g["airline#extensions#coc#enabled"] = 1
vim.g["airline#extensions#coc#show_coc_status"] = 1

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true}
-- Show all diagnostics
-- keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
-- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
-- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
keyset("n", "go", ":<C-u>CocList outline<cr>", opts)
-- Search workspace symbols
keyset("n", "gt", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
-- keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
-- keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
-- keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

-- call hierarchy
keyset("n", "ghi", ":CocCommand document.showIncomingCalls<cr>", opts)
keyset("n", "gho", ":CocCommand document.showOutgoingCalls<cr>", opts)


-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "bash", "lua", "json", "make", "vim", "help", "query" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner"
      },

      selection_modes = {
        ["@function.outer"] = 'V',   -- linewise
        ["@class.outer"] = '<c-v>',  -- blockwise
      }
    },

    move = {
      enable = true,
      set_jumps = true,  -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]a"] = "@parameter.inner",
      },
      goto_next_end = {
      },
      goto_previous_start = {
        ["[a"] = "@parameter.inner",
      },
      goto_previous_end = {
      },

      -- either start or end, whichever is closer
      goto_next = {
        ["]f"] = "@function.outer"
      },
      goto_previous = {
        ["[f"] = "@function.outer"
      }
    }
  },

  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    disable = {},
    -- Which query to use for finding delimiters
    query = 'rainbow-parens',
    -- Highlight the entire buffer all at once
    strategy = require('ts-rainbow').strategy.global,
  }
}

-- Atom One Light theme
vim.cmd 'colorscheme one'
vim.opt.background = 'light'

-- Rainbow colors
vim.cmd [[
  highlight TSRainbowRed    guifg=#dd5a58
  highlight TSRainbowYellow guifg=#bfbc07
  highlight TSRainbowBlue   guifg=#268bd2
  highlight TSRainbowOrange guifg=#e2972d
  highlight TSRainbowGreen  guifg=#859900
  highlight TSRainbowViolet guifg=#6c71c4
  highlight TSRainbowCyan   guifg=#2aa198
]]

-- Airline
vim.g.airline_theme = 'one'
vim.g.airline_powerline_fonts = 1
-- Show time instead of line number
vim.g.airline_section_z = ' %{strftime("%-I:%M %p")}'

-- hop.nvim
vim.api.nvim_set_keymap('n', ' ', '<cmd>lua require\'hop\'.hint_words()<cr>', {})
require'hop'.setup { create_hl_autocmd = false }

-- <C-f> for NERDTree
vim.keymap.set('n', '<C-f>', function() vim.api.nvim_command('NERDTreeToggle') end)
-- close nerdtree if it's the last window
vim.cmd 'autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif'

-- Ctrl-P
vim.cmd "set wildignore+=*/target/*,*/node_modules/*,*.so,*.swp,*.zip"
vim.keymap.set('', '<C-b>', function() vim.api.nvim_command('CtrlPBuffer') end, { silent = true })

-- Automatic indentation detection
vim.cmd [[
  let g:detectindent_preferred_indent = 4
  augroup DetectIndent
     autocmd!
     autocmd BufReadPost *  DetectIndent
  augroup END
]]
