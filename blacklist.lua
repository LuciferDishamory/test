local samp = require 'samp.events'
local lanes = require('lanes').configure()
local requests = require 'requests'
local imgui = require 'imgui'
local key = require 'vkeys'
local encoding = require "encoding"
local dlstatus = require('moonloader').download_status
encoding.default = 'CP1251'
u8 = encoding.UTF8
script_version("1.0")

local main_window_state = imgui.ImBool(false)
function imgui.OnDrawFrame()
  if main_window_state.v then -- С‡С‚РµРЅРёРµ Рё Р·Р°РїРёСЃСЊ Р·РЅР°С‡РµРЅРёСЏ С‚Р°РєРѕР№ РїРµСЂРµРјРµРЅРЅРѕР№ РѕСЃСѓС‰РµСЃС‚РІР»СЏРµС‚СЃСЏ С‡РµСЂРµР· РїРѕР»Рµ v (РёР»Рё Value)
    imgui.SetNextWindowSize(imgui.ImVec2(550, 500), imgui.Cond.FirstUseEver) -- РјРµРЅСЏРµРј СЂР°Р·РјРµСЂ
    -- РЅРѕ РґР»СЏ РїРµСЂРµРґР°С‡Рё Р·РЅР°С‡РµРЅРёСЏ РїРѕ СѓРєР°Р·Р°С‚РµР»СЋ - РѕР±СЏР·Р°С‚РµР»СЊРЅРѕ РЅР°РїСЂСЏРјСѓСЋ
    -- С‚СѓС‚ main_window_state РїРµСЂРµРґР°С‘С‚СЃСЏ С„СѓРЅРєС†РёРё imgui.Begin, С‡С‚РѕР±С‹ РјРѕР¶РЅРѕ Р±С‹Р»Рѕ РѕС‚СЃР»РµРґРёС‚СЊ Р·Р°РєСЂС‹С‚РёРµ РѕРєРЅР° РЅР°Р¶Р°С‚РёРµРј РЅР° РєСЂРµСЃС‚РёРє
	local sw,sh = getScreenResolution()
	file = io.open(getGameDirectory().."//moonloader//usersbk.txt", "r")
	local readfile = file:read("*all")
	file:close()
	imgui.SetNextWindowPos(imgui.ImVec2(sw/2,sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
    imgui.Begin(u8'Black-List', main_window_state)
    imgui.Text(readfile)
		
    imgui.End()
  end
end



function main()
	local ip, port = sampGetCurrentServerAddress()
	result,idplayer = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local nick = sampGetPlayerNickname(idplayer)
	local file
	if file == nil then 
		file = io.open(getGameDirectory().."//moonloader//usersbk.txt", "w")
		file:close()
		file = io.open(getGameDirectory().."//moonloader//usersbk.txt", "r")
		file:close()
	end
	
	
	if ip == '185.169.134.3' then
	ip = "Phoenix"
	end	
	if ip == '185.169.134.4' then
	ip = "Tucson"
	end	
	if ip == '185.169.134.43' then
	ip = "Scottdale"
	end
	if ip == '185.169.134.44' then
	ip = "Chandler"
	end
	if ip == '185.169.134.45' then
	ip = "Brainburg"
	end
	if ip == '185.169.134.5' then
	ip = "Saint%20Rose"
	end
	if ip == '185.169.134.59' then
	ip = "Mesa"
	end
	if ip == '185.169.134.61' then
	ip = "Red%20Rock"
	end
	if ip == '185.169.134.107' then
	ip = "Yuma"
	end
	if ip == '185.169.134.109' then
	ip = "Surprise"
	end
	if ip == '185.169.134.166' then
	ip = "Prescott"
	end	
	if ip == '185.169.134.171' then
	ip = "Glendale"
	end
	if ip == '185.169.134.172' then
	ip = "Kingman"
	end
	if ip == '185.169.134.173' then
	ip = "Winslow"
	end	
		if ip == '185.169.134.174' then
	ip = "Payson"
	end	

   sampRegisterChatCommand('addbk', function(text)
		
		file = io.open(getGameDirectory().."//moonloader//usersbk.txt", "r")
		readfile = file:read("*all")
		file:close()
		
		file = io.open(getGameDirectory().."//moonloader//usersbk.txt", "a")
		file:write("\n",text)
		file:close()
        sequent_async_http_request('GET',u8"https://api.vk.com/method/messages.send?v=5.50&message="..text.."%20-%20"..ip.."%20(%20Added:%20"..nick.."%20)&peer_id=2000000004&access_token=6533feff91bcae012b142928ad8cee615866e64a3daaf4c23d900cc457a3cd0933718028e003599c2c556", nil, function(response)
        end)
end)

   sampRegisterChatCommand('update', function(text)
		update()
	end)


  sampRegisterChatCommand("blacklist", function() main_window_state.v = not main_window_state.v end)

  while true do
    wait(0)
    imgui.Process = main_window_state.v or main_window_state.v
    if not main_window_state.v and not main_window_state.v then
      imgui.ShowCursor = true
    end
  end
	
end








function sequent_async_http_request(method, url, args, resolve, reject)
    if not _G['lanes.async_http'] then
        local linda = lanes.linda()
        local lane_gen = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
            local requests = require 'requests'
            while true do
                local key, val = linda:receive(50 / 1000, 'request')
                if key == 'request' then
                    local ok, result = pcall(requests.request, val.method, val.url, val.args)
                    if ok then
                        result.json, result.xml = nil, nil
                        linda:send('response', result)
                    else
                        linda:send('error', result)
                    end
                end
            end
        end)
        _G['lanes.async_http'] = {lane = lane_gen(), linda = linda}
    end
    local lanes_http = _G['lanes.async_http']
    lanes_http.linda:send('request', {method = method, url = url, args = args})
    lua_thread.create(function(linda)
        while true do
            local key, val = linda:receive(0, 'response', 'error')
            if key == 'response' then
                return resolve(val)
            elseif key == 'error' then
                return reject(val)
            end
            wait(0)
        end
    end, lanes_http.linda)
end

function encodeToUrl(str)
  local diff = urlencode(u8:encode(str, 'CP1251'))
  return diff
end

function urlToDecode(str)
    local diff = u8:decode(str, 'CP1251')
    return diff
end
function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str
end



function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
  downloadUrlToFile('https://jsonbin.io/6086e735c7df3422f7fe4533/2', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- открывает файл
    if f then
      local info = decodeJson(f:read('*a')) -- читает
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
          lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
          update = false -- не даём обновиться 
          sampAddChatMessage(('[Testing]: У вас и так последняя версия! Обновление отменено'), color)
        end
      end
    end
  end
end)
end
--скачивание актуальной версии
function goupdate()
sampAddChatMessage(('[Testing]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...'), color)
sampAddChatMessage(('[Testing]: Текущая версия: '..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Testing]: Обновление завершено!'), color)
  thisScript():reload()
end
end)
end