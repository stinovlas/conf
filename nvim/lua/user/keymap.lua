local map = require('user.utils').map

map({ 'n', 'q', ':' })
map({ 'n', 'Q', 'q' })

-- Switching between panes
map({ 'n', '<A-h>', ':TmuxNavigateLeft<CR>', silent = true })
map({ 'n', '<A-j>', ':TmuxNavigateDown<CR>', silent = true })
map({ 'n', '<A-k>', ':TmuxNavigateUp<CR>', silent = true })
map({ 'n', '<A-l>', ':TmuxNavigateRight<CR>', silent = true })
map({ 'n', '<A-Left>', ':TmuxNavigateLeft<CR>', silent = true })
map({ 'n', '<A-Down>', ':TmuxNavigateDown<CR>', silent = true })
map({ 'n', '<A-Up>', ':TmuxNavigateUp<CR>', silent = true })
map({ 'n', '<A-Right>', ':TmuxNavigateRight<CR>', silent = true })

-- Gitsigns hunk manipulation
map({ 'n', '<leader>hs', '<cmd>lua package.loaded.gitsigns.stage_hunk()<CR>' })
map({ 'n', '<leader>hr', '<cmd>lua package.loaded.gitsigns.reset_hunk()<CR>' })
map({ 'n', '<leader>hp', '<cmd>lua package.loaded.gitsigns.preview_hunk()<CR>' })
map({ 'n', '<leader>hu', '<cmd>lua package.loaded.gitsigns.undo_stage_hunk()<CR>' })

map({ 'n', '<A-PageDown>', ':bn<CR>', silent = true })
map({ 'n', '<A-PageUp>', ':bp<CR>', silent = true })
