

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local health
local multi
local pulse = 70
local area = "Nem látható"
local lastHit
local blood = 100
local bleeding = 0
local dead = false
local timer = 0

local cPulse = -1
local cBlood = -1
local cNameF = ""
local cNameL = ""
local cArea = ""
local cBleeding = "Semmi"

RegisterCommand('getpulse', function(source, args)

	local health = GetEntityHealth(GetPlayerPed(-1))
	if health > 0 then
		pulse = (health / 4 + math.random(19, 28)) 
	end
	
	print(pulse)
	local hit, bone = GetPedLastDamageBone(GetPlayerPed(-1))
	print(bone)
	
end, false)

AddEventHandler('esx:onPlayerDeath', function(data)

	multi = 2.0
	blood = 100
	health = GetEntityHealth(GetPlayerPed(-1))
	area = "Kéz/Láb"
	local hit, bone = GetPedLastDamageBone(GetPlayerPed(-1))
	bleeding = 1
	if (bone == 31086) then
		multi = 0.0
		print('HEADSHOT')
		TriggerEvent('chatMessage', "MED", {255, 0, 0}, "Fejbelőttek!")
		bleeding = 5
		area = "Fej"
	end
	if bone == 24817 or bone == 24818 or bone == 10706 or bone == 24816 or bone == 11816 then
		multi = 1.0
		print('Lövés')
		TriggerEvent('chatMessage', "MED", {255, 0, 0}, "Meglőttek")
		bleeding = 2
		area = "Test"
	end
	
	pulse = ((health / 4 + 20) * multi) + math.random(0, 4)
	dead = true
end)

Citizen.CreateThread( function()
while true do
	Wait(5000)
	local hp = GetEntityHealth(GetPlayerPed(-1))
	if hp >= 1 and dead then
		dead = false
		bleeding = 0
		blood = 100
	end
	if dead and blood > 0 then
	blood = blood - bleeding
	end
end
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,100)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

RegisterNetEvent('medSystem:near')
AddEventHandler('medSystem:near', function(x,y,z, pulse, blood, nameF, nameL, area, bldn)
		
--	ESX.ShowNotification( nameF..' '..nameL..area , true , true, 30)   --- client

local md = Config.Declared

	if area == "Fej" and blood<=5 then
	--if area ~= nil then
		cBlood = blood
		cPulse = pulse
		cNameF = nameF
		cNameL = nameL
		cArea = area
			
	ESX.ShowNotification( nameF..' '..nameL..' '..Config.Declared , true , true, 20)   --- client
		message = nameF..' '..nameL..' '..Config.Declared
	
		TriggerEvent('chat:addMessage',  {
            template = '<div class="chat-message ems"><b>Medical Center </b>: <b>'..message..'</b></div>',
            args = { -1, message }
        })
		-- TriggerEvent('chatMessage', "Eastbound Medical: ", {255,0 , 0}, "^1 "..message..!")
		   

		
	end
	local a,b,c = GetEntityCoords(GetPlayerPed(-1))
	
	if GetDistanceBetweenCoords(x,y,z,a,b,c,false) < 10 then
		timer = Config.Timer
		ESX.ShowNotification( "MedSystem: [0-5] DEAD | [5-15] Needs hospital | [15-38] EMS Can help | [38-55] Police can help | [55+] Healthy", false,true,30)
		cBlood = blood
		cPulse = pulse
		cNameF = nameF
		cNameL = nameL
		cArea = area
		
		if bldn == 1 then
		cBleeding = "Könnyü"
		elseif bldn == 2 then
		cBleeding "Közepes"
		elseif bldn == 5 then
		cBleeding = "Súlyos"
		elseif bldn == 0 then
		cBleeding = "Semmi"
		end

	
	--	TriggerEvent('chatMessage', "Eastbound Medical", {255,0 , 0}, cNameF.." "..cNameL.."^1 DECLARED DEAD. ^6 PLEASE RESPAWN.!")
		
	else
		timer = 0
		cBlood = -1
		cPulse = -1
		cNameF = ""
		cNameL = ""
		cArea = ""
		cBleeding = "Lassú"
	end
	

end)

Citizen.CreateThread( function()
	while true do
		Wait(1)
			while timer >= 1 do
				Wait(1)
				if cPulse ~= -1 and cBlood ~= -1 then
					DrawAdvancedText(0.7, 0.7, 0.005, 0.0028, 0.9, cNameF .. " " .. cNameL .. "\n~r~Pulzus: ~w~" .. cPulse .. "BPM\n~r~Vérnyomás: ~w~" .. cBlood .. "%~r~\nSeb helye: ~w~" .. cArea .. "\n~r~Vérzés: ~w~" .. cBleeding, 255, 255, 255, 255, 4, 1)
					
				end
			end
	end
end)

Citizen.CreateThread( function()
	while true do
		Wait(1000)
		if timer >= 1 then
			timer = timer - 1
		end	
	end
end)

RegisterNetEvent('medSystem:send')
AddEventHandler('medSystem:send', function(req)
		
	
	local health = GetEntityHealth(GetPlayerPed(-1))
	if health > 0 then
		pulse = (health / 4 + math.random(19, 28)) 
	end
	local a, b, c = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

	
	TriggerServerEvent('medSystem:print', req, math.floor(pulse * (blood / 90)), area, blood, a, b, c, bleeding)


end)
