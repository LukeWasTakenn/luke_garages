Locales = {}

function Locale(str)
    if Locales[Config.Locale][str] then return Locales[Config.Locale][str] 
    else return '[NO STRING]' end
end