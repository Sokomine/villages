
--[[
    automatic filling of chests; used by my villages mod for MineTest
    see https://github.com/Sokomine/villages

    Copyright (C) 2013 Sokomine

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

-- Version 0.2


-- TODO: refill chest after some time?
-- TODO: alert NPC that something was taken


fill_chest = {};
fill_chest.random_chest_content = {};

-- TODO: currently, this is more adapted to the lumberjacks in the wild

-- things that can be found in private, not locked chests belonging to npc
-- contains tables of the following structure: { node_name, probability (in percent, 100=always, 0=never), max_amount, repeat (for more than one stack) }
fill_chest.random_chest_content = {
	{"default:pick_stone",             10,  1, 3 }, 
	{"default:pick_steel",              5,  1, 2 }, 
	{"default:pick_mese",               2,  1, 2 }, 
	{"default:shovel_stone",            5,  1, 3 }, 
	{"default:shovel_steel",            5,  1, 2 }, 
	{"default:axe_stone",               5,  1, 3 }, 
	{"default:axe_steel",               5,  1, 2 }, 
	{"default:sword_stone",             1,  1, 3 }, 
	{"default:sword_steel",             1,  1, 3 }, 
	{"default:stick",                  20, 40, 2 }, 
	{"default:torch",                  50, 10, 4 }, 

	{"default:book",                   60,  1, 2 },
	{"default:paper",                  60,  6, 4 },
	{"default:apple",                  50, 10, 2 },
	{"default:ladder",                 20,  1, 2 },
        
	{"default:coal_lump",              80, 30, 1 },
	{"default:steel_ingot",            30,  4, 2 },
	{"default:mese_crystal_fragment",  10,  3, 1 },

	{"bucket:bucket_empty",            10,  3, 2 },
	{"bucket:bucket_water",             5,  3, 2 },
	{"bucket:bucket_lava",              3,  3, 2 },

	{"vessels:glass_bottle",           10, 10, 2 },
	{"vessels:drinking_glass",         20,  2, 1 },
	{"vessels:steel_bottle",           10,  1, 1 },

	{"wool:white",                     60,  8, 2 },
}


-- that someone will hide valuable ingots in chests that are not locked is fairly unrealistic; thus, those items are rare
if( minetest.get_modpath("moreores") ~= nil ) then
   table.insert( fill_chest.random_chest_content, {"moreores:gold_ingot",             1,  2, 1 } );
   table.insert( fill_chest.random_chest_content, {"moreores:silver_ingot",           1,  2, 1 } );
   table.insert( fill_chest.random_chest_content, {"moreores:copper_ingot",          30, 10, 1 } );
   table.insert( fill_chest.random_chest_content, {"moreores:tin_ingot",              1,  5, 1 } );
   table.insert( fill_chest.random_chest_content, {"moreores:bronze_ingot",           1,  1, 1 } );
   table.insert( fill_chest.random_chest_content, {"moreores:mithril_ingot",          1,  1, 1 } );
end

-- candles are a very likely content of chests
if( minetest.get_modpath("candles") ~= nil ) then
   table.insert( fill_chest.random_chest_content, {"candles:candle",                 80, 12, 2 } );
   table.insert( fill_chest.random_chest_content, {"candles:candelabra_steel",        1,  1, 1 } );
   table.insert( fill_chest.random_chest_content, {"candles:candelabra_copper",       1,  1, 1 } );
   table.insert( fill_chest.random_chest_content, {"candles:honey",                  50,  2, 1 } );
end

-- our NPC have to spend their free time somehow...also adds food variety
if( minetest.get_modpath("fishing") ~= nil ) then
   table.insert( fill_chest.random_chest_content, {"fishing:pole",                   60,  1, 1 } );
end

-- ropes are always useful
if( minetest.get_modpath("ropes") ~= nil ) then
   table.insert( fill_chest.random_chest_content, {"ropes:rope",                     60,  5, 2 } );
elseif( minetest.get_modpath("farming") ~= nil ) then
   table.insert( fill_chest.random_chest_content, {"farming:string",                 60,  5, 2 } );
elseif( minetest.get_modpath("moreblocks") ~= nil ) then
   table.insert( fill_chest.random_chest_content, {"moreblocks:rope",                60,  5, 2 } );
end

-- TODO: food mod



-- get some random content for a chest
fill_chest.fill_chest_random = function( pos )

   local meta = minetest.env:get_meta( pos );
   local inv = meta:get_inventory();

   local count = 0;

   for i,v in ipairs( fill_chest.random_chest_content ) do

      -- repeat this many times
      for count=1, v[ 4 ] do

         local inv_size = inv:get_size('main');
         -- to avoid too many things inside a chest, lower probability
         if(     count<30 -- make sure it does not get too much and there is still room for a new stack
             and v[ 2 ] > math.random( 1, 200 )    and inv_size ~= nil and inv_size > 0) then

             --inv:add_item('main', v[ 1 ].." "..tostring( math.random( 1, tonumber(v[ 3 ]) )));
             -- add itemstack at a random position in the chests inventory 
             inv:set_stack( 'main', math.random( 1, inv:get_size( 'main' )), v[ 1 ].." "..tostring( math.random( 1, tonumber(v[ 3 ]) )) );
             count = count+1;
         end
      end
   end
end


