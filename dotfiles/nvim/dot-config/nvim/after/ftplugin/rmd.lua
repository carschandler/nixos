vim.keymap.set("", "<Leader>lk", function ()
  vim.system(
    {'Rscript', '-e', "rmarkdown::render(\"" .. vim.fn.expand("%:p:.") .. "\")"},
    {text = true},
    function(o)
      print(vim.trim(o.stdout))
      print(vim.trim(o.stderr))
    end
  )
end, {desc = "Knit RMarkdown file"})

vim.keymap.set("", "<Leader>lK", function ()
  vim.cmd([[belowright term Rscript -e 'rmarkdown::render("%")']])
end, {desc = "Knit RMarkdown file in split terminal"})

