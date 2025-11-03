# Easy encryption with gpg for files

## Usage 

Install with `ya pkg add Ascyii/gpg`.

Setup in `init.lua` with

```lua
require("gpg"):setup {
  default = "username@example.com",
  delete = true,
}
```

Code was taken from `yazi-rs` and `Rolv-Apneseth`.
