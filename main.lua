--- @since 25.2.7

local function info(content)
	return ya.notify {
		title = "Gpg",
		content = content,
		timeout = 5,
	}
end

local hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and h.url
end)

return {
	entry = function()
		local hovered =  hovered_url()
		if not hovered then
			return info("No file selected")
		end

		local output, err = Command("gpg"):arg("--yes"):arg("--recipient"):arg("jonashahn1@gmx.net"):arg("--output"):arg(hovered .. ".gpg"):arg("--encrypt"):arg(hovered):output()
		if not output then
			return info("Failed to gpg diff, error: " .. err)
		end

		info("Done!")

		ya.clipboard(output.stdout)
		info("Diff copied to clipboard")
	end,
}
