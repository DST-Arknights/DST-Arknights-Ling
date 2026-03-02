-- container
local containers = require "containers"
local cooking = require("cooking")

local  params = containers.params
params.ling_jars =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 32 + 8 + 4, 0),
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.COOK,
            position = Vector3(0, -165, 0),
        }
    },
    acceptsstacks = false,
    type = "cooker",
}

function params.ling_jars.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

function params.ling_jars.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.COOK):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
    end
end

function params.ling_jars.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

-- cooking
local foods = require("preparedfoods")
AddCookerRecipe("ling_jars", foods.wetgoop, true)