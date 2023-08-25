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
    -- vim.g.rcsv_colorpairs = {
    --   {"1", "red"},
    --   {"2", "blue"},
    -- }
  end,
}
