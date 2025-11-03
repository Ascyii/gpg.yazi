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

        local urls = selected_or_hovered()
        if #urls == 0 then
            return ya.notify { title = "GPG Encrypt", content = "No file selected", level = "warn", timeout = 5 }
        end

        -- Ask for GPG recipient
        local recipient, event = ya.input {
            title = "GPG Recipient:",
            pos = { "top-center", y = 3, w = 50 },
        }
        if event ~= 1 or recipient == "" then
            return
        end

        for _, file_path in ipairs(urls) do
            local gpg_file = file_path .. ".gpg"
            local status, err = Command("gpg")
                :arg("--yes")
                :arg("--batch")
                :arg("--recipient")
                :arg(recipient)
                :arg("--output")
                :arg(gpg_file)
                :arg("--encrypt")
                :arg(file_path)
                :spawn()
                :wait()

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
