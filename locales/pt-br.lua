local Translations = {
error = {
    -- Você pode adicionar traduções para mensagens de erro aqui, se necessário.
},
success = {
    -- Você pode adicionar traduções para mensagens de sucesso aqui, se necessário.
},
info = {
    getstress = "Você está ficando estressado",
    thirsty = "Você está um pouco com sede",
    relaxing = "Você está relaxando",
}
}

if GetConvar('rsg_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
