if not request then 
	return false
end

Local HttpService = game:GetService("HttpService")

local response = request({
    Url = 'http://127.0.0.1:6463/rpc?v=1',
    Method = 'POST',
    Headers = {
        ['Content-Type'] = 'application/json',
        Origin = 'https://discord.com'
    },
    Body = HttpService:JSONEncode({
        cmd = 'INVITE_BROWSER',
        nonce = HttpService:GenerateGUID(false),
        args = {code = 'invite_code_here'} -- For example: discord.gg/invite_code, you would remove discord.gg so its just invite_code
    })
})

return response and response.Success
