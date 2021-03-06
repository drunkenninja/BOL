local pi, pi2, sin, cos, huge, sqrt, floor, ceil, max, random, round = math.pi, 2*math.pi, math.sin, math.cos, math.huge, math.sqrt, math.floor, math.ceil, math.max, math.random, math.round
local clock = os.clock
local pairs, ipairs = pairs, ipairs
local insert, remove = table.insert, table.remove
local TEAM_ALLY, TEAM_ENEMY

local function Log(message)
    print("<font color='#FF0000'>["..myHero.charName.."]</font> <font color='#FFFFFF'>"..message.."</font>")
end
local function CreateBaseMenu()
    _G.LulzMenu = scriptConfig("Lulz"..myHero.charName, myHero.charName .. "lulz")
    LulzMenu:addSubMenu("Drawing Menu", "Draw")
        LulzMenu.Draw:addSubMenu("AA Settings", "AASettings")
            LulzMenu.Draw.AASettings:addParam("Enabled", "Draw AA Range", 1, true)
            LulzMenu.Draw.AASettings:addParam("CircleColor", "Circle color", SCRIPT_PARAM_COLOR, {255,255,0,0})
        LulzMenu.Draw:addSubMenu("Q Settings", "QSettings")
            LulzMenu.Draw.QSettings:addParam("Enabled", "Draw Range", 1, true)
            LulzMenu.Draw.QSettings:addParam("Hide", "Don't Draw When Not Castable", 1, true)
            LulzMenu.Draw.QSettings:addParam("CircleColor", "Circle color", SCRIPT_PARAM_COLOR, {255,0,255,0})
        LulzMenu.Draw:addSubMenu("W Settings", "WSettings")
            LulzMenu.Draw.WSettings:addParam("Enabled", "Draw Range", 1, true)
            LulzMenu.Draw.WSettings:addParam("Hide", "Don't Draw When Not Castable", 1, true)
            LulzMenu.Draw.WSettings:addParam("CircleColor", "Circle color", SCRIPT_PARAM_COLOR, {255,0,255,0})
        LulzMenu.Draw:addSubMenu("E Settings", "ESettings")
            LulzMenu.Draw.ESettings:addParam("Enabled", "Draw Range", 1, true)
            LulzMenu.Draw.ESettings:addParam("Hide", "Don't Draw When Not Castable", 1, true)
            LulzMenu.Draw.ESettings:addParam("CircleColor", "Circle color", SCRIPT_PARAM_COLOR, {255,0,255,0})
        LulzMenu.Draw:addSubMenu("R Settings", "RSettings")
            LulzMenu.Draw.RSettings:addParam("Enabled", "Draw Range", 1, true)
            LulzMenu.Draw.RSettings:addParam("Hide", "Don't Draw When Not Castable", 1, true)
            LulzMenu.Draw.RSettings:addParam("CircleColor", "Circle color", SCRIPT_PARAM_COLOR, {255,0,255,0})
        LulzMenu.Draw:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
        LulzMenu.Draw:addParam("StreamMode", "Enable Streaming Mode(F7)", SCRIPT_PARAM_ONKEYTOGGLE, false, 118)
        LulzMenu.Draw:addParam("DrawTarget", "Draw Target", 1, true)
        LulzMenu.Draw:addParam("LowFPS", "Use LowFPS Circles", 1, true)
        LulzMenu.Draw:addParam("Quality", 'LowFPS Circle Quality', SCRIPT_PARAM_SLICE, 20, 10, 200, 0)
    LulzMenu:addSubMenu("Spells Menu & Masteries", "Spell")
        LulzMenu.Spell:addSubMenu("Q Menu", "QMenu")
        LulzMenu.Spell:addSubMenu("W Menu", "WMenu")
        LulzMenu.Spell:addSubMenu("E Menu", "EMenu")
        LulzMenu.Spell:addSubMenu("R Menu", "RMenu")
    LulzMenu:addSubMenu("Items Menu", "Items")
        LulzMenu.Items:addSubMenu("Offensive Items", "OffensiveItems")
            LulzMenu.Items.OffensiveItems:addParam("Enable", "Use items during", SCRIPT_PARAM_LIST, 3,{"Never","Combo","Combo+Harass"})
			LulzMenu.Items.OffensiveItems:addParam("HealthPercent", "If my health % is less than", SCRIPT_PARAM_SLICE, 85, 0, 100, decimalPlace)
			LulzMenu.Items.OffensiveItems:addParam("EnemyHealthPercent", "If target health % is less than", SCRIPT_PARAM_SLICE, 85, 0, 100, decimalPlace)
        LulzMenu.Items:addSubMenu("Defensive Items", "DefensiveItems")
            LulzMenu.Items.DefensiveItems:addParam("Enable", "Use items during", SCRIPT_PARAM_LIST, 3,{"Never","Combo","Combo+Harass"})
            LulzMenu.Items.DefensiveItems:addParam("HealthPercent", "If my health % is less than", SCRIPT_PARAM_SLICE, 50, 0, 100, decimalPlace)
            LulzMenu.Items.DefensiveItems:addParam("NegateCC", "Use to negate CC if cleanse is down", 1, true)
        LulzMenu.Items:addSubMenu("QSS/Cleanse Settings", "CleanseSettings")
            LulzMenu.Items.CleanseSettings:addParam("Enable", "Remove CC", SCRIPT_PARAM_LIST, 3,{"Never","Combo","Always"})
            LulzMenu.Items.CleanseSettings:addParam("Blitz", "Remove Rocket Grab", SCRIPT_PARAM_ONOFF, false)
            LulzMenu.Items.CleanseSettings:addParam("Blind", "Remove Blind", SCRIPT_PARAM_ONOFF, false)
            LulzMenu.Items.CleanseSettings:addParam("Delay", "Humanizer delay (ms)", SCRIPT_PARAM_SLICE, 0, 0, 500, 0)
        LulzMenu.Items:addSubMenu("Auto Warding", "Warding")
            LulzMenu.Items.Warding:addParam("Enable", "Auto ward on vision lost", SCRIPT_PARAM_LIST, 3,{"Never","Combo","Always"})
            LulzMenu.Items.Warding:addParam("Delay", "Humanizer delay (ms)", SCRIPT_PARAM_SLICE, 250, 0, 1000, 0)

        LulzMenu.Items:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    	LulzMenu.Items:addParam("AutoPotion", "Auto Health Pot", SCRIPT_PARAM_LIST, 2,{"Never","Combo","Always"})
    	LulzMenu.Items:addParam("HealthPercent", "Pot If My Health % is <", SCRIPT_PARAM_SLICE, 50, 0, 100, decimalPlace)
    LulzMenu:addSubMenu("General Menu", "General")
        LulzMenu.General:addSubMenu("Auto Leveler", "Level")
            LulzMenu.General.Level:addParam("Enable", "Enable Auto Leveler", 1, true)
            LulzMenu.General.Level:addParam("Ignore", "Ignore First 3 Levels", 1, true)
            LulzMenu.General.Level:addParam("Sequence", "Leveling Sequence", SCRIPT_PARAM_LIST, 1,{'Q>E>W', 'Q>W>E', 'W>Q>E', 'W>E>Q'})
        LulzMenu.General:addSubMenu("Auto Buy", "Buy")
            LulzMenu.General.Buy:addParam("StartingItems", "Purchase Starting Items", 1, true)
		    LulzMenu.General.Buy:addParam("TrinketSwitch", "Auto Switch Trinket At 9", SCRIPT_PARAM_LIST, 2, {"Off","Blue","Red"})
        LulzMenu.General:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
        LulzMenu.General:addParam("Lane", "Get to lane faster", 1, true)
        LulzMenu.General:addParam("Verbose", "Track enemy recall in chat", 1, true)
    LulzMenu:addSubMenu("Hotkeys Menu", "Hotkeys")
        LulzMenu.Hotkeys:addParam("ForceUlt", "Ult execute keybinding", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        LulzMenu.Hotkeys:addParam("FleeKey", "Flee Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
        LulzMenu.Hotkeys:addParam("Burst", "Burst Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Y"))
        LulzMenu.Hotkeys:addParam("Stack", "Tear Stacker Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("J"))
    LulzMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    LulzMenu:addParam("Taunt", "Taunt On Kill", SCRIPT_PARAM_LIST, 1,{"None","Dance","Taunt","Laugh","Joke","Mastery"})
    LulzMenu:addParam("Skins", 'Skin Changer', SCRIPT_PARAM_SLICE, 0, 0, 25, 0)
    LulzMenu:setCallback("Skins", function(v)
        SetSkin(myHero, v - 1)
    end)
end
local function RenderCircle(size, menu)
    local function ReturnColor(color) return ARGB(color[1],color[2],color[3],color[4]) end

    if LulzMenu.Draw.LowFPS then
        DrawCircle3D(myHero.x, myHero.y, myHero.z, size, 1, ReturnColor(menu.CircleColor), LulzMenu.Draw.Quality)
    else
        DrawCircle(myHero.x, myHero.y, myHero.z, size, ReturnColor(menu.CircleColor))
    end
end

function OnLoad()
    local version = 0.18
    CheckUpdatesLib()
    CheckUpdates(version)

    if _G.Lulzlib then
        CreateBaseMenu()
        SetSkin(myHero, LulzMenu.Skins - 1)
        Orbwalker()
        Prediction(LulzMenu.General)
        CTargetSelector()
        ItemsAndSummoners()
        AntiBaseUlt()
        Humanizer()
        ThreshLantern()
    end

    _G[myHero.charName]()
end
function OnUnload()
    SetSkin(myHero, -1)
end

class "Ezreal"
function Ezreal:__init()
    self.QState, self.WState, self.EState = nil, nil, nil
    self.manaPercent = nil
    self.print,self.PrintChat = _G.print, _G.PrintChat
    self.lastBardRCoords = {x = 0, z = 0, time = 0, ulted = false}
    self.castTime = 0
    self.SpellTable = {
        Q = {range = 1150, speed = 2000, delay = 0.25, width = 75, collision = true},
        W = {range = 1000, speed = 1550, delay = 0.25, width = 100, collision = false},
        E = {range = 475, maxRange = 750},
        R = {range = 9999, speed = 2000, delay = 1, width = 150, collision = false}
    }
    self.autoRTable = {
        ["Malphite"] = {name = "UFSlash", range = 300},
        ["Orianna"] = {name = "OrianaDetonateCommand", range = 400},
        ["Annie"] = {name = "InfernalGuardian", range = 250},
        ["Leona"] = {name = "LeonaSolarFlare", range = 300},
        ["Yasuo"] = {name = "YasuoRDummySpell", range = 400},
        ["Bard"] = {name = "BardR", range = 350},
    }
    self.spellDmg = {
        [_Q] = function(unit) if self.QState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_Q).level * 20) + 15) + (myHero.ap * 0.4)) + (myHero.totalDamage * 1.1))) end end,
        [_W] = function(unit) if self.WState then return myHero:CalcMagicDamage(unit, (((myHero:GetSpellData(_W).level * 45) + 25) + (myHero.ap * 0.8))) end end,
        [_E] = function(unit) if self.EState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_E).level * 50) + 25) + (myHero.ap * 0.75)) + (myHero.addDamage * 0.5))) end end,
        [_R] = function(unit) if self.RState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_R).level * 150) + 200) + (myHero.ap * 0.9)) + myHero.addDamage)) end end
    }
    self.BaseSpots = {
                D3DXVECTOR3(396,182.132,462),
                D3DXVECTOR3(14340.418,171.9777,14391.075)
            }

    self.enemyHeros = GetEnemyHeroes()
    self.enemyMinions = minionManager(MINION_ENEMY, self.SpellTable.Q.range - 400, myHero, MINION_SORT_HEALTH_ASC)
    self.jungleMinions = minionManager(MINION_JUNGLE, 625, myHero, MINION_SORT_MAXHEALTH_ASC)

    self.recallStatus = {}
    self.recallTimes = {
    	['recall'] = 7.9,
    	['odinrecall'] = 4.4,
    	['odinrecallimproved'] = 3.9,
    	['recallimproved'] = 6.9,
    	['superrecall'] = 3.9,
    }
    self.activeRecalls = {}
    self.lasttime={}

    for i, enemy in pairs(self.enemyHeros) do
    	self.recallStatus[enemy.charName] = enemy.recall
    end
    for i, hero in pairs(GetAllyHeroes()) do
        if self.autoRTable[hero.charName] then
            LulzMenu.Spell.RMenu:addParam(hero.charName, "Use on " .. hero.charName .. " Ultimate", 1, true)
        end
    end

    self:AddToMenu()
    AddTickCallback(function() self:OnTick() end)
    AddTickCallback(function()
    	for i, enemy in pairs(self.enemyHeros) do
    		if enemy.recall ~= self.recallStatus[enemy.charName] then
    			self:recallFunction(enemy, enemy.recall)
    		end
    		self.recallStatus[enemy.charName] = enemy.recall
    	end
    end)
    AddDrawCallback(function() self:OnDraw() end)
    AddProcessSpellCallback(function(unit, spell) self:AutoR(unit, spell) end)
end
function Ezreal:BaseUlt()
    if not myHero.dead and LulzMenu.Spell.RMenu.BaseUlt then
        self.time = GetDistance(myHero, self.BaseSpots[2]) / 2000
        for i, snipeTarget in pairs(self.activeRecalls) do
            if (snipeTarget.endT - os.clock()) <= self.time + 1 and (snipeTarget.endT - os.clock()) >= self.time + .5 and self:BaseUltPredictIfUltCanKill(snipeTarget) then
                CastSpell(_R, self:BaseUltGetBaseCoords().x, self:BaseUltGetBaseCoords().z)
            end
        end
    end
end
function Ezreal:recallFunction(Hero, Status)
	local o = Hero
	if o and o.valid and o.type == 'AIHeroClient' then
		local str = Status
		if self.recallTimes[str:lower()] then
			if LulzMenu.General.Verbose then
				if not o.visible and self.lasttime[o.networkID]  then
					print(r.name.." is recalling. Last seen "..string.format("%.1f", os.clock() -self.lasttime[o.networkID], 1).." seconds ago." )
				end
			end
			self.activeRecalls[o.networkID] = {
            					name = o.charName,
            					startT = os.clock(),
            					duration = self.recallTimes[str:lower()],
            					endT = os.clock() + self.recallTimes[str:lower()],
                                startHP = o.health,
                                hpRegen = o.hpRegen,
                                object = o
            				}
			return
		elseif self.activeRecalls[o.networkID] then
			if self.activeRecalls[o.networkID] and self.activeRecalls[o.networkID].endT > os.clock() then
				if LulzMenu.General.Verbose then
					print(self.activeRecalls[o.networkID].name.." canceled recall")
				end
				recallTime = nil
				recallName = nil
				blockName = nil
				self.activeRecalls[o.networkID] = nil
				return
			else
				if junglerName == self.activeRecalls[o.networkID].name then
					jungleText = "Recalled"
				end
				if LulzMenu.General.Verbose then
					print(self.activeRecalls[o.networkID].name.." finished recall")
				end
				self.activeRecalls[o.networkID] = nil
				recallTime = nil
				recallName = nil
				blockName = nil
				return
			end
		end
	end
end
function Ezreal:AddToMenu()
    LulzMenu.Draw.RSettings:addParam("BaseUlt", "Draw baseult tracker", 1, true)

    LulzMenu.Spell.QMenu:addParam("EnableCombo", "Use in combo", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableHarass", "Use in harass", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableClear", "Use in clear", SCRIPT_PARAM_LIST, 1,{"Off","Last Hit","Clear"})
    LulzMenu.Spell.QMenu:addParam("EnableJungle", "Use in jungle", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableKs", "Use to KS", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableFlee", "Use to flee with iceborn", 1, true)
    LulzMenu.Spell.QMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.QMenu:addParam("HarassMana", "Harass mana managment % >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
    LulzMenu.Spell.QMenu:addParam("ClearMana", "Lane clear mana managment % >", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
    LulzMenu.Spell.QMenu:addParam("PlaceHolder2", "", SCRIPT_PARAM_INFO, "")
    Prediction:AddToMenu(LulzMenu.Spell.QMenu)

    LulzMenu.Spell.WMenu:addParam("EnableCombo", "Use in combo", 1, true)
    LulzMenu.Spell.WMenu:addParam("EnableHarass", "Use in harass", 1, false)
    LulzMenu.Spell.WMenu:addParam("EnableClear", "Use in clear", 1, false)
    LulzMenu.Spell.WMenu:addParam("EnableKs", "Use to KS", 1, true)
    LulzMenu.Spell.WMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.WMenu:addParam("HarassMana", "Harass mana managment % >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
    LulzMenu.Spell.WMenu:addParam("ClearMana", "Lane clear mana managment % >", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
    LulzMenu.Spell.WMenu:addParam("PlaceHolder2", "", SCRIPT_PARAM_INFO, "")
    Prediction:AddToMenu(LulzMenu.Spell.WMenu)

    LulzMenu.Spell.EMenu:addParam("Enable", "Use as gap closer", SCRIPT_PARAM_LIST, 1,{"Never", "Combo", "Combo+Harass"})
    LulzMenu.Spell.EMenu:addParam("EnableKs", "Use to KS", 1, true)
    LulzMenu.Spell.EMenu:addParam("EnableFlee", "Use to flee", 1, true)
    LulzMenu.Spell.EMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.EMenu:addParam("HarassMana", "Harass mana managment % >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    LulzMenu.Spell.RMenu:addParam("EnableCombo", "Use in combo", 1, true)
    LulzMenu.Spell.RMenu:addParam("ComboRangeCheck", "Combo ult range check", SCRIPT_PARAM_SLICE, 800, 0, 9000, 0)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder44", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.RMenu:addParam("BaseUlt", "Enable base ult", 1, true)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder3", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.RMenu:addParam("EnableSnipe", "Ult to global snipe", 1, true)
    LulzMenu.Spell.RMenu:addParam("SnipeRangeCheckMax", "Global snipe max range check", SCRIPT_PARAM_SLICE, 1500, 300, 9000, 0)
    LulzMenu.Spell.RMenu:setCallback("SnipeRangeCheckMax", function(v)
        LulzMenu.Spell.RMenu:removeParam("SnipeRangeCheckMin")
        LulzMenu.Spell.RMenu:addParam("SnipeRangeCheckMin", "Global snipe min range check", SCRIPT_PARAM_SLICE, 1500, 0, v, 0)
        if LulzMenu.Spell.RMenu.SnipeRangeCheckMin > v then LulzMenu.Spell.RMenu.SnipeRangeCheckMin = v - 300 end
    end)
    LulzMenu.Spell.RMenu:addParam("SnipeRangeCheckMin", "Global snipe min range check", SCRIPT_PARAM_SLICE, 1200, 0, 9000, 0)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder23", "", SCRIPT_PARAM_INFO, "")


    LulzMenu.Spell.RMenu:addParam("EnableInitiator", "Use on initiators", 1, true)
    LulzMenu.Spell.RMenu:addParam("InitiatorRangeCheck", "Initiators ult range check", SCRIPT_PARAM_SLICE, 2000, 0, 9000, 0)
    LulzMenu.Spell.RMenu:addParam("InitiateNum", "Min number of enemies to ult", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder2", "", SCRIPT_PARAM_INFO, "")
    Prediction:AddToMenu(LulzMenu.Spell.RMenu)
end
function Ezreal:GetDamage(spell, unit)
    if spell == "ALL" then
        local sum = 0
          for spell, func in pairs(self.spellDmg) do
            sum = sum + (func(unit) or 0)
          end
         return sum
       else
          return self.spellDmg[spell](unit) or 0
       end
end
function Ezreal:OnTick()
    self.QState = myHero:CanUseSpell(_Q) == READY
    self.WState = myHero:CanUseSpell(_W) == READY
    self.EState = myHero:CanUseSpell(_E) == READY
    self.RState = myHero:CanUseSpell(_R) == READY
    self.manaPercent = myHero.mana / myHero.maxMana * 100
    _G.Target = Orbwalker:GetOrbwalkerTarget(1100)

    self:Combo()
    self:Harass()
    self:LaneClear()
    self:GetToLaneFaster()
    --self:KillSteal()
    self:FleeMode()
    self:TearStack()
    self:BaseUlt()
end
function Ezreal:OnDraw()
    local function ReturnColor(color) return ARGB(color[1],color[2],color[3],color[4]) end
    local function BaseUltProgressBar(x, y, percent, text, tick)
        DrawRectangle(x, y - 5, 300, 40, ARGB(255,100,100,100))
        DrawRectangle(x + 5, y, 290, 30, ARGB(255,30,30,30))
        DrawRectangle(x + 5, y, (percent/100)*290, 30, ARGB(255,255,0,0))
        DrawRectangle(x + (6.9 / 7.9 * 290), y, (100/100)*290 - x + (6.9 / 7.9 * 290), 30, ARGB(100,30,30,30))
        if tick <= 100 then
            DrawRectangle(x + 5 + (tick/100)*290, y, 2, 30, ARGB(255,0,255,0))
        else
            DrawRectangle(x + 5 + (100/100)*290, y, 2, 30, ARGB(255,0,255,0))
        end
        DrawText(text,20,y + 8,x + 5,ARGB(255,255,255,255))
    end

    if not myHero.dead then
        if LulzMenu.Draw.AASettings.Enabled then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, myHero.range + myHero.boundingRadius, 1, ReturnColor(LulzMenu.Draw.AASettings.CircleColor), 100)
        end
        if LulzMenu.Draw.QSettings.Enabled and (self.QState or not LulzMenu.Draw.QSettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.Q.range, 1, ReturnColor(LulzMenu.Draw.QSettings.CircleColor), 100)
        end
        if LulzMenu.Draw.WSettings.Enabled and (self.WState or not LulzMenu.Draw.WSettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.W.range, 1, ReturnColor(LulzMenu.Draw.WSettings.CircleColor), 100)
        end
        if LulzMenu.Draw.ESettings.Enabled and (self.EState or not LulzMenu.Draw.ESettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.E.range, 1, ReturnColor(LulzMenu.Draw.ESettings.CircleColor), 100)
        end
        if LulzMenu.Draw.ESettings.Enabled and (self.EState or not LulzMenu.Draw.ESettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.E.maxRange, 1, ReturnColor(LulzMenu.Draw.ESettings.CircleColor), 100)
        end
        if LulzMenu.Draw.RSettings.Enabled and (self.RState or not LulzMenu.Draw.RSettings.Hide) then
            DrawCircleMinimap(myHero.x, myHero.y, myHero.z, LulzMenu.Spell.RMenu.SnipeRangeCheckMax, 1, ReturnColor(LulzMenu.Draw.RSettings.CircleColor), 50)
            DrawCircleMinimap(myHero.x, myHero.y, myHero.z, LulzMenu.Spell.RMenu.SnipeRangeCheckMin, 1, ReturnColor(LulzMenu.Draw.RSettings.CircleColor), 50)
            for i, enemy in pairs(self.enemyHeros) do
                if enemy and ValidTarget(enemy) then
                    if self.RState and self:GetDamage(_R,enemy) > enemy.health and GetDistance(enemy) < LulzMenu.Spell.RMenu.SnipeRangeCheckMax and GetDistance(enemy) > LulzMenu.Spell.RMenu.SnipeRangeCheckMin then
                        DrawTextA("You can kill 1 or more enemies, Hold your Force ult key!", 25, WINDOW_H / 2, 50, ARGB(255,255,0,0), "center", "center")
                    end
                end
            end
        end
        if LulzMenu.Draw.DrawTarget then
            if Target ~= nil then
                DrawCircle3D(Target.x, Target.y, Target.z, 100, 1, ARGB(255,255,0,0), 100)
            end
        end
        if LulzMenu.Spell.RMenu.BaseUlt and LulzMenu.Draw.RSettings.BaseUlt then
            for i, enemy in pairs(self.activeRecalls) do
                 if self:BaseUltPredictIfUltCanKill(enemy) then
                     BaseUltProgressBar(500,500,(enemy.endT - os.clock()) / 7.9 * 100, enemy.name, ((GetDistance(myHero, self:BaseUltGetBaseCoords()) / 2000) + 1) / 8 * 100)
                 end
            end
        end
    end
end
function Ezreal:BaseUltGetBaseCoords()
    if myHero.team == 100 then
        return self.BaseSpots[2]
    else
        return self.BaseSpots[1]
    end
end
function Ezreal:BaseUltPredictIfUltCanKill(target)
    if myHero.charName == "Ezreal" or myHero.charName == "Jinx" or myHero.charName == "Draven" or myHero.charName == "Ashe" then
        if self:GetDamage(_R, target.object) > target.startHP + (target.hpRegen * 7.9)  then
            return true
        else
            return false
        end
    end
end
function Ezreal:GetToLaneFaster()
	local function inCircle(cx,cz,x,z,r)
		if (math.pow(cx-x,2)+math.pow(cz-z,2)<math.pow(r,2)) then
			return true
		else
			return false
		end
	end

	if LulzMenu.General.Lane then
		for _, i in pairs(GetTurrets()) do
			if i.range == 1050 then
				if not inCircle(myHero.x, myHero.z, i.x, i.z, 900) and inCircle(myHero.x, myHero.z, i.x, i.z, 1050) and self.EState and not inCircle(myHero.endPath.x, myHero.endPath.z, i.x, i.z, 1050) then
					CastSpell(_E, myHero.endPath.x, myHero.endPath.z)
				end
			end
		end
	end
end
function Ezreal:CastQ(enemy)
    if self.QState then
        local CastPosition, HitChance, Info = Prediction:GetLineCastPosition(enemy, self.SpellTable.Q, "Q")
        if CastPosition and HitChance >= LulzMenu.Spell.QMenu.Accuracy then
            if Info ~= nil and Info.collision ~= nil and not Info.collision or Info == nil or Info.collision == nil then
                CastSpell(_Q, CastPosition.x, CastPosition.z)
            end
        end
    end
end
function Ezreal:CastW(enemy)
    local CastPosition, HitChance, Info = Prediction:GetLineCastPosition(enemy, self.SpellTable.W, "W")
    if CastPosition and HitChance >= LulzMenu.Spell.WMenu.Accuracy then
        CastSpell(_W, CastPosition.x, CastPosition.z)
    end
end
function Ezreal:CastE(x,z)
    if self.EState then
        CastSpell(_E, x, z)
    end
end
function Ezreal:CastR(enemy)
    local CastPosition, HitChance, Info = Prediction:GetLineCastPosition(enemy, self.SpellTable.R)
    if CastPosition and HitChance >= LulzMenu.Spell.RMenu.Accuracy then
        CastSpell(_R, CastPosition.x, CastPosition.z)
    end
end
function Ezreal:Combo()
    if Orbwalker:IsFighting() then
        if ValidTarget(Target) then
            if self.QState then
                self:CastQ(Target)
            end

            if self.WState then
                self:CastW(Target)
            end
        end
    end
end
function Ezreal:Harass()
    if Orbwalker:IsHarassing() then
        if ValidTarget(Target) then
            if self.QState and LulzMenu.Spell.QMenu.EnableHarass then
                self:CastQ(Target)
            end

            if self.WState and LulzMenu.Spell.WMenu.EnableHarass then
                self:CastW(Target)
            end
        end
    end
end
function Ezreal:LaneClear()
    if Orbwalker:IsLaneClearing() then
        if LulzMenu.Spell.QMenu.EnableJungle then
            self.jungleMinions:update()

            if self.QState then
                for i, jungle in pairs(self.jungleMinions.objects) do
                    if jungle ~= nil and ValidTarget(jungle) and GetDistance(jungle) < self.SpellTable.Q.range and string.split(jungle.charName,'_')[2] ~= "Plant" then
                        self:CastQ(jungle)
                    end
                end
            end
        end

        if LulzMenu.Spell.QMenu.EnableClear > 1 then
            self.enemyMinions:update()
            if self.QState then
                for i, minion in pairs(self.enemyMinions.objects) do
                    if minion ~= nil and ValidTarget(minion) and GetDistance(minion) < self.SpellTable.Q.range then
                        if LulzMenu.Spell.QMenu.EnableClear == 3 then
                            self:CastQ(minion)
                        else
                            if self:GetDamage(_Q, minion) > minion.health then
                                self:CastQ(minion)
                            end
                        end
                    end
                end
            end
        end
    end
end
function Ezreal:KillSteal()
    for i, enemy in pairs(self.enemyHeros) do
        if enemy and ValidTarget(enemy) then
            if LulzMenu.Spell.EMenu.EnableKs then
                if GetDistance(enemy) > self.SpellTable.Q.range and GetDistance(enemy) < (self.SpellTable.Q.range + self.SpellTable.E.range) then
                    if enemy.health < (getDmg("Q", enemy, myHero)+((myHero.damage)*1.1)+(myHero.ap*0.4)) then
                        local p = myHero + (Vector(enemy.pos) - myHero):normalized() * 475
                        self:CastE(p.x,p.z)
                        DelayAction((function() self:CastQ(enemy) end), .3)

                    end
                end
            end

            if LulzMenu.Spell.QMenu.EnableKs then
                if self:GetDamage(_Q, enemy) > enemy.health and enemy.health < self:GetDamage(_W, enemy) then
                    self:CastQ(enemy)
                end
            end

            if LulzMenu.Spell.WMenu.EnableKs then
                if self:GetDamage(_Q, enemy) < enemy.health and enemy.health > self:GetDamage(_W, enemy) then
                    self:CastW(enemy)
                end
            end

            if LulzMenu.Hotkeys.ForceUlt then
                if self.RState and self:GetDamage(_R, enemy) > enemy.health and GetDistance(enemy) < LulzMenu.Spell.RMenu.SnipeRangeCheckMax and GetDistance(enemy) > LulzMenu.Spell.RMenu.SnipeRangeCheckMin then
                    self:CastR(enemy)
                end
            end
        end
    end
end
function Ezreal:FleeMode()
    if LulzMenu.Hotkeys.FleeKey then
        myHero:MoveTo(mousePos.x, mousePos.z)

        if LulzMenu.Spell.QMenu.EnableFlee then
            if ItemsAndSummoners:HasItem(3025) then
                self:CastQ(Target)
            end
        end
    end
end
function Ezreal:TearStack()
    if LulzMenu.Hotkeys.Stack then
        if ItemsAndSummoners:HasItem(3070) or ItemsAndSummoners:HasItem(3004) then
            local castqpos = myHero + (Vector(mousePos) - myHero):normalized() * 300
            CastSpell(_Q, castqpos.x, castqpos.z)
        end
    end
end
function Ezreal:AutoR(unit, spell)
    if not LulzMenu.Spell.RMenu.EnableInitiator or unit.isMe then return end
    if unit.team == myHero.team then
        if LulzMenu.Spell.RMenu[unit.charName] then
            if GetDistanceSqr(spell.endPos) <= LulzMenu.Spell.RMenu.InitiatorRangeCheck * LulzMenu.Spell.RMenu.InitiatorRangeCheck then
                if self.autoRTable[unit.charName].name == spell.name then
                    if ItemsAndSummoners:CountEnemiesNearUnitReg(spell.endPos, self.autoRTable[unit.charName].range) >= LulzMenu.Spell.RMenu.InitiateNum then
                        if self.RState then
                            if unit.charName == "Yasuo" then
                                CastSpell(_R, unit.x, unit.z)
                            elseif unit.charName == "Bard" then
                                --self.lastBardRCoords.time = os.clock() + math.abs(((GetDistance(spell.endPos) / 2000) + 1) - ((GetDistance(spell.endPos, unit) / 2100) + 3.5))
                                --self.lastBardRCoords.z = spell.endPos.z
                                --self.lastBardRCoords.x = spell.endPos.x
                                --self.lastBardRCoords.ulted = true
                            else
                                CastSpell(_R, spell.endPos.x, spell.endPos.z)
                            end
                        end
                    end
                end
            end
        end
    end
end


class "Jinx"
function Jinx:__init()
    self.QState, self.WState, self.EState = nil, nil, nil
    self.manaPercent = nil
    self.print,self.PrintChat = _G.print, _G.PrintChat
    self.QToggle = nil

    self.SpellTable = {
        Q = {range = 1150, speed = 2000, delay = 0.25, width = 75, collision = true},
        W = {range = 1500, speed = 3200, delay = 0.25, width = 100, collision = true},
        E = {range = 475, maxRange = 750},
        R = {range = 9999, speed = 2500, delay = .6, width = 150, collision = true}
    }
    self.spellDmg = {
        [_Q] = function(unit) if self.QState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_Q).level * 20) + 15) + (myHero.ap * 0.4)) + (myHero.totalDamage * 1.1))) end end,
        [_W] = function(unit) if self.WState then return myHero:CalcMagicDamage(unit, (((myHero:GetSpellData(_W).level * 45) + 25) + (myHero.ap * 0.8))) end end,
        [_E] = function(unit) if self.EState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_E).level * 50) + 25) + (myHero.ap * 0.75)) + (myHero.addDamage * 0.5))) end end,
        [_R] = function(unit) if self.RState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_R).level * 150) + 200) + (myHero.ap * 0.9)) + myHero.addDamage)) end end
    }
    self.BaseSpots = {
                D3DXVECTOR3(396,182.132,462),
                D3DXVECTOR3(14340.418,171.9777,14391.075)
            }

    self.enemyHeros = GetEnemyHeroes()
    self.enemyMinions = minionManager(MINION_ENEMY, self.SpellTable.W.range, myHero, MINION_SORT_HEALTH_ASC)
    self.jungleMinions = minionManager(MINION_JUNGLE, 625, myHero, MINION_SORT_MAXHEALTH_ASC)

    self.recallStatus = {}
    self.recallTimes = {
    	['recall'] = 7.9,
    	['odinrecall'] = 4.4,
    	['odinrecallimproved'] = 3.9,
    	['recallimproved'] = 6.9,
    	['superrecall'] = 3.9,
    }
    self.activeRecalls = {}
    self.lasttime={}
    self.target = nil

    for i, enemy in pairs(self.enemyHeros) do
    	self.recallStatus[enemy.charName] = enemy.recall
    end

    self:AddToMenu()

    AddTickCallback(function() self:OnTick() end)
    AddTickCallback(function()
    	for i, enemy in pairs(self.enemyHeros) do
    		if enemy.recall ~= self.recallStatus[enemy.charName] then
    			self:recallFunction(enemy, enemy.recall)
    		end
    		self.recallStatus[enemy.charName] = enemy.recall
    	end
    end)
    AddDrawCallback(function() self:OnDraw() end)
end
function Jinx:BaseUlt()
    if not myHero.dead and LulzMenu.Spell.RMenu.BaseUlt then
        self.time = GetDistance(myHero, self.BaseSpots[2]) / 2000
        for i, snipeTarget in pairs(self.activeRecalls) do
            if (snipeTarget.endT - os.clock()) <= self.time + .4 and (snipeTarget.endT - os.clock()) >= self.time + .2 and self:BaseUltPredictIfUltCanKill(snipeTarget) then
                CastSpell(_R, self:BaseUltGetBaseCoords().x, self:BaseUltGetBaseCoords().z)
            end
        end
    end
end
function Jinx:recallFunction(Hero, Status)
	local o = Hero
	if o and o.valid and o.type == 'AIHeroClient' then
		local str = Status
		if self.recallTimes[str:lower()] then
			if LulzMenu.General.Verbose then
				if not o.visible and self.lasttime[o.networkID]  then
					print(r.name.." is recalling. Last seen "..string.format("%.1f", os.clock() -self.lasttime[o.networkID], 1).." seconds ago." )
				end
			end
			self.activeRecalls[o.networkID] = {
            					name = o.charName,
            					startT = os.clock(),
            					duration = self.recallTimes[str:lower()],
            					endT = os.clock() + self.recallTimes[str:lower()],
                                startHP = o.health,
                                hpRegen = o.hpRegen,
                                object = o
            				}
			return
		elseif self.activeRecalls[o.networkID] then
			if self.activeRecalls[o.networkID] and self.activeRecalls[o.networkID].endT > os.clock() then
				if LulzMenu.General.Verbose then
					print(self.activeRecalls[o.networkID].name.." canceled recall")
				end
				recallTime = nil
				recallName = nil
				blockName = nil
				self.activeRecalls[o.networkID] = nil
				return
			else
				if junglerName == self.activeRecalls[o.networkID].name then
					jungleText = "Recalled"
				end
				if LulzMenu.General.Verbose then
					print(self.activeRecalls[o.networkID].name.." finished recall")
				end
				self.activeRecalls[o.networkID] = nil
				recallTime = nil
				recallName = nil
				blockName = nil
				return
			end
		end
	end
end
function Jinx:AddToMenu()
    LulzMenu.Draw.RSettings:addParam("BaseUlt", "Draw baseult tracker", 1, true)

    LulzMenu.Spell.QMenu:addParam("EnableCombo", "Use in combo", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableHarass", "Use in harass", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableClear", "Use in clear", SCRIPT_PARAM_LIST, 1,{"Off","Last Hit","Clear"})
    LulzMenu.Spell.QMenu:addParam("EnableJungle", "Use in jungle", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableKs", "Use to KS", 1, true)
    LulzMenu.Spell.QMenu:addParam("EnableFlee", "Use to flee with iceborn", 1, true)
    LulzMenu.Spell.QMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.QMenu:addParam("HarassMana", "Harass mana managment % >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
    LulzMenu.Spell.QMenu:addParam("ClearMana", "Lane clear mana managment % >", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
    LulzMenu.Spell.QMenu:addParam("PlaceHolder2", "", SCRIPT_PARAM_INFO, "")
    Prediction:AddToMenu(LulzMenu.Spell.QMenu)

    LulzMenu.Spell.WMenu:addParam("EnableCombo", "Use in combo", 1, true)
    LulzMenu.Spell.WMenu:addParam("EnableHarass", "Use in harass", 1, false)
    LulzMenu.Spell.WMenu:addParam("EnableClear", "Use in clear", 1, false)
    LulzMenu.Spell.WMenu:addParam("EnableKs", "Use to KS", 1, true)
    LulzMenu.Spell.WMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.WMenu:addParam("HarassMana", "Harass mana managment % >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
    LulzMenu.Spell.WMenu:addParam("ClearMana", "Lane clear mana managment % >", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
    LulzMenu.Spell.WMenu:addParam("PlaceHolder2", "", SCRIPT_PARAM_INFO, "")
    Prediction:AddToMenu(LulzMenu.Spell.WMenu)

    LulzMenu.Spell.EMenu:addParam("Enable", "Use as gap closer", SCRIPT_PARAM_LIST, 1,{"Never", "Combo", "Combo+Harass"})
    LulzMenu.Spell.EMenu:addParam("EnableKs", "Use to KS", 1, true)
    LulzMenu.Spell.EMenu:addParam("EnableFlee", "Use to flee", 1, true)
    LulzMenu.Spell.EMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.EMenu:addParam("HarassMana", "Harass mana managment % >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    LulzMenu.Spell.RMenu:addParam("EnableCombo", "Use in combo", 1, true)
    LulzMenu.Spell.RMenu:addParam("ComboRangeCheck", "Combo ult range check", SCRIPT_PARAM_SLICE, 800, 0, 9000, 0)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder44", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.RMenu:addParam("BaseUlt", "Enable base ult", 1, true)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder3", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Spell.RMenu:addParam("EnableSnipe", "Ult to global snipe", 1, true)
    LulzMenu.Spell.RMenu:addParam("SnipeRangeCheckMax", "Global snipe max range check", SCRIPT_PARAM_SLICE, 1500, 300, 9000, 0)
    LulzMenu.Spell.RMenu:setCallback("SnipeRangeCheckMax", function(v)
        LulzMenu.Spell.RMenu:removeParam("SnipeRangeCheckMin")
        LulzMenu.Spell.RMenu:addParam("SnipeRangeCheckMin", "Global snipe min range check", SCRIPT_PARAM_SLICE, 1500, 0, v, 0)
        if LulzMenu.Spell.RMenu.SnipeRangeCheckMin > v then LulzMenu.Spell.RMenu.SnipeRangeCheckMin = v - 300 end
    end)
    LulzMenu.Spell.RMenu:addParam("SnipeRangeCheckMin", "Global snipe min range check", SCRIPT_PARAM_SLICE, 1200, 0, 9000, 0)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder23", "", SCRIPT_PARAM_INFO, "")


    LulzMenu.Spell.RMenu:addParam("EnableInitiator", "Use on initiators", 1, true)
    LulzMenu.Spell.RMenu:addParam("InitiatorRangeCheck", "Initiators ult range check", SCRIPT_PARAM_SLICE, 2000, 0, 9000, 0)
    LulzMenu.Spell.RMenu:addParam("InitiateNum", "Min number of enemies to ult", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
    LulzMenu.Spell.RMenu:addParam("PlaceHolder2", "", SCRIPT_PARAM_INFO, "")
    Prediction:AddToMenu(LulzMenu.Spell.RMenu)
end
function Jinx:GetDamage(spell, unit)
    if spell == "ALL" then
        local sum = 0
          for spell, func in pairs(self.spellDmg) do
            sum = sum + (func(unit) or 0)
          end
         return sum
       else
          return self.spellDmg[spell](unit) or 0
       end
end
function Jinx:OnTick()
    self.QState = myHero:CanUseSpell(_Q) == READY
    self.WState = myHero:CanUseSpell(_W) == READY
    self.EState = myHero:CanUseSpell(_E) == READY
    self.RState = myHero:CanUseSpell(_R) == READY
    self.QToggle = GetSpellData(_Q).toggleState
    self.manaPercent = myHero.mana / myHero.maxMana * 100
    self.target = CTargetSelector:GetTarget()

    self:Combo()
    self:Harass()
    self:LaneClear()
    --self:KillSteal()
    self:FleeMode()
    --self:BaseUlt()
end
function Jinx:OnDraw()
    local function ReturnColor(color) return ARGB(color[1],color[2],color[3],color[4]) end
    local function BaseUltProgressBar(x, y, percent, text, tick)
        DrawRectangle(x, y - 5, 300, 40, ARGB(255,100,100,100))
        DrawRectangle(x + 5, y, 290, 30, ARGB(255,30,30,30))
        DrawRectangle(x + 5, y, (percent/100)*290, 30, ARGB(255,255,0,0))
        DrawRectangle(x + (6.9 / 7.9 * 290), y, (100/100)*290 - x + (6.9 / 7.9 * 290), 30, ARGB(100,30,30,30))
        if tick <= 100 then
            DrawRectangle(x + 5 + (tick/100)*290, y, 2, 30, ARGB(255,0,255,0))
        else
            DrawRectangle(x + 5 + (100/100)*290, y, 2, 30, ARGB(255,0,255,0))
        end
        DrawText(text,20,y + 8,x + 5,ARGB(255,255,255,255))
    end

    if not myHero.dead then
        if LulzMenu.Draw.AASettings.Enabled then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, myHero.range + myHero.boundingRadius, 1, ReturnColor(LulzMenu.Draw.AASettings.CircleColor), 100)
        end
        if LulzMenu.Draw.QSettings.Enabled and (self.QState or not LulzMenu.Draw.QSettings.Hide) then
            --DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.Q.range, 1, ReturnColor(LulzMenu.Draw.QSettings.CircleColor), 100)
        end
        if LulzMenu.Draw.WSettings.Enabled and (self.WState or not LulzMenu.Draw.WSettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.W.range, 1, ReturnColor(LulzMenu.Draw.WSettings.CircleColor), 100)
        end
        if LulzMenu.Draw.ESettings.Enabled and (self.EState or not LulzMenu.Draw.ESettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.E.range, 1, ReturnColor(LulzMenu.Draw.ESettings.CircleColor), 100)
        end
        if LulzMenu.Draw.ESettings.Enabled and (self.EState or not LulzMenu.Draw.ESettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.E.maxRange, 1, ReturnColor(LulzMenu.Draw.ESettings.CircleColor), 100)
        end
        if LulzMenu.Draw.RSettings.Enabled and (self.RState or not LulzMenu.Draw.RSettings.Hide) then
            DrawCircleMinimap(myHero.x, myHero.y, myHero.z, LulzMenu.Spell.RMenu.SnipeRangeCheckMax, 1, ReturnColor(LulzMenu.Draw.RSettings.CircleColor), 50)
            DrawCircleMinimap(myHero.x, myHero.y, myHero.z, LulzMenu.Spell.RMenu.SnipeRangeCheckMin, 1, ReturnColor(LulzMenu.Draw.RSettings.CircleColor), 50)
            for i, enemy in pairs(self.enemyHeros) do
                if enemy and ValidTarget(enemy) then
                    if self.RState and self:GetDamage(_R,enemy) > enemy.health and GetDistance(enemy) < LulzMenu.Spell.RMenu.SnipeRangeCheckMax and GetDistance(enemy) > LulzMenu.Spell.RMenu.SnipeRangeCheckMin then
                        DrawTextA("You can kill 1 or more enemies, Hold your Force ult key!", 25, WINDOW_H / 2, 50, ARGB(255,255,0,0), "center", "center")
                    end
                end
            end
        end
        if LulzMenu.Draw.DrawTarget then
            if ValidTarget(self.target) then
                DrawCircle3D(self.target.x, self.target.y, self.target.z, 100, 1, ARGB(255,255,0,0), 100)
            end
        end
        if LulzMenu.Spell.RMenu.BaseUlt and LulzMenu.Draw.RSettings.BaseUlt then
            for i, enemy in pairs(self.activeRecalls) do
                 if self:BaseUltPredictIfUltCanKill(enemy) then
                     BaseUltProgressBar(500,500,(enemy.endT - os.clock()) / 7.9 * 100, enemy.name, ((GetDistance(myHero, self:BaseUltGetBaseCoords()) / 2500) + 1.5) / 8 * 100)
                 end
            end
        end
    end
end
function Jinx:BaseUltGetBaseCoords()
    if myHero.team == 100 then
        return self.BaseSpots[2]
    else
        return self.BaseSpots[1]
    end
end
function Jinx:BaseUltPredictIfUltCanKill(target)
    if myHero.charName == "Ezreal" or myHero.charName == "Jinx" or myHero.charName == "Draven" or myHero.charName == "Ashe" then
        if self:GetDamage(_R, target.object) > target.startHP + (target.hpRegen * 7.9)  then
            return true
        else
            return false
        end
    end
end
function Jinx:CastQ(enemy)
    if self.QState then
        if (GetDistanceSqr(enemy) > math.pow(myHero.range + myHero.boundingRadius,2) and self.QToggle == 1) or (GetDistanceSqr(enemy) < math.pow(myHero.range + myHero.boundingRadius,2) and self.QToggle == 2) then
            CastSpell(_Q)
        end
    end
end
function Jinx:CastW(enemy)
    local CastPosition, HitChance, Info = Prediction:GetLineCastPosition(enemy, self.SpellTable.W, "W")
    if CastPosition and HitChance >= LulzMenu.Spell.WMenu.Accuracy then
        CastSpell(_W, CastPosition.x, CastPosition.z)
    end
end
function Jinx:CastE(x,z)
    if self.EState then
        CastSpell(_E, x, z)
    end
end
function Jinx:CastR(enemy)
    local CastPosition, HitChance, Info = Prediction:GetLineCastPosition(enemy, self.SpellTable.R)
    if CastPosition and HitChance >= LulzMenu.Spell.RMenu.Accuracy then
        CastSpell(_R, CastPosition.x, CastPosition.z)
    end
end
function Jinx:Combo()
    if Orbwalker:IsFighting() then
        if ValidTarget(self.target) then
            if self.QState then
                self:CastQ(self.target)
            end

            if self.WState then
                self:CastW(self.target)
            end
        end
    end
end
function Jinx:Harass()
    if Orbwalker:IsHarassing() then
        if ValidTarget(self.target) then
            if self.QState and LulzMenu.Spell.QMenu.EnableHarass then
                self:CastQ(self.target)
            end

            if self.WState and LulzMenu.Spell.WMenu.EnableHarass then
                self:CastW(self.target)
            end
        end
    end
end
function Jinx:LaneClear()
    if Orbwalker:IsLaneClearing() then
        if LulzMenu.Spell.QMenu.EnableJungle then
            self.jungleMinions:update()

            if self.QState then
                for i, jungle in pairs(self.jungleMinions.objects) do
                    if jungle ~= nil and ValidTarget(jungle) and GetDistance(jungle) < self.SpellTable.Q.range and string.split(jungle.charName,'_')[2] ~= "Plant" then
                        self:CastQ(jungle)
                    end
                end
            end
        end

        if LulzMenu.Spell.QMenu.EnableClear > 1 then
            self.enemyMinions:update()
            if self.QState then
                for i, minion in pairs(self.enemyMinions.objects) do
                    if minion ~= nil and ValidTarget(minion) and GetDistance(minion) < self.SpellTable.Q.range then
                        if LulzMenu.Spell.QMenu.EnableClear == 3 then
                            self:CastQ(minion)
                        else
                            if self:GetDamage(_Q, minion) > minion.health then
                                self:CastQ(minion)
                            end
                        end
                    end
                end
            end
        end
    end
end
function Jinx:KillSteal()
    for i, enemy in pairs(self.enemyHeros) do
        if enemy and ValidTarget(enemy) then
            if LulzMenu.Spell.EMenu.EnableKs then
                if GetDistance(enemy) > self.SpellTable.Q.range and GetDistance(enemy) < (self.SpellTable.Q.range + self.SpellTable.E.range) then
                    if enemy.health < (getDmg("Q", enemy, myHero)+((myHero.damage)*1.1)+(myHero.ap*0.4)) then
                        local p = myHero + (Vector(enemy.pos) - myHero):normalized() * 475
                        self:CastE(p.x,p.z)
                        DelayAction((function() self:CastQ(enemy) end), .3)

                    end
                end
            end

            if LulzMenu.Spell.QMenu.EnableKs then
                if self:GetDamage(_Q, enemy) > enemy.health and enemy.health < self:GetDamage(_W, enemy) then
                    self:CastQ(enemy)
                end
            end

            if LulzMenu.Spell.WMenu.EnableKs then
                if self:GetDamage(_Q, enemy) < enemy.health and enemy.health > self:GetDamage(_W, enemy) then
                    self:CastW(enemy)
                end
            end

            if LulzMenu.Hotkeys.ForceUlt then
                if self.RState and self:GetDamage(_R, enemy) > enemy.health and GetDistance(enemy) < LulzMenu.Spell.RMenu.SnipeRangeCheckMax and GetDistance(enemy) > LulzMenu.Spell.RMenu.SnipeRangeCheckMin then
                    self:CastR(enemy)
                end
            end
        end
    end
end
function Jinx:FleeMode()
    if LulzMenu.Hotkeys.FleeKey then
        myHero:MoveTo(mousePos.x, mousePos.z)

        if LulzMenu.Spell.QMenu.EnableFlee then
            if ItemsAndSummoners:HasItem(3025) then
                --self:CastQ(self.target)
            end
        end
    end
end


class "Yasuo"
function Yasuo:__init()
    self.QState, self.WState, self.EState , self.RState = nil, nil, nil, nil
    self.spellExpired = true
    self.SpellTable = {
        Q = {range = 475, speed = huge, delay = 0.20, width = 40, collision = false},
       Q3 = {range = 1050, speed = 2200, delay = 0.20, width = 70, collision = false},
        W = {range = 400, speed = 2000, delay = 0.012, width = 85, collision = true},
        E = {range = 475, speed = 2000, delay = 0.25, width = 80, collision = true},
        R = {range = 1200, speed = 1350, delay = 0.25, width = 85, collision = false},
    }
    self.spellDmg = {
        [_Q] = function(unit) if self.QState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_Q).level * 20)) + (myHero.totalDamage * 1)))) end end,
        [_E] = function(unit) if self.EState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_E).level * 20) + 50) + (myHero.ap * 0.6)))) end end,
        [_R] = function(unit) if self.RState then return myHero:CalcMagicDamage(unit, ((((myHero:GetSpellData(_R).level * 225) + 25) + (myHero.addDamage * 2)))) end end,
    }
    self.autoWall = {
        ['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
        ['Aatrox']      = {true, spell = _E,                  range = 1000,  projSpeed = 1000, },
        ['Ahri']        = {true, spell = _E,                  range = 950,   projSpeed = 1500, },
        ['Amumu']       = {true, spell = _Q,                  range = 1100,  projSpeed = 2000, },
        ['Amumu']       = {true, spell = _R,                  range = 550,   projSpeed = huge, },
        ['Anivia']      = {true, spell = _Q,                  range = 1075,  projSpeed = 850, },
        ['Annie']       = {true, spell = _Q,                  range = 625,   projSpeed = huge, },
        ['Annie']       = {true, spell = _W,                  range = 625,   projSpeed = huge, },
        --['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, },
        --['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, },
        ['Ashe']        = {true, spell = _R,                  range = 20000, projSpeed = 1600, },
        ['Azir']        = {true, spell = _R,                  range = 500,   projSpeed = 1600, },
        ['Blitzcrank']  = {true, spell = _Q,                  range = 925,   projSpeed = 1800, },
        ['Brand']       = {true, spell = _R,                  range = 750,   projSpeed = 780, },
        ['Braum']       = {true, spell = _R,                  range = 1250,  projSpeed = 1600, },
        ['Caitlyn']     = {true, spell = _R,                  range = 3000,  projSpeed = huge, },
        ['Cassiopeia']  = {true, spell = _R,                  range = 825,   projSpeed = huge, },
        ['Chogath']     = {true, spell = _Q,                  range = 950,   projSpeed = huge, },
        ['Corki']       = {true, spell = _Q,                  range = 825,   projSpeed = 1125, },
        ['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, },
        ['Darius']      = {true, spell = _E,                  range = 540,   projSpeed = 1500, },
        ['Darius']      = {true, spell = _R,                  range = 480,   projSpeed = huge, },
        ['Ezrael']      = {true, spell = _R,                  range = 20000, projSpeed = 2000, },
        ['Fiora']       = {true, spell = _R,                  range = 400,   projSpeed = huge, },
        ['Fizz']        = {true, spell = _R,                  range = 1200,  projSpeed = 1200, },
        ['Gangplank']   = {true, spell = _Q,                  range = 620,   projSpeed = huge, },
        ['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
        ['Gragas']      = {true, spell = _R,                  range = 800,   projSpeed = 1300, },
        ['Graves']      = {true, spell = _R,                  range = 1100,  projSpeed = 2100, },
        ['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
        --['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, },
        ['Irelia']      = {true, spell = _E,                  range = 425,   projSpeed = huge, },
        --['JarvanIV']    = {true, spell = jarvanAddition,      range = 770,   projSpeed = 2000, },
        ['Jax']         = {true, spell = _E,                  range = 250,   projSpeed = huge, },
        ['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, },
        ['Jinx']        = {true, spell = _R,                  range = 20000, projSpeed = 1700, },
        ['Kayle']       = {true, spell = _Q,                  range = 600,   projSpeed = huge, },
        ['Kennen']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1700, },
        ['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
        ['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
        ['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
        ['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
        ['Leona']       = {true, spell = _R,                  range = 1100,  projSpeed = huge, },
        ['Lulu']        = {true, spell = _Q,                  range = 950,   projSpeed = 1600, },
        ['Lux']         = {true, spell = _Q,                  range = 1300,  projSpeed = 1200, },
        --['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500 + unit.ms},
        ['Maokai']      = {true, spell = _Q,                  range = 600,   projSpeed = 1200, },
        ['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, },
        ['Morgana']     = {true, spell = _Q,                  range = 1175,  projSpeed = 1200, },
        ['Nocturne']    = {true, spell = _R,                  range = 2000,  projSpeed = 500, },
        ['Orianna']     = {true, spell = _Q,                  range = 825,   projSpeed = 1200, },
        ['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
        ['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, },
        ['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
        ['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
        ['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
        ['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
        ['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
        ['Twistedfate'] = {true, spell = _W,                  range = 525,   projSpeed = huge, },
        ['Vayne']       = {true, spell = _E,                  range = 550,   projSpeed = huge, },
        ['Veigar']      = {true, spell = _R,                  range = 700,   projSpeed = huge, },
        ['Vi']          = {true, spell = _R,                  range = 600,   projSpeed = 1200, },
        ['Xerath']      = {true, spell = _E,                  range = 1000,  projSpeed = 1200, },
        ['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, },
        ['Yasuo']       = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
        ['Zyra']        = {true, spell = _E,                  range = 1175,  projSpeed = 1400, },
        ['Swain']       = {true, spell = _W,                  range = 900,  projSpeed = huge, },
    }
    self.enemyHeros = GetEnemyHeroes()
    self.enemyMinions = minionManager(MINION_ENEMY, self.SpellTable.Q3.range, myHero, MINION_SORT_HEALTH_ASC)
    self.jungleMinions = minionManager(MINION_JUNGLE, 625, myHero, MINION_SORT_MAXHEALTH_ASC)
    self.informationTable = {}
    self.dashTable = {}

    local function championMenu()
        LulzMenu.Spell.QMenu:addParam("EnableCombo", "Use in combo", 1, true)
        LulzMenu.Spell.QMenu:addParam("EnableHarass", "Use in harass", 1, true)
        LulzMenu.Spell.QMenu:addParam("EnableClear", "Use in clear", SCRIPT_PARAM_LIST, 1,{"Off","Last Hit","Clear"})
        LulzMenu.Spell.QMenu:addParam("EnableJungle", "Use in jungle", 1, true)
        LulzMenu.Spell.QMenu:addParam("EnableKs", "Use to KS", 1, true)
        LulzMenu.Spell.QMenu:addParam("PlaceHolder", "", SCRIPT_PARAM_INFO, "")
        LulzMenu.Spell.QMenu:addParam("HarassMana", "Harass mana managment % >", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
        LulzMenu.Spell.QMenu:addParam("ClearMana", "Lane clear mana managment % >", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
        LulzMenu.Spell.QMenu:addParam("PlaceHolder2", "", SCRIPT_PARAM_INFO, "")

        LulzMenu.Spell.WMenu:addParam("Enable", "Auto wind wall", SCRIPT_PARAM_LIST, 4,{"Off","Combo","Combo+Harass","Always"})
        LulzMenu.Spell.WMenu:addParam("EnableFlee", "Use in flee", 1, true)
        LulzMenu.Spell.WMenu:addParam("EnableJungle", "Use in jungle", 1, true)

        LulzMenu.Spell.EMenu:addParam("EnableCombo", "Use in combo", 1, true)
        LulzMenu.Spell.EMenu:addParam("EnableHarass", "Use in harass", 1, false)
        LulzMenu.Spell.EMenu:addParam("EnableJungle", "Use in jungle", SCRIPT_PARAM_LIST, 3,{"Off","Everything","Everything expect dragon and baron"})
        LulzMenu.Spell.EMenu:addParam("EnableClear", "Use in clear", SCRIPT_PARAM_LIST, 3,{"Off","Push","Lasthit"})
        LulzMenu.Spell.EMenu:addParam("EnableFlee", "Use in flee", 1, true)
        LulzMenu.Spell.EMenu:addParam("EnableKS", "Use to KS", 1, true)

        LulzMenu.Spell.RMenu:addParam("AutoUlt", "Auto ult to execute", 1, true)
        LulzMenu.Spell.RMenu:addParam("EnableCombo", "Use in combo", 1, true)

        _G.Prediction:AddToMenu(LulzMenu.Spell.QMenu)
    end

    championMenu()
    AddDrawCallback(function() self:OnDraw() end)
    AddTickCallback(function() self:OnTick() end)
    AddApplyBuffCallback(function(source, unit, buff) self:UltHelper(source, unit, buff) end)
    AddProcessSpellCallback(function(unit, spell) self:AutoWall(unit, spell) end)
end
function Yasuo:GapCloseMinion(Target)
    self.enemyMinions:update()
    local LineEnd = myHero + (Vector(Target) - myHero):normalized() * GetDistance(Target)
    local n = 0
    for i, minion in pairs(self.enemyMinions.objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(Vector(myHero), LineEnd, minion)
        if isOnSegment and GetDistance(minion, pointSegment) <= 85*1.25 then
            if GetDistance(minion) < self.SpellTable.E.range then
                return minion
            end
        end
    end
end
function Yasuo:OnDraw()
    local function ReturnColor(color) return ARGB(color[1],color[2],color[3],color[4]) end
    if not myHero.dead then
        if LulzMenu.Draw.AASettings.Enabled then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, myHero.range + myHero.boundingRadius, 1, ReturnColor(LulzMenu.Draw.AASettings.CircleColor), 100)
        end
        if LulzMenu.Draw.QSettings.Enabled and (self.QState or not LulzMenu.Draw.QSettings.Hide) then
            if myHero:GetSpellData(_Q).name == "YasuoQW" or myHero:GetSpellData(_Q).name == "YasuoQ2W" then
                DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.Q.range, 1, ReturnColor(LulzMenu.Draw.QSettings.CircleColor), 100)
            elseif myHero:GetSpellData(_Q).name == "YasuoQ3W" then
                DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.Q3.range, 1, ReturnColor(LulzMenu.Draw.QSettings.CircleColor), 100)
            end
        end
        if LulzMenu.Draw.WSettings.Enabled and (self.WState or not LulzMenu.Draw.WSettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.W.range, 1, ReturnColor(LulzMenu.Draw.WSettings.CircleColor), 100)
        end
        if LulzMenu.Draw.ESettings.Enabled and (self.EState or not LulzMenu.Draw.ESettings.Hide) then
            RenderCircle(self.SpellTable.E.range,LulzMenu.Draw.ESettings)
            --DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.E.range, 1, ReturnColor(LulzMenu.Draw.ESettings.CircleColor), 100)
        end
        if LulzMenu.Draw.RSettings.Enabled and (self.RState or not LulzMenu.Draw.RSettings.Hide) then
            DrawCircle3D(myHero.x, myHero.y, myHero.z, self.SpellTable.R.range, 1, ReturnColor(LulzMenu.Draw.RSettings.CircleColor), 100)
        end
        if LulzMenu.Draw.DrawTarget then
            if Target ~= nil then
                DrawCircle3D(Target.x, Target.y, Target.z, 100, 1, ARGB(255,255,0,0), 100)
            end
        end
    end
end
function Yasuo:OnTick()
    self.QState = myHero:CanUseSpell(_Q) == READY
    self.WState = myHero:CanUseSpell(_W) == READY
    self.EState = myHero:CanUseSpell(_E) == READY
    self.RState = myHero:CanUseSpell(_R) == READY
    _G.Target = CTargetSelector:GetTarget()
    self:Combo()
    --self:Harass()
    self:LaneClear()
    self:SpellExpired()
    --self:GetToLaneFaster()
    --self:KillSteal()
    --self:FleeMode()
    --self:TearStack()
    --self:UltBardR()
end
function Yasuo:GetDamage(spell, unit)
    if spell == "ALL" then
        local sum = 0
          for spell, func in pairs(spellDmg) do
            sum = sum + (func(unit) or 0)
          end
         return sum
       else
          return self.spellDmg[spell](unit) or 0
       end
end
function Yasuo:Combo()
    if Orbwalker:IsFighting() then
        if ValidTarget(Target) then
            if GetDistance(Target) > myHero.range + myHero.boundingRadius + 100 then
                local m = self:GapCloseMinion(Target)
                if ValidTarget(m) then
                    self:CastE(m)
                end
            end
            if LulzMenu.Spell.EMenu.EnableCombo then self:CastE(Target) end
            if LulzMenu.Spell.QMenu.EnableCombo then self:CastQ(Target) end
        end
    end
end
function Yasuo:LaneClear()
    if Orbwalker:IsLaneClearing() then
        self.enemyMinions:update()
        self.jungleMinions:update()

        if LulzMenu.Spell.WMenu.EnableJungle then
            if self.WState then
                for i, jungle in pairs(self.jungleMinions.objects) do
                    if jungle ~= nil and ValidTarget(jungle) and GetDistance(jungle) < self.SpellTable.E.range and  GetDistance(jungle) > 350 and string.split(jungle.charName,'_')[2] == "Dragon" or self.SpellTable.E.range and string.split(jungle.charName,'_')[2] == "Baron" then
                        self:CastW(jungle)
                    end
                end
            end
        end
        if LulzMenu.Spell.QMenu.EnableJungle then
            if self.QState then
                for i, jungle in pairs(self.jungleMinions.objects) do
                    if jungle ~= nil and ValidTarget(jungle) and GetDistance(jungle) < self.SpellTable.Q.range and string.split(jungle.charName,'_')[2] ~= "Plant" then
                        self:CastQ(jungle)
                    end
                end
            end
        end
        if LulzMenu.Spell.EMenu.EnableJungle then
            if self.EState then
                for i, jungle in pairs(self.jungleMinions.objects) do
                    if jungle ~= nil and ValidTarget(jungle) and GetDistance(jungle) < self.SpellTable.E.range and string.split(jungle.charName,'_')[2] ~= "Plant" then
                        self:CastE(jungle)
                    end
                end
            end
        end

        if LulzMenu.Spell.QMenu.EnableClear > 1 then
            if self.QState then
				for i, minion in pairs(self.enemyMinions.objects) do
                    if LulzMenu.Spell.QMenu.EnableClear == 2 then
                        if self:GetDamage(_Q,minion) >= minion.health then
                            self:CastQ(minion)
                        end
                    else
                        self:CastQ(minion)
                    end
                end
            end
        end
        if LulzMenu.Spell.EMenu.EnableClear > 1 then
            if self.EState then
				for i, minion in pairs(self.enemyMinions.objects) do
                    if not UnderTurret((myHero + (Vector(minion) - myHero):normalized() * self.SpellTable.E.range)) then
                        if LulzMenu.Spell.EMenu.EnableClear == 3 then
                            if self:GetDamage(_E,minion) >= minion.health then
                                self:CastE(minion)
                            end
                        else
                            self:CastE(minion)
                        end
                    end
                end
            end
        end
    end
end
function Yasuo:CastQ(enemy)
    if self.QState then
        if myHero:GetSpellData(_Q).name == "YasuoQW" or myHero:GetSpellData(_Q).name == "YasuoQ2W" then
            local CastPosition, HitChance = Prediction:GetLineCastPosition(enemy, self.SpellTable.Q3)
            if CastPosition and HitChance >= LulzMenu.Spell.QMenu.Accuracy and GetDistance(enemy) <= self.SpellTable.Q.range then
                CastSpell(_Q, CastPosition.x, CastPosition.z)
            end
        elseif myHero:GetSpellData(_Q).name == "YasuoQ3W" then
            local CastPosition, HitChance = Prediction:GetLineCastPosition(enemy, self.SpellTable.Q3)
            if CastPosition and HitChance >= LulzMenu.Spell.QMenu.Accuracy then
                CastSpell(_Q, CastPosition.x, CastPosition.z)
            end
        end
    end
end
function Yasuo:CastE(enemy)
    local function hasEBuff(target)
        if self.dashTable[target.networkID] and self.dashTable[target.networkID] + (12 - myHero:GetSpellData(_Q).level) > clock() then
            return true
        elseif self.dashTable[target.networkID] then
            self.dashTable[target.networkID] = nil
        end
        return false
    end
    if self.EState then
        if GetDistance(enemy) <= self.SpellTable.E.range and not hasEBuff(enemy) then
            CastSpell(_E, enemy)
        end
    end
end
function Yasuo:CastW(enemy)
    if self.WState then
        CastSpell(_W, enemy.x, enemy.z)
    end
end
function Yasuo:CastR(enemy)
    if self.RState then
        if GetDistance(enemy) < self.SpellTable.R.range then
            CastSpell(_R, enemy)
        end
    end
end
function Yasuo:UltHelper(source, unit, buff)
    if source.isMe and buff.name == "YasuoDashWrapper" then
        self.dashTable[unit.networkID] = clock()
    end
	if not buff or not source or not source.valid or not unit or not unit.valid then return end
    if LulzMenu.Spell.RMenu.AutoUlt or (LulzMenu.Spell.RMenu.EnableCombo and Orbwalker:IsFighting()) then
        if buff.type == 29 and GetDistance(unit) < self.SpellTable.R.range then
            self:CastR(unit)
        end
    end
end
function Yasuo:AutoWall(unit, spell)
    if self.EState then
        if unit.type == myHero.type and unit.team ~= myHero.team and self.autoWall[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then
            print("here1")
            if unit:GetSpellData(self.autoWall[unit.charName].spell).name or self.autoWall[unit.charName].spell then
                print("here2")
                if spell.target ~= nil and spell.target.isMe then
                    print("here")
                    if self.EState  then
                        self:CastW(unit)
                    end
                else

                    self.spellExpired = false
                    self.informationTable = {
                        spellSource = unit,
                        spellCastedTick = GetTickCount(),
                        spellStartPos = Point(spell.startPos.x, spell.startPos.z),
                        spellEndPos = Point(spell.endPos.x, spell.endPos.z),
                        spellRange = self.autoWall[unit.charName].range,
                        spellSpeed = self.autoWall[unit.charName].projSpeed
                    }
                end
            end
        end
    end
end
function Yasuo:SpellExpired()
    if not self.spellExpired and (GetTickCount() - self.informationTable.spellCastedTick) <= (self.informationTable.spellRange / self.informationTable.spellSpeed) * 1000 then
        local spellDirection     = (self.informationTable.spellEndPos - self.informationTable.spellStartPos):normalized()
        local spellStartPosition = self.informationTable.spellStartPos + spellDirection
        local spellEndPosition   = self.informationTable.spellStartPos + spellDirection * self.informationTable.spellRange
        local heroPosition = Point(myHero.x, myHero.z)
        local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))

        if lineSegment:distance(heroPosition) <= 350 and self.EState then
            self:CastW(self.informationTable.spellSource)
        end
    else
        self.spellExpired = true
        self.informationTable = {}
    end
end

class "ItemsAndSummoners"
function ItemsAndSummoners:__init()
    local function GetSummonerSpellFromName(name)
    	if myHero:GetSpellData(SUMMONER_1).name:lower():find(name:lower()) then
    		return SUMMONER_1
    	elseif myHero:GetSpellData(SUMMONER_2).name:lower():find(name:lower()) then
    		return SUMMONER_2
    	end
    end

    self.itemsAndSpells = {
        ["Potions"] = {"RegenerationPotion","ItemCrystalFlask","ItemDarkCrystalFlask","ItemCrystalFlaskJungle","ItemMiniRegenPotion"},
        ["OffensiveItems"] = {
            {"BilgewaterCutlass", 550, true},
            {"ItemSwordOfFeastAndFamine", 550, true},
            {"HextechGunblade", 700, true},
            {"YoumusBlade", 600, false},
            {"ItemVeilChannel",700, false},
            {"ItemSoFBoltSpellBase", 550, true}
        },
        ["DefensiveItems"] = {"ZhonyasHourglass", "RanduinsOmen", "ArchAngelsDummySpell"},
        ["CleanseItems"] = {"ItemMercurial", "QuicksilverSash"},
        ["Wards"] = {"ItemGhostWard","TrinketOrbLvl3","TrinketTotemLvl1"},
        ["Cooldowns"] = {
            ["LastPotion"] = 0
        },
        ["SummonerSpells"] = {
            ["Ignite"] = GetSummonerSpellFromName("SummonerDot"),
            ["Exaughst"] = GetSummonerSpellFromName("SummonerExhaust"),
            ["Heal"] = GetSummonerSpellFromName("SummonerHeal"),
            ["Ghost"] = GetSummonerSpellFromName("SummonerHaste"),
            ["Cleanse"] = GetSummonerSpellFromName("SummonerBoost"),
            ["Flash"] = GetSummonerSpellFromName("SummonerFlash"),
            ["Barrier"] = GetSummonerSpellFromName("SummonerBarrier"),
            ["Smite"] = GetSummonerSpellFromName("SummonerSmite")
        }
    }
    ItemsAndSummoners.enemyHeroes = GetEnemyHeroes()
    self.allyHeroes = GetAllyHeroes()
    self.lastTAttack = 0
    self.tDamage = 1
    self.lastRemove = 0
    self.firstBuy = true
    self.enemies = {}
	self.tick = 0
    self.killCount = myHero.kills

    self.jungleMinions = minionManager(MINION_JUNGLE, 625, myHero, MINION_SORT_MINHEALTH_DEC)
    for _, k in pairs(GetEnemyHeroes()) do
		self.enemies[k.networkID] = {k.visible, Vector(k), clock() + 1, Vector(k.path:Path(2))}
	end

    LulzMenu.Spell:addSubMenu("Summoner Spells Menu", "SummonerSpellsMenu")
    LulzMenu.Spell:addSubMenu("Masteries Menu", "MasteriesMenu")
        LulzMenu.Spell.MasteriesMenu:addParam("FerocityMasteries", "Ferocity Masteries", SCRIPT_PARAM_LIST, 1,{"None","Bounty Hunter","Double Edged Sword","Battle Trance"})
        LulzMenu.Spell.MasteriesMenu:addParam("Merciless", "Merciless", 1, false)
        LulzMenu.Spell.MasteriesMenu:addParam("Savagry", "Savagry", SCRIPT_PARAM_SLICE, 0, 0, 5, 0)

    AddLoadCallback(function() self:PrepSummonerSpells() end)

    AddTickCallback(function() self:OnTick() end)
    AddDrawCallback(function() self:AutoSmiteDraw() end)
    AddCastSpellCallback(function(iSpell, vStart, vEnd, target) self:FlashProtection(iSpell, vStart, vEnd, target) end)
    AddProcessAttackCallback(function(unit, spell) self:ProtectFromTower(unit, spell) end)
    AddProcessSpellCallback(function(unit, spell) self:SpellProtection(unit, spell) end)
	AddApplyBuffCallback(function(source, unit, buff) self:CleanseCC(source, unit, buff) end)
end
function ItemsAndSummoners:PrepSummonerSpells()
    if self.itemsAndSpells.SummonerSpells.Ignite then
        LulzMenu.Spell.SummonerSpellsMenu:addParam("SmartIgnite", "Use smart ignite", SCRIPT_PARAM_LIST, 2, {"Never", "Optimal", "Aggressive"})
    end
    if self.itemsAndSpells.SummonerSpells.Exaughst then
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Exaughst", "Use exaughst", SCRIPT_PARAM_LIST, 4, {"Never", "High AP", "High AD", "Target"})
    end
    if self.itemsAndSpells.SummonerSpells.Heal then
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Heal", "Use heal", 1, true)
        LulzMenu.Spell.SummonerSpellsMenu:addParam("HealAlly", "Use heal on ally", 1, true)
        LulzMenu.Spell.SummonerSpellsMenu:addParam("HealToChase", "Use heal to secure kill", 1, true)
        LulzMenu.Spell.SummonerSpellsMenu:addParam("HealthPercent", "If my health % is <", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
    end
    if self.itemsAndSpells.SummonerSpells.Ghost then
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Ghost", "Use ghost to chase", SCRIPT_PARAM_LIST, 2, {"Never", "Optimal", "Aggressive"})
    end
    if self.itemsAndSpells.SummonerSpells.Flash then
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Flash", "Block flash fails", 1, false)
    end
    if self.itemsAndSpells.SummonerSpells.Barrier then
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Barrier", "Use barrier", 1, true)
        LulzMenu.Spell.SummonerSpellsMenu:addParam("HealthPercent", "If my health % is <", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
    end
    if self.itemsAndSpells.SummonerSpells.Cleanse then
        LulzMenu.Items.CleanseSettings:addParam("Cleanse", "Use Cleanse Summoner", SCRIPT_PARAM_ONOFF, true)
    end
    if self.itemsAndSpells.SummonerSpells.Smite then
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Smite", "Use smite", SCRIPT_PARAM_ONOFF, true)
		LulzMenu.Spell.SummonerSpellsMenu:addParam("DrawSmite", "Draw smite range", SCRIPT_PARAM_ONOFF, true)
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Dragon", "Use Smite on: Dragon", SCRIPT_PARAM_ONOFF, true)
		LulzMenu.Spell.SummonerSpellsMenu:addParam("Baron", "Use Smite on: Baron", SCRIPT_PARAM_ONOFF, true)
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Red", "Use Smite on: Red Buff", SCRIPT_PARAM_ONOFF, true)
		LulzMenu.Spell.SummonerSpellsMenu:addParam("Blue", "Use Smite on: Blue Buff", SCRIPT_PARAM_ONOFF, true)
        LulzMenu.Spell.SummonerSpellsMenu:addParam("Crab", "Use Smite on: Rift Scuttler", SCRIPT_PARAM_ONOFF, false)
		LulzMenu.Spell.SummonerSpellsMenu:addParam("Razorbeak", "Use Smite on: Wraith", SCRIPT_PARAM_ONOFF, false)
		LulzMenu.Spell.SummonerSpellsMenu:addParam("Murkwolf", "Use Smite on: Wolf", SCRIPT_PARAM_ONOFF, false)
		LulzMenu.Spell.SummonerSpellsMenu:addParam("Krug", "Use Smite on: Krug", SCRIPT_PARAM_ONOFF, false)
		LulzMenu.Spell.SummonerSpellsMenu:addParam("Gromp", "Use Smite on: Gromp", SCRIPT_PARAM_ONOFF, false)
    end
end
function ItemsAndSummoners:OnTick()
    if not myHero.dead then
        self:UsePotion()
        self:HealToChase()
        self:AutoIgnite()
        self:UseItems()
        self:AutoLeveler()
        self:AutoBuy()
        self:AutoHeal()
        self:SightWard(self.enemies, self.tick)
        self:AutoSmite()
        self:TauntOnKill()
    end
end
function ItemsAndSummoners:HasItem(id)
  local itemSlot = GetInventorySlotItem(id)
  if itemSlot ~= nil then
    return true
  else
    return false
  end
end
function ItemsAndSummoners:GetSlotItemFromName(itemname)
	for i = 6, 12 do
		local item = myHero:GetSpellData(i).name
		if item and item:lower():find(itemname:lower()) and myHero:CanUseSpell(i) == READY then
			return i
		end
	end
	return nil
end
function ItemsAndSummoners:isFleeingFromMe(target, range)
    fpos = Prediction:GetPredictedPosistion(target, 0.26)
	if fpos and GetDistanceSqr(fpos) > range*range then
		return true
	end
	return false
end
function ItemsAndSummoners:FlashProtection(iSpell, vStart, vEnd, target)
    if self.itemsAndSpells.SummonerSpells.Flash and LulzMenu.Spell.SummonerSpellsMenu.Flash then
        if myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Flash) == READY then
            local correctedMouse1 = myHero + (Vector(mousePos) - myHero):normalized() * (GetDistance(myHero, mousePos) + 30)
            local correctedMouse2 = myHero + (Vector(mousePos) - myHero):normalized() * 480
            local correctedMouseD3d = D3DXVECTOR3(correctedMouse2.x,correctedMouse2.y,correctedMouse2.z)
            local correctedMouseD3d2 = D3DXVECTOR3(correctedMouse1.x,correctedMouse1.y,correctedMouse1.z)
            if GetDistance(myHero, mousePos) > 450 then
                if IsWall(correctedMouseD3d) then
                    if iSpell == self.itemsAndSpells.SummonerSpells.Flash then
                		BlockSpell()
                	end
                end
            else
                if IsWall(correctedMouseD3d2) then
                    if iSpell == self.itemsAndSpells.SummonerSpells.Flash then
                		BlockSpell()
                	end
                end
            end
        end
    end
end
function ItemsAndSummoners:UsePotion()
    if not myHero.dead then
        if LulzMenu.Items.AutoPotion == 2 and Orbwalker:IsFighting() or LulzMenu.Items.AutoPotion == 3 then
        	if clock() - self.itemsAndSpells.Cooldowns.LastPotion < 8 then return end
            if LulzMenu.Items.HealthPercent >= (myHero.health / myHero.maxHealth * 100) then
                for i = 1, 5 do
                    if self:GetSlotItemFromName(self.itemsAndSpells.Potions[i]) ~= nil then
                        CastSpell(self:GetSlotItemFromName(self.itemsAndSpells.Potions[i]))
                		self.itemsAndSpells.Cooldowns.LastPotion= clock()
                    end
                end
            end
        end
    end
end
function ItemsAndSummoners:AutoIgnite()
    if self.itemsAndSpells.SummonerSpells.Ignite and LulzMenu.Spell.SummonerSpellsMenu.SmartIgnite > 1 then
        if myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Ignite) == READY then
        	local IgniteDmg = 50 + (20 * myHero.level)
        	local aggro = LulzMenu.Spell.SummonerSpellsMenu.SmartIgnite == 3 and 0.05 or 0
        	for i, enemy in pairs(self.enemyHeroes) do
        		if ValidTarget(enemy, 600) then
        			local spellDamage = 0
        			local adDamage = myHero:CalcDamage(enemy, myHero.totalDamage)
        			spellDamage = spellDamage + adDamage
        			if myHero.health < myHero.maxHealth*(0.35+aggro) and enemy.health < enemy.maxHealth*(0.34+aggro)  and GetDistanceSqr(enemy) < 420 * 420 then
        				CastSpell(self.itemsAndSpells.SummonerSpells.Ignite, enemy)
        			end
        			local r = myHero.range+65
        			local trange = r < 575 and r or 575
        			if self:isFleeingFromMe(enemy, trange) then
        				if enemy.health < IgniteDmg + spellDamage  + 10 then
        					if myHero.ms < enemy.ms then
        						CastSpell(self.itemsAndSpells.SummonerSpells.Ignite, enemy)
        					end
        				end
        			end
        			if (GetDistanceSqr(enemy) > 160000 and (myHero.health+myHero.shield) < myHero.maxHealth*0.3) then
        				if enemy.health > spellDamage-(500*aggro) and enemy.health < IgniteDmg + spellDamage-(500*aggro)  then
        					CastSpell(self.itemsAndSpells.SummonerSpells.Ignite, enemy)
        				end
        			end
        		end
        	end
        end
    end
end
function ItemsAndSummoners:ProtectFromTower(unit, spell)
	if not unit or not unit.valid or not spell then return end
	if spell.target and spell.target.type == myHero.type and spell.target.team == myHero.team and (spell.name:lower():find("_turret_chaos") or spell.name:lower():find("_turret_order")) and not (spell.name:lower():find("4") or spell.name:lower():find("3")) then
		if GetDistance(unit) < 2000 then
			if clock() - self.lastTAttack < 1.75 then
				if self.tDamage < 1.75 then
					self.tDamage = self.tDamage + 0.375
				else
					self.tDamage = self.tDamage + 0.250
					self.tDamage = self.tDamage > 2.25 and 2.25 or self.tDamage
				end
			else
				self.tDamage = 1
			end
			self.lastTAttack = clock()
            if self.itemsAndSpells.SummonerSpells.Heal then
                if (myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Heal) == 0) and spell.target.isMe then
    				local realDamage = unit.totalDamage / (((myHero.armor * 0.7) / 100) + 1)

    				if Prediction:GetPredictedHealth(myHero, 0.5) + myHero.shield <= realDamage * self.tDamage then
    					DelayAction(function()
    						CastSpell(self.itemsAndSpells.SummonerSpells.Heal)
                            Log("Saving you from tower")
    					end, 0.5)
    				end
    			end
            end

            if self.itemsAndSpells.SummonerSpells.Barrier then
                if (myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Barrier) == 0) and spell.target.isMe then
    				local realDamage = unit.totalDamage / (((myHero.armor * 0.7) / 100) + 1)

    				if Prediction:GetPredictedHealth(myHero, 0.5) + myHero.shield <= realDamage * self.tDamage then
    					DelayAction(function()
    						CastSpell(self.itemsAndSpells.SummonerSpells.Barrier)
                            Log("Saving you from tower")
    					end, 0.5)
    				end
    			end
            end

		end
	end
end
function ItemsAndSummoners:HealToChase()
    local function CalcDist(enemy)
    	local ourMS, targetMS = ((myHero.ms*1.30)),Target.ms
    	local msDiff = ourMS - targetMS
    	local adDamage = myHero:CalcDamage(Target, myHero.totalDamage)

    	if (GetDistance(enemy) - msDiff) < (myHero.range + myHero.boundingRadius) and (GetDistance(enemy) - msDiff) > (myHero.range + myHero.boundingRadius) - 20 and adDamage > enemy.health and msDiff > 0 then
    		return true
    	else
    		return false
    	end
    end

	if self.itemsAndSpells.SummonerSpells.Heal and LulzMenu.Spell.SummonerSpellsMenu.HealToChase then
        if myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Heal) == READY then
    		if ValidTarget(Target) and LulzMenu.Spell.SummonerSpellsMenu.HealToChase then
    			local ourMS, targetMS = myHero.ms,Target.ms
    			local adDamage = myHero:CalcDamage(Target, myHero.totalDamage)

    			if Orbwalker:IsFighting() then
    				local r = myHero.range+65
    				local trange = r < 575 and r or 575
    				if self:isFleeingFromMe(Target, trange) and CalcDist(Target) then
    					if not EREADY then
    						CastSpell(self.itemsAndSpells.SummonerSpells.Heal)
    					else
    						CastSpell(_E, Target.x, Target.z)
    					end
    				elseif EREADY and adDamage*2 > Target.health and GetDistance(Target) < (myHero.range + myHero.boundingRadius) + 475 then
    					CastSpell(_E, Target.x, Target.z)
    				end
    			end
    		end
        end
	end
end
function ItemsAndSummoners:AutoHeal()
	if self.itemsAndSpells.SummonerSpells.Heal and LulzMenu.Spell.SummonerSpellsMenu.Heal then
        if myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Heal) == READY then
    		if myHero.health / myHero.maxHealth * 100 <= LulzMenu.Spell.SummonerSpellsMenu.HealthPercent then
                CastSpell(self.itemsAndSpells.SummonerSpells.Heal)
            end

            if LulzMenu.Spell.SummonerSpellsMenu.HealAlly then
                for i,ally in pairs(self.allyHeroes) do
                    if GetDistance(ally) <= 850 then
                        if ally.health / ally.maxHealth * 100 <= LulzMenu.Spell.SummonerSpellsMenu.HealthPercent then
                            CastSpell(self.itemsAndSpells.SummonerSpells.Heal)
                        end
                    end
                end
            end
        end
	end
end
function ItemsAndSummoners:UseItems()
	if not ValidTarget(Target) and Target ~= myHero then return end
	for i=1,5 do
        self.itemSlot = self:GetSlotItemFromName(self.itemsAndSpells.OffensiveItems[i][1])
        if self.itemSlot ~= nil then
            if GetDistance(myHero, Target) <= self.itemsAndSpells.OffensiveItems[i][2] then
                if self.itemsAndSpells.OffensiveItems[i][3] == true then
                    CastSpell(self.itemSlot, Target)
                else
                    CastItem(self.itemSlot)
                end
            end
        end
	end
end
function ItemsAndSummoners:SpellProtection(unit, spell)
    local function CastZhonya()
    	if not myHero.dead and not TargetHaveBuff("kindredrnodeathbuff") and not TargetHaveBuff("judicatorinter") then
    		local item = GetSlotItemFromName("ZhonyasHourglass")
    		if item then
    			CastSpell(item)
    			return true
    		end
    	end
    end

    if not unit or not unit.valid or not spell then return end
	if heal and LulzMenu.Spell.SummonerSpellsMenu.Heal and myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Heal) == 0 and spell.target and spell.target.isMe and unit.team ~= myHero.team and unit.type == myHero.type then
		if myHero.health/myHero.maxHealth <= (LulzMenu.Spell.SummonerSpellsMenu.HealthPercent/100)*1.5 then
			CastSpell(self.itemsAndSpells.SummonerSpells.Heal)
		end
	end
	if spell.name:lower():find("zedr") and spell.target == myHero then
        if LulzMenu.Items.DefensiveItems.Enable then
    		DelayAction(function()
    		    CastZhonya()
    		end, .6)
        end
	end
end
function ItemsAndSummoners:CleanseCC(source, unit, buff)
    local function UseItemsCC()
    	if clock() - self.lastRemove < 1 then return end
        for i=1,2 do
            self.cleanseSlot = self:GetSlotItemFromName(self.itemsAndSpells.CleanseItems[i])
            if self.cleanseSlot ~= nil then
                DelayAction(function()
                    CastSpell(self.cleanseSlot,myHero)
                end, LulzMenu.Items.CleanseSettings.Delay/1000)
                self.lastRemove = clock()
            end
    	end


    	-- if MainMenu.cc.Summoner and SummonerSlot and myHero:CanUseSpell(SummonerSlot) == 0 then
    	-- 	DelayAction(function()
    	-- 		CastSpell(SummonerSlot)
    	-- 	end, MainMenu.cc.delay/1000)
    	-- 	lastRemove = clock()
    	-- end
    end
    local function CountEnemiesNearUnitReg(unit, range)
    	local count = 0
    	for i, enemy in pairs(ItemsAndSummoners.enemyHeroes) do
    		if enemy and enemy.valid and not enemy.dead and enemy.visible then
    			if  GetDistanceSqr(unit, enemy) < range * range  then
    				count = count + 1
    			end
    		end
    	end
    	return count
    end

    if not buff or not source or not source.valid or not unit or not unit.valid then return end
	if unit.isMe and (LulzMenu.Items.CleanseSettings.Enable == 3 or LulzMenu.Items.CleanseSettings.Enable == 2 and Orbwalker:IsFighting()) then
        if (source.charName == "Rammus" and buff.type ~= 8) or source.charName == "Alistar" or source.charName:lower():find("baron") or source.charName:lower():find("spiderboss") or source.charName == "LeeSin" or (source.charName == "Hecarim" and not buff.name:lower():find("fleeslow")) then return end
		if buff.name and ((not cleanse and buff.type == 24) or buff.type == 5 or buff.type == 11 or buff.type == 22 or buff.type == 21 or buff.type == 8) or (buff.type == 25 and LulzMenu.Items.CleanseSettings.Blind)
		or (buff.type == 10 and buff.name and buff.name:lower():find("fleeslow")) then
		--or (LulzMenu.Items.CleanseSettings.Exhaust and buff.name and buff.name:lower():find("summonerexhaust")) then
			if buff.name and buff.name:lower():find("caitlynyor") and CountEnemiesNearUnitReg(myHero, 700) == 0   then
				return false
			elseif not source.charName:lower():find("blitzcrank") then
				UseItemsCC()
			end
		end
	end
end
function ItemsAndSummoners:AutoLeveler()
	if LulzMenu.General.Level.Enable then
	if LulzMenu.General.Level.Ignore and myHero.level <= 3 then return end
		self.abilitySequence = {
            {1,3,1,2,1,4,1,3,1,3,4,3,3,2,2,4,2,2},
            {1,2,3,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3},
            {2,1,3,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3},
            {2,3,1,2,2,4,2,3,2,3,4,3,3,1,1,4,1,1}
        }
        autoLevelSetSequence(self.abilitySequence[LulzMenu.General.Level.Sequence])
	end
end
function ItemsAndSummoners:AutoBuy()
    if LulzMenu.General.Buy.StartingItems then
		if myHero.level <= 1 and self.firstBuy and InFountain() then
			BuyItem(1055)
            BuyItem(2003)
            BuyItem(3340)
			self.firstBuy = false
		end
	end

	if LulzMenu.General.Buy.TrinketSwitch > 1 then
		if myHero.level >= 9 and InFountain() and myHero:GetSpellData(ITEM_7).name ~= "TrinketOrbLvl3" and LulzMenu.General.Buy.TrinketSwitch == 2 then
			BuyItem(3363)
		end

        if myHero.level >= 9 and InFountain() and myHero:GetSpellData(ITEM_7).name ~= "TrinketSweeperLvl3" and LulzMenu.General.Buy.TrinketSwitch == 3 then
			BuyItem(3364)
		end
	end
end
function ItemsAndSummoners:SightWard(enemies, tick)
    local function CastWard(wardPos)
        for i=1,3 do
            self.itemSlot = self:GetSlotItemFromName(self.itemsAndSpells.Wards[i])
            if self.itemSlot ~= nil then
                DelayAction(function()
                    CastSpell(self.itemSlot, wardPos.x, wardPos.z)
                end, LulzMenu.Items.Warding.Delay/1000)
            end
    	end
    end

    if LulzMenu.Items.Warding.Enable == 3 or LulzMenu.Items.Warding.Enable == 2 and Orbwalker:IsFighting() then
		tick = clock()+0.125
		for _, k in pairs(GetEnemyHeroes()) do
			if enemies[k.networkID][1] and not k.visible and not k.dead and enemies[k.networkID][3] >= clock() and GetDistance(k) < ( myHero.range + myHero.boundingRadius+50) then
				local pos = enemies[k.networkID][2]
				local dir = (enemies[k.networkID][4] - enemies[k.networkID][2]):normalized()
				for _=150, 600 do
					local ppos = pos + dir * _
					if IsWallOfGrass(D3DXVECTOR3(ppos.x,ppos.y,ppos.z)) then
						CastWard(ppos)
						enemies[k.networkID][3] = 0
					end
				end
			else
				if k.visible and not k.dead then
					enemies[k.networkID] = {k.visible, Vector(k), clock() + 1, Vector(k.path:Path(2))}
				end
			end
		end
	end
end
function ItemsAndSummoners:AutoSmite()
    if self.itemsAndSpells.SummonerSpells.Smite then
        if LulzMenu.Spell.SummonerSpellsMenu.Smite then
            self.jungleMinions:update()

            if myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Smite) == READY then
        		for i, jungle in pairs(self.jungleMinions.objects) do
        			if jungle ~= nil then
                        if max(20 * myHero.level + 370, 30 * myHero.level + 330, 40 * myHero.level + 240, 50 * myHero.level + 100) >= jungle.health then
                            if LulzMenu.Spell.SummonerSpellsMenu[string.split(jungle.charName,'_')[2]] then
                                CastSpell(self.itemsAndSpells.SummonerSpells.Smite, jungle)
                            end
                        end
        			end
        		end
            end
        end
	end
end
function ItemsAndSummoners:AutoSmiteDraw()
    if self.itemsAndSpells.SummonerSpells.Smite then
        if LulzMenu.Spell.SummonerSpellsMenu.Smite and LulzMenu.Spell.SummonerSpellsMenu.DrawSmite then
            if myHero:CanUseSpell(self.itemsAndSpells.SummonerSpells.Smite) == READY then
                for i, jungle in pairs(self.jungleMinions.objects) do
                    if jungle ~= nil then
                        if LulzMenu.Spell.SummonerSpellsMenu[string.split(jungle.charName,'_')[2]] then
                            DrawText3D("Smite Damage " .. floor(max(20 * myHero.level + 370, 30 * myHero.level + 330, 40 * myHero.level + 240, 50 * myHero.level + 100)/jungle.health*100) .. "%", jungle.x, jungle.y, jungle.z, 20, ARGB(255,255,0,0), true)
                        end
                    end
                end
            end
        end
    end
end
function ItemsAndSummoners:TauntOnKill()
	if myHero.kills > self.killCount then
		DoEmote(LulzMenu.Taunt - 2)

		self.killCount = myHero.kills
	end
end

class "AntiBaseUlt"
function AntiBaseUlt:__init()
    self.lower, self.clock, self.recallingTime = string.lower, clock(), 0
    self.spellData = {
		['Ashe'] = {
			MissileName = "EnchantedCrystalArrow",
			Speed = 1600
		},
		['Draven'] = {
			MissileName = "DravenR",
			Speed = 2000
		},
		['Ezreal'] = {
			MissileName = "EzrealTrueshotBarrage",
			Speed = 2000
		},
		['Jinx'] = {
			MissileName = "JinxR",
			Speed = 1700
		}
	}

    LulzMenu.General:addSubMenu("Anti BaseUlt", "BaseUlt")
        LulzMenu.General.BaseUlt:addParam("Enabled", "Enable Anti BaseUlt", 1, true)

    for _, Hero in pairs(GetEnemyHeroes()) do
		if self.spellData[Hero.charName] ~= nil then
			LulzMenu.General.BaseUlt:addParam(Hero.charName, Hero.charName .. " - " .. self.spellData[Hero.charName].MissileName, SCRIPT_PARAM_ONOFF, true)
		end
	end
    if next(LulzMenu.General.BaseUlt._param) == nil then
	    LulzMenu.General.BaseUlt:addParam("Info", "No champions supported!", SCRIPT_PARAM_INFO, "")
    else
        AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
        AddCreateObjCallback(function(object) self:OnCreateObj(object) end)
	end
end
function AntiBaseUlt:OnProcessSpell(unit, spell)
	if not LulzMenu.General.BaseUlt.Enabled then return end

	if unit == myHero and string.find(spell.name, "recall") then
		self.recallSpells = {
			['recall'] = 8.0,
			['recallimproved'] = 7.0,
			['odinrecall'] = 4.5,
			['odinrecallimproved'] = 4.0,
			['superrecall'] = 4.0,
			['superrecallimproved'] = 4.0
		}

		self.recallingTime = clock() + self.recallSpells[string.lower(spell.name)]
	end
end
function AntiBaseUlt:OnCreateObj(object)
    if not LulzMenu.General.BaseUlt.Enabled then return end

	if not object or not object.valid or object.type ~= "MissileClient" or not object.spellOwner or not object.spellOwner.valid
    or self.recallingTime < clock() or object.spellOwner.type ~= myHero.type or object.spellOwner.team == myHero.team
    or self.spellData[object.spellOwner.charName] == nil or not LulzMenu.General.BaseUlt[object.spellOwner.charName]
    or self.spellData[object.spellOwner.charName].MissileName ~= object.spellName then return end

    self.time = clock() + (GetDistance(object.pos, GetFountain()) / self.spellData[object.spellOwner.charName].Speed)
    if not self:IsLineCircleIntersection(GetFountain(), 500, object.pos, object.spellEnd) or 1 + self.recallingTime < self.time or self.recallingTime - 1 > self.time then
		return
	end

	myHero:MoveTo(1 + myHero.x, 1 + myHero.z)
	Log("Saving you from " .. object.spellOwner.charName .. " BaseUlt")
end
function AntiBaseUlt:IsLineCircleIntersection(circle, radius, v1, v2)
    local ToLineEnd = v2 - v1
	local ToCircle = circle - v1
	local Theta = (ToCircle.x * ToLineEnd.x + ToCircle.y * ToLineEnd.y) / (ToLineEnd.x * ToLineEnd.x + ToLineEnd.y * ToLineEnd.y)
	Theta = Theta <= 0 and 0 or 1

	local Closest = v1 + D3DXVECTOR3(ToLineEnd.x * Theta, ToLineEnd.y * Theta, ToLineEnd.z * Theta)
	local D = circle - Closest
	local Dist = (D.x * D.x) + (D.y * D.y)
	return Dist <= radius * radius
end

class "ThreshLantern"
function ThreshLantern:__init()
    self.lantern = nil

    AddTickCallback(function() self:OnTick() end)
    AddCreateObjCallback(function(a) self:OnCreateObj(a) end)
    AddDeleteObjCallback(function(a) self:OnDeleteObj(a) end)
end
function ThreshLantern:OnTick()
    if self.lantern ~= nil and LulzMenu.Hotkeys.FleeKey then
        if GetDistanceSqr(self.lantern) < 90000 then
            self.lantern:Interact()
        end
    end
end
function ThreshLantern:OnCreateObj(obj)
    if obj.name == "ThreshLantern" then
        self.lantern = obj
    end
end
function ThreshLantern:OnDeleteObj(obj)
    if obj.name == "ThreshLantern" then
        self.lantern = nil
    end
end

class "CTargetSelector"
function CTargetSelector:__init()
    CTargetSelector.targetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, TEAM_ENEMY)
    CTargetSelector.enemyHeros = GetEnemyHeroes()
    focus = nil
    CTargetSelector.championTable = {
        [5] = {"Alistar", "Braum", "DrMundo", "Galio", "Garen", "Leona", "Nautilus", "Shen", "Singed", "Sion", "Poppy", "Rammus", "Skarner", "Tahm Kench", "Taric", "Thresh", "Zac"},
        [4] = {"Aatrox", "Amumu", "Blitzcrank", "Darius", "Gnar", "Gragas", "Illaoi", "Ivern", "Janna", "Kled", "Malphite", "Maokai", "Nami", "Nasus", "Nunu", "Olaf", "Sejuani", "Shyvana", "RekSai", "Renekton", "Swain", "Trundle", "Udyr", "Urgot", "Volibear", "Yorick"},
        [3] = {"Akali", "Anivia", "Bard", "ChoGath", "Ekko", "Elise", "Fiora", "Gangplank", "Hecarim", "Heimerdinger", "Irelia", "JarvanIV", "Jax", "Jayce", "Kassadin", "Kayle", "Lee Sin", "Lissandra", "Lulu", "Mordekaiser", "Morgana", "Nidalee", "Pantheon", "Sona", "Taliyah", "Tryndamere", "Vi", "Vladimir", "Warwick", "Wukong", "XinZhao", "Zilean", "Zyra"},
        [2] = {"Ahri", "Annie", "Aurelion Sol", "Azir", "Camille", "Cassiopeia", "Corki", "Diana", "Evelynn", "Fiddlesticks", "Fizz", "Graves", "Karma", "Karthus", "Katarina", "Kennen", "Kindred", "LeBlanc", "Lux", "Malzahar", "Nocturne", "Orianna", "Ryze", "Shaco", "Riven", "Rengar", "Syndra", "Soraka", "Talon", "Twisted Fate", "Veigar", "VelKoz","Viktor", "Xerath", "Zed", "Ziggs"},
        [1] = {"Ashe", "Brand", "Caitlyn", "Draven", "Ezreal", "Jhin", "Jinx", "Kalista", "KhaZix", "KogMaw", "Lucian", "Master Yi", "Miss Fortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne", "Yasuo"},
    }
    CTargetSelector.sendOnce = true

    LulzMenu:addSubMenu("Target Selection Menu", "Targeting")
    LulzMenu.Targeting:addParam("Focus", "Left click to focus", SCRIPT_PARAM_LIST, 2, {"Never","For 1 Minute", "Until Removed"})
    LulzMenu.Targeting:addParam("FocusIgnore", "Focus ignore range", SCRIPT_PARAM_SLICE, 1500, 0, 3000, 0)
    LulzMenu.Targeting:addParam("TargetingInfo2", "", SCRIPT_PARAM_INFO, "")
    LulzMenu.Targeting:addParam("Method", "Target selection method", SCRIPT_PARAM_LIST, 8,{"Low HP", "Most AP", "Most AD", "Less Cast", "Near Mouse", "Priority", "Low HP Priority", "Less Cast Priority"})
    LulzMenu.Targeting:addParam("OrbWalker", "Prefer orbwalker targeting", 1, true)
    LulzMenu.Targeting:addParam("TargetingInfo3", "", SCRIPT_PARAM_INFO, "")

    for i, enemy in pairs(CTargetSelector.enemyHeros) do
        for i = 1, 5 do
            for key, value in pairs(CTargetSelector.championTable[i]) do
                if string.lower(value) == string.lower(enemy.charName) then
                    LulzMenu.Targeting:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_SLICE, i, 1, 5, 0)
                    break
                end
            end
        end
        LulzMenu.Targeting:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
    end

    LulzMenu.Targeting:addParam("TargetingInfo", "5 = Low Priority, 1 = Max Priority(You will focus first)", SCRIPT_PARAM_INFO, "")

    AddMsgCallback(function(msg,key) self:OnWndMsg(msg, key) end)
end
function CTargetSelector:GetTarget()
    if ValidTarget(focus) and GetDistanceSqr(focus) > LulzMenu.Targeting.FocusIgnore * LulzMenu.Targeting.FocusIgnore then
        return focus
    end
    local orbTarget = Orbwalker:GetOrbwalkerTarget()
    if LulzMenu.Targeting.OrbWalker and ValidTarget(orbTarget) then
        return orbTarget
    else
        CTargetSelector.targetSelector.mode = LulzMenu.Targeting.Method
        local priority = {}
        for i, enemy in pairs(self.enemyHeros) do
            insert(priority, LulzMenu.Targeting[enemy.charName])
        end
        table.sort(priority, function(a,b) return a < b end)

        for i, enemy in pairs(self.enemyHeros) do
            TS_SetHeroPriority(i, enemy)
        end

        CTargetSelector.targetSelector:update()
        local tsTarget = CTargetSelector.targetSelector.target

        if ValidTarget(tsTarget) then
            return tsTarget
        else
            return nil
        end
    end
end
function CTargetSelector:ClosestEnemy(pos)
	if pos == nil then return huge, nil end
	local closestEnemy, distanceEnemy = nil, huge

	for i=1, #CTargetSelector.enemyHeros do
		if not CTargetSelector.enemyHeros[i].dead then
			if GetDistance(pos, CTargetSelector.enemyHeros[i]) < distanceEnemy then
				distanceEnemy = GetDistance(pos, CTargetSelector.enemyHeros[i])
				closestEnemy = CTargetSelector.enemyHeros[i]
			end
		end
	end

	return closestEnemy, distanceEnemy
end
function CTargetSelector:OnWndMsg(msg,key)
	if msg == WM_LBUTTONDOWN then
		local enemy, distance = self:ClosestEnemy(mousePos)

		if distance < 250 then
			if focus and focus.charName == enemy.charName then
				focus = nil
			else
				focus = enemy
                self:FocusTarget()
			end
		end
	end
end
function CTargetSelector:FocusTarget()
	if LulzMenu.Targeting.Focus > 1 then
		if CTargetSelector.sendOnce and LulzMenu.Targeting.Focus == 2 then
			DelayAction(function()
				if focus ~= nil then
					focus = nil
					CTargetSelector.sendOnce = true
				end
			end, 60)
			CTargetSelector.sendOnce = false
		end
	end
end

class "Humanizer"
function Humanizer:__init()
    self.lastCommand = 0
    self.lastMessage = 0
    self.bCount = 0
    self.streamMode = LulzMenu.Draw.StreamMode
    self.print,self.PrintChat = _G.print, _G.PrintChat
    self.globalUlt = {["Draven"] = true, ["Ezreal"] = true, ["Jinx"] = true, ["Ashe"] = true}
    self.originalCastSpell = _G.CastSpell
    self.originalValidTarget = _G.ValidTarget
    self.functionTrackerValid,self.functionTrackerCast = 0, 0

    self.gameVersion = GetGameVersion():sub(1,10)
    self.enemyHeros = GetEnemyHeroes()
    self.missingEnemy = {}
    for i, Enemy in pairs(self.enemyHeros) do
    	self.missingEnemy[Enemy.charName] = clock()
    end

    LulzMenu:addSubMenu("Humanizer Menu", "Humanizer")
        LulzMenu.Humanizer:addSubMenu(myHero.charName.." Spell Whitelist", myHero.charName)
            LulzMenu.Humanizer[myHero.charName]:addParam("0", "Spell Q", SCRIPT_PARAM_ONOFF, false)
            LulzMenu.Humanizer[myHero.charName]:addParam("1", "Spell W", SCRIPT_PARAM_ONOFF, false)
            LulzMenu.Humanizer[myHero.charName]:addParam("2", "Spell E", SCRIPT_PARAM_ONOFF, false)
            LulzMenu.Humanizer[myHero.charName]:addParam("3", "Spell R", SCRIPT_PARAM_ONOFF, true)
            LulzMenu.Humanizer[myHero.charName]:addParam("info22","Turning off Spell R may affect base ult!", SCRIPT_PARAM_INFO, "")
        LulzMenu.Humanizer:addSubMenu("Movement Limiter", "Movement")
            LulzMenu.Humanizer.Movement:addParam("Enable", "Use Movement Limiter", SCRIPT_PARAM_ONOFF, true)
            LulzMenu.Humanizer.Movement:addParam("info222","", SCRIPT_PARAM_INFO, "")
            LulzMenu.Humanizer.Movement:addParam("info23","Max Actions Per Second", SCRIPT_PARAM_INFO, "")
            LulzMenu.Humanizer.Movement:addParam("lhit", "Last Hit", SCRIPT_PARAM_SLICE, 6, 1, 25, 0)
            LulzMenu.Humanizer.Movement:addParam("lclear", "Lane Clear", SCRIPT_PARAM_SLICE, 6, 1, 25, 0)
            LulzMenu.Humanizer.Movement:addParam("harass", "Harass", SCRIPT_PARAM_SLICE, 8, 1, 25, 0)
            LulzMenu.Humanizer.Movement:addParam("combo", "Combo", SCRIPT_PARAM_SLICE, 13, 1, 25, 0)
            LulzMenu.Humanizer.Movement:addParam("perm", "Persistant", SCRIPT_PARAM_SLICE, 9, 1, 25, 0)
            LulzMenu.Humanizer.Movement:addParam("info233","25 = No restrictions, 1 = Highly Restricted", SCRIPT_PARAM_INFO, "")
        LulzMenu.Humanizer:addParam("info23","", SCRIPT_PARAM_INFO, "")
        LulzMenu.Humanizer:addParam("Enable", "Enable humanizer", SCRIPT_PARAM_ONOFF, true)
        LulzMenu.Humanizer:addParam("FOW", "Ignore new FoW enemies", SCRIPT_PARAM_ONOFF, true)
        LulzMenu.Humanizer:addParam("info22","Total Commands Blocked: 0", SCRIPT_PARAM_INFO, "")

    AddMsgCallback(function(msg,key) self:OnWndMsg(msg, key) end)
    AddIssueOrderCallback(function(source, order, position, target) self:OnIssueOrder(source, order, position, target) end)
    AddTickCallback(function() self:NewEnemy() end)
    AddTickCallback(function() self:Functions() end)
end
function Humanizer:IsOnScreen(spot)
    local check = WorldToScreen(D3DXVECTOR3(spot.x, spot.y, spot.z))
    local x, y = check.x, check.y
    if x > 0 and x < WINDOW_W and y > 0 and y < WINDOW_H then
        return true
    end
end
function Humanizer:Functions()
    if LulzMenu.Humanizer.FOW and self.functionTrackerValid == 0 then
        _G.ValidTarget = function(object, distance, enemyTeam)
        	local enemyTeam = (enemyTeam ~= false)
        	if object ~= nil and object.valid and object.name and (object.type == myHero.type or object.type:find("obj_AI")) and object.bTargetable and (object.team ~= player.team) == enemyTeam and object.visible and not object.dead and (enemyTeam == false or object.bInvulnerable == 0) and (distance == nil or GetDistanceSqr(object) <= distance * distance) and self:IsOnScreen(object) then
        		if LulzMenu.Humanizer.FOW and object.type == myHero.type and object.team ~= myHero.team and self.missingEnemy[object.charName] ~= 0 then return end
        		return true
            end
        end
        self.functionTrackerValid = 1
    elseif not LulzMenu.Humanizer.FOW and self.functionTrackerValid == 1 then
        _G.ValidTarget = self.originalValidTarget
        self.functionTrackerValid = 0
    end

    if LulzMenu.Humanizer.Enable and self.functionTrackerCast == 0 then
        _G.CastSpell = function(ID, param2, param3)
    	if param3 and param2 then
    		local endPos = Vector(param2, myHero.y, param3)
    		if ID == 3 and self.globalUlt[myHero.charName] and self:IsOnScreen(myHero.pos) and not LulzMenu.Humanizer[myHero.charName][tostring(ID)] then
    			local ultSpot = Vector(myHero.x, myHero.y, myHero.z) + (Vector(param2, myHero.y, param3) - Vector(myHero.x, myHero.y, myHero.z)):normalized() * (80 + (random()*420))
    			param2, param3 = ultSpot.x, ultSpot.z
    		elseif ID ~= 13 and not LulzMenu.Humanizer[myHero.charName][tostring(ID)] then
    			if endPos then
    				if not self:IsOnScreen(endPos) then
    					self.bCount = self.bCount + 1
    					LulzMenu.Humanizer:modifyParam("info22", "text", "Total Commands Blocked: "..self.bCount)
    					return
    				end
    			end
    		end
    	end
    	if param3 and param2 then
    		self.originalCastSpell(ID, param2, param3)
    	elseif param2 then
    		self.originalCastSpell(ID, param2)
    	else
    		self.originalCastSpell(ID)
    	end
        end
        self.functionTrackerCast = 1
    elseif not LulzMenu.Humanizer.Enable and self.functionTrackerCast == 1 then
        _G.CastSpell = self.originalCastSpell
        self.functionTrackerCast = 0
    end

    if LulzMenu.Draw.StreamMode and not self.streamMode then
        for i=1, 20 do
            print(" ")
        end
        DisableOverlay()
        _G.print = function() end
        _G.PrintChat = function() end

        self.streamMode = true
    elseif not LulzMenu.Draw.StreamMode and self.streamMode then
        EnableOverlay()
        _G.print = self.print
        _G.PrintChat = self.PrintChat
        self.streamMode = false
    end
end
function Humanizer:NewEnemy()
	for i, Enemy in pairs(self.enemyHeros) do
		if not Enemy.visible then
			self.missingEnemy[Enemy.charName] = clock()
		elseif Enemy.visible and self.missingEnemy[Enemy.charName] ~= 0 then
			if clock() - self.missingEnemy[Enemy.charName] > 1.5 then
				self.missingEnemy[Enemy.charName] = 0
			end
		end
	end
end
function Humanizer:OnIssueOrder(source, order, position, target)
    local function moveEvery()
    	if Orbwalker:IsFighting() then return 1 / LulzMenu.Humanizer.Movement.combo
    	elseif Orbwalker:IsLastHitting() then return 1 / LulzMenu.Humanizer.Movement.lhit
    	elseif Orbwalker:IsHarassing() then return 1 / LulzMenu.Humanizer.Movement.harass
    	elseif Orbwalker:IsLaneClearing() then return 1 / LulzMenu.Humanizer.Movement.lclear
    	else return 1 / LulzMenu.Humanizer.Movement.perm
    	end
    end
    if not LulzMenu.Humanizer.Enable then return end
	if LulzMenu.Humanizer.Movement.Enable and clock() - self.lastCommand < moveEvery() and order == 2 then
		BlockOrder()
		self.bCount = self.bCount + 1
		LulzMenu.Humanizer:modifyParam("info22", "text", "Total Commands Blocked: "..self.bCount)
		return
	elseif order == 3 then
		if not self:IsOnScreen(target) then
			BlockOrder()
			self.bCount = self.bCount + 1
			LulzMenu.Humanizer:modifyParam("info22", "text", "Total Commands Blocked: "..self.bCount)
			return
		end
	end

	self.lastCommand = clock()
end
function Humanizer:OnWndMsg(msg, key)
	if msg == 516 and key == 2 then
        self.okMove = true
    end
end

class "Orbwalker"
function Orbwalker:__init()
    local orbwalker = nil
    Orbwalker.timer = clock()

    LulzMenu:addSubMenu("Orbwalker Menu", "Orbwalker")
        LulzMenu.Orbwalker:addParam("CustomKey", "Use Custom Combat Keys", SCRIPT_PARAM_ONOFF, false)
        LulzMenu.Orbwalker:setCallback("CustomKey", function(v)
        	if v == true then
        		LulzMenu.Orbwalker:removeParam("Orbwalker")
        		LulzMenu.Orbwalker:addParam("Combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
        		LulzMenu.Orbwalker:addParam("Harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        		LulzMenu.Orbwalker:addParam("Laneclear", "Lane Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        		LulzMenu.Orbwalker:addParam("Lasthit", "Last Hit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        	elseif v == false then
        		LulzMenu.Orbwalker:addParam("Orbwalker", orbwalker .. " Detected, Hotkeys integrated", SCRIPT_PARAM_INFO, "")
        		LulzMenu.Orbwalker:removeParam("Combo")
        		LulzMenu.Orbwalker:removeParam("Harass")
        		LulzMenu.Orbwalker:removeParam("Laneclear")
        		LulzMenu.Orbwalker:removeParam("Lasthit")
        	end
    	end)

    AddTickCallback(function() self:FindOrbwalker() end)
end
function Orbwalker:FindOrbwalker()
    if orbwalker ~= nil then return end
    if _G.Reborn_Initialised and _G.Reborn_Loaded then
       orbwalker = "SAC:R"
    elseif _G.MMA_IsLoaded then
       orbwalker = "MMA"
    elseif _Pewalk then
       orbwalker = "PEWalk"
    else
        if Orbwalker.timer + 15 <= clock() then
            orbwalker = "SX"
            if FileExist(LIB_PATH.."SxOrbWalk.lua") then
                require "SxOrbWalk"
                SxOrb:LoadToMenu(LulzMenu.Orbwalker)
                sxLoaded = true
            else
                DownloadSXOrb()
            end
        end
    end

    if orbwalker ~= nil and not LulzMenu.Orbwalker.CustomKey then
        LulzMenu.Orbwalker:addParam("Orbwalker", orbwalker .. " Detected, Hotkeys integrated", SCRIPT_PARAM_INFO, "")
    elseif orbwalker ~= nil then
        LulzMenu.Orbwalker:addParam("Combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
        LulzMenu.Orbwalker:addParam("Harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        LulzMenu.Orbwalker:addParam("Laneclear", "Lane Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        LulzMenu.Orbwalker:addParam("Lasthit", "Last Hit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    end
end
function Orbwalker:IsFighting()
    if not LulzMenu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" then
            return _G.AutoCarry.Keys.AutoCarry
        elseif orbwalker == "MMA" then
            return _G.MMA_IsOrbwalking()
        elseif orbwalker == "PEWalk" then
            return _G._Pewalk.GetActiveMode().Carry
        elseif orbwalker == "SX" then
            return _G.SxOrb.isFight
        end
    else
        return LulzMenu.Orbwalker.Combo
    end
end
function Orbwalker:IsHarassing()
    if not LulzMenu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" then
            return _G.AutoCarry.Keys.MixedMode
        elseif orbwalker == "MMA" then
            return _G.MMA_IsDualCarrying()
        elseif orbwalker == "PEWalk" then
            return _G._Pewalk.GetActiveMode().Mixed
        elseif orbwalker == "SX" then
            return _G.SxOrb.isHarass
        end
    else
        return LulzMenu.Orbwalker.Harass
    end
end
function Orbwalker:IsLaneClearing()
    if not LulzMenu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" then
            return _G.AutoCarry.Keys.LaneClear
        elseif orbwalker == "MMA" then
            return _G.MMA_IsLaneClearing()
        elseif orbwalker == "PEWalk" then
            return _G._Pewalk.GetActiveMode().LaneClear
        elseif orbwalker == "SX" then
            return _G.SxOrb.isLaneClear
        end
    else
        return LulzMenu.Orbwalker.LaneClear
    end
end
function Orbwalker:IsLastHitting()
    if not LulzMenu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" then
            return _G.AutoCarry.Keys.LaneClear
        elseif orbwalker == "MMA" then
            return _G.MMA_IsLaneClearing()
        elseif orbwalker == "PEWalk" then
            return _G._Pewalk.GetActiveMode().LaneClear
        elseif orbwalker == "SX" then
            return _G.SxOrb.isLaneClear
        end
    else
        return LulzMenu.Orbwalker.LaneClear
    end
end
function Orbwalker:GetOrbwalkerTarget(range)
    if orbwalker == "SAC:R" then
        _G.AutoCarry.Crosshair:SetSkillCrosshairRange(range)
        return _G.AutoCarry.SkillsCrosshair.target
    elseif orbwalker == "MMA" then
        return _G.MMA_Target(range)
    elseif orbwalker == "PEWalk" then
        return _G._Pewalk.GetTarget(range)
    elseif orbwalker == "SX" then
        return SxOrb:GetTarget(range)
    end
end
function Orbwalker:ForceTarget(target)
    if orbwalker == "SAC:R" then
        _G.AutoCarry.Crosshair:ForceTarget(target)
    elseif orbwalker == "MMA" then
        _G.MMA_ForceTarget(target)
    elseif orbwalker == "PEWalk" then
        _G._Pewalk.ForceTarget(target)
    elseif orbwalker == "SX" then
        SxOrb:ForceTarget(target)
    end
end
function Orbwalker:AllowAttacks(bool)
    if orbwalker == "SAC:R" then
        _G.AutoCarry.MyHero:AttacksEnabled(bool)
    elseif orbwalker == "MMA" then
        _G.MMA_StopAttacks(not bool)
    elseif orbwalker == "PEWalk" then
        _G._Pewalk.AllowAttack(bool)
    elseif orbwalker == "SX" then
        if bool then
            SxOrb:EnableAttacks()
        else
            SxOrb:DisableAttacks()
        end
    end
end
function Orbwalker:AllowMovement(bool)
    if orbwalker == "SAC:R" then
        _G.AutoCarry.MyHero:MovementEnabled(bool)
    elseif orbwalker == "MMA" then
        _G.MMA_AvoidMovement(not bool)
    elseif orbwalker == "PEWalk" then
        _G._Pewalk.AllowMove(bool)
    elseif orbwalker == "SX" then
        if bool then
            SxOrb:EnableMove()
        else
            SxOrb:DisableMove()
        end
    end
end

class "Prediction"
function Prediction:__init()
    _G.predictonTable = {
        ["Predictions"] = {{"VPrediction", 2, 1, 3, 0}, {"FHPrediction", 1.1, 1, 2, 2}, {"HPrediction", 1.05, 0, 3, 2}, {"TRPrediction", 1, 0, 2.5, 1}, {"KPrediction", 1.75, 0, 3, 2}},
        ["FoundPredictions"] = {},
        ["LoadedPredictions"] = {},
        ["GlobalCallbacks"] = {},
        ["ActivePrediction"] = nil,
    }
    self.lastPrediction = nil
    Prediction.menuItems = {}
	for i=1, #_G.predictonTable.Predictions do
        if FileExist(LIB_PATH .. _G.predictonTable.Predictions[i][1] .. ".lua") then
            insert(_G.predictonTable.FoundPredictions, _G.predictonTable.Predictions[i][1])
    	end
    end

    LulzMenu.General:addParam("Prediction", "Prediction", SCRIPT_PARAM_LIST, 1, _G.predictonTable.FoundPredictions)
    LulzMenu.General:setCallback("Prediction", function(v)
        for i=1, #self.menuItems do
            self.menuItems[i]:modifyParam("Accuracy", "min",  _G.predictonTable.Predictions[v][3])
            self.menuItems[i]:modifyParam("Accuracy", "max",  _G.predictonTable.Predictions[v][4])
            self.menuItems[i]:modifyParam("Accuracy", "idc",  _G.predictonTable.Predictions[v][5])
        end
    end)
    AddTickCallback(function() self:ActivePrediction() end)
end
function Prediction:ActivePrediction()
    _G.predictonTable.ActivePrediction = _G.predictonTable.Predictions[LulzMenu.General.Prediction][1]
    if _G[_G.predictonTable.ActivePrediction] and _G.predictonTable.ActivePrediction ~= "FHPrediction" and self.lastPrediction ~= _G.predictonTable.ActivePrediction then
        if not _G.predictonTable.GlobalCallbacks[_G.predictonTable.ActivePrediction] then
            _G.predictonTable.GlobalCallbacks[_G.predictonTable.ActivePrediction] = _G[_G.predictonTable.ActivePrediction]()
            activePrediction = _G.predictonTable.GlobalCallbacks[_G.predictonTable.ActivePrediction]
        else
            activePrediction = _G.predictonTable.GlobalCallbacks[_G.predictonTable.ActivePrediction]
        end
        self.lastPrediction = _G.predictonTable.ActivePrediction
    end

    for i=1, #_G.predictonTable.LoadedPredictions do
        if _G.predictonTable.LoadedPredictions[i] == _G.predictonTable.ActivePrediction then
            return
        end
    end

    insert(_G.predictonTable.LoadedPredictions, _G.predictonTable.ActivePrediction)
    require(_G.predictonTable.ActivePrediction)
end
function Prediction:AddToMenu(menu)
    menu:addParam("Accuracy", "Prediction Accuracy", SCRIPT_PARAM_SLICE, _G.predictonTable.Predictions[LulzMenu.General.Prediction][2], _G.predictonTable.Predictions[LulzMenu.General.Prediction][3], _G.predictonTable.Predictions[LulzMenu.General.Prediction][4], _G.predictonTable.Predictions[LulzMenu.General.Prediction][5])
    insert(Prediction.menuItems,menu)
end
function Prediction:GetLineCastPosition(target, spellTable, usePreset)
    if _G.predictonTable.ActivePrediction ~= nil then
        if _G.predictonTable.ActivePrediction == "VPrediction" then
            return activePrediction:GetLineCastPosition(target, spellTable.delay, spellTable.width, spellTable.range, spellTable.speed, myHero, spellTable.collision)
        elseif _G.predictonTable.ActivePrediction == "FHPrediction" then
            local CastPosition, HitChance, Info = FHPrediction.GetPrediction(usePreset or spellTable, target)
            if spellTable.collision and not Info.collision then
                return CastPosition, HitChance
            elseif not spellTable.collision then
                return CastPosition, HitChance
            end
        elseif _G.predictonTable.ActivePrediction == "HPrediction" then
            return activePrediction:GetPredict(HPSkillshot({type = "DelayLine", delay = spellTable.delay, range = spellTable.range, speed = spellTable.speed, collisionM = spellTable.collision, collisionH = spellTable.collision, width = spellTable.width}), target, myHero)
        elseif _G.predictonTable.ActivePrediction == "TRPrediction" then
            local CastPosition, HitChance, Info = activePrediction:GetPrediction(TR_BindSS({type = 'IsLinear', delay = spellTable.delay, range = spellTable.range, width = spellTable.width, speed = spellTable.speed}), target, myHero)
            if spellTable.collision and not Info then
                return CastPosition, HitChance
            elseif not spellTable.collision then
                return CastPosition, HitChance
            end
        elseif _G.predictonTable.ActivePrediction == "KPrediction" then
            return activePrediction:GetPrediction(KPSkillshot({type = "DelayLine", delay = spellTable.delay, range = spellTable.range, speed = spellTable.speed, collision = spellTable.collision, width = spellTable.width}), target, myHero);
        end
    end
end
function Prediction:GetCircularCastPosition(target, spellTable, usePreset)
    if _G.predictonTable.ActivePrediction ~= nil then
        if _G.predictonTable.ActivePrediction == "VPrediction" then
            return activePrediction:GetCircularCastPosition(target, spellTable.delay, spellTable.radius, spellTable.range, spellTable.speed, myHero, spellTable.collision)
        elseif _G.predictonTable.ActivePrediction == "FHPrediction" then
            return FHPrediction.GetPrediction(usePreset or spellTable, target)
        elseif _G.predictonTable.ActivePrediction == "HPrediction" then
            return activePrediction:GetPredict(HPSkillshot({type = "DelayCircle", delay = spellTable.delay, range = spellTable.range, speed = spellTable.speed, collisionM = spellTable.collision, collisionH = spellTable.collision, radius = spellTable.radius}), target, myHero);
        elseif _G.predictonTable.ActivePrediction == "TRPrediction" then
            local CastPosition, HitChance, Info = activePrediction:GetPrediction(TR_BindSS({type = 'IsRadial', delay = spellTable.delay, range = spellTable.range, radius = spellTable.radius, speed = spellTable.speed}), target, myHero)
            if spellTable.collision and not Info then
                return CastPosition, HitChance
            elseif not spellTable.collision then
                return CastPosition, HitChance
            end
        end
    end
end
function Prediction:GetPredictedHealth(unit, time)
    if _G.predictonTable.ActivePrediction ~= nil then
        if _G.predictonTable.ActivePrediction == "VPrediction" then
            return activePrediction:GetPredictedHealth(unit, time)
        elseif _G.predictonTable.ActivePrediction == "FHPrediction" then
            return FHPrediction.PredictHealth(unit, time)
        elseif _G.predictonTable.ActivePrediction == "HPrediction" then
            return activePrediction:PredictHealth(unit, time)
        elseif _G.predictonTable.ActivePrediction == "TRPrediction" then
            return activePrediction:GetPredictedHealth(unit, time)
        elseif _G.predictonTable.ActivePrediction == "KPrediction" then
            return activePrediction:GetHealth(unit, time)
        end
    end
end
function Prediction:GetPredictedPosistion(hero, delay)
    if _G.predictonTable.ActivePrediction ~= nil then
        if _G.predictonTable.ActivePrediction == "VPrediction" then
            return activePrediction:GetPredictedPos(hero, delay)
        elseif _G.predictonTable.ActivePrediction == "FHPrediction" then
            return FHPrediction.PredictPosition(hero, delay)
        elseif _G.predictonTable.ActivePrediction == "HPrediction" then
            return HPrediction:PredictPos(hero, delay)
        elseif _G.predictonTable.ActivePrediction == "TRPrediction" then
            return TRPrediction:GetUnitPosition(hero, delay)
        elseif _G.predictonTable.ActivePrediction == "KPrediction" then
            return activePrediction:GetPos(hero, delay)
        end
    end
end

class "SxScriptUpdate"
function CheckUpdatesLib()
    local ToUpdate = {}
    ToUpdate.UseHttps = true
    ToUpdate.Host = "raw.githubusercontent.com"
    ToUpdate.VersionPath = "/Celtech/BOL/master/Lulzlub/version"
    ToUpdate.ScriptPath =  "/Celtech/BOL/master/Lulzlub/Lulzlib.lua"
    ToUpdate.SavePath = LIB_PATH.."Lulzlib.lua"
    ToUpdate.Version = nil
    ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color='#55AAAA'>[Lulzlib]</font> <font color='#FFFFFF'>".."Updated to v"..NewVersion.."</font>") end
    ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color='#55AAAA'>[Lulzlib]</font> <font color='#FFFFFF'>".."No Updates Found, loading version " .. OldVersion .. "</font>") LIBUPDATED = true  end
    ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color='#55AAAA'>[Lulzlib]</font> <font color='#FFFFFF'>".."New Version found ("..NewVersion.."). Please wait until its downloaded then F9x2".."</font>") end
    ToUpdate.CallbackError = function(NewVersion) print("<font color='#55AAAA'>[Lulzlib]</font> <font color='#FFFFFF'>".."Error while Downloading. Please try again.".."</font>") end

    if FileExist(LIB_PATH.."Lulzlib.lua") then
        require "Lulzlib"
		_G.Lulzlib = Lulzlib()
        ToUpdate.Version = Lulzlib.version
    else
        ToUpdate.Version = .00
    end


    SxScriptUpdate(ToUpdate.Version,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
end
function CheckUpdates(Version)
	local ToUpdate = {}
    ToUpdate.UseHttps = true
    ToUpdate.Host = "raw.githubusercontent.com"
    ToUpdate.VersionPath = "/Celtech/BOL/master/LulzAIO/LulzAIO.version"
    ToUpdate.ScriptPath =  "/Celtech/BOL/master/LulzAIO/LulzAIO.lua"
    ToUpdate.SavePath = SCRIPT_PATH.._ENV.FILE_NAME
    ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color='#FF0000'>["..myHero.charName.."]</font> <font color='#FFFFFF'>".."Updated to v"..NewVersion.."</font>") end
    ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color='#FF0000'>["..myHero.charName.."]</font> <font color='#FFFFFF'>".."No Updates Found, loading version ".. OldVersion .."</font>") SCRIPTUPDATED = true  end
    ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color='#FF0000'>["..myHero.charName.."]</font> <font color='#FFFFFF'>".."New Version found ("..NewVersion.."). Please wait until its downloaded then F9x2".."</font>") end
    ToUpdate.CallbackError = function(NewVersion) print("<font color='#FF0000'>["..myHero.charName.."]</font> <font color='#FFFFFF'>".."Error while Downloading. Please try again.".."</font>") end

    SxScriptUpdate(Version,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError)
end
function DownloadSXOrb()
    local ToUpdate = {}
    ToUpdate.UseHttps = true
    ToUpdate.Host = "raw.githubusercontent.com"
    ToUpdate.VersionPath = "/Superx321/BoL/master/common/SxOrbWalk.Version"
    ToUpdate.ScriptPath =  "/Superx321/BoL/master/common/SxOrbWalk.lua"
    ToUpdate.SavePath = LIB_PATH.."SxOrbWalk.lua"
    ToUpdate.Version = nil
    ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) require "SxOrbWalk" SxOrb:LoadToMenu(Menu.Orbwalker) end
    ToUpdate.CallbackNoUpdate = function(OldVersion)  require "SxOrbWalk" SxOrb:LoadToMenu(Menu.Orbwalker)  end
    ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color='#ff8300'>[SxOrbWalker]</font> <font color='#FFFFFF'>".."Downloading SxOrbWalker v"..NewVersion..". No need to reload!".."</font>") end
    ToUpdate.CallbackError = function(NewVersion) print("<font color='#ff8300'>[SxOrbWalker]</font> <font color='#FFFFFF'>".."Error while Downloading. Please try again.".."</font>") end

    SxScriptUpdate(0.00,ToUpdate.UseHttps, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion,ToUpdate.CallbackError, true)
end
function SxScriptUpdate:__init(LocalVersion,UseHttps, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion,CallbackError, IsLib)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..random(99999999)
    self.SavePath = SavePath
    self.CallbackUpdate = CallbackUpdate
    self.CallbackNoUpdate = CallbackNoUpdate
    self.CallbackNewVersion = CallbackNewVersion
    self.CallbackError = CallbackError
    self.Updated = false
    self.isLib = IsLib or false
    AddDrawCallback(function() self:OnDraw() end)
    self:CreateSocket(self.VersionPath)
    self.DownloadStatus = 'Connect to Server for VersionInfo'
    AddTickCallback(function() self:GetOnlineVersion() end)
end
function SxScriptUpdate:OnDraw()
    if self.DownloadStatus ~= 'Downloading Script (100%)' and self.DownloadStatus ~= 'Downloading VersionInfo (100%)'then
        DrawText('Download Status: '..(self.DownloadStatus or 'Unknown'),50,10,50,ARGB(0xFF,0xFF,0xFF,0xFF))
    end

    if self.Updated and not self.isLib then
        DrawTextA('Update Downloaded, Reload the script!',50,WINDOW_W / 2,WINDOW_H / 2,ARGB(0xFF,0xFF,0x00,0x00), "center", "center")
    end
end
function SxScriptUpdate:CreateSocket(url)
    if not self.LuaSocket then
        self.LuaSocket = require("socket")
    else
        self.Socket:close()
        self.Socket = nil
        self.Size = nil
        self.RecvStarted = false
    end
    self.LuaSocket = require("socket")
    self.Socket = self.LuaSocket.tcp()
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.Socket:connect('sx-bol.eu', 80)
    self.Url = url
    self.Started = false
    self.Lastprint = ""
    self.File = ""
end
function SxScriptUpdate:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
function SxScriptUpdate:GetOnlineVersion()
    if self.GotScriptVersion then return end

    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading VersionInfo (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</s'..'ize>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading VersionInfo ('..round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading VersionInfo (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.File:find('<scr'..'ipt>')
        local ContentEnd, _ = self.File:find('</sc'..'ript>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            self.OnlineVersion = (Base64Decode(self.File:sub(ContentStart + 1,ContentEnd-1)))
            self.OnlineVersion = tonumber(self.OnlineVersion)
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self:CreateSocket(self.ScriptPath)
                self.DownloadStatus = 'Connect to Server for ScriptDownload'
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        end
        self.GotScriptVersion = true
    end
end
function SxScriptUpdate:DownloadUpdate()
    if self.GotSxScriptUpdate then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)
    if self.Status == 'timeout' and not self.Started then
        self.Started = true
        self.Socket:send("GET "..self.Url.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
    end
    if (self.Receive or (#self.Snipped > 0)) and not self.RecvStarted then
        self.RecvStarted = true
        self.DownloadStatus = 'Downloading Script (0%)'
    end

    self.File = self.File .. (self.Receive or self.Snipped)
    if self.File:find('</si'..'ze>') then
        if not self.Size then
            self.Size = tonumber(self.File:sub(self.File:find('<si'..'ze>')+6,self.File:find('</si'..'ze>')-1))
        end
        if self.File:find('<scr'..'ipt>') then
            local _,ScriptFind = self.File:find('<scr'..'ipt>')
            local ScriptEnd = self.File:find('</scr'..'ipt>')
            if ScriptEnd then ScriptEnd = ScriptEnd - 1 end
            local DownloadedSize = self.File:sub(ScriptFind+1,ScriptEnd or -1):len()
            self.DownloadStatus = 'Downloading Script ('..round(100/self.Size*DownloadedSize,2)..'%)'
        end
    end
    if self.File:find('</scr'..'ipt>') then
        self.DownloadStatus = 'Downloading Script (100%)'
        local a,b = self.File:find('\r\n\r\n')
        self.File = self.File:sub(a,-1)
        self.NewFile = ''
        for line,content in ipairs(self.File:split('\n')) do
            if content:len() > 5 then
                self.NewFile = self.NewFile .. content
            end
        end
        local HeaderEnd, ContentStart = self.NewFile:find('<sc'..'ript>')
        local ContentEnd, _ = self.NewFile:find('</scr'..'ipt>')
        if not ContentStart or not ContentEnd then
            if self.CallbackError and type(self.CallbackError) == 'function' then
                self.CallbackError()
            end
        else
            local newf = self.NewFile:sub(ContentStart+1,ContentEnd-1)
            local newf = newf:gsub('\r','')
            if newf:len() ~= self.Size then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
                return
            end
            local newf = Base64Decode(newf)
            if type(load(newf)) ~= 'function' then
                if self.CallbackError and type(self.CallbackError) == 'function' then
                    self.CallbackError()
                end
            else
                local f = io.open(self.SavePath,"w+b")
                f:write(newf)
                f:close()
                if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                    self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
                    self.Updated = true
                end
            end
        end
        self.GotSxScriptUpdate = true
    end
end
