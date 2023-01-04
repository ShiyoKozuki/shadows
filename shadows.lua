addon.name      = 'Shadows';
addon.author    = 'Shiyo';
addon.version   = '1.3';
addon.desc      = 'Displays utsusemi and third eye count';
addon.link      = 'https://github.com/ShiyoKozuki';

require('common');
local chat = require('chat');
local fonts = require('fonts');
local settings = require('settings');

local windowWidth = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0001', 1024);
local windowHeight = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0002', 768);

local default_settings = T{
	font = T{
        visible = true,
        font_family = 'Arial',
        font_height = 30,
        color = 0xFFFFFFFF,
        position_y = 800,
        position_x = 1338,
		background = T{
			visible = true,
			color = 0x80000000,
		}
    }
};

local shadows = T{
	settings = settings.load(default_settings)
};

local UpdateSettings = function(settings)
  shadows.settings = settings;
  if (shadows.font ~= nil) then
      shadows.font:apply(shadows.settings.font)
  end
end

local function GetShadowCount()
    local me = AshitaCore:GetMemoryManager():GetPlayer()
    local buffs = me:GetBuffs()

    for _, buff in pairs(buffs) do
        if buff == 66 or buff == 67 then
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
  settings.register('settings', 'settingchange', UpdateSettings);
end);


ashita.events.register('d3d_present', 'present_cb', function ()
 	local mJob = AshitaCore:GetMemoryManager():GetPlayer():GetMainJob();
	local sJob = AshitaCore:GetMemoryManager():GetPlayer():GetSubJob();

  local fontObject = shadows.font;
  if (fontObject.position_x > windowWidth) then
    fontObject.position_x = 0;
  end
  if (fontObject.position_y > windowHeight) then
    fontObject.position_y = 0;
  end
  if (fontObject.position_x ~= shadows.settings.font.position_x) or (fontObject.position_y ~= shadows.settings.font.position_y) then
      shadows.settings.font.position_x = fontObject.position_x;
      shadows.settings.font.position_y = fontObject.position_y;
      settings.save()
  end
	
	if mJob == 12 or mJob == 13 or sJob == 12 or sJob == 13 then
	  shadows.font.text = ('%d' ):fmt(GetShadowCount());
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