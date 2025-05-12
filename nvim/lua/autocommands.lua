vim.api.nvim_create_autocmd({'BufEnter'}, {
  pattern = '*',
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree then
      vim.cmd('q')
    end
  end
})
