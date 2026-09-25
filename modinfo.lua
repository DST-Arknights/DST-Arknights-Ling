-- 对不支持的语言兜底到英文（DST 原版 ChooseTranslationTable 只回退到 tbl[1]，
-- 但我们用字典键值而非数字索引，非 en/zh 语言会返回 nil 导致崩溃）
local function T(tbl)
    return ChooseTranslationTable(tbl) or tbl["en"]
end

name = T({
    en = "Ling",
    zh = "令"
})
-- 版本更新说明（由发布脚本自动维护，请勿手动编辑）
local UPDATE_EN = [[
v1.3.4 (2026-09-26)
- Added Japanese, Mandarin, dialect, and Korean random chatter voices with short, synchronized playback across clients
- Added guard disappearance handling and improved guard management when switching characters
---
v1.3.3 (2026-08-31)
- Disabled minimap entity caching to improve performance
- Refactored the code structure to improve readability and maintainability
]]

local UPDATE_ZH = [[
v1.3.4 (2026-09-26)
- 新增 Japanese、Mandarin、dialect、Korean 多语言随机闲聊语音，并优化为短句随机播放且多端同步
- 新增守卫消失处理，优化角色换人时的守卫管理
---
v1.3.3 (2026-08-31)
- 禁用迷你地图实体缓存以提高性能
- 重构代码结构，提升可读性与可维护性
]]

description = T({
    en = [[The wildfire on the plains never dies; in a single night, every traveler longs for home.

]] .. UPDATE_EN .. [[

Feedback channels for requests and suggestions:
Issues: https://github.com/DST-Arknights/DST-Arknights-Ling/issues
QQ: 3139902761
Email: tohsakakuro@outlook.com
QQ Group: 666511586

Everyone is welcome to participate!]],
    zh = [[长风不灭原上火，一夜征夫尽望乡。

]] .. UPDATE_ZH .. [[

需求与建议反馈渠道:
Issues: https://github.com/DST-Arknights/DST-Arknights-Ling/issues
QQ: 3139902761
Email: tohsakakuro@outlook.com
QQ群: 666511586

欢迎大家积极参与!]]
})
author = "让 望月心灵"
version = "1.3.4"
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
    name = "language",
    label = T({
        en = "Text Language",
        zh = "界面文本语言"
    }),
    hover = T({
        en = "Choose the language of the mod UI text (Auto follows game language)",
        zh = "选择模组界面文本的语言 (Auto 跟随游戏语言)"
    }),
    options = {{
        description = T({
            en = "Auto (follow game)",
            zh = "自动 (跟随游戏)"
        }),
        data = "auto"
    }, {
        description = T({
            en = "Simplified Chinese",
            zh = "简体中文"
        }),
        data = "zh"
    }, {
        description = T({
            en = "English",
            zh = "英文"
        }),
        data = "en"
    }},
    default = "auto"
}, {
    name = "voice_language",
    label = T({
        en = "Choose Voice Language",
        zh = "选择角色语音语言"
    }),
    hover = T({
        en = "Choose the language of the voice",
        zh = "选择角色语音的语言"
    }),
    options = {{
        description = T({
            en = "Japanese",
            zh = "日语"
        }),
        data = "japanese"
    }, {
        description = T({
            en = "Mandarin",
            zh = "汉语-普通话"
        }),
        data = "mandarin"
    }, {
        description = T({
            en = "Dialect",
            zh = "汉语-方言"
        }),
        data = "dialect"
    }, {
        description = T({
            en = "Korean",
            zh = "韩语"
        }),
        data = "korea"
    }, {
        description = T({
            en = "Auto",
            zh = "自动"
        }),
        data = "auto"
    }},
    default = "auto"
}}
mod_dependencies = {
    {["DST-ArknightsItemPackage"] = false},
}