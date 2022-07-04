addon.name      = 'Shadows';
addon.author    = 'Shiyo';
addon.version   = '1.2';
addon.desc      = 'Displays shadow count';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local fonts = require('fonts');
local settings = require('settings');

local default_settings = T{
	font = T{
        visible = true,
        font_family = 'Arial',
        font_height = 30,
        color = 0xFFFFFFFF,
        position_x = 1,
        position_y = 1,
		background = T{
			visible = true,
			color = 0x80000000,
		}
    }
};

local shadows = T{
	settings = settings.load(default_settings)
};

local function GetShadowCount()
    local me = AshitaCore:GetMemoryManager():GetPlayer()
    local buffs = me:GetBuffs()

    for _, buff in pairs(buffs) do
        if buff == 66 then
          return 1;
        elseif buff == 444 then
          return 2;
        elseif buff == 445 then
          return 3;
        elseif buff == 446 then
          return 4;
        end
    end
    return 0;
end

ashita.events.register('load', 'load_cb', function ()
    shadows.font = fonts.new(shadows.settings.font);
end);

ashita.events.register('d3d_present', 'present_cb', function ()
 	local mJob = AshitaCore:GetMemoryManager():GetPlayer():GetMainJob();
	local sJob = AshitaCore:GetMemoryManager():GetPlayer():GetSubJob();
	
	if mJob == 13 or sJob == 13 then
	  shadows.font.text = ('%d' ):fmt(GetShadowCount());    
	  shadows.settings.font.position_x = shadows.font:GetPositionX();
	  shadows.settings.font.position_y = shadows.font:GetPositionY();
	  shadows.font.visible = true;
	else
	  shadows.font.visible = false;
  end
end);

ashita.events.register('unload', 'unload_cb', function ()
    if (shadows.font ~= nil) then
        shadows.font:destroy();
    end
settings.save();
end);