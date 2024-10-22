return {
  { -- Seamless Git interface in Vim
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },
    init = function()
      vim.g.git_status_bufnr = -1
    end,
    config = function()
      -- [[ Configure Fugitive ]]
      --  See `:help fugitive`
      local nmap = function(keys, func, desc)
        desc = desc and "[G]it " .. desc
        vim.keymap.set("n", keys, func, { desc = desc })
      end

      nmap("<leader>glg", function()
        vim.cmd("Git log --stat")
      end, "[L]o[g]")

      nmap("<leader>glo", function()
        vim.cmd("Git log --oneline --decorate")
      end, "[L]og --[o]neline")

      nmap("<leader>G", function()
        local window_ids = vim.fn.win_findbuf(vim.g.git_status_bufnr)
        if #window_ids ~= 0 then
          vim.fn.win_gotoid(window_ids[1])
        else
          vim.cmd("0tab Git")
          vim.g.git_status_bufnr = vim.fn.bufnr()
        end
      end, "status")

      -- Pretty print the relative author dates and author names alongside
      -- commits
      --  See `:Man git-log` under format:<format-string> in the "PRETTY
      --  FORMATS" section for details about these placeholders
      nmap("<leader>glp", function()
        vim.cmd('Git log --graph --pretty="%Cred%h%Creset%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"')
      end, "[L]og --[p]retty")
    end,
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing
    -- changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signs_staged_enable = false,
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, desc)
          desc = desc and "Gitsigns: " .. desc
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
        end
        local gs = require("gitsigns")

        map("n", "<Leader>hb", gs.blame_line, "[H]unk [B]lame line")
        map("n", "<Leader>hr", gs.reset_hunk, "[H]unk [R]eset")
        map("n", "<Leader>hs", gs.stage_hunk, "[H]unk [S]tage")
        map("n", "<Leader>hu", gs.undo_stage_hunk, "[H]unk [U]ndo stage")
        map("n", "<Leader>hv", gs.preview_hunk, "[H]unk [V]iew")

        -- Center the cursor in the window after jumping to a hunk in Normal
        -- mode
        map("n", "<Leader>hn", function()
          gs.nav_hunk("next")
          vim.cmd.normal("zz")
        end, "[H]unk [N]ext")

        map("n", "<Leader>hp", function()
          gs.nav_hunk("prev")
          vim.cmd.normal("zz")
        end, "[H]unk [P]rev")

        map("x", "<Leader>hn", function()
          gs.nav_hunk("next")
        end, "[H]unk [N]ext")

        map("x", "<Leader>hp", function()
          gs.nav_hunk("prev")
        end, "[H]unk [P]rev")

        -- Mappings to stage and reset hunks in Visual mode
        map("x", "<Leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "[H]unk [R]eset selected range")

        map("x", "<Leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "[H]unk [S]tage selected range")
      end,
    },
  },
}
