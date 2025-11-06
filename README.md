# Easy encryption with gpg for files

> "Easy file encryption in Neovim using GPG. Quickly encrypt files with a single keybind, manage default recipients, and optionally delete originals after encryption. Lightweight, Lua-configurable, and perfect for secure workflows." - GPT

## Usage 

Install with `ya pkg add Ascyii/gpg`.

Setup in `init.lua` with

```lua
require("gpg"):setup {
  default_recipient = "username@example.com",
  delete_after = true,
}
```

Then add a keybind to the `keymap.toml`

```toml
[mgr]
prepend_keymap = [
	{on = [ "g", "E" ], run = "plugin gpg", desc = "Gpg encrypt the hovered file"}
]
```

Code was taken from `yazi-rs` and `Rolv-Apneseth`.
