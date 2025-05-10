-- return {
--   "miikanissi/modus-themes.nvim",
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("modus_vivendi")
--   end,
-- }
return {
  { "folke/tokyonight.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      local auto_dark_mode = require("auto-dark-mode")
      auto_dark_mode.setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.cmd("colorscheme oxocarbon")
        end,
        set_light_mode = function()
          vim.cmd("colorscheme tokyonight-day")
        end,
      })
      auto_dark_mode.init()
    end,
  },
}
-- return {
--   { -- automatic color scheme
--     "f-person/auto-dark-mode.nvim",
--   },
--   { -- theme
--     "nyoom-engineering/oxocarbon.nvim",
--     priority = 1000,
--     config = function()
--       vim.opt.termguicolors = true
--       vim.cmd.colorscheme("oxocarbon")
--     end,
--   },
-- }
-- return {
--   "rjshkhr/shadow.nvim",
--   priority = 1000,
--   config = function()
--     vim.opt.termguicolors = true
--     vim.cmd.colorscheme("shadow")
--   end,
-- }

-- return {
--   { "arcticicestudio/nord-vim" },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "nord",
--     },
--   },
-- }
