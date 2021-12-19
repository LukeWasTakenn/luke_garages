if Config.EnableVersionCheck == true then
    local resource = GetCurrentResourceName()
    local versionData = GetResourceMetadata(resource, 'version')
    local gitRepo = 'https://raw.githubusercontent.com/lukewastakenn/luke_garages/master/fxmanifest.lua'

    function versionCheck(error, response, headers)
        local response = tostring(response)
        for line in response:gmatch("([^\n]*)\n?") do
            if line:find('^version ') then
                repoVersion = line:sub(10, (line:len(line) - 1))
                break 
            end
        end

        if versionData < repoVersion then
            print(string.format("New version is available: ^1%s^7, current version: ^3%s^0", repoVersion, versionData))
        end
    end

    Citizen.CreateThread(function()
        while true do
            PerformHttpRequest(gitRepo, versionCheck, "GET")
            Citizen.Wait(60000 * Config.VersionCheckInterval)
        end
    end)
end
