IncludeFile("Lib\\TOIR_SDK.lua")
--IncludeFile("Lib\\OrbNew.lua")
--IncludeFile("Lib\\Baseult.lua")

Ezreal = class()

function OnLoad()
	if GetChampName(GetMyChamp()) == "Ezreal" then
		Ezreal:__init()
	end
end
local function PrintChat(msg) --Credits to Shulepong kappa
	return __PrintTextGame("<b><font color=\"#4286f4\">[Diabaths] </font></b> </font><font color=\"#c5eff7\"> " .. msg .. " </font><b><font color=\"#4286f4\"></font></b> </font>")
end
function Ezreal:__init()
	-- VPrediction
	vpred = VPrediction(true)

	--TS
    self.menu_ts = TargetSelector(1750, 0, myHero, true, true, true)


    self.Q = Spell(_Q, 1200) --
    self.W = Spell(_W, 1000) --
    self.E = Spell(_E, 550)  --
    self.R = Spell(_R, 3000) --

    self.Q:SetSkillShot(0.25, 2000, 60, true) --
    self.W:SetSkillShot(0.25, 1600, 80, false) --
    self.E:SetActive()
    self.R:SetSkillShot(1.1, 2000, 160, false) --


	Callback.Add("Tick", function(...) self:OnTick(...) end)
  Callback.Add("Draw", function(...) self:OnDraw(...) end)
	Callback.Add("AfterAttack", function(...) self:OnAfterAttack(...) end)
	Callback.Add("Attack", function(...) self:OnAttack(...) end)
  Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
    self:MenuValueDefault()
		PrintChat("Ezreal Loaded. Good Luck!")
		self.RRange =3000
end

function Ezreal:MenuValueDefault()
	self.menu = "D-Ezreal"
	self.Draw_When_Already = self:MenuBool("Draw When Already", true)
	self.Draw_Q = self:MenuBool("Draw Q Range", true)
	self.Draw_W = self:MenuBool("Draw W Range", true)
	self.Draw_E = self:MenuBool("Draw E Range", true)
	self.Draw_R = self:MenuBool("Draw R Range", true)

	self.combo_q = self:MenuBool("Use Q in Combo", true)
  self.combo_w = self:MenuBool("Use W in Combo", true)
  self.combo_r = self:MenuBool("Use R if Is killable in Combo", true)
  self.ComboRAOEuse = self:MenuBool("Use R if hit 3 Enemys", false)
	self.ComboRCC = self:MenuBool("Use R during CC", true)

	self.harass_q = self:MenuBool("Use Q in Harass", true)
  self.harass_W = self:MenuBool("Use W in Harass", false)
	self.harass_mana= self:MenuSliderInt("Harass  Mana % >", 60)

	self.lane_q = self:MenuBool("Use Q to farm", false)
  self.lane_mana= self:MenuSliderInt("Lane Clear  Mana % >", 60)

	self.jungle_q = self:MenuBool("Use Q Jungle", true)
	self.jungle_mana= self:MenuSliderInt("Jungle Clear  Mana % >", 60)

	self.RMaxRange = self:MenuSliderInt("Set the R Max Range", 3000)
	self.useR = self:MenuKeyBinding("Semi-manual cast R key", 84)
	self.tear = self:MenuBool("Stack Tear", true)
	self.stackQmana = self:MenuSliderInt("Stuck Tear if MP% >", 60)
	self.Wally = self:MenuBool("W on Ally To Push Tower", true)
	self.KillstealQ = self:MenuBool("Use Q to killsteal", true)
	self.KillstealW = self:MenuBool("Use W to killsteal", true)
	self.KillstealR = self:MenuBool("Use R to killsteal", true)
	self.ImmobileQ = self:MenuBool("Use Q in Immobile", true)
	self.ImmobileW = self:MenuBool("Use W in Immobile", true)

	self.Combo = self:MenuKeyBinding("Combo", 32)
	self.Harass = self:MenuKeyBinding("Harass", 67)
	self.Lane_Clear = self:MenuKeyBinding("Lane Clear", 86)
	self.Jungle_Clear = self:MenuKeyBinding("Lane Clear", 86)
  self.Last_Hit = self:MenuKeyBinding("Last Hit", 88)

end

function Ezreal:OnDrawMenu()
	if Menu_Begin(self.menu) then
		if Menu_Begin("Combo Setting") then
			self.combo_q = Menu_Bool("Use Q in Combo", self.combo_q, self.menu)
			self.combo_w = Menu_Bool("Use W in Combo", self.combo_w, self.menu)
			self.combo_r = Menu_Bool("Use R if Is killable in Combo", self.combo_r, self.menu)
			self.ComboRAOEuse = Menu_Bool("Use R if hit 3 Enemys", self.ComboRAOEuse, self.menu)
			self.ComboRCC = Menu_Bool("Use R during CC", self.ComboRCC, self.menu)
			Menu_End()
		end
		if Menu_Begin("Harass Setting") then
			self.harass_q = Menu_Bool("Use Q in Harass", self.harass_q, self.menu)
			self.harass_w = Menu_Bool("Use W in Harass", self.harass_w, self.menu)
			self.harass_mana = Menu_SliderInt("Harass  Mana % >", self.harass_mana, 1, 100, self.menu)
			Menu_End()
		end
		if Menu_Begin("Lane Clear Setting") then
			self.lane_q = Menu_Bool("Use Q to farm", self.lane_q, self.menu)
			self.lane_mana = Menu_SliderInt("Lane Clear  Mana % >", self.lane_mana, 1, 100, self.menu)
			Menu_End()
		end
		if Menu_Begin("Jungle Clear Setting") then
			self.jungle_q = Menu_Bool("Use Q Jungle", self.jungle_q, self.menu)
			self.jungle_mana = Menu_SliderInt("Jungle Clear  Mana % >", self.jungle_mana, 1, 100, self.menu)
			Menu_End()
		end
		if Menu_Begin("Misc Setting") then
			self.RMaxRange = Menu_SliderInt("Set the R Max Range", self.RMaxRange, 2500, 6000, self.menu)
			self.useR = Menu_KeyBinding("Semi-manual cast R key", self.useR, self.menu)
			self.tear = Menu_Bool("Stack Tear", self.tear, self.menu)
			self.stackQmana = Menu_SliderInt("Stack Tear if MP %", self.stackQmana, 0, 100, self.menu)
			self.Wally = Menu_Bool("W on Ally To Push Tower", self.Wally, self.menu)
			self.KillstealQ = Menu_Bool("Use Q to killsteal", self.KillstealQ, self.menu)
			self.KillstealW = Menu_Bool("Use W to killsteal", self.KillstealW, self.menu)
			self.KillstealR = Menu_Bool("Use R to killsteal", self.KillstealR, self.menu)
			self.ImmobileQ = Menu_Bool("Use Q in Immobile", self.ImmobileQ, self.menu)
			self.ImmobileW = Menu_Bool("Use W in Immobile", self.ImmobileW, self.menu)
			Menu_End()
		end
		if Menu_Begin("Draw Spell") then
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

function Ezreal:MenuBool(stringKey, bool)
	return ReadIniBoolean(self.menu, stringKey, bool)
end

function Ezreal:MenuSliderInt(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Ezreal:MenuSliderFloat(stringKey, valueDefault)
	return ReadIniFloat(self.menu, stringKey, valueDefault)
end

function Ezreal:MenuComboBox(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Ezreal:MenuKeyBinding(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Ezreal:OnTick()
	if myHero.IsDead or IsTyping() or myHero.IsRecall or IsDodging() then return end
 		SetLuaCombo(true)
		SetLuaHarass(true)
		SetLuaLaneClear(true)

		self.R.range = self.RMaxRange
		for i, heros in ipairs(GetEnemyHeroes()) do
				if heros ~= nil  and CanCast(_R) then
						local target = GetAIHero(heros)
								if GetKeyPress(self.useR) > 0 and IsValidTarget(target.Addr, self.R.range - 150) and CountEnemyChampAroundObject(myHero.Addr, 800) == 0 then
										local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.R.delay, self.R.width, self.R.range, self.R.speed, myHero, false)
												if HitChance >= 2 then
													CastSpellToPos(CastPosition.x, CastPosition.z, _R)  end
								 end
				 end
		end

		if GetKeyPress(self.Combo) > 0		then
			self:EzrealCombo()	end

		if GetKeyPress(self.Harass) > 0		then
			self:EzrealHarass()	end

	  if   GetKeyPress(self.Combo) > 0 or  GetKeyPress(self.Harass) > 0 or  GetKeyPress(self.Lane_Clear) > 0 or  GetKeyPress(self.Jungle_Clear) > 0  then  return
	 	else self:StuckTear()  	end

		self:OnImmobile()
		self:KillSteal()

end
function Ezreal:EnemyMinionsTbl()
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
function Ezreal:OnAttack(unit, target)
	if GetKeyPress(self.Lane_Clear) > 0  then
	local orbTarget = GetTargetOrb()
		if orbTarget ~= nil and GetType(orbTarget) == 1 then
			for i, minions in ipairs(self:EnemyMinionsTbl()) do
				if minions ~= nil then
					local minion = GetUnit(minions)
					if CanCast(_Q) and self.lane_q and myHero.MP / myHero.MaxMP * 100 > self.lane_mana and IsValidTarget(minion.Addr, self.Q.range) and minion.NetworkId ~= GetIndex(orbTarget) then
						local delay = GetDistance(orbTarget) / self.Q.speed + self.Q.delay
						local minionHP = GetHealthPred(minion.Addr, delay, 0.07)
						local qdmg = GetDamage("Q", minion)
						local aadmg = GetAADamageHitEnemy(minion)
						local Collision = CountObjectCollision(0, minion.Addr, myHero.x, myHero.z, minion.x, minion.z, self.Q.width, self.Q.range, 65)
						if  minionHP > 0 and Collision == 0 and (qdmg >= minionHP or  aadmg >= minionHP or qdmg + aadmg >= minionHP ) then
									CastSpellToPos(minion.x, minion.z, _Q)
						end
					end
				end
			end
		end
	end
	if GetKeyPress(self.Jungle_Clear) > 0  then
		if CanCast(_Q) and (GetType(GetTargetOrb()) == 3) and self.jungle_q and myHero.MP / myHero.MaxMP * 100 > self.jungle_mana then
			if (GetObjName(GetTargetOrb()) ~= "PlantSatchel" and GetObjName(GetTargetOrb()) ~= "PlantHealth" and GetObjName(GetTargetOrb()) ~= "PlantVision") then
				target = GetUnit(GetTargetOrb())
		    	local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, true)
				CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
			end
		end
	end
end
function Ezreal:OnAfterAttack(unit, target)
	local myHeroPos = Vector(myHero.x, myHero.y, myHero.z)
	if self:IsUnderTurretEnemy(myHeroPos) and CanCast(_W) and self.Wally  and self.CountEnemiesInRange(myHeroPos, 1000) < 1 then
		for i,hero in pairs(GetAllyHeroes()) do
		 if hero ~= nil then
			 ally = GetAIHero(hero)
			 if  GetDistance(ally.Addr) < 600 and not ally.IsMe and not ally.IsDead then
				 CastSpellToPos(ally.x, ally.z, _W)
			 end
		 end
	 end
	 end
end

function Ezreal:EzrealHarass()
	if myHero.MP / myHero.MaxMP * 100 > self.harass_mana  then
			local TargetQ = GetTargetSelector(self.Q.range - 50, 1)
			if CanCast(_Q) and TargetQ ~= 0 and self.harass_q then
				target = GetAIHero(TargetQ)
				local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, true)
				local distance = VPGetLineCastPosition(target.Addr, self.Q.delay, self.Q.speed)
							if HitChance >= 2 and not GetCollision(target.Addr, self.Q.width, self.Q.range, distance, 1) then
							CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
						end
				end
				local TargetW = GetTargetSelector(self.W.range - 50, 1)
				if CanCast(_W) and TargetW ~= 0 and self.harass_w then
					target = GetAIHero(TargetW)
					local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.W.delay, self.W.width, self.W.range, self.W.speed, myHero, false)
								if HitChance >= 2 then
								CastSpellToPos(CastPosition.x, CastPosition.z, _W)
							 end
					end
		  end
end

function Ezreal:CanMove(unit)
	if (CountBuffByType(unit.Addr, 5) == 1 or CountBuffByType(unit.Addr, 21) == 1 or CountBuffByType(unit.Addr, 11) == 1 or CountBuffByType(unit.Addr, 29) == 1 or
		unit.HasBuff("recall") or CountBuffByType(unit.Addr, 30) == 1 or CountBuffByType(unit.Addr, 22) == 1 or CountBuffByType(unit.Addr, 8) == 1 or CountBuffByType(unit.Addr, 24) == 1
		or CountBuffByType(unit.Addr, 20) == 1 or CountBuffByType(unit.Addr, 18) == 1) then
		return false
	end
	return true
end

function Ezreal:EzrealCombo()
	local TargetQ = GetTargetSelector(self.Q.range - 50, 1)
			if CanCast(_Q) and TargetQ ~= 0 and self.combo_q then
				target = GetAIHero(TargetQ)
				local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, true)
				local distance = VPGetLineCastPosition(target.Addr, self.Q.delay, self.Q.speed)
				    	if HitChance >= 2 and not GetCollision(target.Addr, self.Q.width, self.Q.range, distance, 1) then
		        	CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
		        end
    		end
			local TargetW = GetTargetSelector(self.W.range - 50, 1)
			if CanCast(_W) and TargetW ~= 0 and self.combo_w then
				target = GetAIHero(TargetW)
				local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.W.delay, self.W.width, self.W.range, self.W.speed, myHero, false)
				    	if HitChance >= 2 then
			       	CastSpellToPos(CastPosition.x, CastPosition.z, _W)
			       end
	   		end
			for i, heros in ipairs(GetEnemyHeroes()) do
					if heros ~= nil  and CanCast(_R) then
							local target = GetAIHero(heros)
							local rDmg = GetDamage("R", target)
									if self.combo_r and rDmg * 0.8 > target.HP and IsValidTarget(target.Addr, self.R.range - 150) and CountEnemyChampAroundObject(myHero.Addr, 800) == 0 then
			  							local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.R.delay, self.R.width, self.R.range, self.R.speed, myHero, false)
										    	if HitChance >= 2 then
									       		CastSpellToPos(CastPosition.x, CastPosition.z, _R)  end
									 end
									 if self.ComboRAOEuse and IsValidTarget(target.Addr, self.R.range - 150) and CountEnemyChampAroundObject(myHero.Addr, 800) == 0 then
										 	local CastPosition, HitChance, Position = vpred:GetLineAOECastPosition(target, self.R.delay, self.R.width, self.R.range, self.R.speed, myHero, false)
													if HitChance >= 2 then
														CastSpellToPos(CastPosition.x, CastPosition.z, _R) end
									 end
									 if self.ComboRCC and IsValidTarget(target.Addr, self.R.range - 150) and CountEnemyChampAroundObject(myHero.Addr, 800) == 0 then
										 			if self:IsImmobileTarget(target) then
														CastSpellToPos(target.x, target.z, _R) end
									 end
					 end
			end
end
function Ezreal:StuckTear()
	pos = Vector(myHero):Extended(GetMousePos(), 100)
	if CanCast(Q) and self.tear  and myHero.MP / myHero.MaxMP * 100 > self.stackQmana  and (GetItemByID(3070) > 0 or GetItemByID(3004) > 0 or GetItemByID(3003) > 0) and CountEnemyChampAroundObject(myHero.Addr, 2000) == 0   then
			CastSpellToPos(pos.x, pos.z, _Q)
		end
end

function Ezreal:OnImmobile()
	local enemy = self.menu_ts:GetTarget(self.Q.range)
				if CanCast(Q)  and IsValidTarget(enemy, self.Q.range) then
						if  self:IsImmobileTarget(enemy) and self.ImmobileQ then
							local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, true)
    					local distance = VPGetLineCastPosition(target.Addr, self.Q.delay, self.Q.speed)
							if not GetCollision(target.Addr, self.Q.width, self.Q.range, distance, 1) then
	    					CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
							end
						end
			 end
			 if CanCast(W)  and IsValidTarget(enemy, self.W.range) then
				 local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.W.delay, self.W.width, self.W.range, self.W.speed, myHero, true)
				 			 if  self:IsImmobileTarget(enemy) and self.ImmobileW then
						 	 CastSpellToPos(CastPosition.x, CastPosition.z, _W)
					 end
			end
end

function Ezreal:KillSteal()
	for i, heros in ipairs(GetEnemyHeroes()) do
			if heros ~= nil then
				local target = GetAIHero(heros)
		  	local qDmg = GetDamage("Q", target)
		  	local wDmg = GetDamage("W", target)
				local rDmg = GetDamage("R", target)
  	    	if CanCast(_Q) and target ~= 0 and IsValidTarget(target, self.Q.range) and self.KillstealQ then
		      local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, true)
		 	       if HitChance >= 2 and qDmg > target.HP then
			          CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
						 end
	 	      end
		    	if CanCast(_W) and target ~= 0 and IsValidTarget(target, self.W.range) and self.KillstealW then
			     local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.W.delay, self.W.width, self.W.range, self.W.speed, myHero, false)
			       if HitChance >= 2 and wDmg > target.HP then
				        CastSpellToPos(CastPosition.x, CastPosition.z, _W)
			      end
			   end
				 if self.KillstealR and rDmg * 0.8 > target.HP and IsValidTarget(target.Addr, self.R.range - 150) and CountEnemyChampAroundObject(myHero.Addr, 800) == 0 then
						local CastPosition, HitChance, Position = vpred:GetLineCastPosition(target, self.R.delay, self.R.width, self.R.range, self.R.speed, myHero, false)
							if HitChance >= 2 then
											CastSpellToPos(CastPosition.x, CastPosition.z, _R)
						end
				 end
			end
	end
end


function Ezreal:IsImmobileTarget(unit)
	if (CountBuffByType(unit, 5) == 1 or CountBuffByType(unit, 11) == 1 or CountBuffByType(unit, 29) == 1 or CountBuffByType(unit, 24) == 1 or CountBuffByType(unit, 10) == 1 or CountBuffByType(unit, 29) == 1) then
		return true
	end
	return false
end

function Ezreal:OnDraw()
	for i,hero in pairs(GetEnemyHeroes()) do
		if IsValidTarget(hero, 2000) then
			target = GetAIHero(hero)
			if IsValidTarget(target.Addr, self.R.range) and GetDamage("R", target) > target.HP then
				local a,b = WorldToScreen(target.x, target.y, target.z)
				DrawTextD3DX(a, b, "CAN KILL by R", Lua_ARGB(255, 0, 255, 10))
			end
		end
	end

	if self.menu_Draw_Already then
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

function Ezreal:IsUnderTurretEnemy(pos)			--Will Only work near myHero
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

function Ezreal:IsUnderAllyTurret(pos)
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

function Ezreal:CountEnemiesInRange(pos, range)
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
