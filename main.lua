--- @since 25.2.7

local function info(content)
	return ya.notify {
		title = "Gpg information",
		content = content,
		timeout = 5,
	}
end

local hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and h.url
end)

local get_state_attr = ya.sync(function(state, attr)
  return state[attr]
end)

return {
	setup = function(state, options)
		state.delete = options.path or true
		state.default = options.default
	end,
	entry = function()
		local delete, default = get_state_attr("delete"), get_state_attr("default")
		local hovered =  hovered_url()
		if not hovered then
			return info("No file selected")
		end

		if not default then
			return info("No recipient set")
		end

		local _, err = Command("gpg"):arg("--yes"):arg("--recipient"):arg(default):arg("--output"):arg(tostring(hovered) .. ".gpg"):arg("--encrypt"):arg(tostring(hovered)):output()
		if err then
			return info("Failed to gpg with error: " .. err)
		end

		-- Delete the plain file
		if delete == true then
			os.remove(hovered)
		end

		info("Done encrypting the file! The plain one is deleted now.")
	end,
}
