set rtp+=.
set rtp+=vendor/plenary.nvim

runtime plugin/plenary.vim
runtime plugin/carbon-now.vim

lua require('plenary.busted')
