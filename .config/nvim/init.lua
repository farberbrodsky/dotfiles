vim.call('plug#begin', '~/.config/nvim/plugged')

-- All the important keybindings in one place
local CREATE_TERMINAL = '<C-t>'
local TOGGLE_NERDTREE = '<C-f>'
local TOGGLE_LINE_NUMBERS = '<C-n>'

local GOTO_DEFINITION      = 'gd'
local GOTO_TYPE_DEFINITION = 'gy'
local GOTO_IMPLEMENTATION  = 'gi'
local GOTO_REFERENCES      = 'gr'

local COC_OUTLINE                     = 'go'
local COC_TELESCOPE_WORKSPACE_SYMBOLS = 'gt'
local COC_INCOMING_HIERARCHY          = 'ghi'
local COC_OUTGOING_HIERARCHY          = 'gho'
local COC_SWITCH_SOURCE_HEADER        = 'gs'

local COC_SHOW_DOCS            = 'K'
local COC_RENAME               = '<leader>rn'
local COC_FORMAT_SELECTED      = '<leader>rf'
local COC_QUICK_FIX            = '<leader>qf'
local COC_CODE_LENS            = '<leader>cl'
local SCROLL_PREVIEW_DOWN      = '<M-j>'
local SCROLL_PREVIEW_UP        = '<M-k>'

local SELECT_CLASS_OUTER     = 'ac'
local SELECT_CLASS_INNER     = 'ic'
local SELECT_FUNCTION_OUTER  = 'af'
local SELECT_FUNCTION_INNER  = 'if'
local SELECT_PARAMETER_OUTER = 'aa'
local SELECT_PARAMETER_INNER = 'ia'
local SELECT_HUNK_INNER      = 'ih'

local SELECT_TEXTSUBJECT_SMART   = '.'  -- upper block, might be like a or i
local TEXTSUBJECT_PREV_SELECTION = ','  -- go back to a smaller selection with ,

local NEXT_DIAGNOSTIC = ']g'
local PREV_DIAGNOSTIC = '[g'
local NEXT_PARAMETER  = ']a'
local PREV_PARAMETER  = '[a'
local NEXT_FUNCTION   = ']f'
local PREV_FUNCTION   = '[f'
local NEXT_CHANGE     = ']c'
local PREV_CHANGE     = '[c'

local APPEND_NEXT_ARGUMENT = 'a]a'
local APPEND_PREV_ARGUMENT = 'a[a'

local TELESCOPE_GIT_FILES = '<C-p>'
local TELESCOPE_FILES     = '<leader>ff'
local TELESCOPE_GREP      = '<leader>fg'
local TELESCOPE_BUFFERS   = '<C-b>'

local GITSIGNS_PREVIEW_HUNK_INLINE = '<leader>hp'
local GITSIGNS_TOGGLE_DELETED      = '<leader>td'

local GITSIGNS_DIFF_PREV_HEAD = '<leader>hD'
local GITSIGNS_DIFF_HEAD      = '<leader>hd'

local GITSIGNS_CURRENT_LINE_BLAME        = '<leader>hb'
local GITSIGNS_TOGGLE_CURRENT_LINE_BLAME = '<leader>tb'

local GITSIGNS_STAGE_HUNK      = '<leader>hs'
local GITSIGNS_UNDO_STAGE_HUNK = '<leader>hu'
local GITSIGNS_RESET_HUNK      = '<leader>hr'

local GITSIGNS_STAGE_BUFFER = '<leader>hS'
local GITSIGNS_RESET_BUFFER = '<leader>hR'


local ALIGN_RIGHT = 'gl'
local ALIGN_LEFT  = 'gL'

local TCOMMENT_LEADER = 'gc'  -- gc - toggle comment, gcc - toggle comment for line, etc. See: :h tcomment.txt

-- Helper functions
local function for_hjkl(f)
    local hjkl = {'h', 'j', 'k', 'l'}
    for i = 1, #hjkl do
        f(hjkl[i])
    end
end

local function add_plugin(s, extra)
    if extra == nil then
        vim.cmd('Plug \'' .. s .. '\'')
    else
        vim.cmd('Plug \'' .. s .. '\', ' .. extra)
    end
end

-- List of plugins
add_plugin('catppuccin/nvim', "{'as': 'catppuccin'}")  -- Catppuccin theme
add_plugin 'vim-airline/vim-airline'                   -- Airline status line
add_plugin 'tpope/vim-surround'                        -- Classic surround.vim
add_plugin 'lukas-reineke/indent-blankline.nvim'       -- Indentation blanklines
add_plugin 'roryokane/detectindent'                    -- Detect indentation
add_plugin 'ryanoasis/vim-devicons'                    -- Icons for NERDTree and airline
add_plugin 'tpope/vim-fugitive'                        -- Fugitive, git with :Git
add_plugin 'lewis6991/gitsigns.nvim'                   -- Show git changed lines and blame etc.
add_plugin 'windwp/nvim-autopairs'                     -- Autopairs with treesitter
add_plugin 'scrooloose/nerdtree'                       -- The tree file viewer sidebar
add_plugin 'tpope/vim-obsession'                       -- Save session automatically by using :Obsess - then, nvim -S Session.vim
add_plugin 'phaazon/hop.nvim'                          -- Like EasyMotion
add_plugin 'tommcdo/vim-lion'                          -- lion.vim - align text by some character
add_plugin 'tomtom/tcomment_vim'                       -- tcomment - comment stuff out
add_plugin 'nvim-lua/plenary.nvim'                     -- telescope
add_plugin 'nvim-telescope/telescope.nvim'             -- telescope
add_plugin 'fannheyward/telescope-coc.nvim'            -- telescope + CoC

add_plugin('nvim-treesitter/nvim-treesitter',"{'do': ':TSUpdate'}") -- Treesitter
add_plugin 'nvim-treesitter/nvim-treesitter-textobjects'            -- Treesitter text objects
add_plugin 'RRethy/nvim-treesitter-textsubjects'                    -- Treesitter text subjects
add_plugin 'HiPhish/nvim-ts-rainbow2'                               -- Treesitter rainbow parentheses

vim.cmd "Plug 'neoclide/coc.nvim', {'branch': 'release'}"             -- CoC

vim.call('plug#end')

-- Useful function
local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

-- Navigation keybindings
-- CTRL-H,J,K,L move between windows
for_hjkl(function (c) vim.keymap.set('n', '<C-' .. c .. '>', '<C-w><C-' .. c .. '>', { silent = true }) end)

-- Terminal bindings
-- Create a vertical split for a terminal without numbering, with <C-t>
vim.keymap.set('n', CREATE_TERMINAL, ':vsplit<Enter><C-l>:set nonumber<Enter>:set norelativenumber<Enter>:terminal<Enter>i', { silent = true, remap=true })
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

-- Toggle line numbers
vim.keymap.set('n', TOGGLE_LINE_NUMBERS, function()
  vim.cmd [[
    set invrelativenumber
    set invnumber
  ]]
end)

-- Tab vim settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.timeoutlen = 180  -- i can type combinations fast

-- Copy and paste from system clipboard
vim.keymap.set('v', '<C-c>', '"+y',       { silent = true })
vim.keymap.set('v', '<C-x>', '"+c',       { silent = true })
vim.keymap.set('v', '<C-v>', 'c<Esc>"+p', { silent = true })
vim.keymap.set('n', '<C-v>', '"+p',       { silent = true })
vim.keymap.set('i', '<C-v>', '<Esc>"+pa', { silent = true })

-- Misc vim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.g.markdown_fenced_languages = {'c', 'cpp', 'python'}
vim.opt.scrolloff = 10


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
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
-- Use <c-j> to trigger snippets
-- vim.keymap.set("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
vim.keymap.set("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
do
    local function next_diagnostic() vim.api.nvim_command("call CocAction('diagnosticNext')") end
    local function prev_diagnostic() vim.api.nvim_command("call CocAction('diagnosticPrevious')") end
    local next_diagnostic_repeat, prev_diagnostic_repeat = ts_repeat_move.make_repeatable_move_pair(next_diagnostic, prev_diagnostic)
    vim.keymap.set({'n', 'x', 'o'}, NEXT_DIAGNOSTIC, next_diagnostic_repeat)
    vim.keymap.set({'n', 'x', 'o'}, PREV_DIAGNOSTIC, prev_diagnostic_repeat)
end

-- GoTo code navigation
vim.keymap.set("n", GOTO_DEFINITION,      "<Plug>(coc-definition)",      {silent = true})
vim.keymap.set("n", GOTO_TYPE_DEFINITION, "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", GOTO_IMPLEMENTATION,  "<Plug>(coc-implementation)",  {silent = true})
vim.keymap.set("n", GOTO_REFERENCES,      "<Plug>(coc-references)",      {silent = true})


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
vim.keymap.set("n", COC_SHOW_DOCS, '<CMD>lua _G.show_docs()<CR>', {silent = true})


-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})


-- Symbol renaming
vim.keymap.set("n", COC_RENAME, "<Plug>(coc-rename)", {silent = true})

-- Formatting selected code
vim.keymap.set({"n", "x"}, COC_FORMAT_SELECTED, "<Plug>(coc-format-selected)", {silent = true})

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
-- vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for apply code actions at the cursor position.
-- vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply code actions affect whole buffer.
-- vim.keymap.set("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- Remap keys for applying codeActions to the current buffer
-- vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
-- Apply the most preferred quickfix action on the current line.
vim.keymap.set("n", COC_QUICK_FIX, "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
-- vim.keymap.set("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
-- vim.keymap.set("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
-- vim.keymap.set("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Run the Code Lens actions on the current line
vim.keymap.set("n", COC_CODE_LENS, "<Plug>(coc-codelens-action)", opts)

-- Remap <M-j> and <M-k> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
vim.keymap.set("n", SCROLL_PREVIEW_DOWN, 'coc#float#has_scroll() ? coc#float#scroll(1) : ' .. SCROLL_PREVIEW_DOWN, opts)
vim.keymap.set("n", SCROLL_PREVIEW_UP, 'coc#float#has_scroll() ? coc#float#scroll(0) : ' .. SCROLL_PREVIEW_UP, opts)
vim.keymap.set("i", SCROLL_PREVIEW_DOWN,
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
vim.keymap.set("i", SCROLL_PREVIEW_UP,
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
vim.keymap.set("v", SCROLL_PREVIEW_DOWN, 'coc#float#has_scroll() ? coc#float#scroll(1) : ' .. SCROLL_PREVIEW_DOWN, opts)
vim.keymap.set("v", SCROLL_PREVIEW_UP, 'coc#float#has_scroll() ? coc#float#scroll(0) : ' .. SCROLL_PREVIEW_UP, opts)

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add airline support
vim.g["airline#extensions#coc#enabled"] = 1
vim.g["airline#extensions#coc#show_coc_status"] = 1
vim.g["airline_theme"] = "catppuccin"

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true}
-- Show all diagnostics
-- vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
-- vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
-- vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
vim.keymap.set("n", COC_OUTLINE,           ":<C-u>CocList outline<cr>",    opts)
-- Search workspace symbols
-- vim.keymap.set("n", COC_WORKSPACE_SYMBOLS, ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
-- vim.keymap.set("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
-- vim.keymap.set("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
-- vim.keymap.set("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

-- call hierarchy
vim.keymap.set("n", COC_INCOMING_HIERARCHY, ":CocCommand document.showIncomingCalls<cr>", opts)
vim.keymap.set("n", COC_OUTGOING_HIERARCHY, ":CocCommand document.showOutgoingCalls<cr>", opts)

-- switch source/header
vim.keymap.set("n", COC_SWITCH_SOURCE_HEADER, function() vim.api.nvim_command('CocCommand clangd.switchSourceHeader') end, opts)


-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "bash", "lua", "javascript", "latex", "markdown",
                       "json", "ini", "yaml", "cmake", "make", "vim", "help", "query" },

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
        [SELECT_CLASS_OUTER]     = "@class.outer",
        [SELECT_CLASS_INNER]     = "@class.inner",
        [SELECT_FUNCTION_OUTER]  = "@function.outer",
        [SELECT_FUNCTION_INNER]  = "@function.inner",
        [SELECT_PARAMETER_OUTER] = "@parameter.outer",
        [SELECT_PARAMETER_INNER] = "@parameter.inner"
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
        [NEXT_PARAMETER] = "@parameter.inner",
      },
      goto_next_end = {
      },
      goto_previous_start = {
        [PREV_PARAMETER] = "@parameter.inner",
      },
      goto_previous_end = {
      },

      -- either start or end, whichever is closer
      goto_next = {
        [NEXT_FUNCTION] = "@function.outer"
      },
      goto_previous = {
        [PREV_FUNCTION] = "@function.outer"
      }
    }
  },

  textsubjects = {
    enable = true,
    prev_selection = TEXTSUBJECT_PREV_SELECTION,
    keymaps = {
      [SELECT_TEXTSUBJECT_SMART] = 'textsubjects-smart'
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

-- Make these repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
-- Keep f,F,t,T repeatable
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

-- Append Argument - go to the end of the argument, insert a comma in insert mode
vim.keymap.set('n', APPEND_NEXT_ARGUMENT, 'via<Esc>a, ', { remap = true, silent = true })
vim.keymap.set('n', APPEND_PREV_ARGUMENT, 'viao<Esc>i, <Left><Left>', { remap = true, silent = true })

-- Autopairs with treesitter config
require('nvim-autopairs').setup({
  check_ts = true,
  ts_config = {
    lua    = {'string'}, -- not for string in lua
    cpp    = {'string'},
    c      = {'string'},
    python = {'string'}
  }
})


-- Atom One Light theme
vim.o.background = 'light'
vim.cmd 'colorscheme catppuccin-latte'

-- Airline
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_z = '%4l'

-- hop.nvim
vim.api.nvim_set_keymap('n', ' ', '<cmd>lua require\'hop\'.hint_words()<cr>', {})
require'hop'.setup { create_hl_autocmd = false }

-- <C-f> for NERDTree
vim.keymap.set('n', TOGGLE_NERDTREE, function() vim.api.nvim_command('NERDTreeToggle') end)
-- close nerdtree if it's the last window
vim.cmd 'autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif'

-- indent blanklines
require("indent_blankline").setup {
    show_trailing_blankline_indent = false
}
vim.g.indent_blankline_use_treesitter = true
vim.cmd 'highlight IndentBlanklineChar guifg=#e2e2e2 gui=nocombine'

-- lion.vim
vim.g.lion_map_right = ALIGN_RIGHT
vim.g.lion_map_left  = ALIGN_LEFT

-- tcomment.vim
vim.g.tcomment_opleader1 = TCOMMENT_LEADER

-- gitsigns.nvim
require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame  = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text         = true,
    virt_text_pos     = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay             = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority    = 6,
  update_debounce  = 100,
  status_formatter = nil, -- Use default
  max_file_length  = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation (for repeating with ; and , - use treesitter textobjects)
    local function next_hunk()
      if vim.wo.diff then
        vim.call('feedkeys', ']c', 'n')
      else
        vim.schedule(function() gs.next_hunk() end)
      end
    end
    local function prev_hunk()
      if vim.wo.diff then
        vim.call('feedkeys', '[c', 'n')
      else
        vim.schedule(function() gs.prev_hunk() end)
      end
    end

    local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(next_hunk, prev_hunk)
    map({'n', 'x', 'o'}, NEXT_CHANGE, next_hunk_repeat)
    map({'n', 'x', 'o'}, PREV_CHANGE, prev_hunk_repeat)

    -- Actions
    map({'n', 'v'}, GITSIGNS_STAGE_HUNK, ':Gitsigns stage_hunk<CR>', { silent = true })
    map({'n', 'v'}, GITSIGNS_RESET_HUNK, ':Gitsigns reset_hunk<CR>', { silent = true })
    map('n', GITSIGNS_STAGE_BUFFER,              gs.stage_buffer)
    map('n', GITSIGNS_UNDO_STAGE_HUNK,           gs.undo_stage_hunk)
    map('n', GITSIGNS_RESET_BUFFER,              gs.reset_buffer)
    map('n', GITSIGNS_PREVIEW_HUNK_INLINE,       gs.preview_hunk_inline)
    map('n', GITSIGNS_CURRENT_LINE_BLAME,        function() gs.blame_line{full=true} end)
    map('n', GITSIGNS_TOGGLE_CURRENT_LINE_BLAME, gs.toggle_current_line_blame)
    map('n', GITSIGNS_DIFF_HEAD,                 gs.diffthis)                     -- diff from HEAD
    map('n', GITSIGNS_DIFF_PREV_HEAD,            function() gs.diffthis('~') end) -- diff from HEAD^
    map('n', GITSIGNS_TOGGLE_DELETED,            gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, SELECT_HUNK_INNER, ':<C-U>Gitsigns select_hunk<CR>')
  end
}

-- telescope.nvim
require('telescope').setup{
    defaults = {
        -- Default configuration for telescope goes here:
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        coc = {
            prefer_locations = true
        }
    }
}
require('telescope').load_extension('coc')

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', TELESCOPE_GIT_FILES, telescope_builtin.git_files, {})
vim.keymap.set('n', TELESCOPE_FILES, telescope_builtin.find_files, {})
vim.keymap.set('n', TELESCOPE_GREP, telescope_builtin.live_grep, {})
vim.keymap.set('n', TELESCOPE_BUFFERS, telescope_builtin.buffers, {})
vim.keymap.set('n', COC_TELESCOPE_WORKSPACE_SYMBOLS, function() vim.cmd('Telescope coc workspace_symbols') end, {})
