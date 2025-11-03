--- @since 25.5.31

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		ya.emit("escape", { visual = true })

		return ya.notify { title = "Gpg", content = "No file selected", level = "warn", timeout = 5 }

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify { title = "Gpg", content = "No file selected", level = "warn", timeout = 5 }
		end
		local status, err = Command("gpg"):arg("--yes"):arg("--recipient"):arg("jonashahn1@gmx.net"):arg(urls[1]):arg("--encrypt"):arg(urls[1] .. ".gpg"):spawn():wait()
		if not status or not status.success then
			ya.notify {
				title = "Chmod",
				content = string.format("Chmod on selected files failed, error: %s", status and status.code or err),
				level = "error",
				timeout = 5,
			}
		end
	end,
}
