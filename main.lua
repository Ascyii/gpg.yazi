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


		ya.notify{title = "NOTI", content = "okay", level =  "info"}

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify { title = "GPG Encrypt", content = "No file selected", level = "warn", timeout = 5 }
		end


		ya.notify{title = "NOTI", content = "okay", level =  "info"}
		for _, file_path in ipairs(urls) do
			local gpg_file = file_path .. ".gpg"
			ya.notify{title = "NOTI", content = file_path, level =  "info"}
			local status, err = Command("gpg"):arg("--yes"):arg("--batch"):arg("--recipient"):arg("jonashahn1@gmx.net")
			:arg(gpg_file):arg("--encrypt"):arg(file_path):spawn():wait()

			if not status or not status.success then
				ya.notify {
					title = "GPG Encrypt",
					content = string.format("Encryption failed for %s: %s", file_path, status and status.code or err),
					level = "error",
					timeout = 5,
				}
			else
				os.remove(file_path)
			end
		end

		ya.refresh()
		ya.notify { title = "GPG Encrypt", content = "Encryption complete", level = "info", timeout = 3 }
	end,
}
