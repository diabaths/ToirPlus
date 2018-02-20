IncludeFile("Lib\\TOIR_SDK.lua")
--IncludeFile("Lib\\OrbNew.lua")
--IncludeFile("Lib\\Baseult.lua")

Riven = class()

function OnLoad()
	if GetChampName(GetMyChamp()) == "Riven" then
		Riven:__init()
	end
end
local function PrintChat(msg) --Credits to Shulepong kappa
	return __PrintTextGame("<b><font color=\"#4286f4\">[Diabaths] </font></b> </font><font color=\"#c5eff7\"> " .. msg .. " </font><b><font color=\"#4286f4\"></font></b> </font>")
end
function Riven:__init()
	self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	-- VPrediction
	vpred = VPrediction(true)

	--TS
    self.menu_ts = TargetSelector(1750, 0, myHero, true, true, true)

    self.Q = Spell(_Q, 315) --
    self.W = Spell(_W, 265) --
    self.E = Spell(_E, 325)  --
    self.R = Spell(_R, math.huge) --
		self.R2 = Spell(_R, 900) --

    self.Q:SetTargetted() --
    self.W:SetTargetted() --
    self.E:SetSkillShot(0.1, 1450, 80, false)
    self.R:SetActive() --
		self.R2:SetSkillShot(0.25, math.huge, (15 * math.pi / 60), false)


		Callback.Add("Tick", function(...) self:OnTick(...) end)
  	Callback.Add("Draw", function(...) self:OnDraw(...) end)
		Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
		Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
		Callback.Add("PlayAnimation", function(...) self:OnAnimation(...) end)
		Callback.Add("AfterAttack", function(...) self:OnAfterAttack(...) end)
		self:MenuValueDefault()
		PrintChat("Riven Loaded. Good Luck!")


end

function Riven:MenuValueDefault()
	self.menu = "D-Riven"
	self.useingite = self:MenuBool("Use Ignite if killable(all in)", true)
	self.useflash = self:MenuBool("Use Flash in Combos", true)
	self.combo_q = self:MenuBool("Use Q in Combo", true)
  self.combo_w = self:MenuBool("Use W in Combo", true)
	self.combo_e = self:MenuBool("Use E in Combo", true)
	self.combo_r = self:MenuBool("Use R if enemy if Killable", true)
	self.combo_rall = self:MenuSliderInt("Open R1 if Enemies Around >=", 3)
	self.combomode = self:MenuComboBox("Pick your Combo Mode", 0)
	self.comboprio = self:MenuKeyBinding("Change your Combo", 84)


	self.harass_q = self:MenuBool("Use Q in Harass", true)
  self.harass_w = self:MenuBool("Use W in Harass", true)
	self.harass_e = self:MenuBool("Use E in Harass", true)


	self.lane_q = self:MenuBool("Use Q to farm", true)
	self.lane_w = self:MenuBool("Use W to farm", true)
	self.lane_e = self:MenuBool("Use E to farm", false)


	self.jungle_q = self:MenuBool("Use Q Jungle", true)
	self.jungle_w = self:MenuBool("Use W Jungle", true)
	self.jungle_e = self:MenuBool("Use E Jungle", false)


	self.use_titanic = self:MenuBool("Use Titanic_Hydra", true)
	self.use_ravenous = self:MenuBool("Use Ravenous_Hydras", true)
	self.use_tiamat = self:MenuBool("UseTiamat", true)
	self.use_youmuu = self:MenuBool("Use Youmuus", true)
	self.FleeKey = self:MenuKeyBinding("Flee Key", 84)
	self.KillstealQ = self:MenuBool("Use Q to killsteal", true)
	self.KillstealW = self:MenuBool("Use W to killsteal", true)
	self.KillstealE = self:MenuBool("Use E to killsteal", true)

	self.Draw_text = self:MenuBool("Draw Text if kilable(all in)", true)
	self.Draw_combomode = self:MenuBool("Draw the Combo Mode", true)
	self.Draw_When_Already = self:MenuBool("Draw When Already", true)
	self.Draw_Q = self:MenuBool("Draw Q Range", true)
	self.Draw_W = self:MenuBool("Draw W Range", true)
	self.Draw_E = self:MenuBool("Draw E Range", true)
	self.Draw_R = self:MenuBool("Draw R Range", true)

	self.Combo = self:MenuKeyBinding("Combo", 32)
	self.Harass = self:MenuKeyBinding("Harass", 67)
	self.Lane_Clear = self:MenuKeyBinding("Lane Clear", 86)
	self.Jungle_Clear = self:MenuKeyBinding("Jungle Clear", 86)
  self.Last_Hit = self:MenuKeyBinding("Last Hit", 88)
	self.CombokeyDown = 0
	self.lastQ = 0
	self.Delay = 0
	self.JustReset = 0
	self.autoattack = 0
	self.justauto = 0
	self.NowuseQ = nil
	self.Qstucks = 0

end

function Riven:OnDrawMenu()
	if Menu_Begin(self.menu) then
		if Menu_Begin("Combo Setting") then
			self.useingite = Menu_Bool("Use Ignite if killable(all in)", self.useingite, self.menu)
			self.useflash = Menu_Bool("Use Flash in Combos", self.useflash, self.menu)
			self.combo_q = Menu_Bool("Use Q in Combo", self.combo_q, self.menu)
			self.combo_w = Menu_Bool("Use W in Combo", self.combo_w, self.menu)
			self.combo_e = Menu_Bool("Use E in Combo", self.combo_e, self.menu)
			self.combo_r = Menu_Bool("Use R if enemy if Killable", self.combo_r, self.menu)
			self.combo_rall = Menu_SliderInt("Open R1 if Enemies Around >=", self.combo_rall, 1, 5, self.menu)
			self.combomode = Menu_ComboBox("Pick your Combo Mode", self.combomode, "Normal\0Werhli\0Shy\0", self.menu)
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
			self.use_titanic = Menu_Bool("Use Titanic_Hydra", self.use_titanic, self.menu)
			self.use_ravenous = Menu_Bool("Use Ravenous_Hydras", self.use_ravenous, self.menu)
			self.use_tiamat = Menu_Bool("UseTiamat", self.use_tiamat, self.menu)
			self.use_youmuu = Menu_Bool("Use Youmuus", self.use_youmuu, self.menu)
			self.FleeKey = Menu_KeyBinding("Flee Key", self.FleeKey, self.menu)
			self.KillstealQ = Menu_Bool("Use Q to killsteal", self.KillstealQ, self.menu)
			self.KillstealW = Menu_Bool("Use W to killsteal", self.KillstealW, self.menu)
			self.KillstealE = Menu_Bool("Use E to killsteal", self.KillstealE, self.menu)
			Menu_End()
		end

		if Menu_Begin("Draw Spell") then
				self.Draw_text = Menu_Bool("Draw Text if kilable(all in)", self.Draw_text, self.menu)
				self.Draw_combomode = Menu_Bool("Draw the Combo Mode", self.Draw_combomode, self.menu)
				self.Draw_When_Already = Menu_Bool("Draw When Already", self.Draw_When_Already, self.menu)
				self.Draw_Q = Menu_Bool("Draw Q Range", self.Draw_Q, self.menu)
				self.Draw_W = Menu_Bool("Draw W Range", self.Draw_W, self.menu)
				self.Draw_E = Menu_Bool("Draw E Range", self.Draw_E, self.menu)
				self.Draw_R = Menu_Bool("Draw R Range", self.Draw_R, self.menu)
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

function Riven:MenuBool(stringKey, bool)
	return ReadIniBoolean(self.menu, stringKey, bool)
end

function Riven:MenuSliderInt(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Riven:MenuSliderFloat(stringKey, valueDefault)
	return ReadIniFloat(self.menu, stringKey, valueDefault)
end

function Riven:MenuComboBox(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Riven:MenuKeyBinding(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Riven:OnTick()
	if myHero.IsDead or IsTyping() or myHero.IsRecall or IsDodging() then return end
 		SetLuaCombo(true)
		SetLuaHarass(true)
		SetLuaLaneClear(true)
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

		if GetKeyPress(self.Combo) > 0		then
			self:RivenCombo()
		end
		if GetKeyPress(self.Harass) > 0		then
			self:RivenHarass()
		end
		if GetKeyPress(self.Jungle_Clear) > 0  then
			self:Rivenjungle()
		end
		if GetKeyPress(self.Lane_Clear) > 0  then
			self:RivenLane()
		end
		if GetKeyPress(self.FleeKey) > 0  then
			self:Rivenforest()
		end
		if GetKeyPress(self.Harass) > 0		then
			self:RivenHarass()	end
		self:KillSteal()


			if GetTimeGame() - self.lastQ  > 0.6 then
				self.lastQ = 0
			end
			if GetTimeGame() - self.lastQ > 0.6 and self.Qstucks == 3 then
				self.Qstucks = 0
			end


end
function Riven:Rivenforest()
	MoveToPos(GetMousePos().x, GetMousePos().z)
	local Target = GetTargetSelector(1500, 0)
	target = GetAIHero(Target)

end
function Riven:OnAfterAttack(unit, target)
	if GetKeyPress(self.Combo) > 0 then
		self.NowuseQ = true
		self.justauto = GetTimeGame()
	end
end

function Riven:OnAnimation(unit, animationName)
    if unit.IsMe then
        if animationName == "Spell1a" then
      		self.lastQ = GetTimeGame()
					self.Qstucks =1
				end
				if animationName == "Spell1b" then
      		self.lastQ = GetTimeGame()
					self.Qstucks =2
				end
				if animationName == "Spell1c" then
      		self.lastQ = GetTimeGame()
					self.Qstucks =3
				end
			end
		end
function Riven:Reset()
			--SetLuaMoveOnly(true)
			--DelayAction(function() MoveToPos(GetMousePos().x, GetMousePos().z) end, 0.1)
			MoveToPos(GetMousePos().x, GetMousePos().z)
			--MoveToPos(target.x, target.z)
			self.JustReset = GetTimeGame()			
	end



function Riven:OnProcessSpell(unit, spell)
	local spellName = spell.Name:lower()
	if unit.IsMe then
	--__PrintTextGame(spell.Name)
	end

	if self.combomode == 2 and GetKeyPress(self.Combo) > 0 then
 	 self:ProcessShy(unit, spell)
  end
 if self.combomode == 1 and GetKeyPress(self.Combo) > 0 then
	 self:ProcessWerhli(unit, spell)
 end
 if self.combomode == 0 and GetKeyPress(self.Combo) > 0 then
	self:ProcessNormal(unit, spell)
 end
	if unit.IsMe and spell.Name:lower():find("attack") then
			self.autoattack = true
			SetLuaMoveOnly(false)
	end
	if  spell.Name == "RivenTriCleave"  then
		self.autoattack = false
		self:Reset()
	end
end

function Riven:ProcessNormal(unit, spell)
	if self.combomode == 0 then
	local Target = GetTargetSelector(1500, 1)
	target = GetAIHero(Target)
	if unit.IsMe then
		if spell.Name == "RivenFeint" then
			if CanCast(_W) and self.combo_w then
				DelayAction(function() self:CastW() end, 0.2)
			end
			if CanCast(_Q) and self.combo_q then
				DelayAction(function() self:CastQ() end, 0.21)
			end
		end
		if  spell.Name == "RivenTriCleave" then
		 __PrintTextGame("QQQQ")
	 end
	 if spell.Name == "ItemTiamatCleave" then
		  __PrintTextGame("tiamat")
			if CanCast(_Q)  and self.combo_q then
				self:CastQ()
			end
		end
		if spell.Name == "RivenMartyr" then
			if CanCast(_Q) and self.combo_q then
				self:CastQ()
				 __PrintTextGame("WWWW")
			end
			 self:UseItems()
			if self.combo_r and self.IsR2() and CanCast(_R) then
				self:CastR2()
			end
		end
		if spell.Name == "RivenFengShuiEngine" then
			if CanCast(_W) and self.combo_w then
				self:CastW()
			end
			if CanCast(_Q) and self.combo_q then
				self:CastQ()
			end
		end
	end
end
end

function Riven:ProcessWerhli(unit, spell)
	if self.combomode == 1 then
	local Target = GetTargetSelector(1500, 1)
	target = GetAIHero(Target)
	if unit.IsMe then
		 if spell.Name == "RivenFeint" then
			 if CanCast(_W)  then
				 DelayAction(function() self:CastW() end, 0.2+ GetPing())
			 end
			 if CanCast(_Q)  then
				 DelayAction(function() self:CastQ() end, 0.24 + GetPing())
			 end
		 end
		 if spell.Name == "RivenMartyr" then
			-- self:UseItems()
			 self:CastQ()
		 end
		 if  spell.Name == "RivenTriCleave" then
 		 	 self:UseItems()
 	 	 end
 	 	 if not CanCast(_Q) and spell.Name == "RivenMartyr" then
 		 	 self:UseItems()
 	 	 end
		end
	end
end

function Riven:ProcessShy(unit, spell)
	if self.combomode == 2 then
	local Target = GetTargetSelector(1500, 1)
	target = GetAIHero(Target)
	if unit.IsMe then
		if spell.Name:lower():find("attack") then
			 self:UseItems()
			 __PrintTextGame("tiamat")
		 end
		 if spell.Name == "RivenFeint" then
			 if CanCast(_R) and self.IsR1() then
			 	CastSpellTarget(myHero.Addr, _R)
			end
		 end
		 if spell.Name == "SummonerFlash" then
			 if CanCast(_W) then
			 	CastSpellTarget(myHero.Addr, _W)
			 end
		 end
		 if  spell.Name == "RivenTriCleave" then
				if CanCast(_R) and self.IsR2() then
					CastSpellToPos(target.x, target.z, _R)
				end
			end
	 end
 end
end

function GetMinionsHit(Pos, radius)
	local count = 0
	for i, minion in pairs(EnemyMinionsTbl()) do
		if GetDistance(minion, Pos) < radius then
			count = count + 1
		end
	end
	return count
end

function Riven:RivenLane()

end

function Riven:Rivenjungle()

end



function Riven:RivenHarass()
end

function Riven:GetELinePreCore(target)
	local castPosX, castPosZ, unitPosX, unitPosZ, hitChance, _aoeTargetsHitCount = GetPredictionCore(target.Addr, 0, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero.x, myHero.z, true, false, 5, 5, 5, 5, 5, 5)
	if target ~= nil then
		 CastPosition = Vector(castPosX, target.y, castPosZ)
		 HitChance = hitChance
		 Position = Vector(unitPosX, target.y, unitPosZ)
		 return CastPosition, HitChance, Position
	end
	return nil , 0 , nil
end

function Riven:GetRconePreCore(target)
	local castPosX, castPosZ, unitPosX, unitPosZ, hitChance, _aoeTargetsHitCount = GetPredictionCore(target.Addr, 2, self.R2.delay, self.R2.width, self.R2.range, self.R2.speed, myHero.x, myHero.z, true, false, 5, 5, 5, 5, 5, 5)
	if target ~= nil then
		 CastPosition = Vector(castPosX, target.y, castPosZ)
		 HitChance = hitChance
		 Position = Vector(unitPosX, target.y, unitPosZ)
		 return CastPosition, HitChance, Position
	end
	return nil , 0 , nil
end

function Riven:IsR1()
	if CanCast(_R) then
        	return GetSpellNameByIndex(myHero.Addr, _R) == "RivenFengShuiEngine"
	end
end

function Riven:IsR2()
	if CanCast(_R) then
        	return GetSpellNameByIndex(myHero.Addr, _R) == "RivenIzunaBlade"
	end
end

function Riven:UseItems()
	local tiamat = GetSpellIndexByName("ItemTiamatCleave")
	if  (self.use_tiamat or self.use_ravenous) and (myHero.HasItem(3077) or myHero.HasItem(3074)) and CanCast(tiamat) then
			CastSpellTarget(myHero.Addr, tiamat)
	local titanic = GetSpellIndexByName("ItemTitanicHydraCleave")
	elseif myHero.HasItem(3748)  and CanCast(titanic) and self.use_titanic then
				CastSpellTarget(myHero.Addr, titanic)
	end
end
function Riven:UseYommous()
	if self.use_youmuu  then
			local yommus = GetSpellIndexByName("YoumusBlade")
			if myHero.HasItem(3142)  and CanCast(yommus) then
				DelayAction(function() CastSpellTarget(myHero.Addr, yommus) end, 0.3)
			end
		end
	end

function GetIgnite()
	if GetSpellIndexByName("SummonerDot") > -1 then
		return GetSpellIndexByName("SummonerDot")
	end
	return -1
end

function Riven:CastIgnite()
	local Target = GetTargetSelector(600, 1)
	targetignite = GetAIHero(Target)
	if  IsValidTarget(targetignite, 600) and not IsDead(targetignite) and GetIgnite() > -1  and TotalDamage(targetignite) >= targetignite.HP then
		 CastSpellTarget(targetignite.Addr, GetIgnite())
	 end
 end

function GetFlash()
		if GetSpellIndexByName("SummonerFlash") > -1 then
			return GetSpellIndexByName("SummonerFlash")
		end
		return -1
	end

	function Riven:CastFlash()
		local Target = GetTargetSelector(1500, 1)
		targetflash = GetAIHero(Target)
		if (GetFlash() > -1 and  CanCast(GetFlash())) then
			CastSpellToPos(targetflash.x, targetflash.z, GetFlash())
		end
	end

function TotalDamage(target)
	local totaldamage = 0
	if CanCast(_Q) then
		totaldamage = totaldamage + 3 * GetDamage("Q", target)
	end
	if CanCast(_W) then
		totaldamage = totaldamage + GetDamage("W", target)
	end
	if CanCast(_E) then
		totaldamage = totaldamage + GetDamage("E", target)
	end
	if CanCast(_R) then
		totaldamage = totaldamage + GetDamage("R", target)
	end
	if GetDistance(target, myHero) < 1000  then
		totaldamage = totaldamage + GetAADamageHitEnemy(target) * 3
	end
	if target.HasBuff("Moredkaiser") then
			totaldamage = totaldamage - target.MP
	end
	if target.HasBuff("BlitzcrankManaBarrierCD") and target.HasBuff("ManaBarrier") then
			totaldamage = totaldamage - target.MP / 2
	end
	if target.HasBuff("GarenW") then
	  	totaldamage = totaldamage * 0.7
	end
	if target.HasBuff("ferocioushowl") then
			totaldamage = totaldamage * 0.7
	end
	if myHero.HasBuff("SummonerExhaust") then
			totaldamage = totaldamage * 0.6
	end
	if GetIgnite() > -1 and CanCast(GetIgnite()) then
		totaldamage = totaldamage +(50 + 20 * myHero.Level)
	end
--	elseif CanCast(self:GetIgnite()) then
	--	totaldamage = 50 + 20 * myHero.Level
	return totaldamage
end

function Riven:CastQ(target)
	local TargetQ = GetTargetSelector(1500, 0)
	targetQ = GetAIHero(TargetQ)
	if  not IsDead(targetQ)  and  GetDistance(targetQ, myHero) < self.Q.range + GetTrueAttackRange() then
		if (self.Qstucks ==1 or self.Qstucks ==2) and self.autoattack and self.NowuseQ and GetTimeGame() - self.lastQ > 0.5 then
				CastSpellTarget(targetQ.Addr, _Q)
				self.autoattack= false
			end
			if (self.Qstucks ==0 or self.Qstucks ==3)  then
				CastSpellTarget(targetQ.Addr, _Q)
				self.autoattack= false
			end
		end
end

function Riven:CastW()
		local TargetW = GetTargetSelector(1500, 0)
		targetW = GetAIHero(TargetW)
		if CanCast(_W)  and not IsDead(targetW) and IsValidTarget(targetW, self.W.range) then
			if self.Qstucks == 0 then
				CastSpellTarget(myHero.Addr, _W)
			end
			if not CanCast(_Q) and self.Qstucks == 0 then
				CastSpellTarget(myHero.Addr, _W)
			end
			if myHero.HasBuff("RivenFeint") then
				CastSpellTarget(myHero.Addr, _W)
			end
		end
	end

function Riven:CastE()
	local TargetE = GetTargetSelector(1500, 0)
	targetE = GetAIHero(TargetE)
	if IsValidTarget(targetE, self.E.range + GetTrueAttackRange())  and GetDistance(target, myHero) > GetTrueAttackRange() then
	 CastSpellToPos(target.x, target.z, _E)
	elseif
	 CanCast(_W) and GetDistance(target, myHero) < 325 + self.W.range - 50 and GetDistance(target, myHero) > GetTrueAttackRange() then
		CastSpellToPos(target.x, target.z, _E)
	elseif
	CanCast(_Q) and not CanCast(_W) and GetDistance(target, myHero) < 325 + self.W.range - 50 and GetDistance(target, myHero) > GetTrueAttackRange() then
	 CastSpellToPos(target.x, target.z, _E)
	end
end

function Riven:CastR1(target)
	local Target = GetTargetSelector(1500, 0)
	target = GetAIHero(Target)
	if 	TotalDamage(target) >= target.HP then
		CastSpellTarget(myHero.Addr, _R)
	end
	if CountEnemyChampAroundObject(myHero.Addr, 900) >= self.combo_rall then
		CastSpellTarget(myHero.Addr, _R)
	end
end

function Riven:CastR2()
	local Target = GetTargetSelector(1500, 0)
	target = GetAIHero(Target)
	local rDmg = GetDamage("R", target)
	local aadmg = GetAADamageHitEnemy(target)
	local Timestart = GetBuffTimeBegin(myHero, "RivenFengShuiEngine")
	local Timeend = GetBuffTimeEnd  (myHero, "RivenFengShuiEngine")
	--__PrintTextGame(Timeend- GetTimeGame())
	if   target.HP / target.MaxHP * 100 < 20 or rDmg > target.HP
	or TotalDamage(target) >= target.HP then
		CastSpellToPos(target.x, target.z, _R)
	end
end

function Riven:RivenCombo(target)
	if self.combomode == 2 then
			self:Shy()
		end
	if self.combomode == 1 then
			self:Werhli()
		end
		if self.combomode == 0 then
				self:Normal()
			end
		end

function Riven:Normal(target)
	local Target = GetTargetSelector(1500, 0)
	target = GetAIHero(Target)

	if IsValidTarget(target, 1500) then
		self:UseYommous()
	end
	if self.useingite then
		self:CastIgnite();
	end
	if CanCast(_R) and self:IsR1() and IsValidTarget(target, 900) and self.combo_r then
		self:CastR1()
	end
	if IsValidTarget(target, self.E.range+150) and self.combo_e and CanCast(_E) and CanMove(myHero) then
		self:CastE()
		if CanCast(_W) and self.combo_w then
			DelayAction(function() self:CastW() end, 0.20 + GetPing())
		end
		if CanCast(_Q) and self.combo_q then
			DelayAction(function() self:CastQ() end, 0.24 + GetPing())
		end
	end
	if self.combo_w and CanCast(_W) and IsValidTarget(target, self.W.range) then
		self:CastW()
	end
	if self.combo_q and CanCast(_Q) and not CanCast(_W) and CanMove(myHero)and IsValidTarget(target, self.Q.range) then
		self:CastQ()
		self:UseItems()
	end
	if CanCast(_R) and self:IsR2() and IsValidTarget(target, self.R2.range)  and self.combo_r then
		self:CastR2()
	end
end

function Riven:Werhli(target)
	local Target = GetTargetSelector(1500, 0)
	target = GetAIHero(Target)
	if IsValidTarget(target, 1500) then
		self:UseYommous()
	end
	if self.useingite then
		self:CastIgnite();
	end
	if self.combo_r and IsValidTarget(target, 1500) and not IsDead(target) and CanCast(_R) and self:IsR1() then
		CastSpellTarget(myHero.Addr, _R)
	end
	if self.useflash and GetFlash() > -1 and  CanCast(GetFlash()) and GetDistance(myHero, target) > 700 then
		if IsValidTarget(target, self.R2.range - 50) then
			if not IsDead(target) and CanCast(_E) then
				CastSpellToPos(target.x, target.z, _E)
				if IsValidTarget(target, self.R2.range) and not IsDead(target) and CanCast(_R) and self:IsR2() then
				CastSpellToPos(target.x, target.z , _R)
				end
				if GetFlash() > -1 and  CanCast(GetFlash()) and GetDistance(myHero, target) > self.E.range then
					DelayAction(function()  self:CastFlash() end, 0.05)
				end
			end
			if  CanCast(_W) and IsValidTarget(target, self.W.range)then
				DelayAction(function()  CastSpellTarget(myHero.Addr, _W) end, 0.10 + GetPing())
			end
			if IsValidTarget(target, self.Q.range) and CanCast(_Q) then
				DelayAction(function()  self:CastQ() end, 0.14 + GetPing())
			end
		end
	end
	if not self.useflash or not CanCast(GetFlash()) or  GetDistance(myHero, target) < 600 then
		if IsValidTarget(target, 425) and CanCast(_E) then
			CastSpellToPos(target.x, target.z, _E)
			if IsValidTarget(target, self.R2.range)  and not IsDead(target) and CanCast(_R) and self:IsR2() then
				DelayAction(function() CastSpellToPos(target.x, target.z , _R) end, 0.1)
			end
		end
		if  CanCast(_W) and IsValidTarget(target, self.W.range)then
			DelayAction(function()  CastSpellTarget(myHero.Addr, _W) end, 0.15)
		end
		if IsValidTarget(target, self.Q.range) and CanCast(_Q) then
			DelayAction(function()  self:CastQ() end, 0.20)
		end
	end
	if self.combo_w and CanCast(_W) and IsValidTarget(target, self.W.range) then
		self:CastW()
	end
	if CanCast(_Q)  and not CanCast(_W) and not IsDead(target) then
				if IsValidTarget(target, self.Q.range) then
					self:UseItems()
					self:CastQ()
				end
			end
end

function Riven:Shy(target)
	local Target = GetTargetSelector(1500, 0)
	target = GetAIHero(Target)
	if IsValidTarget(target, 1500) then
		self:UseYommous()
	end
	if self.useflash then
			if IsValidTarget(target, 800) and not IsDead(target) and CanCast(_E) then
				CastSpellToPos(target.x, target.z, _E)
				if self.combo_r and IsValidTarget(target, 900) and not IsDead(target) and CanCast(_R)  and self:IsR1() then
					CastSpellTarget(myHero.Addr, _R)
				end
			end
			if GetFlash() > -1 and  CanCast(GetFlash()) and IsValidTarget(target, 500) then
				self:CastFlash()
				if  CanCast(_W) then
				   CastSpellTarget(myHero.Addr, _W)
				end
			end
			if IsValidTarget(target, self.R2.range)  and not IsDead(target) and CanCast(_R) and self:IsR2() then
				CastSpellToPos(target.x, target.z , _R)
				if IsValidTarget(target, self.Q.range) and CanCast(_Q) then
					 self:CastQ()
				end
			end
		end
		if not self.useflash or not CanCast(GetFlash()) then
		end
		if IsValidTarget(target, self.Q.range) and CanCast(_Q) and not CanCast(_R) then
			 self:CastQ()
		end


end


function Riven:KillSteal()
	for i, heros in ipairs(GetEnemyHeroes()) do
			if heros ~= nil then
				local target = GetAIHero(heros)
		  	local qDmg = GetDamage("Q", target)
		  	local wDmg = GetDamage("W", target)
				local rDmg = GetDamage("R", target)
			end
		end
	end

	function Riven:OnDraw()
		if self.Draw_combomode then
			local a,b = WorldToScreen(myHero.x, myHero.y, myHero.z)
			if self.combomode == 0 then
				DrawTextD3DX(a, b, "Normal", Lua_ARGB(255, 255, 132, 0))
			elseif self.combomode == 1 then
				DrawTextD3DX(a, b, "Werhli(all in)", Lua_ARGB(255, 0, 255, 10))
		  elseif self.combomode == 2 then
				DrawTextD3DX(a, b, "Shy", Lua_ARGB(255, 132, 0, 10))
			end
		end

		if self.Draw_text then
			for i,hero in pairs(GetEnemyHeroes()) do
				if IsValidTarget(hero, 2000) then
					target = GetAIHero(hero)
					if IsValidTarget(target.Addr, 1500) and TotalDamage(target) > target.HP then
						local a,b = WorldToScreen(target.x, target.y, target.z)
						DrawTextD3DX(a, b, "Killable(All in)", Lua_ARGB(255, 0, 255, 10))
					end
				end
			end
		end
		if self.Draw_When_Already then
			if self.Draw_Q and CanCast(_Q) then
				DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
			end
			if self.Draw_W and CanCast(_W) then
				DrawCircleGame(myHero.x, myHero.y, myHero.z, self.W.range, Lua_ARGB(255,0,0,255))
			end
			if self.Draw_E and CanCast(_E) then
				DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
			end
			if self.Draw_R and CanCast(_R) then
				DrawCircleGame(myHero.x, myHero.y, myHero.z, self.R2.range, Lua_ARGB(255,255,0,0))
			end
		else
			if self.Draw_Q then
				DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
			end
			if self.Draw_W then
					DrawCircleGame(myHero.x, myHero.y, myHero.z, self.W.range, Lua_ARGB(255,0,0,255))
			end
			if self.Draw_E then
				DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
			end
			if self.Draw_R then
				DrawCircleGame(myHero.x, myHero.y, myHero.z, self.R2.range, Lua_ARGB(255,255,0,0))
			end
		end
	end
