# Easy encryption with gpg for files

## Usage 

Install with `ya pkg add Ascyii/gpg`.

Setup in `init.lua` with

```lua
require("gpg"):setup {
  default_recipient = "username@example.com",
  delete_after = true,
}
```

Code was taken from `yazi-rs` and `Rolv-Apneseth`.
