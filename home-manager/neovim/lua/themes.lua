require('onedark').setup(
  {
    transparent = true,
  }
)

require('lualine').setup {
  options = {
    theme = 'onedark-nvim',
  },
  tabline = {
    lualine_a = {'buffers'},
  }
}
