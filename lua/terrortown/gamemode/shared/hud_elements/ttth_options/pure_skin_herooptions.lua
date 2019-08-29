local draw = draw
local string = string

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local optionMargin = 20
	local optionWidth = 200
	local optionHeight = 40
	local linePad = 5

	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = optionWidth, h = optionHeight * 2 + 5},
		minsize = {w = 130, h = 40}
	}

	function HUDELEMENT:PreInitialize()
		BaseClass.PreInitialize(self)

		local hud = huds.GetStored("pure_skin")
		if not hud then return end

		hud:ForceElement(self.id)
	end

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.optionMargin = optionMargin
		self.optionWidth = optionWidth
		self.optionHeight = optionHeight
		self.linePad = linePad

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = ScrW() - self.optionWidth - self.optionMargin, y =  self.optionMargin + 80 }

		return const_defaults
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end
	-- parameter overwrites end

	function HUDELEMENT:PerformLayout()
		self.scale = self:GetHUDScale()
		self.optionMargin = optionMargin * self.scale
		self.optionWidth = optionWidth * self.scale
		self.optionHeight = optionHeight * self.scale
		self.linePad = linePad * self.scale

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:DrawClassOption(ty, key, name, color)
		local x = self:GetPos().x
		local w = self:GetSize().w

		-- draw bg and shadow
		self:DrawBg(x, ty, w, self.optionHeight, color)

		-- draw key
		local pad = 40

		draw.AdvancedText(key, "ClassDescOptions", x + pad * 0.5, ty + self.optionHeight * 0.5, self:GetDefaultFontColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		-- draw line
		local line = 3

		draw.RoundedBoxEx(0, x + pad + 1, ty + self.linePad, 1, self.optionHeight - 2 * self.linePad, COLOR_WHITE)

		-- draw class name
		draw.AdvancedText(name, "ClassDesc", x + pad + line + (w - pad - line) * 0.5, ty + self.optionHeight * 0.5, self:GetDefaultFontColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, true, self.scale)

		-- draw lines around the element
		self:DrawLines(x, ty, w, self.optionHeight)
	end

	local rawT

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local y = pos.y

		rawT = rawT or LANG.GetRawTranslation

		local key1 = string.upper(input.GetKeyName(bind.Find("toggleclass")) or "?")
		local key2 = string.upper(input.GetKeyName(bind.Find("abortclass")) or "?")

		local y_temp = y

		local hd1 = CLASS.GetClassDataByIndex(client.classOpt1)
		local hd2 = CLASS.GetClassDataByIndex(client.classOpt2)

		self:DrawClassOption(y_temp, key1, rawT(hd1.name), hd1.color)

		y_temp = y_temp + self.optionHeight + 5

		self:DrawClassOption(y_temp, key2, rawT(hd2.name), hd2.color)

	end

	function HUDELEMENT:ShouldDraw()
		local client = LocalPlayer()

		return client:IsActive() and GetGlobalBool("ttt_classes_option") and client.classOpt1 and client.classOpt2
	end
end
