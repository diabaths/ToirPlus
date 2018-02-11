IncludeFile("Lib\\TOIR_SDK.lua")
--IncludeFile("Lib\\OrbNew.lua")
--IncludeFile("Lib\\Baseult.lua")

Orianna = class()

function OnLoad()
	if GetChampName(GetMyChamp()) == "Orianna" then
		Orianna:__init()
	end
end
local function PrintChat(msg) --Credits to Shulepong kappa
	return __PrintTextGame("<b><font color=\"#4286f4\">[Diabaths] </font></b> </font><font color=\"#c5eff7\"> " .. msg .. " </font><b><font color=\"#4286f4\"></font></b> </font>")
end
function Orianna:__init()
	self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	-- VPrediction
	vpred = VPrediction(true)

	--TS
    self.menu_ts = TargetSelector(1750, 0, myHero, true, true, true)

    self.Q = Spell(_Q, 900) --
    self.W = Spell(_W, 225) --
    self.E = Spell(_E, 1095)  --
    self.R = Spell(_R, 380) --

    self.Q:SetSkillShot(0, 1200, 140, false) --
    self.W:SetSkillShot(0.25, math.huge, 255, false) --
    self.E:SetSkillShot(0.25, 1700, 80, false)
    self.R:SetSkillShot(0.6, math.huge, 380, false) --


		Callback.Add("Tick", function(...) self:OnTick(...) end)
  	Callback.Add("Draw", function(...) self:OnDraw(...) end)
		Callback.Add("CreateObject", function(...) self:OnCreateObject(...) end)
  	Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
		Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
		self:MenuValueDefault()
		PrintChat("Orianna Loaded. Good Luck!")
		self.rotateRadius = 0
		self.innerRadius = 0
 		self.outterRadius = 0
		self.Missile = nil
		self.BallPos = myHero
		self.BallMoving = false
		self.InitiatorsList =
			{
				["MaokaiUnstableGrowth"] = true,
				["NautilusAnchorDrag"] = true,
				["RekSai"] = true,
				["ShenE"] = true,
				["QuinnE"] = true,
				["LeonaZenithBlade"] = true,
				["HecarimUlt"] = true,
				["GragasE"] = true,
				["KledE"] = true,
				["KledR"] = true,
				["IvernQ"] = true,
				["EkkoE"] = true,
				["CamilleE"] = true,
				["AkaliShadowDance"] = true,
			  ["ViQ"] = true,
			  ["ViR"] = true,
			  ["Landslide"] = true,
			  ["NocturneParanoia"] = true,
			  ["ZacE"] = true,
			  ["MonkeyKingNimbus"] = true,
			  ["MonkeyKingSpinToWin"] = true,
			  ["SummonerFlash"] = true,
			  ["ShyvanaTransformCast"] = true,
			  ["threshqleap"] = true,
			  ["AatroxQ"] = true,
			  ["RenektonSliceAndDice"] = true,
			  ["KennenLightningRush"] = true,
			  ["SummonerFlash"] = true,
			  ["OlafRagnarok"] = true,
			  ["UdyrBearStance"] = true,
			  ["VolibearQ"] = true,
			  ["TalonCutthroat"] = true,
			  ["JarvanIVDragonStrike"] = true,
			  ["InfiniteDuress"] = true,
			  ["Jax"] = true,
			  ["JaxLeapStrike"] = true,
			  ["DianaTeleport"] = true,
			  ["BlindMonkQTwo"] = true,
			  ["ShenShadowDash"] = true,
			  ["Headbutt"] = true,
			  ["BandageToss"] = true,
			  ["UrgotSwap2"] = true,
			  ["RengarR"] = true,
			}
			self.Interruplist =
	{
		["KatarinaR"] = true,
		["AlZaharNetherGrasp"] = true,
		["TwistedFateR"] = true,
		["VelkozR"] = true,
		["InfiniteDuress"] = true,
		["JhinR"] = true,
		["CaitlynAceintheHole"] = true,
		["UrgotSwap2"] = true,
		["LucianR"] = true,
		["GalioIdolOfDurand"] = true,
		["MissFortuneBulletTime"] = true,
		["XerathLocusPulse"] = true,
	}

end

function Orianna:MenuValueDefault()
	self.menu = "D-Orianna"
	self.useingite = self:MenuBool("Use Ignite if killable(all in)", true)
	self.combo_q = self:MenuBool("Use Q in Combo", true)
  self.combo_w = self:MenuBool("Use W in Combo", true)
	self.combo_e = self:MenuBool("Use E in Combo", true)
	self.combo_rall = self:MenuBool("Use R if enemy if Killable", true)
	self.combo_r = self:MenuSliderInt("Use Auto R if Hit X enemies", 3)


	self.harass_q = self:MenuBool("Use Q in Harass", true)
  self.harass_W = self:MenuBool("Use W in Harass", false)
	self.Ignoreharassmana = self:MenuBool("Ignore Mana if Have Blue Buff", true)
	self.harass_mana= self:MenuSliderInt("Harass  Mana % >", 60)

	self.lane_q = self:MenuBool("Use Q to farm", true)
	self.lane_q_minion = self:MenuSliderInt("Use Q if minion is killable and and hit >=", 3)
	self.lane_w = self:MenuBool("Use W to farm", true)
	self.lane_w_minion = self:MenuSliderInt("Use W if minion is killable and and hit >=", 3)
	--self.lane_e = self:MenuBool("Use E to farm", false)
	--self.lane_e_minion = self:MenuSliderInt("Use E if minion is killable and and hit >=", 3)
	self.Ignorelanemana = self:MenuBool("Ignore Mana if Have Blue Buff", true)
  self.lane_mana= self:MenuSliderInt("Lane Clear  Mana % >", 60)

	self.jungle_q = self:MenuBool("Use Q Jungle", true)
	self.jungle_w = self:MenuBool("Use W Jungle", true)
	self.jungle_e = self:MenuBool("Use E Jungle", false)
	self.Ignorejunglemana = self:MenuBool("Ignore Mana if Have Blue Buff", true)
	self.jungle_mana= self:MenuSliderInt("Jungle Clear  Mana % >", 60)

	self.InitiatorsE =  self:MenuBool("Use Auto E Initiators", true)
	self.InitiatorsEmode = self:MenuComboBox("Use Auto E Initiators", 0)
	self.AutoER = self:MenuSliderInt("Use R on ally if Ally potision hit Enemies >= ", 2)
	self.Interrupt =  self:MenuBool("Use R to  Interrupt", true)
	self.Interruptmode = self:MenuComboBox("Use R to Interrupt", 0)
	self.FleeKey = self:MenuKeyBinding("Flee Key", 84)
	self.KillstealQ = self:MenuBool("Use Q to killsteal", true)
	self.KillstealW = self:MenuBool("Use W to killsteal", true)
	self.KillstealE = self:MenuBool("Use E to killsteal", true)

	self.Draw_text = self:MenuBool("Draw Text if kilable(all in)", true)
	self.Draw_ball = self:MenuBool("Draw Ball Position", true)
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


end

function Orianna:OnDrawMenu()
	if Menu_Begin(self.menu) then
		if Menu_Begin("Combo Setting") then
			self.useingite = Menu_Bool("Use Ignite if killable(all in)", self.useingite, self.menu)
			self.combo_q = Menu_Bool("Use Q in Combo", self.combo_q, self.menu)
			self.combo_w = Menu_Bool("Use W in Combo", self.combo_w, self.menu)
			self.combo_e = Menu_Bool("Use E in Combo", self.combo_e, self.menu)
			self.combo_rall = Menu_Bool("Use R if enemy if Killable", self.combo_rall, self.menu)
			self.combo_r = Menu_SliderInt("Use Auto R if Hit X enemies", self.combo_r, 1, 5, self.menu)
			Menu_End()
		end

		if Menu_Begin("Harass Setting") then
			self.harass_q = Menu_Bool("Use Q in Harass", self.harass_q, self.menu)
			self.harass_w = Menu_Bool("Use W in Harass", self.harass_w, self.menu)
			self.Ignoreharassmana = Menu_Bool("Ignore Mana if Have Blue Buff", self.Ignoreharassmana, self.menu)
			self.harass_mana = Menu_SliderInt("Harass  Mana % >", self.harass_mana, 1, 100, self.menu)
			Menu_End()
		end

		if Menu_Begin("Lane Clear Setting") then
			self.lane_q = Menu_Bool("Use Q to farm", self.lane_q, self.menu)
			self.lane_q_minion = Menu_SliderInt("Use Q if minion is killable and and hit >=", self.lane_q_minion, 1, 6, self.menu)
			self.lane_w = Menu_Bool("Use W to farm", self.lane_w, self.menu)
			self.lane_w_minion = Menu_SliderInt("Use W if minion is killable and and hit >=", self.lane_w_minion, 1, 6, self.menu)
			--self.lane_e = Menu_Bool("Use E to farm", self.lane_e, self.menu)
			--self.lane_e_minion = Menu_SliderInt("Use E if minion is killable and and hit >=", self.lane_e_minion, 1, 6, self.menu)
			self.Ignorelanemana = Menu_Bool("Ignore Mana if Have Blue Buff", self.Ignorelanemana, self.menu)
			self.lane_mana = Menu_SliderInt("Lane Clear  Mana % >", self.lane_mana, 1, 100, self.menu)
			Menu_End()
		end

		if Menu_Begin("Jungle Clear Setting") then
			self.jungle_q = Menu_Bool("Use Q Jungle", self.jungle_q, self.menu)
			self.jungle_w = Menu_Bool("Use W Jungle", self.jungle_w, self.menu)
			self.jungle_e = Menu_Bool("Use E Jungle", self.jungle_e, self.menu)
			self.Ignorejunglemana = Menu_Bool("Ignore Mana if Have Blue Buff", self.Ignorejunglemana, self.menu)
			self.jungle_mana = Menu_SliderInt("Jungle Clear  Mana % >", self.jungle_mana, 1, 100, self.menu)
			Menu_End()
		end

		if Menu_Begin("Misc Setting") then
			self.InitiatorsE = Menu_Bool("Use Auto E Initiators", self.InitiatorsE, self.menu)
			self.InitiatorsEmode = Menu_ComboBox("Use Auto E Initiators", self.InitiatorsEmode, "In Combo\0Always\0\0", self.menu)
			self.AutoER = Menu_SliderInt("Use R on ally if Ally potision hit Enemies >=", self.AutoER, 1, 5, self.menu)
			self.Interrupt =  Menu_Bool("Use R to  Interrupt", self.Interrupt, self.menu)
			self.Interruptmode = Menu_ComboBox("Use R to Interrupt", self.Interruptmode, "In Combo\0Always\0\0", self.menu)
			self.FleeKey = Menu_KeyBinding("Flee Key", self.FleeKey, self.menu)
			self.KillstealQ = Menu_Bool("Use Q to killsteal", self.KillstealQ, self.menu)
			self.KillstealW = Menu_Bool("Use W to killsteal", self.KillstealW, self.menu)
			self.KillstealE = Menu_Bool("Use E to killsteal", self.KillstealE, self.menu)
			Menu_End()
		end

		if Menu_Begin("Draw Spell") then
				self.Draw_text = Menu_Bool("Draw Text if kilable(all in)", self.Draw_text, self.menu)
				self.Draw_ball = Menu_Bool("Draw Ball Position", self.Draw_ball, self.menu)
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

function Orianna:MenuBool(stringKey, bool)
	return ReadIniBoolean(self.menu, stringKey, bool)
end

function Orianna:MenuSliderInt(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Orianna:MenuSliderFloat(stringKey, valueDefault)
	return ReadIniFloat(self.menu, stringKey, valueDefault)
end

function Orianna:MenuComboBox(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Orianna:MenuKeyBinding(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Orianna:OnTick()
	if myHero.IsDead or IsTyping() or myHero.IsRecall or IsDodging() then return end
 		SetLuaCombo(true)
		SetLuaHarass(true)
		SetLuaLaneClear(true)

		if myHero.HasBuff("orianaghostself") or myHero.HasBuff("orianaghost")  then
			self.BallPos = myHero
			self.BallMoving = false
		end
		for i, heros in ipairs(GetAllyHeroes()) do
		if heros ~= nil then
			local target = GetAIHero(heros)
			if not target.IsMe and target.HasBuff("orianaghostself") or target.HasBuff("orianaghost") then
				self.BallPos = target
				self.BallMoving = false
			end
		end
	end
		if GetKeyPress(self.Combo) > 0		then
			self:OriannaCombo()
		end
		if GetKeyPress(self.Harass) > 0		then
			self:OriannaHarass()
		end
		if GetKeyPress(self.Jungle_Clear) > 0  then
			self:Oriannajungle()
		end
		if GetKeyPress(self.Lane_Clear) > 0  then
			self:OriannaLane()
		end
		if GetKeyPress(self.FleeKey) > 0  then
			self:Oriannaforest()
		end
		if GetKeyPress(self.Harass) > 0		then
			self:OriannaHarass()	end
		self:KillSteal()
		 -- self.rotateRadius = (self.rotateRadius + 2 /* 2 is speed of the spin , change it to 1 for slower and 3 for faster */) % 360;
		 self.rotateRadius = (self.rotateRadius + 2) % 360

end
function Orianna:Oriannaforest()
	MoveToPos(GetMousePos().x, GetMousePos().z)
	local Target = GetTargetSelector(1500, 0)
	target = GetAIHero(Target)
	if not self.BallMoving then
		if  CanCast(_Q) and IsValidTarget(targetQ, self.Q.range + self.Q.width) then
			local CastPosition, HitChance, Position = self:GetQLinePreCore(targetQ)
			if HitChance >= 6  then
					CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
				end
			end
		if CanCast(_E) and not myHero.HasBuff("orianaghostself") then
				CastSpellTarget(myHero.Addr, _E)
			end
		if CanCast(_W) and myHero.HasBuff("orianaghostself") then
			CastSpellToPos(self.BallPos.x, self.BallPos.z, _W)
		end
	end
end

function Orianna:OnProcessSpell(unit, spell)
	local spellName = spell.Name:lower()
	--if IsValidTarget(unit.Addr, 1500) then
	--if  unit.IsEnemy then
		--	if spell.Name:lower():find("attack") and spell.TargetId == 0  then
			--	__PrintTextGame("AAA")
			--local wPos = Vector(myHero) + (Vector(unit) - Vector(myHero)):Normalized() * self.W.range
			--	CastSpellTarget(myHero.Addr, _E)
			--end
	--end
	--end
	if myHero then
		--__PrintTextGame(spell.Name)
	end
	if unit.IsMe and  (spellName == "orianaizunacommand") then--Q
		self.BallMoving = true
    DelayAction(function(p) self.BallPos = Vector(p) end, GetDistance(spell.endPos, BallPos) / self.Q.speed - GetLatency()/1000 - 0.35, {Vector(spell.endPos)})
	end
	if unit.IsMe and (spellName =="orianaredactcommand") then--E
		self.BallMoving = true
		--self.BallPos = spell.target
	end
	if  self.InitiatorsE then
		if IsValidTarget(unit, self.E.range) and not self.BallMoving and CanCast(_E) then
			 if  self.InitiatorsList[spell.Name] ~= nil and IsAlly(unit.Addr) then
				 if  self.InitiatorsEmode == 0 and GetKeyPress(self.Combo) > 0 then
				 		CastSpellTarget(unit.Addr, _E)
					end
					if  self.InitiatorsEmode == 1  then
					CastSpellTarget(unit.Addr, _E)
					 end
			 end
		end
	end
	if  self.Interrupt then
		if IsValidTarget(unit, self.Q.range) and GetDistance(unit, self.BallPos) < self.R.width  and not self.BallMoving and CanCast(_R) then
			 if  self.Interruplist[spell.Name] ~= nil and unit.IsEnemy then
				 if  self.Interruptmode == 0 and GetKeyPress(self.Combo) > 0 then
				 		CastSpellTarget(myHero.Addr, _R)
					end
					if  self.Interruptmode == 1  then
					CastSpellTarget(myHero.Addr, _R)
					 end
			 end
		end
	end
end

function  Orianna:OnCreateObject(obj)
	local name = GetObjName(obj.Addr)
	local missile = GetMissile(obj.Addr)
	if name == "Orianna_Base_Q_yomu_ring_green.troy" then
		self.BallPos = obj
		self.BallMoving = false
	end
	if name == "Orianna_Base_Z_Ball_Flash.troy" then
		self.BallPos =myHero
		self.BallMoving = false
	end
	if name == "Orianna_Base_Q_BallIndicatorNear.troy" or name == "Orianna_Base_W_Dissonance_ball_green.troy" then
		self.BallMoving = false
	end
	if name == "TheDoomBall" then
		self.BallPos =obj
		self.BallMoving = true
	end
end
local function GetDistanceSqr(p1, p2)
    p2 = GetOrigin(p2) or GetOrigin(myHero)
    return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
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
local function CountEnemiesInRange(pos, range)
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
function GetMinionsHit(Pos, radius)
	local count = 0
	for i, minion in pairs(EnemyMinionsTbl()) do
		if GetDistance(minion, Pos) < radius then
			count = count + 1
		end
	end
	return count
end

function Orianna:OriannaLane()
if myHero.MP / myHero.MaxMP * 100 < self.lane_mana and (not myHero.HasBuff("crestoftheancientgolem") or(myHero.HasBuff("crestoftheancientgolem") and not self.Ignorelanemana))then return end
	if CanCast(_Q) and not self.BallMoving and self.lane_q then
		local MaxHit = 0
		local MaxPos = 0
		if self.lane_w and CanCast(_W) then
			for i, minion in pairs(EnemyMinionsTbl()) do
				if IsValidTarget(minion, self.Q.range) then
					local MinionPos = vpred:GetPredictedPos(minion, self.Q.delay, self.Q.speed, self.BallPos)
					local Hit = GetMinionsHit(minion, self.W.width)
					local minionHP = GetHealthPred(minion.Addr, delay, 0.07)
					local qdmg = GetDamage("Q", minion)
					local wdmg = GetDamage("W", minion)
					if Hit >= self.lane_q_minion or minionHP < qdmg + wdmg or (minionHP <= qdmg and GetDistance(minion, myHero) > GetTrueAttackRange()) then
						MaxHit = Hit
						MaxPos = MinionPos
					end
				end
			end
			if MaxHit > 0 and MaxPos then
				CastSpellToPos(MaxPos.x, MaxPos.z, _Q)
			end
		else
		for i, minion in pairs(EnemyMinionsTbl()) do
			local minionHP = GetHealthPred(minion.Addr, delay, 0.07)
			local qdmg = GetDamage("Q", minion)
			local Hit = GetMinionsHit(minion, self.Q.width)
			if (minionHP < qdmg   and Hit >= self.lane_q_minion) or (minionHP <= qdmg and GetDistance(minion, myHero) > GetTrueAttackRange()) then
				local MinionPos = vpred:GetPredictedPos(minion,self.Q.delay, self.Q.speed, self.BallPos)
				CastSpellToPos(MinionPos.x, MinionPos.z, _Q)
				break
			end
		end
	end
end
if self.lane_w and CanCast(_W) then
	for i, minion in pairs(EnemyMinionsTbl()) do
		local minionHP = GetHealthPred(minion.Addr, delay, 0.07)
		local wdmg = GetDamage("W", minion)
		local Hit = GetMinionsHit(self.BallPos, self.W.width)
		if  GetDistance(minion, self.BallPos) < self.W.width then
			if  (minionHP  < wdmg   and Hit >= self.lane_w_minion)  or (minionHP <= wdmg and GetDistance(minion, myHero) > GetTrueAttackRange())then
				CastSpellToPos(self.BallPos.x, self.BallPos.z, _W)
			end
		end
		end
	end
end
function Orianna:Oriannajungle()
	if myHero.MP / myHero.MaxMP * 100 < self.jungle_mana and (not myHero.HasBuff("crestoftheancientgolem") or(myHero.HasBuff("crestoftheancientgolem") and not self.Ignorejunglemana))then return end
	if (GetType(GetTargetOrb()) == 3) and (GetObjName(GetTargetOrb()) ~= "PlantSatchel" and GetObjName(GetTargetOrb()) ~= "PlantHealth" and GetObjName(GetTargetOrb()) ~= "PlantVision") then
		target = GetUnit(GetTargetOrb())
		if not IsDead(target) then

		if CanCast(_Q) and not self.BallMoving and  IsValidTarget(target, self.Q.range) and self.jungle_q then
			local CastPosition, HitChance, Position = self:GetQLinePreCore(target)
			if HitChance >= 5 then
					CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
				end
		end
		if CanCast(_W) and not self.BallMoving and IsValidTarget(target, 1500) and self.jungle_w then
				if GetDistance(target, self.BallPos) < self.W.width then
					CastSpellToPos(self.BallPos.x, self.BallPos.z, _W)
				end
			end
		if CanCast(_E) and not self.BallMoving and IsValidTarget(target, 1500) and self.jungle_e then
			local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(self.BallPos, myHero, target)
				if isOnSegment  and GetDistance(pointSegment, target) < self.E.width + 30 then
					CastSpellTarget(myHero.Addr, _E)
				end
				if myHero.HP / myHero.MaxHP * 100 < 40 then
					CastSpellTarget(myHero.Addr, _E)
				end
			end
		end
	end
end



function Orianna:OriannaHarass()
	if myHero.MP / myHero.MaxMP * 100 < self.harass_mana  and (not myHero.HasBuff("crestoftheancientgolem") or(myHero.HasBuff("crestoftheancientgolem") and not self.Ignoreharassmana))then return end
	if CanCast(_Q)  and self.harass_q then
		self:CastQ();
	end
	if CanCast(_W) and self.harass_w then
	 self:CastW();
 end
end

function Orianna:GetQLinePreCore(target)
	local castPosX, castPosZ, unitPosX, unitPosZ, hitChance, _aoeTargetsHitCount = GetPredictionCore(target.Addr, 0, self.Q.delay, self.Q.width, 2 * self.Q.range, self.Q.speed, self.BallPos.x, self.BallPos.z, true, false, 5, 5, 5, 5, 5, 5)
	if target ~= nil then
		 CastPosition = Vector(castPosX, target.y, castPosZ)
		 HitChance = hitChance
		 Position = Vector(unitPosX, target.y, unitPosZ)
		 return CastPosition, HitChance, Position
	end
	return nil , 0 , nil
end

function Orianna:GetCirclePreCore(target)
	local castPosX, castPosZ, unitPosX, unitPosZ, hitChance, _aoeTargetsHitCount = GetPredictionCore(target.Addr, 1, self.R.delay, self.R.width, self.R.range, self.R.speed, self.BallPos.x, self.BallPos.z, true, false, 5, 5, 5, 5, 5, 5)
	if target ~= nil then
		 CastPosition = Vector(castPosX, target.y, castPosZ)
		 HitChance = hitChance
		 Position = Vector(unitPosX, target.y, unitPosZ)
		 return CastPosition, HitChance, Position
	end
	return nil , 0 , nil
end

function GetIgnite()
	if GetSpellIndexByName("SummonerDot") > -1 then
		return GetSpellIndexByName("SummonerDot")
	end
	return -1
end

function TotalDamage(target)
	local totaldamage = 0
	if CanCast(_Q) then
		totaldamage = totaldamage + GetDamage("Q", target)
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
		totaldamage = totaldamage + GetAADamageHitEnemy(target) * 2
	end
	if target.HasBuff("Moredkaiser") then
			totaldamage = totaldamage - target.MP
	end
	if target.HasBuff("BlitzcrankManaBarrierCD") and target.HasBuff("ManaBarrier") then
			totaldamage = totaldamage - target.MP / 2
	end
	if target.HasBuff("GarenW") then
	  	totaldamage = totaldamage * 0.7;
	end
	if target.HasBuff("ferocioushowl") then
			totaldamage = totaldamage * 0.7;
	end
	if myHero.HasBuff("SummonerExhaust") then
			totaldamage = totaldamage * 0.6;
	end
	if GetIgnite() > -1 then
		totaldamage = totaldamage +(50 + 20 * myHero.Level)
	end
--	elseif CanCast(self:GetIgnite()) then
	--	totaldamage = 50 + 20 * myHero.Level
	return totaldamage
end
function Orianna:CastIgnite()
	local Target = GetTargetSelector(600, 0)
	targetignite = GetAIHero(Target)
	if  IsValidTarget(target, 600) and GetIgnite() > -1 and TotalDamage(targetignite) >= targetignite.HP then
		 CastSpellTarget(target.Addr, GetIgnite())
	 end
 end
function Orianna:CastQ()
		local TargetQ = GetTargetSelector(1500, 0)
		targetQ = GetAIHero(TargetQ)
			if CanCast(_Q) and not self.BallMoving and  IsValidTarget(targetQ, self.Q.range + self.Q.width) then
				local CastPosition, HitChance, Position = self:GetQLinePreCore(targetQ)
				if HitChance >= 6  then
			 			CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
		 			end
	 		end
		end

	function Orianna:CastW()
		local TargetW = GetTargetSelector(1500, 0)
		targetW = GetAIHero(TargetW)
		if CanCast(_W)  and not self.BallMoving then
 		 		if GetDistance(targetW, self.BallPos) < self.W.width then
					--CastSpellToPos(self.BallPos.x, self.BallPos.z, _W)
					CastSpellTarget(myHero.Addr, _W)
 		 		end
 	 		end
 		end

function Orianna:CastE()
	local TargetE = GetTargetSelector(1500, 0)
	targetE = GetAIHero(TargetE)
	if CanCast(_E) and not self.BallMoving and IsValidTarget(targetE, 1500)  then
		if myHero.HP / myHero.MaxHP * 100 < 10 then
				CastSpellTarget(myHero.Addr, _E)
		end
		if targetE.IsMelee and GetDistance(myHero, targetE) < 400 then
			  CastSpellTarget(myHero.Addr, _E)
		end
		if CountEnemyChampAroundObject(myHero.Addr, 800) >= 2  then
			if TotalDamage(targetE) >= targetE.HP and CanCast(_R) then return end
				CastSpellTarget(myHero.Addr, _E)
		end
			local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(myHero, targetE, self.BallPos)
			if pointLine  and GetDistance(pointSegment, targetE) < self.E.width + 50 then
				if CountEnemyChampAroundObject(myHero.Addr, 1500) >= 1  then
					if TotalDamage(targetE) >= targetE.HP and CanCast(_R) then return end
					CastSpellTarget(myHero.Addr, _E)
				end
				local eDmg = GetDamage("E", targetE)
				if eDmg >= targetE.HP then
					CastSpellTarget(myHero.Addr, _E)
				end
			end
	end
end
function Orianna:CastR()
	local TargetR = GetTargetSelector(1500, 0)
	targetR = GetAIHero(TargetR)
	if CanCast(_R) and  IsValidTarget(targetR, 1500) then
		if CountEnemyChampAroundObject(self.BallPos.Addr, 380) >= self.combo_r then
			CastSpellToPos(self.BallPos.x, self.BallPos.z, _R)
		end
		if not targetR.IsDash and not self.BallMoving and  self.combo_rall and GetDistance(targetR, self.BallPos) < self.R.width and TotalDamage(targetR) >= targetR.HP then
			if targetR.HasBuff("UndyingRage") or targetR.HasBuff("JudicatorIntervention") or targetR.HasBuff("ChronoShift") or targetR.HasBuff("FioraW") or targetR.HasBuff("SivirShield") then return end
						--CastSpellToPos(CastPosition.x, CastPosition.z, _R)
						CastSpellTarget(myHero.Addr, _R)
				end

				for i, heros in ipairs(GetAllyHeroes()) do
				if heros ~= nil then
						local ally = GetAIHero(heros)
						if not ally.IsMe and CanCast(_E) and CountEnemyChampAroundObject(ally.Addr, 1000) >= self.AutoER then
							CastSpellTarget(ally.Addr, _E)
							end
						if CountEnemyChampAroundObject(self.BallPos.Addr, 380) >=  self.AutoER and not targetR.IsDash then
							CastSpellToPos(self.BallPos.x, self.BallPos.z, _R)
						end
					end
				end
			end
		end


function Orianna:OriannaCombo(target)
	if self.useingite then
		self:CastIgnite();
	end
	if CanCast(_Q)  and self.combo_q then
		self:CastQ();
	end
	if CanCast(_W) and self.combo_w then
	 self:CastW();
 end
	if CanCast(_R)  then
 	self:CastR();
	end
	if CanCast(_E) and self.combo_e then
	self:CastE();
	end
end

function Orianna:KillSteal()
	for i, heros in ipairs(GetEnemyHeroes()) do
			if heros ~= nil then
				local target = GetAIHero(heros)
		  	local qDmg = GetDamage("Q", target)
		  	local wDmg = GetDamage("W", target)
				local rDmg = GetDamage("R", target)
				if CanCast(_Q) and target ~= 0 and IsValidTarget(target, self.Q.range +self.Q.width) and self.KillstealQ and qDmg >target.HP then
						local CastPosition, HitChance, Position = self:GetQLinePreCore(target)
						if HitChance >= 6  then
								CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
							end
						end
			 if CanCast(_W) and target ~= 0 and IsValidTarget(target, 1500) and self.KillstealW and wDmg >target.HP then
						if not self.BallMoving and  GetDistance(target, self.BallPos) < self.W.width then
								CastSpellToPos(self.BallPos.x, self.BallPos.z, _W)
							end
						end
			if CanCast(_E) and not self.BallMoving and self.KillstealE and IsValidTarget(targetE, 1500) then
			 local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(myHero, target, self.BallPos)
			 if pointLine  and GetDistance(pointSegment, target) < self.E.width + 50 then
		 	  	local eDmg = GetDamage("E", target)
		    	if eDmg >= target.HP then
		  					CastSpellTarget(myHero.Addr, _E)
		  				end
		  			end
					end
			end
		end
	end

	function RotateAroundPoint(v1,v2, angle)
	     cos, sin = math.cos(angle), math.sin(angle)
	     x = ((v1.x - v2.x) * cos) - ((v2.z - v1.z) * sin) + v2.x
	     z = ((v2.z - v1.z) * cos) + ((v1.x - v2.x) * sin) + v2.z
	    return Vector(x, v1.y, z or 0)
	end

	function Orianna:OnDraw()
		if self.Draw_ball then
		local innerPoint = RotateAroundPoint(self.BallPos + Vector(0, 0, 3), self.BallPos, 200*math.pi/180)
		local innerPoint2 = RotateAroundPoint(self.BallPos, innerPoint, 60*math.pi/180)
		local innerPoint3 = RotateAroundPoint(self.BallPos, innerPoint, 120*math.pi/180)
		local innerPoint4 = RotateAroundPoint(self.BallPos, innerPoint, 180*math.pi/180)
		local innerPoint5 = RotateAroundPoint(self.BallPos, innerPoint, 240*math.pi/180)
		local innerPoint6 = RotateAroundPoint(self.BallPos, innerPoint, 300*math.pi/180)
		local outterPoint = RotateAroundPoint(self.BallPos + Vector(0, 0, 3), self.BallPos, 200*math.pi/180 +90)
		local outterPoint2 = RotateAroundPoint(self.BallPos, outterPoint, 60*math.pi/180)
		local outterPoint3 = RotateAroundPoint(self.BallPos, outterPoint, 120*math.pi/180)
		local outterPoint4 = RotateAroundPoint(self.BallPos, outterPoint, 180*math.pi/180)
		local outterPoint5 = RotateAroundPoint(self.BallPos, outterPoint, 240*math.pi/180)
		local outterPoint6 = RotateAroundPoint(self.BallPos, outterPoint, 300*math.pi/180)


		DrawLineGame(innerPoint.x, innerPoint.y, innerPoint.z, outterPoint.x, outterPoint.y, outterPoint.z, 80)
		DrawLineGame(outterPoint.x, outterPoint.y, outterPoint.z, innerPoint2.x, innerPoint2.y, innerPoint2.z, 80)
		DrawLineGame(innerPoint2.x, innerPoint2.y, innerPoint2.z, outterPoint2.x, outterPoint2.y, outterPoint2.z, 80)
		DrawLineGame(outterPoint2.x, outterPoint2.y, outterPoint2.z, innerPoint3.x, innerPoint3.y, innerPoint3.z, 80)
		DrawLineGame(innerPoint3.x, innerPoint3.y, innerPoint3.z, outterPoint3.x, outterPoint3.y, outterPoint3.z, 80)
		DrawLineGame(outterPoint3.x, outterPoint3.y, outterPoint3.z, innerPoint4.x, innerPoint4.y, innerPoint4.z, 80)
		DrawLineGame(innerPoint4.x, innerPoint4.y, innerPoint4.z, outterPoint4.x, outterPoint4.y, outterPoint4.z, 80)--
		DrawLineGame(outterPoint4.x, outterPoint4.y, outterPoint4.z, innerPoint5.x, innerPoint5.y, innerPoint5.z, 80)--
		DrawLineGame(innerPoint5.x, innerPoint5.y, innerPoint5.z, outterPoint5.x, outterPoint5.y, outterPoint5.z, 80)
		DrawLineGame(outterPoint5.x, outterPoint5.y, outterPoint5.z, innerPoint6.x, innerPoint6.y, innerPoint6.z, 80)
		DrawLineGame(innerPoint6.x, innerPoint6.y, innerPoint6.z, outterPoint6.x, outterPoint6.y, outterPoint6.z, 80)
		DrawLineGame(outterPoint6.x, outterPoint6.y, outterPoint6.z, innerPoint.x, innerPoint.y, innerPoint.z, 80)
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
				DrawCircleGame(self.BallPos.x, self.BallPos.y, self.BallPos.z, self.W.width, Lua_ARGB(255,0,0,255))
			end
			if self.Draw_E and CanCast(_E) then
				DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
			end
			if self.Draw_R and CanCast(_R) then
				DrawCircleGame(self.BallPos.x, self.BallPos.y, self.BallPos.z, self.R.width, Lua_ARGB(255,255,0,0))
			end
		else
			if self.Draw_Q then
				DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
			end
			if self.Draw_W then
				DrawCircleGame(self.BallPos.x, self.BallPos.y, self.BallPos.z, self.W.width, Lua_ARGB(255,0,0,255))
			end
			if self.Draw_E then
				DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
			end
			if self.Draw_R then
				DrawCircleGame(self.BallPos.x, self.BallPos.y, self.BallPos.z, self.R.width, Lua_ARGB(255,0,255,255))
			end
		end
	end
