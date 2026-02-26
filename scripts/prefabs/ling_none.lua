local assets =
{
	Asset( "ANIM", "anim/ling.zip" ),
	Asset( "ANIM", "anim/ghost_ling_build.zip" ),
}

local skins =
{
	normal_skin = "ling",
	ghost_skin = "ghost_ling_build",
}

local base_prefab = "ling"

local tags = {"BASE" ,"LING", "CHARACTER"}

return CreatePrefabSkin("ling_none",
{
	base_prefab = base_prefab,
	skins = skins,
	assets = assets,
	skin_tags = tags,

	build_name_override = "ling",
	rarity = "Character",
})