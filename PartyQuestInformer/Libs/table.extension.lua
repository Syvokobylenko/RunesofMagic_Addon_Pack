local pairs = pairs

function table.isempty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

function table.length(self)
    local count = 0
    for _ in pairs(self) do count = count + 1 end
    return count
end