return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys", padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            cmd = "if [[ -d .git ]]; then git --no-pager diff --stat -B -M -C; else echo 'No git repo here'; fi",
            padding = 1,
          },
          { section = "startup" },
          -- { section = "terminal", cmd = "cbonsai -l", height = 30, pane = 2 },
        },
      },
    },
  },
}
