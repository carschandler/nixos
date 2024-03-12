return {
  'chomosuke/typst-preview.nvim',
  lazy = false, -- or ft = 'typst'
  version = '0.1.*',
  build = function() require 'typst-preview'.update() end,
  opts = {
    debug = true,
    dependencies_bin = {
      ["typst-preview"] = "typst-preview",
      ["websocat"] = "websocat",
    },
  }
}
