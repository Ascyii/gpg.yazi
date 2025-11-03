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
		state.delete_after = options.delete_after or true
		state.default_recipient = options.default_recipient
	end,
	entry = function()
		local delete_after, default_recipient = get_state_attr("delete_after"), get_state_attr("default_recipient")
		local hovered =  hovered_url()
		if not hovered then
			return info("No file selected")
		end

		if not default_recipient then
			return info("No recipient set")
		end

		local _, err = Command("gpg"):arg("--yes"):arg("--recipient"):arg(default_recipient):arg("--output"):arg(tostring(hovered) .. ".gpg"):arg("--encrypt"):arg(tostring(hovered)):output()
		if err then
			return info("Failed to gpg with error: " .. err)
		end

		-- Delete the plain file
		if delete_after == true then
			os.remove(hovered)
		end

		info("Done encrypting the file! The plain one is deleted now.")
	end,
}
