void_overtime = class({})

function void_overtime:OnSpellStart()

	local dur = self:GetSpecialValueFor("buffduration")
	local caster = self:GetCaster()

	self:GetCaster():AddNewModifier(
						self:GetCaster(),
						self,
						"modifier_overtime",
						{ duration = dur }
	)
end


-----------------------------------------------------------------------------
LinkLuaModifier( "modifier_overtime", "abilities/void_overtime", LUA_MODIFIER_MOTION_NONE )

modifier_overtime = modifier_overtime or class({})

function modifier_overtime:GetTexture() return "modifier_overtime" end
function modifier_overtime:RemoveOnDeath() return true end
function modifier_overtime:IsHidden() return false end 	
function modifier_overtime:IsDebuff() return false end

function modifier_overtime:OnCreated( kv )

	-- setting values manually for now
	slowtime = 0.2
	attackspeed = 450
	movespeed = 4000
	statusresistance = 80
	castimered = 20  -- not sure if casttime reduction is working, need more testing or better value

	
	-- command to slow time scale
	Convars:SetFloat("host_timescale", slowtime )
	
	
	-- Interval think to prevent bug of multiplies modifiers
	if IsServer() then
		self:StartIntervalThink(0.01)
	end
	
	
end

function modifier_overtime:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
end

function modifier_overtime:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_overtime:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, -- This gives true vision to the enemy team.
                                             -- Without this the enemy team will experience game lag since the Client Side picks
                                             -- the hero getting out of vision as the modifier being destroyed. OnDestroy triggers
                                             -- the time scale back to normal, the Client Side will believe that but the server is not.
                                             -- Client Side end up lagging, expecting the game to run on normal speed but the server is
                                             -- giving out informating on a lower speed then normal. So, NEVER REMOVED THIS UNTIL FIXED.
	}
end

function modifier_overtime:OnIntervalThink(event)
	local caster = self:GetCaster()

  -- This is so if there's more then one of this modifier active, if anyone of then ends, another one will keep the time slowed
  Convars:SetFloat("host_timescale", slowtime )
end

function modifier_overtime:OnDestroy()

	-- Set time scale to normal once the modifier ends
	Convars:SetFloat("host_timescale", 1 )
end

function modifier_overtime:GetModifierProvidesFOWVision()
	return 1 
end

function modifier_overtime:GetModifierAttackSpeed_Limit()
	return 1
end

function modifier_overtime:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_overtime:GetModifierTurnRate_Override()
	return 12.0
end

function modifier_overtime:GetModifierAttackSpeedPercentage()
	return attackspeed
end

function modifier_overtime:GetModifierPercentageCasttime()
	return castimered
end

function modifier_overtime:GetModifierStatusResistanceStacking()
	return statusresistance
end

function modifier_overtime:GetModifierMoveSpeedOverride()
	return movespeed
end
