return {
  'cameron-wags/rainbow_csv.nvim',
  ft = {
    'csv',
    'tsv',
    'csv_semicolon',
    'csv_whitespace',
    'csv_pipe',
    'rfc_csv',
    'rfc_semicolon'
  },
  cmd = {
    'RainbowDelim',
    'RainbowDelimSimple',
    'RainbowDelimQuoted',
    'RainbowMultiDelim'
  },
  config = function()
    require('rainbow_csv').setup()
    vim.g.rcsv_colorpairs = {
      {"Cyan", "#8ec07c"},
      {"Blue", "#83a598"},
      {"DarkMagenta", "#ac86d3"},
      {"Magenta", "#d3869b"},
      {"Red", "#fb4934"},
      {"DarkYellow", "#fe8019"},
      {"Yellow", "#fabd2f"},
      {"Green", "#b8bb26"},
      {"White", "#ebdbb2"},
      {"Gray", "#a89984"},
    }
    -- Using the nvim python would probably require that the plugin's module be
    -- added explicitly to the nix python... on my Arch system at work, using
    -- system python works fine
    -- vim.g.rbql_use_system_python = 1
  end,
}
