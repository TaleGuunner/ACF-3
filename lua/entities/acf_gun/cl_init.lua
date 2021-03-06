include("shared.lua")

local HideInfo = ACF.HideInfoBubble

function ENT:Initialize()
	self.LastFire 	= 0
	self.Reload 	= 0
	self.CloseTime 	= 0
	self.Rate 		= 0
	self.RateScale 	= 0
	self.FireAnim 	= self:LookupSequence("shoot")
	self.CloseAnim 	= self:LookupSequence("load")
	self.HitBoxes 	= ACF.HitBoxes[self:GetModel()]

	self.BaseClass.Initialize(self)
end

-- copied from base_wire_entity: DoNormalDraw's notip arg isn't accessible from ENT:Draw defined there.
function ENT:Draw()
	self:DoNormalDraw(false, HideInfo())

	Wire_Render(self)

	if self.GetBeamLength and (not self.GetShowBeam or self:GetShowBeam()) then
		-- Every SENT that has GetBeamLength should draw a tracer. Some of them have the GetShowBeam boolean
		Wire_DrawTracerBeam(self, 1, self.GetBeamHighlight and self:GetBeamHighlight() or false)
	end
end

function ENT:Think()
	self.BaseClass.Think(self)

	local SinceFire = CurTime() - self.LastFire

	self:SetCycle(SinceFire * self.Rate / self.RateScale)

	if CurTime() > self.LastFire + self.CloseTime and self.CloseAnim then
		self:ResetSequence(self.CloseAnim)
		self:SetCycle((SinceFire - self.CloseTime) * self.Rate / self.RateScale)
		self.Rate = 1 / (self.Reload - self.CloseTime) -- Base anim time is 1s, rate is in 1/10 of a second
		self:SetPlaybackRate(self.Rate)
	end
end

function ENT:Animate(ReloadTime, LoadOnly)
	if self.CloseAnim and self.CloseAnim > 0 then
		self.CloseTime = math.max(ReloadTime - 0.75, ReloadTime * 0.75)
	else
		self.CloseTime = ReloadTime
		self.CloseAnim = nil
	end

	self:ResetSequence(self.FireAnim)
	self:SetCycle(0)
	self.RateScale = self:SequenceDuration()

	if LoadOnly then
		self.Rate = 1000000
	else
		self.Rate = 1 / math.Clamp(self.CloseTime, 0.1, 1.5) --Base anim time is 1s, rate is in 1/10 of a second
	end

	self:SetPlaybackRate(self.Rate)
	self.LastFire = CurTime()
	self.Reload = ReloadTime
end

function ACFGunGUICreate(Table)
	acfmenupanel:CPanelText("Name", Table.name)
	acfmenupanel.CData.DisplayModel = vgui.Create("DModelPanel", acfmenupanel.CustomDisplay)
	acfmenupanel.CData.DisplayModel:SetModel(Table.model)
	acfmenupanel.CData.DisplayModel:SetCamPos(Vector(250, 500, 250))
	acfmenupanel.CData.DisplayModel:SetLookAt(Vector(0, 0, 0))
	acfmenupanel.CData.DisplayModel:SetFOV(20)
	acfmenupanel.CData.DisplayModel:SetSize(acfmenupanel:GetWide(), acfmenupanel:GetWide())
	acfmenupanel.CData.DisplayModel.LayoutEntity = function() end
	acfmenupanel.CustomDisplay:AddItem(acfmenupanel.CData.DisplayModel)
	local GunClass = ACF.Classes.GunClass[Table.gunclass]
	acfmenupanel:CPanelText("ClassDesc", GunClass.desc)
	acfmenupanel:CPanelText("GunDesc", Table.desc)
	acfmenupanel:CPanelText("Caliber", "Caliber : " .. (Table.caliber * 10) .. "mm")
	acfmenupanel:CPanelText("Weight", "Weight : " .. Table.weight .. "kg")

	if not Table.rack then
		local RoundVolume = 3.1416 * (Table.caliber / 2) ^ 2 * Table.round.maxlength
		local RoF = 60 / (((RoundVolume / 500) ^ 0.60) * GunClass.rofmod * (Table.rofmod or 1)) --class and per-gun use same var name
		acfmenupanel:CPanelText("Firerate", "RoF : " .. math.Round(RoF, 1) .. " rounds/min")

		if Table.magsize then
			acfmenupanel:CPanelText("Magazine", "Magazine : " .. Table.magsize .. " rounds\nReload :   " .. Table.magreload .. " s")
		end

		acfmenupanel:CPanelText("Spread", "Spread : " .. GunClass.spread .. " degrees")
	end

	acfmenupanel.CustomDisplay:PerformLayout()
end