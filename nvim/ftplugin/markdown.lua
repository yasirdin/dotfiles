-- Emoji shortcuts: the ; prefix keeps them from firing while typing normal words.
local emojis = {
  [';done'] = '✅',
}

for trigger, emoji in pairs(emojis) do
  vim.keymap.set('i', trigger, emoji, { buffer = true })
end
