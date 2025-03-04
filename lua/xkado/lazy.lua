local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.aliases",
  callback = function()
    vim.bo.filetype = "sh" -- Set filetype to 'sh' for .aliases files
  end,
})

require("lazy").setup({ { import = "xkado.plugins" }, { import = "xkado.plugins.lsp" } }, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
