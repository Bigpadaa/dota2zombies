zombies_strengh = class({})
LinkLuaModifier("modifier_strengh_modifier", LUA_MODIFIER_MOTION_NONE)


function zombies_strengh:OnSpellStart()()
	local caster = self.GetCaster()
	caster:SetMaxHealth(int maxHP)

end
