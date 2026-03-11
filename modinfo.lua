name = ChooseTranslationTable({
    en = "Ling",
    zh = "令"
})
description = ChooseTranslationTable({
    en = [[The wildfire on the plains never dies; in a single night, every traveler longs for home.

Feedback channels for requests and suggestions:

Issues: https://github.com/DST-Arknights/DST-Arknights-Ling/issues
QQ: 3139902761
Email: tohsakakuro@outlook.com
QQ Group: 666511586

Everyone is welcome to participate!]],
    zh = [[长风不灭原上火，一夜征夫尽望乡。

需求与建议反馈渠道:

Issues: https://github.com/DST-Arknights/DST-Arknights-Ling/issues
QQ: 3139902761
Email: tohsakakuro@outlook.com
QQ群: 666511586

欢迎大家积极参与!]]
})
author = "让 望月心灵"
version = "0.1.7"
forumthread = "https://github.com/TohsakaKuro/DST-Arknights-Typhon/issues"

api_version = 10

dont_starve_compatible = false
reign_of_giants_compatible = false

dst_compatible = true
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"character", "Ling", "arknights", "令", "明日方舟"}
configuration_options = { {
    name = "voice_language",
    label = ChooseTranslationTable({
        en = "Choose Voice Language",
        zh = "选择角色语音语言"
    }),
    hover = ChooseTranslationTable({
        en = "Choose the language of the voice",
        zh = "选择角色语音的语言"
    }),
    options = {{
        description = ChooseTranslationTable({
            en = "Japanese",
            zh = "日语"
        }),
        data = "jp"
    }, {
        description = ChooseTranslationTable({
            en = "Auto",
            zh = "自动"
        }),
        data = "auto"
    }},
    default = "auto"
}}
mod_dependencies = {
    -- { workshop = "workshop-3677284770"},
    {["DST-ArknightsItemPackage"] = false},
}