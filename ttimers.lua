addon.name      = 'tTimers';
addon.author    = 'Thorny';
addon.version   = '1.00';
addon.desc      = 'Displays time remaining on buffs and debuffs you\'ve cast, as well as the recast timers for your spells and abilities.';
addon.link      = 'https://ashitaxi.com/';

require('common');
require('helpers');

local jit = require('jit');
jit.off();
local gdi = require('gdifonts.include');

ashita.events.register('load', 'load_cb', function ()
    require('initializer');
    require('callbacks');
end);

ashita.events.register('unload', 'unload_cb', function ()
    gdi:destroy_interface();
end);