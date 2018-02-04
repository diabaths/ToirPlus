IncludeFile("Lib\\TOIR_SDK.lua")
--IncludeFile("Lib\\OrbNew.lua")
--IncludeFile("Lib\\Baseult.lua")

Rengar = class()

function OnLoad()
	if GetChampName(GetMyChamp()) == "Rengar" then
		Rengar:__init()
	end
end
local function PrintChat(msg) --Credits to Shulepong kappa
	return __PrintTextGame("<b><font color=\"#4286f4\">[Diabaths] </font></b> </font><font color=\"#c5eff7\"> " .. msg .. " </font><b><font color=\"#4286f4\"></font></b> </font>")
end
function Rengar:__init()
	-- VPrediction
	vpred = VPrediction(true)

	--TS
    self.menu_ts = TargetSelector(1750, 1, myHero, true, true, true)

		self.Q = Spell(_Q, 525)
	  self.Q:SetSkillShot(0.25, 1500, 70, false)

		self.W = Spell(_W, 500)
	  self.W:SetTargetted()

		self.E = Spell(_E, 980)
	  self.E:SetSkillShot(0.1, 1500, 70, true)

		self.R = Spell(_R, 15000)
	  self.R:SetActive()


		PrintChat("Rengar Loaded. Good Luck!")
		self.UltiOn = false
		self.PassiveOn = false
		self.CombokeyDown = 0
		self.passiveup = false

		Callback.Add("Tick", function(...) self:OnTick(...) end)
  	Callback.Add("Draw", function(...) self:OnDraw(...) end)
		Callback.Add("AfterAttack", function(...) self:OnAfterAttack(...) end)
  	Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
		Callback.Add("UpdateBuff", function(...) self:OnUpdateBuff(...) end)
		Callback.Add("CreateObject", function(...) self:OnCreateObject(...) end)
		Callback.Add("DeleteObject", function(...) self:OnDeleteObject(...) end)
		Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
		Callback.Add("DoCast", function(...) self:OnDoCast(...) end)
		--Callback.Add("Dash", function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance) func(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance) end)
    self:MenuValueDefault()

	end

function Rengar:MenuValueDefault()
	self.menu = "D-Rengar"
	self.Draw_When_Already = self:MenuBool("Draw When Already", true)
	self.Draw_combomode = self:MenuBool("Draw the Combo Mode", true)
	self.Draw_Q = self:MenuBool("Draw Q Range", true)
	self.Draw_W = self:MenuBool("Draw W Range", true)
	self.Draw_E = self:MenuBool("Draw E Range", true)

	self.combo_q = self:MenuBool("Use Q in Combo", true)
  self.combo_w = self:MenuBool("Use W in Combo", true)
  self.combo_e = self:MenuBool("Use E in Combo", true)
  self.combomode = self:MenuComboBox("Pick your Combo Mode", 0)
	self.comboprio = self:MenuKeyBinding("Change your Combo", 84)

	self.harass_q = self:MenuBool("Use Q in Harass", true)
  self.harass_W = self:MenuBool("Use W in Harass", true)
	self.harass_E = self:MenuBool("Use E in Harass", true)

	self.lane_q = self:MenuBool("Use Q to farm", true)
	self.lane_w = self:MenuBool("Use W to farm", true)
	self.lane_e = self:MenuBool("Use W to farm", true)

	self.jungle_q = self:MenuBool("Use Q Jungle", true)
	self.jungle_w = self:MenuBool("Use W Jungle", true)
	self.jungle_e = self:MenuBool("Use E Jungle", true)

	self.Enalble_Mod_Skin = self:MenuBool("Enalble Mod Skin", false)
	self.Set_Skin = self:MenuSliderInt("Set Skin", 3)
	self.AutoW = self:MenuBool("Remove crowd control effects", true)
	self.KillstealQ = self:MenuBool("Use Q to killsteal", true)
	self.KillstealW = self:MenuBool("Use W to killsteal", true)
	self.KillstealE = self:MenuBool("Use E to killsteal", true)
	self.ImmobileE = self:MenuBool("Use E in Immobile", true)

	self.use_titanic = self:MenuBool("Use Titanic_Hydra", true)
	self.use_ravenous = self:MenuBool("Use Ravenous_Hydras", true)
	self.use_tiamat = self:MenuBool("UseTiamat", true)
	self.use_youmuu = self:MenuBool("Use Youmuus", true)
	self.use_quicksilver = self:MenuBool("Use Q to killsteal", true)
	self.use_mercurial = self:MenuBool("Use Mercurial ", true)

	self.Combo = self:MenuKeyBinding("Combo", 32)
	self.Harass = self:MenuKeyBinding("Harass", 67)
	self.Lane_Clear = self:MenuKeyBinding("Lane Clear", 86)
	self.Jungle_Clear = self:MenuKeyBinding("Jungle Clear", 86)
  self.Last_Hit = self:MenuKeyBinding("Last Hit", 88)
end

function Rengar:OnDrawMenu()
	if Menu_Begin(self.menu) then
		if Menu_Begin("Combo Setting") then
			self.combo_q = Menu_Bool("Use Q in Combo", self.combo_q, self.menu)
			self.combo_w = Menu_Bool("Use W in Combo", self.combo_w, self.menu)
			self.combo_e = Menu_Bool("Use E in Combo", self.combo_e, self.menu)
			self.combomode = Menu_ComboBox("Pick your Combo Mode", self.combomode, "RETQW\0RETWQ\0REQWT\0", self.menu)
			self.comboprio = Menu_KeyBinding("Change your Comboy", self.comboprio, self.menu)
			Menu_End()
		end
		if Menu_Begin("Harass Setting") then
			self.harass_q = Menu_Bool("Use Q in Harass", self.harass_q, self.menu)
			self.harass_w = Menu_Bool("Use W in Harass", self.harass_w, self.menu)
			self.harass_e = Menu_Bool("Use E in Harass", self.harass_e, self.menu)
			Menu_End()
		end
		if Menu_Begin("Lane Clear Setting") then
			self.lane_q = Menu_Bool("Use Q to farm", self.lane_q, self.menu)
			self.lane_w = Menu_Bool("Use W to farm", self.lane_w, self.menu)
			self.lane_e = Menu_Bool("Use E to farm", self.lane_e, self.menu)
			Menu_End()
		end
		if Menu_Begin("Jungle Clear Setting") then
			self.jungle_q = Menu_Bool("Use Q Jungle", self.jungle_q, self.menu)
			self.jungle_w = Menu_Bool("Use W Jungle", self.jungle_w, self.menu)
			self.jungle_e = Menu_Bool("Use E Jungle", self.jungle_e, self.menu)
			Menu_End()
		end
		if Menu_Begin("Misc Setting") then
			self.Enalble_Mod_Skin = Menu_Bool("Enalble Mod Skin", self.Enalble_Mod_Skin, self.menu)
			self.Set_Skin = Menu_SliderInt("Set Skin", self.Set_Skin, 1, 5, self.menu)
			self.AutoW = Menu_Bool("Remove crowd control effects", self.AutoW, self.menu)
			self.KillstealQ = Menu_Bool("Use Q to killsteal", self.KillstealQ, self.menu)
			self.KillstealW = Menu_Bool("Use W to killsteal", self.KillstealW, self.menu)
			self.KillstealE = Menu_Bool("Use E to killsteal", self.KillstealE, self.menu)
			self.ImmobileE = Menu_Bool("Use E in Immobile", self.ImmobileE, self.menu)
			Menu_End()
		end
		if Menu_Begin("Items Settings") then
			self.use_titanic = Menu_Bool("Use Titanic_Hydra", self.use_titanic, self.menu)
			self.use_ravenous = Menu_Bool("Use Ravenous_Hydras", self.use_ravenous, self.menu)
			self.use_tiamat = Menu_Bool("UseTiamat", self.use_tiamat, self.menu)
			self.use_youmuu = Menu_Bool("Use Youmuus", self.use_youmuu, self.menu)
			self.use_quicksilver = Menu_Bool("Use Q to killsteal", self.use_quicksilver, self.menu)
			self.use_mercurial = Menu_Bool("Use Mercurial ", self.use_mercurial, self.menu)
			Menu_End()
		end
		if Menu_Begin("Draw Spell") then
				self.Draw_When_Already = Menu_Bool("Draw When Already", self.Draw_When_Already, self.menu)
				self.Draw_combomode = Menu_Bool("Draw the Combo Mode", self.Draw_combomode, self.menu)
				self.Draw_Q = Menu_Bool("Draw Q Range", self.Draw_Q, self.menu)
				self.Draw_W = Menu_Bool("Draw W Range", self.Draw_W, self.menu)
				self.Draw_E = Menu_Bool("Draw E Range", self.Draw_E, self.menu)
				Menu_End()
			end
		if Menu_Begin("Key Mode") then
			self.Combo = Menu_KeyBinding("Combo", self.Combo, self.menu)
			self.Harass = Menu_KeyBinding("Harass", self.Harass, self.menu)
			self.Lane_Clear = Menu_KeyBinding("Lane Clear", self.Lane_Clear, self.menu)
			self.Jungle_Clear = Menu_KeyBinding("Jungle Clear", self.Jungle_Clear, self.menu)
			self.Last_Hit = Menu_KeyBinding("Last Hit", self.Last_Hit, self.menu)
			Menu_End()
		end
		Menu_End()
	end
end

function Rengar:MenuBool(stringKey, bool)
	return ReadIniBoolean(self.menu, stringKey, bool)
end

function Rengar:MenuSliderInt(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Rengar:MenuSliderFloat(stringKey, valueDefault)
	return ReadIniFloat(self.menu, stringKey, valueDefault)
end

function Rengar:MenuComboBox(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Rengar:MenuKeyBinding(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Rengar:OnTick()
	if myHero.IsDead or IsTyping() or myHero.IsRecall or IsDodging() then return end
	if myHero.HasBuff("rengarpassivebuff") then
		self.PassiveOn = true
	else self.PassiveOn = false
	end
	if myHero.HasBuff("RengarR") then
		self.UltiOn = true
	else self.UltiOn = false
	end
	if self.Enalble_Mod_Skin then
		ModSkin(self.Set_Skin)
	end

	if GetKeyPress(self.comboprio) > 0  and GetTimeGame() > self.CombokeyDown then
		if self.combomode == 0 then
				self.combomode = 1
				self.CombokeyDown = GetTimeGame() + 0.250
		elseif self.combomode == 1 then
				self.combomode = 2
				self.CombokeyDown = GetTimeGame() + 0.250
		elseif self.combomode == 2 then
				self.combomode = 0
				self.CombokeyDown = GetTimeGame() + 0.250
		end
	end
 	SetLuaCombo(true)
	SetLuaHarass(true)
	SetLuaLaneClear(true)

	if GetKeyPress(self.Combo) > 0		then
		self:RengarCombo()
	end

	if GetKeyPress(self.Harass) > 0		then
			self:RengarHarass()
		end
	if GetKeyPress(self.Jungle_Clear) > 0  then
			self:Rengarjungle()
		end
		self:OnImmobile()
		self:KillSteal()
		--self:DrawHeroInfo()
	end
	function Rengar:OnProcessSpell(unit, spell)
		local spellName = spell.Name:lower()
		if unit.IsMe then
		--__PrintTextGame(spell.Name)
		end
		if (GetKeyPress(self.Jungle_Clear) > 0 or GetKeyPress(self.Lane_Clear) > 0) then
			if unit.IsMe and (spellName == "rengarq" or spellName == "rengarq2") and not CanCast(_E) then
				--DelayAction(function() ResetsAutoAttackTimer() end, 0.3)
				--Orbwalker:ResetAutoAttackTimer()
				local tiamat = GetSpellIndexByName("ItemTiamatCleave")
				if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
						CastSpellTarget(myHero.Addr, tiamat)
				local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
				elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
							CastSpellTarget(myHero.Addr, titanic)
				end
				if CanCast(_W) and IsValidTarget(target, self.W.range) and self.combo_w then
					CastSpellTarget(myHero.Addr, _W)
				end
			end
		end
		if self.combomode == 0  and GetKeyPress(self.Combo) > 0 then
		if unit.IsMe and (spellName == "rengarq" or spellName == "rengarq2") and not CanCast(_E) then
			--DelayAction(function() ResetsAutoAttackTimer() end, 0.3)
			--Orbwalker:ResetAutoAttackTimer()
			local tiamat = GetSpellIndexByName("ItemTiamatCleave")
			if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
					CastSpellTarget(myHero.Addr, tiamat)
			local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
			elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
						CastSpellTarget(myHero.Addr, titanic)
			end
			if CanCast(_W) and IsValidTarget(target, self.W.range) and self.combo_w then
				CastSpellTarget(myHero.Addr, _W)
			end
		end
	end
		if self.combomode == 1  and GetKeyPress(self.Combo) > 0 then
			if unit.IsMe and (spellName == "rengarq" or spellName == "rengarq2") and not CanCast(_E) then
				--DelayAction(function() ResetsAutoAttackTimer() end, 0.3)
				--Orbwalker:ResetAutoAttackTimer()
				local tiamat = GetSpellIndexByName("ItemTiamatCleave")
				if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
						CastSpellTarget(myHero.Addr, tiamat)
				local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
				elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
							CastSpellTarget(myHero.Addr, titanic)
				end
				if CanCast(_W) and IsValidTarget(target, self.W.range) and self.combo_w then
					CastSpellTarget(myHero.Addr, _W)
				end
			end
			if unit.IsMe and (spellName == "rengarw" ) then
				if CanCast(_Q) and IsValidTarget(target, self.Q.range) and self.combo_q then
					local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
							if HitChance >= 1 then
								CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
					end
				end
			end
		end

		if self.combomode == 2  and GetKeyPress(self.Combo) > 0 then
		if unit.IsMe and (spellName == "rengarw" ) then
			--DelayAction(function() ResetsAutoAttackTimer() end, 0.3)
			--Orbwalker:ResetAutoAttackTimer()
			local tiamat = GetSpellIndexByName("ItemTiamatCleave")
			if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
					CastSpellTarget(myHero.Addr, tiamat)
			local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
			elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
						CastSpellTarget(myHero.Addr, titanic)
			end
		end
		if unit.IsMe and (spellName == "rengarq" or spellName == "rengarq2") and not CanCast(_W) then
			--DelayAction(function() ResetsAutoAttackTimer() end, 0.3)
			--Orbwalker:ResetAutoAttackTimer()
			local tiamat = GetSpellIndexByName("ItemTiamatCleave")
			if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
					CastSpellTarget(myHero.Addr, tiamat)
			local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
			elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
						CastSpellTarget(myHero.Addr, titanic)
			end
		end
	end
end

	function Rengar:OnDoCast(unit, spell)
		local Target = GetTargetSelector(1500, 1)
		target = GetAIHero(Target)
		if unit.IsMe then
			--__PrintTextGame(spell.Name)
		end
		if self.combomode == 0 then
		if (spell.Name == "RengarE" or spell.Name == "RengarEEmp") and GetKeyPress(self.Combo) > 0  then
					if IsValidTarget(target, 600)  then
					local tiamat = GetSpellIndexByName("ItemTiamatCleave")
					if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
							CastSpellTarget(myHero.Addr, tiamat)
					local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
				  elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
								CastSpellTarget(myHero.Addr, titanic)
					end
					if CanCast(_Q) and IsValidTarget(target, self.Q.range) and self.combo_q then
						local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
								if HitChance >= 1 then
									CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
								end
							end
						end
					end
				end

	if self.combomode == 1 then
	if (spell.Name == "RengarE" or spell.Name == "RengarEEmp") and GetKeyPress(self.Combo) > 0  then
				if IsValidTarget(target, 600)  then
				local tiamat = GetSpellIndexByName("ItemTiamatCleave")
				if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
						CastSpellTarget(myHero.Addr, tiamat)
				local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
				elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
							CastSpellTarget(myHero.Addr, titanic)
				end
				if CanCast(_W) and IsValidTarget(target, self.W.range) and self.combo_w then
					CastSpellTarget(myHero.Addr, _W)
				end
			end
		end
	end
	if self.combomode == 2 then
	if (spell.Name == "RengarE" or spell.Name == "RengarEEmp") and GetKeyPress(self.Combo) > 0  then
				if IsValidTarget(target, 600)  then
				if CanCast(_W) and IsValidTarget(target, self.W.range) and self.combo_w then
					CastSpellTarget(myHero.Addr, _W)
				end
			end
		end
	end
end

function Rengar:Rengarjungle()
		if (GetType(GetTargetOrb()) == 3) and (GetObjName(GetTargetOrb()) ~= "PlantSatchel" and GetObjName(GetTargetOrb()) ~= "PlantHealth" and GetObjName(GetTargetOrb()) ~= "PlantVision") then
			target = GetUnit(GetTargetOrb())
			if myHero.MP ~= 4 then
				if CanCast(_Q) and self.jungle_q and IsValidTarget(target, self.Q.range) then
					local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
						if HitChance >= 1 then
							CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
						end
					end
					if CanCast(_W) and self.jungle_w and IsValidTarget(target, self.W.range) then
						CastSpellTarget(myHero.Addr, _W)
					end
					if CanCast(_E) and self.jungle_e and IsValidTarget(target, self.E.range) then
						local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
						if HitChance >= 1 then
							CastSpellToPos(CastPosition.x, CastPosition.z, _E)
						end
					end
				end
				if myHero.MP >= 4 then
					if CanCast(_Q) and self.jungle_q and IsValidTarget(target, self.Q.range) then
						local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
							if HitChance >= 1 then
								CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
							end
						end
					end
				end
			end

function  Rengar:OnCreateObject(obj)
	if myHero then
		--__PrintTextGame(obj.Name)
	end

	if string.find(obj.Name, "Rengar_Base_P_Buf_Enhanced_Ring.troy")  then
				self.passiveup = true
			--	__PrintTextGame("passive on")
			end
		end


function  Rengar:OnDeleteObject(obj)
			if string.find(obj.Name, "Rengar_Base_P_Buf_Enhanced_Ring.troy")  then
						self.passiveup = false
						--__PrintTextGame("passive off")
					end
				end
function Rengar:OnUpdateBuff(unit,buff,stacks)
	if unit.IsMe and (buff.Name == "Fear" or buff.Name == "Charm" or buff.Name == "Snare"or buff.Name == "Stun" or buff.Name == "Taunt") then
		if CanCast(_W) and self.AutoW and myHero.MP == myHero.MaxMP then
				CastSpellTarget(myHero.Addr, _W)
		end
		if (not CanCast(_W) or not self.AutoW or  myHero.MP < myHero.MaxMP) then
				local quicksilver = GetSpellIndexByName("QuicksilverSash")
		 		if myHero.HasItem(3140)  and CanCast(quicksilver) then
				 	DelayAction(function() CastSpellTarget(myHero.Addr, quicksilver) end, 0.1)
				end
		 		local mercurial = GetSpellIndexByName("ItemMercurial")
	  		if self.use_mercurial and myHero.HasItem(3139)  and CanCast(mercurial) then
	 		 		DelayAction(function() CastSpellTarget(myHero.Addr, mercurial) end, 0.1)
				end
			end
		end
	end

function Rengar:EnemyMinionsTbl()
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    local result = {}
    for i, obj in pairs(pUnit) do
        if obj ~= 0  then
            local minions = GetUnit(obj)
            if IsEnemy(minions.Addr) and not IsDead(minions.Addr) and not IsInFog(minions.Addr) and GetType(minions.Addr) == 1 then
                table.insert(result, minions.Addr)
            end
        end
    end
    return result
end

function Rengar:OnAfterAttack(unit, target)

end

function Rengar:RengarHarass()
	local Target = GetTargetSelector(1500, 1)
	target = GetAIHero(Target)
	if CanCast(_Q) and self.harass_q and IsValidTarget(target, self.Q.range) then
		local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
				if HitChance >= 1 then
					CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
			end
		end
		if CanCast(_W) and self.harass_w and IsValidTarget(target, self.W.range) then
 		 CastSpellTarget(myHero.Addr, _W)
 	 end
	 if CanCast(_E) and self.harass_e and IsValidTarget(target, self.E.range) then
		 local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
				 if HitChance >= 2 then
					 CastSpellToPos(CastPosition.x, CastPosition.z, _E)
				 end
	 end
 end

function Rengar:CanMove(unit)
	if (CountBuffByType(unit.Addr, 5) == 1 or CountBuffByType(unit.Addr, 21) == 1 or CountBuffByType(unit.Addr, 11) == 1 or CountBuffByType(unit.Addr, 29) == 1 or
		unit.HasBuff("recall") or CountBuffByType(unit.Addr, 30) == 1 or CountBuffByType(unit.Addr, 22) == 1 or CountBuffByType(unit.Addr, 8) == 1 or CountBuffByType(unit.Addr, 24) == 1
		or CountBuffByType(unit.Addr, 20) == 1 or CountBuffByType(unit.Addr, 18) == 1) then
		return false
	end
	return true
end

function Rengar:RengarCombo()
	local Target = GetTargetSelector(1500, 1)
	target = GetAIHero(Target)
	if self.use_youmuu  then
		if self.UltiOn then
			local yommus = GetSpellIndexByName("YoumusBlade")
			if myHero.HasItem(3142)  and CanCast(yommus) then
				DelayAction(function() CastSpellTarget(myHero.Addr, yommus) end, 0.3)
			end
		end
		if not CanCast(_R) and IsValidTarget(target, self.E.range + 150) then
			local yommus = GetSpellIndexByName("YoumusBlade")
			DelayAction(function() CastSpellTarget(myHero.Addr, yommus) end, 0.1)
		end
	end

	if target ~=nil and IsValidTarget(target, 1500) then
		if self.combomode ==2 then
			if myHero.MP ~=4 then
				if CanCast(_E) and self.combo_e and IsValidTarget(target, self.E.range) and not self.passiveup then
					local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
							if HitChance >= 2 then
								CastSpellToPos(CastPosition.x, CastPosition.z, _E)
							end
				end
				if CanCast(_Q) and self.combo_q and IsValidTarget(target, self.Q.range) then
					local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
							if HitChance >= 1 then
								CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
						end
					end
				end
				if CanCast(_W) and self.combo_w and IsValidTarget(target, self.W.range) then
					CastSpellTarget(myHero.Addr, _W)
				end
				if myHero.MP >= 4 then
						if CanCast(_Q) and self.combo_q and IsValidTarget(target, self.Q.range) then
							self.Q:Cast(target.Addr)
						end
						if self.combo_e and IsValidTarget(target, self.E.range) and GetDistance(target.Addr) > self.Q.range and not self.passiveup then
							local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
									if HitChance >= 2 then
										CastSpellToPos(CastPosition.x, CastPosition.z, _E)
									end
								end
							end
						end
		if self.combomode ==1 then
			if myHero.MP ~=4 then
				if CanCast(_E) and self.combo_e and not self.passiveup then
					local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
							if HitChance >= 2 then
								CastSpellToPos(CastPosition.x, CastPosition.z, _E)
							end
				end
				if CanCast(_W) and self.combo_w and IsValidTarget(target, self.W.range) then
					CastSpellTarget(myHero.Addr, _W)
				end
				if CanCast(_Q) and self.combo_q and IsValidTarget(target, self.Q.range) then
					local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
							if HitChance >= 1 then
								CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
						end
					end
				end
				if myHero.MP >= 4 then
						if CanCast(_Q) and self.combo_q and IsValidTarget(target, self.Q.range) then
							self.Q:Cast(target.Addr)
						end
						if self.combo_e and IsValidTarget(target, self.E.range) and GetDistance(target.Addr) > self.Q.range and not self.passiveup then
							local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
									if HitChance >= 2 then
										CastSpellToPos(CastPosition.x, CastPosition.z, _E)
									end
								end
							end
						end

		if self.combomode == 0 then
		if myHero.MP ~= 4 then
			if CanCast(_E) and self.combo_e and not self.passiveup then
				local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
						if HitChance >= 2 then
							CastSpellToPos(CastPosition.x, CastPosition.z, _E)
						end
			end
			if CanCast(_Q) and self.combo_q and IsValidTarget(target, self.Q.range) then
				local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
						if HitChance >= 1 then
							CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
						end
			end
			if CanCast(_W) and self.combo_w and IsValidTarget(target, self.W.range) then
				CastSpellTarget(myHero.Addr, _W)
			end
		end
		if myHero.MP >= 4 then
			if CanCast(_Q) and self.combo_q and IsValidTarget(target, self.Q.range) then
				self.Q:Cast(target.Addr)
			end
			if self.combo_e and IsValidTarget(target, self.E.range) and GetDistance(target.Addr) > self.Q.range and not self.passiveup then
				local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
						if HitChance >= 2 then
							CastSpellToPos(CastPosition.x, CastPosition.z, _E)
						end
					end
				end
			end
		end
	end

function Rengar:OnImmobile()
	local enemy = self.menu_ts:GetTarget(self.Q.range)
			 if CanCast(E)  and IsValidTarget(enemy, self.E.range) then
				 local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
				 			 if  self:IsImmobileTarget(enemy) and self.ImmobileE then
						 	 CastSpellToPos(CastPosition.x, CastPosition.z, _E)
					 end
			end
end

function Rengar:KillSteal()
	for i, heros in ipairs(GetEnemyHeroes()) do
			if heros ~= nil then
				local target = GetAIHero(heros)
		  	local qDmg = GetDamage("Q", target)
		  	local wDmg = GetDamage("W", target)
				local eDmg = GetDamage("E", target)
  	    	if CanCast(_Q) and target ~= 0 and IsValidTarget(target, self.Q.range) and self.KillstealQ then
		      local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
		 	       if HitChance >= 2 and qDmg > target.HP then
			          CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
						 end
	 	      end
		    	if CanCast(_W) and target ~= 0 and IsValidTarget(target, self.W.range) and self.KillstealW then
			       if wDmg > target.HP then
				        CastSpellTarget(myHero.Addr, _W)
			      end
			   end
				 if CanCast(_E) and self.KillstealE and eDmg  > target.HP and IsValidTarget(target, self.E.range) then
						local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, true)
							if HitChance >= 2 then
											CastSpellToPos(CastPosition.x, CastPosition.z, _E)
						end
				 end
			end
	end
end


function Rengar:IsImmobileTarget(unit)
	if (CountBuffByType(unit, 5) == 1 or CountBuffByType(unit, 11) == 1 or CountBuffByType(unit, 29) == 1 or CountBuffByType(unit, 24) == 1 or CountBuffByType(unit, 10) == 1 or CountBuffByType(unit, 29) == 1) then
		return true
	end
	return false
end

function Rengar:OnDraw()
	for i,hero in pairs(GetEnemyHeroes()) do
		if IsValidTarget(hero, 2000) then
			target = GetAIHero(hero)
			if IsValidTarget(target.Addr, self.R.range) and GetDamage("R", target) > target.HP then
				local a,b = WorldToScreen(target.x, target.y, target.z)
				DrawTextD3DX(a, b, "CAN KILL by R", Lua_ARGB(255, 0, 255, 10))
			end
		end
	end
	if self.Draw_combomode then
		local a,b = WorldToScreen(myHero.x, myHero.y, myHero.z)
		if self.combomode == 0 then
			DrawTextD3DX(a, b, "RETQW", Lua_ARGB(255, 255, 132, 0))
		elseif self.combomode == 1 then
			DrawTextD3DX(a, b, "RETWQ", Lua_ARGB(255, 0, 255, 10))
	  elseif self.combomode == 2 then
			DrawTextD3DX(a, b, "REQWT", Lua_ARGB(255, 132, 0, 10))
		end
	end

	if self.Draw_When_Already then
		if self.Draw_Q and self.Q.IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
		end
		if self.Draw_W and self.W:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.W.range, Lua_ARGB(255,255,0,0))
		end
		if self.Draw_E and self.E:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
		end
		if self.Draw_R and self.R:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.R.range, Lua_ARGB(255,255,0,0))
		end
	else
		if self.Draw_Q then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
		end
		if self.Draw_W then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.W.range, Lua_ARGB(255,255,0,0))
		end
		if self.Draw_E then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
		end
		if self.Draw_R then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.R.range, Lua_ARGB(255,255,0,0))
		end
	end
end

local function GetDistanceSqr(p1, p2)
    p2 = GetOrigin(p2) or GetOrigin(myHero)
    return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end

function Rengar:IsUnderTurretEnemy(pos)			--Will Only work near myHero
	GetAllUnitAroundAnObject(myHero.Addr, 2000)
	local objects = pUnit
	for k,v in pairs(objects) do
		if IsTurret(v) and not IsDead(v) and IsEnemy(v) and GetTargetableToTeam(v) == 4 then
			local turretPos = Vector(GetPosX(v), GetPosY(v), GetPosZ(v))
			if GetDistanceSqr(turretPos,pos) < 915*915 then
				return true
			end
		end
	end
	return false
end

function Rengar:IsUnderAllyTurret(pos)
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
  for k,v in pairs(pUnit) do
    if not IsDead(v) and IsTurret(v) and IsAlly(v) and GetTargetableToTeam(v) == 4 then
      local turretPos = Vector(GetPosX(v), GetPosY(v), GetPosZ(v))
      if GetDistance(turretPos,pos) < 915 then
        return true
      end
    end
  end
    return false
end

local function CountAlliesInRange(pos, range)
    local n = 0
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, object in ipairs(pUnit) do
        if GetType(object) == 0 and not IsDead(object) and not IsInFog(object) and GetTargetableToTeam(object) == 4 and IsAlly(object) then
          if GetDistanceSqr(pos, object) <= math.pow(range, 2) then
              n = n + 1
          end
        end
    end
    return n
end

function Rengar:CountEnemiesInRange(pos, range)
    local n = 0
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, object in ipairs(pUnit) do
        if GetType(object) == 0 and not IsDead(object) and not IsInFog(object) and GetTargetableToTeam(object) == 4 and IsEnemy(object) then
        	local objectPos = Vector(GetPos(object))
          	if GetDistanceSqr(pos, objectPos) <= math.pow(range, 2) then
            	n = n + 1
          	end
        end
    end
    return n
end
