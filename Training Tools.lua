require "lib.moonloader"
local keys = require "vkeys"
local dlstatus = require('moonloader').download_status
local x2, y2 = getScreenResolution()
local sampev = require "lib.samp.events"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local fa = require "faIcons"
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

local tag = "{FFA500}[TRAINING TOOLS]: "

local inicfg = require "inicfg"

local directIni = "moonloader\\Training Tools\\trainingTools.ini"

local mainIni = inicfg.load(nil, directIni)

update_state = false

local script_vers = 3
local script_vers_text = "3.0"

local update_url = "https://raw.githubusercontent.com/les1er/trainingTools/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://raw.githubusercontent.com/les1er/trainingTools/main/Training%20Tools.lua"
local script_path = thisScript().path

local ini_path = getWorkingDirectory() .. '/Training Tools/trainingTools.ini'

local sw, sh = getScreenResolution()

function imgui.BeforeDrawFrame()
	if fa_font == nil then
		local font_config = imgui.ImFontConfig()
		font_config.MergeMode = true
		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
	end
end

themes = {u8"Оранжевая тема", u8"Синяя тема"}

local apame_line1 = imgui.ImBuffer(144)
local apame_line2 = imgui.ImBuffer(144)
local apame_line3 = imgui.ImBuffer(144)
local apame_line4 = imgui.ImBuffer(144)
local apame_line5 = imgui.ImBuffer(144)
local apame_line6 = imgui.ImBuffer(144)
local apame_line7 = imgui.ImBuffer(144)
local apame_line8 = imgui.ImBuffer(144)
local apame_line9 = imgui.ImBuffer(144)
local apame_line10 = imgui.ImBuffer(144)
local main_window_state = imgui.ImBool(false)
local secondary_window_state = imgui.ImBool(false)
local temporary_window_state = imgui.ImBool(false)
local hex_window_state = imgui.ImBool(false)
local autopame_window_state = imgui.ImBool(false)
local note_window_state = imgui.ImBool(false)
local note_buffer = imgui.ImBuffer(65000)

local image
local image2
local image3
local image4
local image5
local image6
local image7
local image8
local image9
local obj

local color = imgui.ImFloat3(1.0, 1.0, 1.0)

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	downloadUrlToFile(update_url, update_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
					sampAddChatMessage(tag .. "{FFFFFF}Доступна новая версия скрипта: {80BCFF}" .. updateIni.info.vers_text .. ".0{FFFFFF}!", 0xFFFFFFFF)
					update_state = true
				end
			end
	end)

	apply_custom_style(mainIni.check.theme)

	sampAddChatMessage(tag .. "{FFFFFF}Скрипт успешно загружен! Автор: {80BCFF}lester", 0xFFFFFFFF)
	sampAddChatMessage(tag .. "{FFFFFF}Открыть меню скрипта: {80BCFF}ALT + Z", 0xFFFFFFFF)

	sampRegisterChatCommand("autopame", autopame_cmd)

	image = imgui.CreateTextureFromFile("moonloader/Training Tools/hex1.png")
	image2 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex2.png")
	image3 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex3.png")
	image4 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex4.png")
	image5 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex5.png")
	image6 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex6.png")
	image7 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex7.png")
	image8 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex8.png")
	image9 = imgui.CreateTextureFromFile("moonloader/Training Tools/hex9.png")

imgui.Process = false

apame_line1.v = mainIni.autopame.line1
apame_line2.v = mainIni.autopame.line2
apame_line3.v = mainIni.autopame.line3
apame_line4.v = mainIni.autopame.line4
apame_line5.v = mainIni.autopame.line5
apame_line6.v = mainIni.autopame.line6
apame_line7.v = mainIni.autopame.line7
apame_line8.v = mainIni.autopame.line8
apame_line9.v = mainIni.autopame.line9
apame_line10.v = mainIni.autopame.line10

local file = io.open(getGameDirectory().."//moonloader//Training Tools//notepad.txt", "r")
note_buffer.v = file:read("*a")
file:close()

local font = renderCreateFont("Arial", 7, 4)

	while true do
		wait(0)

		if update_state then
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage(tag .. "{FFFFFF}Скрипт успешно обновлен!", 0xFFFFFFFF)
					os.remove(getWorkingDirectory() .. '/Training Tools/trainingTools.ini')
					downloadUrlToFile("https://raw.githubusercontent.com/les1er/trainingTools/main/trainingTools.ini", ini_path)
					update_state = false
					thisScript():reload()
				end
				end)
			break
		end

		imgui.Process = main_window_state.v

		if isKeyJustPressed(VK_Z) and isKeyDown(VK_MENU) then
			main_window_state.v = not main_window_state.v
			imgui.Process = main_window_state.v
	 end

	 if mainIni.check.objectDisp == true then
		 for _, v in pairs(getAllObjects()) do
			 if isObjectOnScreen(v) then
				 local _, x, y, z = getObjectCoordinates(v)
				 local x1, y1 = convert3DCoordsToScreen(x,y,z)
				 local model = getObjectModel(v)
				 local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
				 local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
				 local distance = string.format("%.1f", getDistanceBetweenCoords3d(x, y, z, x2, y2, z2))
					 renderFontDrawText(font, ("model = "..model).."; distance: "..distance, x1, y1, -1)
					if mainIni.check.objectDispTraser == true then
						renderDrawLine(x10, y10, x1, y1, 1.0, -1)
					end
		 end
	 end
 end
end
end

function sampev.onApplyPlayerAnimation(playerId, animLib, animName, loop, lockX, lockY, freeze, time)
	if mainIni.check.animLib == true then
 	sampAddChatMessage(tag .. "{FFFFFF}Библиотека анимации: {80BCFF}" .. animLib .. "{FFFFFF} ; Название анимации: {80BCFF}" .. animName, 0xFFFFA500)
 end
end

function imgui.NewInputText(lable, val, width, hint, hintpos)
  local hint = hint and hint or ''
  local hintpos = tonumber(hintpos) and tonumber(hintpos) or 1
  local cPos = imgui.GetCursorPos()
  imgui.PushItemWidth(width)
  local result = imgui.InputText(lable, val)
  if #val.v == 0 then
    local hintSize = imgui.CalcTextSize(hint)
    if hintpos == 2 then imgui.SameLine(cPos.x + (width - hintSize.x) / 2)
    elseif hintpos == 3 then imgui.SameLine(cPos.x + (width - hintSize.x - 5))
    else imgui.SameLine(cPos.x + 5) end
    imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.40), tostring(hint))
  end
  imgui.PopItemWidth()
  return result
end

local animLib_check = imgui.ImBool(mainIni.check.animLib)
local object_disp = imgui.ImBool(mainIni.check.objectDisp)
local object_disp_traser = imgui.ImBool(mainIni.check.objectDispTraser)
local theme_select = imgui.ImInt(mainIni.check.theme)

function imgui.TextColoredRGB(string)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col

    local function color_imvec4(color)
        if color:upper() == 'SSSSSS' then return colors[clr.Text] end
        local color = type(color) == 'number' and ('%X'):format(color):upper() or color:upper()
        local rgb = {}
        for i = 1, #color/2 do rgb[#rgb+1] = tonumber(color:sub(2*i-1, 2*i), 16) end
        return imgui.ImVec4(rgb[1]/255, rgb[2]/255, rgb[3]/255, rgb[4] and rgb[4]/255 or colors[clr.Text].w)
    end

    local function render_text(string)
        local text, color = {}, {}
        local m = 1
        while string:find('{......}') do
            local n, k = string:find('{......}')
            text[#text], text[#text+1] = string:sub(m, n-1), string:sub(k+1, #string)
            color[#color+1] = color_imvec4(string:sub(n+1, k-1))
            local t1, t2 = string:sub(1, n-1), string:sub(k+1, #string)
            string = t1..t2
            m = k-7
        end
        if text[0] then
            for i, _ in ipairs(text) do
                imgui.TextColored(color[i] or colors[clr.Text], u8(text[i]))
                imgui.SameLine(nil, 0)
            end
            imgui.NewLine()
        else imgui.Text(u8(string)) end
    end

    render_text(string)
end

function imgui.TextCenter(text)
  local textSize = imgui.CalcTextSize(text)
  imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - textSize.x / 2)
  return imgui.Text(text)
end

function autopame_cmd(arg)
	--1 stroka
	sampSendDialogResponse(32700, -1, 0, apame_line1.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line1.v))
	--2 stroka
	sampSendDialogResponse(32700, -1, 1, apame_line2.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line2.v))
	--3 stroka
	sampSendDialogResponse(32700, -1, 2, apame_line3.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line3.v))
	--4 stroka
	sampSendDialogResponse(32700, -1, 3, apame_line4.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line4.v))
	--5 stroka
	sampSendDialogResponse(32700, -1, 4, apame_line5.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line5.v))
	--6 stroka
	sampSendDialogResponse(32700, -1, 5, apame_line6.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line6.v))
	--7 stroka
	sampSendDialogResponse(32700, -1, 6, apame_line7.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line7.v))
	--8 stroka
	sampSendDialogResponse(32700, -1, 7, apame_line8.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line8.v))
	--9 stroka
	sampSendDialogResponse(32700, -1, 8, apame_line9.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line9.v))
	--10 stroka
	sampSendDialogResponse(32700, -1, 9, apame_line10.v)
	sampSendDialogResponse(32700, 1, -1, u8:decode(" " ..apame_line10.v))
end


function imgui.OnDrawFrame()

	imgui.SetNextWindowSize(imgui.ImVec2(600, 600), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

	if main_window_state.v then
		imgui.Begin(fa.ICON_WRENCH .. u8"   TRAINING TOOLS " .. script_vers_text, main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove)
		x, y, z = getCharCoordinates(PLAYER_PED)
		imgui.Text(u8"Позиция игрока X: " .. math.floor(x))
		imgui.SameLine()
		imgui.Text(u8"Позиция игрока Y: " .. math.floor(y))
		imgui.SameLine()
		imgui.Text(u8"Позиция игрока Z: " .. math.floor(z))
		imgui.SameLine()
		if imgui.Selectable(fa.ICON_LINK .. u8" Скопировать", false) then
			posx = math.floor(x)
			posy = math.floor(y)
			posz = math.floor(z)
			setClipboardText(posx .. " " .. posy .. " " .. posz)
		end
		imgui.Checkbox(u8"Отображение библиотек анимаций", animLib_check)
		mainIni.check.animLib = animLib_check.v
		local stateIni = inicfg.save(mainIni, directIni)
		imgui.SameLine()
		imgui.Checkbox(u8"ID моделей ближайших объектов", object_disp)
		mainIni.check.objectDisp = object_disp.v
		local stateIni = inicfg.save(mainIni, directIni)
		if object_disp.v then
		imgui.SameLine()
		imgui.Checkbox(u8"Трейсер", object_disp_traser)
		mainIni.check.objectDispTraser = object_disp_traser.v
		local stateIni = inicfg.save(mainIni, directIni)
	  end
		imgui.Separator()
		if imgui.Button(fa.ICON_FILE .. u8" Текстовые команды", imgui.ImVec2(150, 25)) then
			secondary_window_state.v = main_window_state.v
			imgui.Process = secondary_window_state.v
		end
		imgui.SameLine()
		if imgui.Button(fa.ICON_FILE .. u8" Коллбэки", imgui.ImVec2(150, 25)) then
			temporary_window_state.v = main_window_state.v
			imgui.Process = temporary_window_state.v
		end
		imgui.SameLine()
		if imgui.Button(fa.ICON_ID_CARD .. u8" Авто пейм", imgui.ImVec2(150, 25)) then
			autopame_window_state.v = main_window_state.v
			imgui.Process = autopame_window_state.v
		end

		if imgui.Button(fa.ICON_PAINT_BRUSH .. u8" Цвета", imgui.ImVec2(150, 25)) then
			hex_window_state.v = main_window_state.v
			imgui.Process = hex_window_state.v
		end
		imgui.SameLine()
		if imgui.Button(fa.ICON_STICKY_NOTE .. u8" Блокнот", imgui.ImVec2(150, 25)) then
			note_window_state.v = main_window_state.v
			imgui.Process = note_window_state.v
		end
		imgui.Separator()
		if imgui.Combo(u8"Сменить тему оформления", theme_select, themes) then
		inicfg.save(mainIni, directIni)
	end
		apply_custom_style(theme_select.v)

		imgui.End()
	end
	if secondary_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(500, 650), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.ICON_FILE .. u8"   Текстовые команды", secondary_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove)
		imgui.Text(u8"#random(число1, число2)# - сгенерировать случайное число.")
		imgui.Text(u8"#array(0 - 26)# - вернуть значение пользовательского массива 0 - 26.")
		imgui.Text(u8"#var(x)# - вернуть значение глобальной переменной x.")
		imgui.Text(u8"#pvar(текст, id)# - вернуть значение пользовательской переменной x.")
		imgui.Text(u8"#vdata(ID транспорта) - вернуть массив транспорта.")
		imgui.Text(u8"#server(0 - 49)# - вернуть значение серверного массива 0 - 49.")
		imgui.Text(u8"#teamOnline(1-20)# - вывести онлайн команды.")
		imgui.Text(u8"#online# - вывести онлайн мира")
		imgui.Text(u8"#skin# - скин игрока.")
		imgui.Text(u8"#gun# - ID оружия в руках игрока.")
		imgui.Text(u8"#vehicle# - вернуть ID транспорта.")
		imgui.Text(u8"#timestamp# - время в секундах от 1970 года.")
		imgui.Text(u8"#team# - вернуть ID команды в которой состоит игрок.")
		imgui.Text(u8"#score# - очки игрока.")
		imgui.Text(u8"#money# - деньги игрока.")
		imgui.Text(u8"#health# - здоровье игрока.")
		imgui.Text(u8"#armour# - броня игрока.")
		imgui.Text(u8"#playerid# - ID игрока.")
		imgui.Text(u8"#name# - ник игрока.")
		imgui.Text(u8"#xyz# - координаты игрока.")
		imgui.Text(u8"#x# #y# #z# - отдельно координаты игрока по X Y Z")
		imgui.Text(u8"#speed# - скорость игрока.")
		imgui.Text(u8"#vehName# - название транспорта.")
		imgui.Text(u8"#vehHealth# - здоровье транспорта.")
		imgui.Text(u8"#vehColor# - цвет транспорта. В RGB формате без { }.")
		imgui.Text(u8"#gunName# - название оружия в руке игрока.")
		imgui.Text(u8"#time# - время мира.")
		imgui.Text(u8"#weather# - погода мира.")
		imgui.Text(u8"#wanted# - уровень розыска игрока.")
		imgui.Text(u8"#bodypart# - часть тела в которую нанесли урон.")
		imgui.Text(u8"#issuerGun# - оружие с какого был нанесен урон.")
		imgui.Text(u8"#attach(1-10)# - модель аттача в слоте.")
		imgui.Text(u8"#retval(0 - 9)# - возвращаемые параметры для игрока")
		imgui.Text(u8"#retstr(0-9)# - возвращаемые параметры для игрока текстовые")
		imgui.Text(u8"#GetPlayerName(id)# - получить ник игрока")
		imgui.Text(u8"#GetVehName(id)# - получить название транспорта")
		imgui.Text(u8"#GetDistPlayer(id)# - получить расстояние до игрока")
		imgui.Text(u8"#GetFAPlayer(id)# - получить значение поворота игрока")
		imgui.Text(u8"#GetDistVeh(id)# - получить расстояние до транспорта")
		imgui.Text(u8"#GetDistObject(id)# - получить расстояние до объекта")
		imgui.Text(u8"#VehModel# - модель транспорта в котором сидит игрок")
		imgui.Text(u8"#GetGunName(id)# - название оружие по ID")
		imgui.Text(u8"#zone# - название района в котором игрок")
		imgui.Text(u8"#ping# - пинг игрока")
		imgui.Text(u8"#netstat# - потери пакетов в % (Качество соединения. Идеально: 0%)")
		imgui.Text(u8"#randomPlayer# - выбрать случайного игрока в мире.")
		imgui.Text(u8"#getZ(x,y)# - найти высоту рельефа по координатам X Y")
		imgui.Text(u8"#fa# - получить значение поворота игрока")
		imgui.Text(u8"#waterlvl# - отобразить уровень воды.")
		imgui.Text(u8"#seatid# - вернуть номер места Т/C на котром сидит игрок.")
		imgui.Text(u8"-1 игрок вне машины ; 0 Игрок за рулем ; 1-3 пассажир.")
		imgui.End()
	end
	if temporary_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(500, 650), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.ICON_FILE .. u8"   Коллбэки", temporary_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove)
		imgui.Text(fa.ICON_LIST .. u8"   Нанесение урона")
		imgui.Text(u8"#retstr(0)# - Ник игрока в который получил урон.")
		imgui.Text(u8"#retstr(1)# - Название оружия.")
		imgui.Text(u8"#retstr(2)# - Часть тела.")
		imgui.Text(u8"#retval(0)# - ID кто нанес урон.")
		imgui.Text(u8"#retval(1)# - ID кому нанес урон.")
		imgui.Text(u8"#retval(2)# - Сумма нанесенного урона.")
		imgui.Text(u8"#retval(3)# - ID оружия.")
		imgui.Text(u8"#retval(4)# - ID части тела.")
		imgui.Text(u8"#retval(5)# - Команда игрока кому нанес урон.")
		imgui.Text(fa.ICON_LIST .. u8"   Получение урона")
		imgui.Text(u8"#retstr(0)# - Ник игрока в который нанес урон.")
		imgui.Text(u8"#retstr(1)# - Название оружия.")
		imgui.Text(u8"#retstr(2)# - Часть тела.")
		imgui.Text(u8"#retval(0)# - ID кто получил урон.")
		imgui.Text(u8"#retval(1)# - ID кто нанес урон.")
		imgui.Text(u8"#retval(2)# - Сумма нанесенного урона.")
		imgui.Text(u8"#retval(3)# - ID оружия.")
		imgui.Text(u8"#retval(4)# - ID части тела.")
		imgui.Text(u8"#retval(5)# - Команда игрока кто нанес урон.")
		imgui.Text(fa.ICON_LIST .. u8"   Выстрел")
		imgui.Text(u8"#retstr(0)# - Название оружия.")
		imgui.Text(u8"#retstr(1)# - Во что выстрелил игрок. (Объект, машина, игрок).")
		imgui.Text(u8"#retval(0)# - ID кто выстрелил.")
		imgui.Text(u8"#retval(1)# - ID оружия")
		imgui.Text(u8"#retval(2)# - Тип выстрела.")
		imgui.Text(u8"#retval(3)# - Уникальный ID выстрела.")
		imgui.Text(u8"#retval(4)# - Куда выстрелил X.")
		imgui.Text(u8"#retval(5)# - Куда выстрелил Y.")
		imgui.Text(u8"#retval(6)# - Куда выстрелил Z.")
		imgui.Text(fa.ICON_LIST .. u8"   Убийство")
		imgui.Text(u8"#retstr(0)# - Ник убитого игрока.")
		imgui.Text(u8"#retstr(1)# - Название оружия.")
		imgui.Text(u8"#retval(0)# - ID кто убил.")
		imgui.Text(u8"#retval(1)# - ID кого убил")
		imgui.Text(u8"#retval(2)# - ID оружия.")
		imgui.Text(u8"#retval(3)# - Команда убитого игрока.")
		imgui.Text(fa.ICON_LIST .. u8"   Смерть")
		imgui.Text(u8"#retstr(0)# - Ник от кого умер.")
		imgui.Text(u8"#retstr(1)# - Название оружия.")
		imgui.Text(u8"#retval(0)# - ID кто умер.")
		imgui.Text(u8"#retval(1)# - ID убийцы.")
		imgui.Text(u8"#retval(2)# - ID оружия.")
		imgui.Text(u8"#retval(3)# - Команда в которой убийца.")
		imgui.Text(fa.ICON_LIST .. u8"   Сесть в транспорт")
		imgui.Text(u8"#retstr(0)# - Название транспорта.")
		imgui.Text(u8"#retval(0)# - ID кто сел в транспорт.")
		imgui.Text(u8"#retval(1)# - На какое место.")
		imgui.Text(u8"#retval(2)# - ID транспорта.")
		imgui.Text(u8"#retval(3)# - Модель транспорта.")
		imgui.Text(u8"#retval(4)# - ID владельца транспорта.")
		imgui.Text(u8"#retval(5)# - Координаты транспорта X.")
		imgui.Text(u8"#retval(6)# - Координаты транспорта Y.")
		imgui.Text(u8"#retval(7)# - Координаты транспорта Z.")
		imgui.Text(fa.ICON_LIST .. u8"   Выйти из транспорта")
		imgui.Text(u8"#retstr(0)# - Название транспорта.")
		imgui.Text(u8"#retval(0)# - ID кто вышел из транспорт.")
		imgui.Text(u8"#retval(1)# - Новое состояние персонажа.")
		imgui.Text(u8"#retval(2)# - ID транспорта.")
		imgui.Text(u8"#retval(3)# - Модель транспорта.")
		imgui.Text(u8"#retval(4)# - ID владельца транспорта.")
		imgui.Text(u8"#retval(5)# - Координаты транспорта X.")
		imgui.Text(u8"#retval(6)# - Координаты транспорта Y.")
		imgui.Text(u8"#retval(7)# - Координаты транспорта Z.")
		imgui.Text(fa.ICON_LIST .. u8"   Взять гоночный чекпоинт")
		imgui.Text(u8"#retval(0)# - ID игрока который взял чекпоинт.")
		imgui.Text(u8"#retval(1)# - ID транспорта.")
		imgui.Text(u8"#retval(2)# - Модель транспорта.")
		imgui.Text(u8"#retval(3)# - Владелец транспорта.")
		imgui.Text(u8"#retval(4)# - Координаты транспорта X.")
		imgui.Text(u8"#retval(5)# - Координаты транспорта Y.")
		imgui.Text(u8"#retval(6)# - Координаты транспорта Z.")
		imgui.Text(u8"#retval(7)# - Скорость транспорта.")
		imgui.Text(fa.ICON_LIST .. u8"   Выйти из гоночного чекпоинта")
		imgui.Text(u8"#retval(0)# - ID игрока который покинул чекпоинт.")
		imgui.Text(u8"#retval(1)# - ID транспорта.")
		imgui.Text(u8"#retval(2)# - Модель транспорта.")
		imgui.Text(u8"#retval(3)# - Владелец транспорта.")
		imgui.Text(u8"#retval(4)# - Координаты транспорта X.")
		imgui.Text(u8"#retval(5)# - Координаты транспорта Y.")
		imgui.Text(u8"#retval(6)# - Координаты транспорта Z.")
		imgui.Text(u8"#retval(7)# - Скорость транспорта.")
		imgui.Text(fa.ICON_LIST .. u8"   Выстрелить по объекту")
		imgui.Text(u8"#retstr(0)# - Название оружия.")
		imgui.Text(u8"#retval(0)# - ID игрока который выстрелил по объекту.")
		imgui.Text(u8"#retval(1)# - ID оружия.")
		imgui.Text(u8"#retval(2)# - ID объекта.")
		imgui.Text(u8"#retval(3)# - Модель объекта.")
		imgui.Text(u8"#retval(4)# - Координаты выстрела X.")
		imgui.Text(u8"#retval(5)# - Координаты выстрела Y.")
		imgui.Text(u8"#retval(6)# - Координаты выстрела Z.")
		imgui.Text(u8"#retval(7)# - Координаты объекта X.")
		imgui.Text(u8"#retval(8)# - Координаты объекта Y.")
		imgui.Text(u8"#retval(9)# - Координаты объекта Z.")
		imgui.Text(fa.ICON_LIST .. u8"   Ввод диалога")
		imgui.Text(u8"#retstr(0-9)# - введенный текст игрока в диалог по 24 символа.")
		imgui.Text(u8"#retval(0)# - ID игрока который активировал диалог.")
		imgui.Text(u8"#retval(1)# - Пункт диалога выбранный игроком.")
		imgui.Text(u8"#retval(2-4)# - Цифровой параметр введенный игроком.")
		imgui.Text(u8"#retval(5)# - ID вызываемого блока.")
		imgui.Text(u8"#retval(6)# - Кнопка диалога выбранная игроком. Y - 1 / X - 0.")
		imgui.End()
	end
	if hex_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(600, 600), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.ICON_PAINT_BRUSH .. u8"   Цвета", hex_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove)
		if imgui.ColorEdit3(u8'Палитра цветов', color) then
        print("{" .. (bit.tohex(imgui.ImColor(imgui.ImVec4(color.v[1], color.v[2], color.v[3], 1.0)):GetU32())):sub(3, 8) .. "}")
    end
		imgui.Image(image, imgui.ImVec2(455, 466))
		imgui.Image(image2, imgui.ImVec2(455, 466))
		imgui.Image(image3, imgui.ImVec2(455, 466))
		imgui.Image(image4, imgui.ImVec2(455, 466))
		imgui.Image(image5, imgui.ImVec2(455, 500))
		imgui.Image(image6, imgui.ImVec2(455, 500))
		imgui.Image(image7, imgui.ImVec2(455, 466))
		imgui.Image(image8, imgui.ImVec2(455, 466))
		imgui.Image(image9, imgui.ImVec2(455, 466))
		imgui.End()
	end
	if note_window_state.v then
	imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.Begin(fa.ICON_STICKY_NOTE .. u8"   Блокнот ", note_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
	imgui.InputTextMultiline('##NotepadInput', note_buffer, imgui.ImVec2(-1, 398))
			if imgui.Button(u8"Сохранить", imgui.ImVec2(-1, 25)) then
				local file = io.open(getGameDirectory().."//moonloader//Training Tools//notepad.txt", "w")
				file:write(note_buffer.v)
				file:close()
			end
	imgui.End()
end
if autopame_window_state.v then
	imgui.SetNextWindowSize(imgui.ImVec2(500, 470), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.Begin(fa.ICON_ID_CARD .. u8"   Авто пейм ", autopame_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
	imgui.Text(fa.ICON_ID_CARD .. u8"  Используйте /autopame при открытом /pame")
	imgui.InputText(u8"1 строка", apame_line1)
	imgui.InputText(u8"2 строка", apame_line2)
	imgui.InputText(u8"3 строка", apame_line3)
	imgui.InputText(u8"4 строка", apame_line4)
	imgui.InputText(u8"5 строка", apame_line5)
	imgui.InputText(u8"6 строка", apame_line6)
	imgui.InputText(u8"7 строка", apame_line7)
	imgui.InputText(u8"8 строка", apame_line8)
	imgui.InputText(u8"9 строка", apame_line9)
	imgui.InputText(u8"10 строка", apame_line10)
	if imgui.Button(u8"Сохранить", imgui.ImVec2(-1, 25)) then
		mainIni.autopame.line1 = apame_line1.v
		mainIni.autopame.line2 = apame_line2.v
		mainIni.autopame.line3 = apame_line3.v
		mainIni.autopame.line4 = apame_line4.v
		mainIni.autopame.line5 = apame_line5.v
		mainIni.autopame.line6 = apame_line6.v
		mainIni.autopame.line7 = apame_line7.v
		mainIni.autopame.line8 = apame_line8.v
		mainIni.autopame.line9 = apame_line9.v
		mainIni.autopame.line10 = apame_line10.v
		local stateIni = inicfg.save(mainIni, directIni)
	end
	imgui.End()
end
end

function apply_custom_style(theme)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding = ImVec2(15, 15)
	style.WindowRounding = 6.0
	style.FramePadding = ImVec2(5, 5)
	style.FrameRounding = 4.0
	style.ItemSpacing = ImVec2(12, 8)
	style.ItemInnerSpacing = ImVec2(8, 6)
	style.IndentSpacing = 25.0
	style.ScrollbarSize = 15.0
	style.ScrollbarRounding = 9.0
	style.GrabMinSize = 5.0
	style.GrabRounding = 3.0
	if theme == 0 then
		colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
		colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
		colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
		colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.TitleBg] = ImVec4(0.76, 0.31, 0.00, 1.00)
		colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
		colors[clr.TitleBgActive] = ImVec4(0.80, 0.33, 0.00, 1.00)
		colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
		colors[clr.CheckMark] = ImVec4(1.00, 0.42, 0.00, 0.53)
		colors[clr.SliderGrab] = ImVec4(1.00, 0.42, 0.00, 0.53)
		colors[clr.SliderGrabActive] = ImVec4(1.00, 0.42, 0.00, 1.00)
		colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
		colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
		colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
		colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
	elseif theme == 1 then
								colors[clr.Text]                 = ImVec4(0.86, 0.93, 0.89, 0.78)
                colors[clr.TextDisabled]         = ImVec4(0.36, 0.42, 0.47, 1.00)
                colors[clr.WindowBg]             = ImVec4(0.11, 0.15, 0.17, 1.00)
                colors[clr.ChildWindowBg]        = ImVec4(0.15, 0.18, 0.22, 1.00)
                colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
                colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
                colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
                colors[clr.FrameBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
                colors[clr.FrameBgHovered]       = ImVec4(0.12, 0.20, 0.28, 1.00)
                colors[clr.FrameBgActive]        = ImVec4(0.09, 0.12, 0.14, 1.00)
                colors[clr.TitleBg]              = ImVec4(0.09, 0.12, 0.14, 0.65)
                colors[clr.TitleBgActive]        = ImVec4(0.11, 0.30, 0.59, 1.00)
                colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.51)
                colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00)
                colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39)
                colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00)
                colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
                colors[clr.ScrollbarGrabActive]  = ImVec4(0.09, 0.21, 0.31, 1.00)
                colors[clr.ComboBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
                colors[clr.CheckMark]            = ImVec4(0.28, 0.56, 1.00, 1.00)
                colors[clr.SliderGrab]           = ImVec4(0.28, 0.56, 1.00, 1.00)
                colors[clr.SliderGrabActive]     = ImVec4(0.37, 0.61, 1.00, 1.00)
                colors[clr.Button]               = ImVec4(0.08, 0.33, 0.55, 1.00)
                colors[clr.ButtonHovered]        = ImVec4(0.28, 0.56, 1.00, 1.00)
                colors[clr.ButtonActive]         = ImVec4(0.06, 0.53, 0.98, 1.00)
                colors[clr.Header]               = ImVec4(0.20, 0.25, 0.29, 0.55)
                colors[clr.HeaderHovered]        = ImVec4(0.26, 0.59, 0.98, 0.80)
                colors[clr.HeaderActive]         = ImVec4(0.26, 0.59, 0.98, 1.00)
                colors[clr.Separator]            = ImVec4(0.50, 0.50, 0.50, 1.00)
                colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00)
                colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00)
                colors[clr.ResizeGrip]           = ImVec4(0.26, 0.59, 0.98, 0.25)
                colors[clr.ResizeGripHovered]    = ImVec4(0.26, 0.59, 0.98, 0.67)
                colors[clr.ResizeGripActive]     = ImVec4(0.06, 0.05, 0.07, 1.00)
                colors[clr.CloseButton]          = ImVec4(0.40, 0.39, 0.38, 0.16)
                colors[clr.CloseButtonHovered]   = ImVec4(0.40, 0.39, 0.38, 0.39)
                colors[clr.CloseButtonActive]    = ImVec4(0.40, 0.39, 0.38, 1.00)
                colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
                colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
                colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
                colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
                colors[clr.TextSelectedBg]       = ImVec4(0.25, 1.00, 0.00, 0.43)
                colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
end
