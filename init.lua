

--[[
    build a road (including sideroads) in order to form a village
    Mod for MineTest
    Full Mod can be found here: https://github.com/Sokomine/villages

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

villages = {}

villages.mts_path = minetest.get_modpath("villages").."/buildings/";

-- these will be used instead of cotton if farming_plus=1 is set in villages.building_data
villages.farming_plus_fruits = {'carrot','potatoe','orange','rhubarb','strawberry','tomato','cotton'};


-- some constants
villages.MIN_BRANCH_DIST     = 50;  -- roads have to be that far apart
villages.BRANCH_PROBABILITY  = 40;  -- how probable is it that we'll branch off after MIN_BRANCH_DIST?

-- entries:
-- burried: amount of blocks in vertical direction that the building is burried/reaches into the ground
-- rotated: for schems that are already rotated to some degree and/or follow a diffrent orientation standard
-- farming_plus: if set to 1, all occourances of cotton plants will be replaced with a random plant from farming_plus
-- avoid: avoid buildings with the same group (that is: avoid having tow of them in a row)
-- typ: used internally; will later be relevant for spawning of npc
--      for now, only typ "road" is relevant
villages.building_data = {
   church_1        = {burried=1, rotated=0,   farming_plus=0, avoid='', typ='church'},    
   church_2        = {burried=1, rotated=90,  farming_plus=0, avoid='', typ='church'},    
   church_3        = {burried=1, rotated=180, farming_plus=0, avoid='', typ='church'},    
   church_4        = {burried=1, rotated=270, farming_plus=0, avoid='', typ='church'},    
   forge_1         = {burried=1, rotated=0, farming_plus=0, avoid='', typ='forge'},
   mill_1          = {burried=1, rotated=0, farming_plus=0, avoid='', typ='mill'},
   hut_1           = {burried=1, rotated=0, farming_plus=0, avoid='', typ='hut'},
   farm_full_1     = {burried=1, rotated=0, farming_plus=0, avoid='', typ='farm_full'},
   farm_full_2     = {burried=1, rotated=0, farming_plus=0, avoid='', typ='farm_full'},
   farm_full_3     = {burried=1, rotated=0, farming_plus=0, avoid='', typ='farm_full'},
   farm_full_4     = {burried=1, rotated=0, farming_plus=0, avoid='', typ='farm_full'},
   farm_full_5     = {burried=1, rotated=0, farming_plus=0, avoid='', typ='farm_full'},
   farm_full_6     = {burried=1, rotated=0, farming_plus=0, avoid='', typ='farm_full'},
   farm_tiny_1     = {burried=1, rotated=0, farming_plus=1, avoid='', typ='farm_tiny'},
   farm_tiny_2     = {burried=1, rotated=0, farming_plus=1, avoid='', typ='farm_tiny'},
   farm_tiny_3     = {burried=1, rotated=0, farming_plus=1, avoid='', typ='farm_tiny'},
   farm_tiny_4     = {burried=1, rotated=0, farming_plus=1, avoid='', typ='farm_tiny'},
   farm_tiny_5     = {burried=1, rotated=0, farming_plus=1, avoid='', typ='farm_tiny'},
   farm_tiny_6     = {burried=1, rotated=0, farming_plus=1, avoid='', typ='farm_tiny'},
   farm_tiny_7     = {burried=1, rotated=0, farming_plus=1, avoid='', typ='farm_tiny'},
   taverne_1       = {burried=1, rotated=0, farming_plus=1, avoid='', typ='tavern'},
   taverne_2       = {burried=1, rotated=0, farming_plus=0, avoid='', typ='tavern'},
   taverne_3       = {burried=1, rotated=0, farming_plus=0, avoid='', typ='tavern'},
   taverne_4       = {burried=1, rotated=0, farming_plus=0, avoid='', typ='tavern'},
   well_1          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},
   well_2          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},
   well_3          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},
   well_4          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},
   well_5          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},
   well_6          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},
   well_7          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},
   well_8          = {burried=1, rotated=0, farming_plus=0, avoid='well', typ='well'},

   tree_place_1    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_2    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_3    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_4    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_5    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_6    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_7    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_8    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_9    = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},
   tree_place_10   = {burried=0, rotated=0, farming_plus=0, avoid='', typ='village_square'},

   dirtroad_1      = {burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},
   black_road_1    = {burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},
   cobble3_road_1  = {burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},
   gravel_road_1   = {burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},
   grey_road_1     = {burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},
   small_grey_road_1={burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},
   stonebrick_road_1={burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},
   wood2_road_1    = {burried=1, rotated=0, farming_plus=0, avoid='', typ='road'},

   river_1         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_2         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_3         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_4         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_5         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_6         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_7         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_8         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_9         = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_10        = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},
   river_11        = {burried=1, rotated=90, farming_plus=0, avoid='', typ='road'},

--[[
   -- Houses from Taokis Structure I/O Mod (see https://forum.minetest.net/viewtopic.php?id=5524)
   default_farm_large     = {burried=1, rotated=180, farming_plus=0, avoid='', typ='farm_full'},
   default_farm_small     = {burried=1, rotated=180, farming_plus=1, avoid='', typ='farm_tiny'},
   default_house_large    = {burried=0, rotated=180, farming_plus=0, avoid='', typ='house'},
   default_house_medium   = {burried=0, rotated=180, farming_plus=0, avoid='', typ='house'},
   default_house_small    = {burried=0, rotated=180, farming_plus=0, avoid='', typ='house'},
   default_tower          = {burried=0, rotated=180, farming_plus=0, avoid='', typ='tower'},
   default_fountain_large = {burried=0, rotated=180, farming_plus=0, avoid='well', typ='well'},
   default_fountain_small = {burried=0, rotated=180, farming_plus=0, avoid='well', typ='well'},
   default_pole           = {burried=0, rotated=180, farming_plus=0, avoid='',     typ='deko'},
--]]
}


-- read the data files and fill in information like size and nodes that need on_construct to be called after placing
villages.init = function()
   -- determine the size of the given houses
   for k,v in pairs( villages.building_data ) do
      -- read the size of the building
      local res  = villages.analyze_mts_file( villages.mts_path..k ); 
      -- store it for later usage 
      villages.building_data[ k ].size = {};
      villages.building_data[ k ].size.x = res.size.x;
      villages.building_data[ k ].size.y = res.size.y;
      villages.building_data[ k ].size.z = res.size.z;

      -- some buildings may be rotated
      if(   villages.building_data[ k ].rotated == 90
        or  villages.building_data[ k ].rotated == 270 ) then

         villages.building_data[ k ].size.x = res.size.x;
         villages.building_data[ k ].size.z = res.size.z;
   --     print('Rotated building. Length: '..tostring( villages.building_data[ k ].size.z )..' width: '..tostring( villages.building_data[ k ].size.x ));
      end

      -- we do need at least the list of nodenames which will need on_constr later on
      villages.building_data[ k ].on_constr = res.on_constr;
      villages.building_data[ k ].nodenames = res.nodenames;

      -- print it for debugging usage
      --print(tostring(size.x)..' x '..tostring(size.y)..' x '..tostring(size.z)..' -> '..tostring( k ));
   end
end



-- at least the cottages may come in a variety of building materials
-- IMPORTANT: don't add any nodes which have on_construct here UNLESS they where in the original file already
--            on_construct will only be called for known nodes that need that treatment (see villages.analyze_mts_file and on_constr)
villages.get_replacement_list = function( housetype )

   local replacements = {};

   -- Taokis houses from structure i/o
   if( housetype == 'taoki' ) then  

      table.insert( replacements, {'default:wood',          'default:clay'});
      table.insert( replacements, {'stairs:slab_wood',      'stairs:slab_sandstone'});
      -- I don't like brick roofs that much
      table.insert( replacements, {'default:brick',         'default:stone'});
      table.insert( replacements, {'stairs:slab_brick',     'stairs:slab_stone'});

      return replacements;
   end

   -- TODO: are there more possible types?
   -- wells can get the same replacements as the sourrounding village; they'll get a fitting roof that way
   if( housetype ~= 'cottages' and housetype ~= 'well') then
      return {};
   end
   -- glass that served as a marker got copied accidently; there's usually no glass in cottages
   table.insert( replacements, {'default:glass',           'air'});
   -- else some grass would never (re)grow (if it's below a roof)
   table.insert( replacements, {'default:dirt',            'default:dirt_with_grass'});

-- TODO: sometimes, half_door/half_door_inverted gets rotated wrong
--   table.insert( replacements, {'cottages:half_door',      'cottages:half_door_inverted'});
--   table.insert( replacements, {'cottages:half_door_inverted', 'cottages:half_door'});

   -- some poor cottage owners cannot afford glass
   if( math.random( 1, 2 ) == 2 ) then
      table.insert( replacements, {'cottages:glass_pane',    'default:fence_wood'});
   end

   -- 'glass' is admittedly debatable; yet it may represent modernized old houses where only the tree-part was left standing
   -- loam and clay are mentioned multiple times because those are the most likely building materials in reality
   local materials = {'cottages:loam', 'cottages:loam', 'cottages:loam', 'cottages:loam', 'cottages:loam', 
                      'default:clay',  'default:clay',  'default:clay',  'default:clay',  'default:clay',
                      'default:wood','default:junglewood','default:sandstone',
                      'default:desert_stone','default:brick','default:cobble','default:stonebrick',
                      'default:desert_stonebrick','default:sandstonebrick','default:stone','default:glass'};

   -- bottom part of the house (usually ground floor from outside)
   local m1 = materials[ math.random( 1, #materials )];
   if( m1 ~= 'default:clay'  ) then
      table.insert( replacements, {'default:clay',           m1});
   end
 
   -- upper part of the house (may be the same as the material for the lower part)
   local m2 = materials[ math.random( 1, #materials )];
   if( m2 ~= 'cottages:loam' ) then
      table.insert( replacements, {'cottages:loam',          m2});
   end

   -- what is sandstone (the floor) may be turned into something else as well
   local mf = materials[ math.random( 1, #materials )];
   -- a glass floor would go too far
   if( mf == 'default:glass' ) then 
      mf = 'cottages:loam';
   end
   if( mf ~= 'default:sandstone' ) then
      table.insert( replacements, {'default:sandstone',      mf});

      -- some houses come with slabs of the material; however, slabs are not available in all materials
      local mfs = string.sub( mf, 9 );
      -- loam and clay: use wood for slabs
      if(  mfs == ':loam' or mfs == 'clay') then 
         mfs = 'wood';
      -- for sandstonebrick, use sandstone
      elseif( mfs == 'sandstonebrick' or mfs == 'desert_stone' or mfs == 'desert_stonebrick') then
         mfs = 'sandstone';
      end
      table.insert( replacements, {'stairs:slab_sandstone',   'stairs:slab_'..mfs});
   end

   -- replace cobble; for these nodes, a stony material is needed (used in wells as well)
   -- mossycobble is fine here as well
   local cob_materials = { 'default:sandstone', 'default:desert_stone',
                      'default:cobble',      'default:cobble',
                      'default:stonebrick',  'default:stonebrick', 'default:stonebrick', -- more common than other materials
                      'default:mossycobble', 'default:mossycobble','default:mossycobble',
                      'default:stone',       'default:stone',
                      'default:desert_stonebrick','default:sandstonebrick'};
   local mc = cob_materials[ math.random( 1, #cob_materials )];
   if( mc ~= 'default:cobble' ) then
      table.insert( replacements, {'default:cobble',         mc});

      -- not all of the materials above come with slabs
      local mcs = string.sub( mc, 9 );
      -- loam and clay: use wood for slabs
      if(  mcs == 'mossycobble') then 
         mcs = 'cobble';
      end
      table.insert( replacements, {'stairs:slab_cobble',      'stairs:slab_'..mcs});
   end



   -- straw is the most likely building material for roofs for historical buildings
   local materials_roof = {'straw', 'straw', 'straw', 'straw', 'straw',
                           'wood',  'wood',  
                           'red',
                           'brown',
                           'black'};
   local mr = materials_roof[ math.random( 1, #materials_roof )];
   if( mr ~= 'straw' ) then
      -- all three shapes of roof parts have to fit together
      table.insert( replacements, {'cottages:roof_straw',              'cottages:roof_'..mr });
      table.insert( replacements, {'cottages:roof_connector_straw',    'cottages:roof_connector_'..mr });
      table.insert( replacements, {'cottages:roof_flat_straw',         'cottages:roof_flat_'..mr });
   end
 
   return replacements;
end







-- taken from https://github.com/MirceaKitsune/minetest_mods_structures/blob/master/structures_io.lua (Taokis Sructures I/O mod)
-- gets the size of a structure file
villages.analyze_mts_file = function( path )
    local size = { x = 0, y = 0, z = 0 }

    path = path..".mts"
    local file = io.open(path, "r")
    if (file == nil) then return nil end

	-- thanks to sfan5 for this advanced code that reads the size from schematic files
	local read_s16 = function(fi)
		return string.byte(fi:read(1)) * 256 + string.byte(fi:read(1))
	end
	local function get_schematic_size(f)
		-- make sure those are the first 4 characters, otherwise this might be a corrupt file
		if f:read(4) ~= "MTSM" then return nil end
		-- advance 2 more characters
		f:read(2)
		-- the next characters here are our size, read them
		return read_s16(f), read_s16(f), read_s16(f)
	end

	size.x, size.y, size.z = get_schematic_size(file)

  
   -- this list is not yet used for anything
   local nodenames = {};
   -- this list is needed for calling on_construct after place_schematic
   local on_constr = {};

   -- after that: read_s16 (2 bytes) to find out how many diffrent nodenames (node_name_count) are present in the file
   local node_name_count = read_s16( file );

   for i = 1, node_name_count do

      -- the length of the next name
      local name_length = read_s16( file );
      -- the text of the next name
      local name_text   = file:read( name_length );

      table.insert( nodenames, name_text );
      -- in order to get this information, the node has to be defined and loaded
      if( minetest.registered_nodes[ name_text ] and minetest.registered_nodes[ name_text ].on_construct) then
         table.insert( on_constr, name_text );
      end
   end

   file.close(file)
   return { size = { x=size.x, y=size.y, z=size.z}, nodenames = nodenames, on_constr = on_constr };
end






-- orientation: 0, 90, 180 or 270
-- housenames: table (list) with the names of houses that can be placed here
--   if you want houses to be more probable than others, list them more than once here
-- interspacing_house_road: table for random space between house and road; has to contain at least one entry of the form  0: <value>
--  example: {95,80,62,10,0} stands for:
--    take 0 as distance if random( 100 ) > 95
--    take 1 as distance if random( 100 ) > 80
--    take 2 as distance if random( 100 ) > 62
--    ..
--    take 4 else
-- interspacing_house_house: see above; this time for space between two subsequent houses
-- max_length: thoe whole house row cannot exceed this length
-- max_witdth: the whole house row (hose width + interspacing_house_road) is not allowed to exceed this value
-- max_houses: allow only that many houses in the row; stop even if max_ength would allow more
-- inverse_street_dir: usually, the street only extends in positive x or z direction; at the end of the road,
--    not all available space may be consumed. with inverse_street_dir set to 1, the "hole" is moved to the other end
-- use_given_order: in case of the central place, the array "housenames" contains the housenames alredy in the desired order
villages.plan_house_row = function( start_pos, orientation, housenames, interspacing_house_road, interspacing_house_house, max_length, max_width, max_houses, inverse_street_dir, allow_branch, use_given_order, start_with, distance_road_start, distance_house_start, village_square, start_with_length )

   local current_length = 0;
   local house_row      = {};
   local house_pos      = { x = start_pos.x, y = start_pos.y, z = start_pos.z };

   local true_length    = 0; -- how long is the road, excluding the last interspacing_house_house?

   local true_width     = 0; -- how wide is the house row?

   local dist_last_branch = 100000; -- when did we last branch off with a new road? (at the start: never - so the distance is huge)

   if( not( allow_branch ) or allow_branch == '' ) then
      dist_last_branch    = -100000; -- this way, we'll never accumulate enough space to branch off
   end



   -- if the street ought to extend in the other direction, start it at the other end
   if( inverse_street_dir == 1 ) then
   
      if( orientation == 0 or orientation == 180 ) then
         start_pos.z = start_pos.z - max_length;
      else
         start_pos.x = start_pos.x - max_length;
      end
   end


   -- at the central place, the distance between the houses from village_square.house_rows_square[ 3 ] and the road needs to be increased
   local inc_space_road  = 0;
   -- at which position are we in village_square.house_rows_square[3]?
   local next_house_at_place = 0;



   while( current_length < max_length and #house_row < max_houses ) do

      local selected_house = '';
      local is_branch = 0;
      local add_rotation_if_branch = 0;


      -- does the village square end here?
      if(     village_square ~= nil 
          and (next_house_at_place == #village_square.house_rows_square[3] + 1 )) then

         inc_space_road = 0;

         -- do this only at the main road
         if( allow_branch ~= nil and allow_branch ~= "") then
            -- add some free space for village_square.house_rows_square[1]
            true_length      = true_length      + village_square.width_row[1]; --length_row[2];
            current_length   = current_length   + village_square.width_row[1]; --length_row[2];
            dist_last_branch = 0;
         end

         -- avoid doing the same again
         next_house_at_place = next_house_at_place + 1;
      end

      -- the first houses the row starts with have been determined alredy; the rest is random!
      if( start_with ~= nil and #house_row < #start_with ) then

         -- Note: Method does not work if inverse_street_dir==1
         selected_house = start_with[ #house_row+1 ];

      -- we are working on the central place
      elseif( village_square ~= nil and next_house_at_place <= #village_square.house_rows_square[ 3 ]) then
      
         -- shall we begin with the place now?
         if(   next_house_at_place   < 1 ) then

            -- sideroad
            if( allow_branch == nil or allow_branch == "" ) then

               next_house_at_place = 1;

            elseif(   dist_last_branch  > villages.MIN_BRANCH_DIST 
              and math.random( 1, 100 ) < villages.BRANCH_PROBABILITY ) then

               next_house_at_place = 1;

               -- add 
               true_length      = true_length      + village_square.width_row[2]; --length_row[1];
               current_length   = current_length   + village_square.width_row[2]; --length_row[1];
               dist_last_branch = -1 * village_square.square_length; --square_width;


               local tree_offset = math.floor( (village_square.square_length - villages.building_data[ village_square.house_rows_square[4][1] ].size.x ) / 2);
               local tree_offset_street = math.floor( (village_square.square_width - villages.building_data[ village_square.house_rows_square[4][1] ].size.z ) / 2)-1;

               -- make sure there is enough place for the road
               if( villages.building_data[ village_square.house_rows_square[ 3 ][ 1 ] ].typ == 'road' ) then
                  tree_offset = tree_offset + villages.building_data[ village_square.house_rows_square[ 3 ][ 1 ] ].size.x;
               else
                  tree_offset = tree_offset - villages.building_data[ village_square.house_rows_square[ 3 ][ #village_square.house_rows_square[3] ] ].size.x;
               end
               if( tree_offset < 0 ) then
                  tree_offset = 0;
               end

               -- place the tree
               if( orientation == 90 or orientation == 270 ) then

                  house_pos.x = start_pos.x + current_length + tree_offset;
                  house_pos.z = start_pos.z + tree_offset_street;
               else
                  house_pos.z = start_pos.z + current_length + tree_offset;
                  house_pos.x = start_pos.x + tree_offset_street;
               end

               house_row[ #house_row + 1 ] = { house     = village_square.house_rows_square[4][1],
                                               dist_next = 0,
                                               dist_road = 0,
                                               pos       = { x = house_pos.x, y = house_pos.y, z = house_pos.z },
                                               size      = villages.building_data[ village_square.house_rows_square[4][1] ].size,
                                               rot       = 0,             -- does not matter in this case
                                               fruit     = nil,           -- no fruit (we plant a tree, not a field)
                                               is_branch = 0,
                                               village_square = nil };
               -- reset house_pos
               house_pos = { x = start_pos.x, y = start_pos.y, z = start_pos.z };
            end
         end

         -- add a house that belongs to the plac
         if( next_house_at_place > 0 ) then

            selected_house      = village_square.house_rows_square[ 3 ][ next_house_at_place ];
            next_house_at_place = next_house_at_place + 1;

            -- how far away do we have to place the houses of village_square.house_rows_square[3] from the main road?
            inc_space_road      = village_square.square_length; ---square_length;

         -- else add a random house
         else
            -- TODO: avoid is not taken into account here
            selected_house = housenames[ math.random( 1, #housenames )];
         end

      -- which house goes at which position has already been determined
      elseif( use_given_order == 1 ) then
         
         -- just get the next from the row
         selected_house = housenames[ #house_row+1 ];
         inc_space_road   = 0;

      -- do we branch off here?
      elseif(    dist_last_branch      > villages.MIN_BRANCH_DIST 
         and math.random( 1, 100 ) < villages.BRANCH_PROBABILITY ) then

         selected_house    = allow_branch; -- select a road
         inc_space_road   = 0;
      else

         -- get a random house
         selected_house = housenames[ math.random( 1, #housenames )];
         inc_space_road   = 0;

         -- avoid to repeat houses/buildings where repeating would be strange (two wells in a row would be pointless)
         while( #house_row > 1 
            and villages.building_data[ house_row[ #house_row ].house ].avoid ~= ''
            and villages.building_data[ house_row[ #house_row ].house ].avoid == 
                villages.building_data[ selected_house                ].avoid ) do

            -- get a new house
            selected_house = housenames[ math.random( 1, #housenames )];
         end
      end


      -- this can only be a branch if it does not consist entirely of road pieces
      if(    villages.building_data[ selected_house ].typ == 'road'
         and villages.building_data[ housenames[ 1 ]].typ ~= 'road') then

         -- if we have a road that branches off from the main road in the street, that one needs to get rotated seperately
         house_length = villages.building_data[ selected_house ].size.x;
         house_width  = villages.building_data[ selected_house ].size.z;

         add_rotation_if_branch = 90;
         is_branch              = 1;
         dist_last_branch  = 0;
      else
         -- the length of the house relative to the street is always the same
         house_width  = villages.building_data[ selected_house ].size.x;
         -- the width of the house; this is only important so that we do not place it too far away from the road
         house_length = villages.building_data[ selected_house ].size.z;

         is_branch              = 0;
         add_rotation_if_branch = 0;
      end

 

      -- add the new house (provided there's space for it)
      if( current_length + house_length < max_length ) then


         -- get a random space between this and the next house
         local a1 = math.random( 1, 100 );
         local space_inbetween = 10000; 
         for i,v in ipairs( interspacing_house_house ) do
            if( a1 > v and space_inbetween == 10000) then 
               space_inbetween = (i-1);
            end
         end

         -- do not exceed the limit with the space between houses if there's no next house coming
         if( current_length + house_length + space_inbetween > max_length ) then
            space_inbetween = 0;
         end


         --how far away from the road does the house start?
         local space_road = 10000; 


         -- increase space at the central village place
         if( inc_space_road ~= 0 and is_branch ~= 1) then
            space_road = -1 + inc_space_road;

         -- most roads will interconnect nicely that way
         elseif( is_branch==1 ) then
            space_road = -1;

         -- make room for a village place
         elseif( start_with ~= nil and (#house_row < #start_with or current_length < start_with_length)) then
            space_road = distance_road_start;
--print( 'distance_road_start: '..tostring( distance_road_start ).." for house "..tostring( selected_house ));

         else
            -- the house may be some nodes away from the road
            local a2 = math.random( 1, 100 );
            for i,v in ipairs( interspacing_house_road ) do
               if( a1 > v and space_road == 10000) then 
                  space_road = (i-1);
               end
            end

            -- make sure we do not get too wide with that
            if( house_width + space_road > max_width ) then
               space_road = 0;
            end

            -- how wide is the road at its widest point? this will be important for further roads branching off
            if( house_width + space_road > true_width ) then
               true_width = house_width + space_road;
            end
         end

         -- this helps to calculate the coordinates
         if( orientation == 90 or orientation == 180 ) then
            space_road = space_road * -1;
         end

         local dir = 1;
--         if( inverse_street_dir == 1 ) then
--            dir = -1;
--         end
         -- house_pos may need to be transformed since place_schematic walks in positive x- and z- direction
         if( orientation == 90 or orientation == 270 ) then

            house_pos.x = start_pos.x + ( dir * current_length);
            house_pos.z = start_pos.z + space_road;
         else
            house_pos.z = start_pos.z + ( dir * current_length);
            house_pos.x = start_pos.x + space_road;
         end


         local rotation = orientation + villages.building_data[ selected_house ].rotated + add_rotation_if_branch;
         while( rotation >= 360 ) do
            rotation = rotation - 360;
         end


         if( is_branch ~= 1 ) then
            if(     (orientation == 180 )) then
               house_pos.x = house_pos.x - house_width;
            elseif( (orientation == 90  )) then
               house_pos.z = house_pos.z - house_width;
            end
         else
            if(     orientation==180 ) then
               house_pos.z = house_pos.z + house_length;
            elseif( orientation==0) then
               house_pos.z = house_pos.z + house_length;

            end
         end




         -- determine which fruit is grown (this is later on important for spawning suitable traders for that fruit in the vicinity of the house)
         local fruit = '';
         if( villages.building_data[ selected_house ].farming_plus == 1 ) then
            fruit = villages.farming_plus_fruits[ math.random( 1, #villages.farming_plus_fruits )];
         end

         -- pass on the copy
         local village_square_copy = nil;
         if( is_branch == 1 and village_square ~= nil and inc_space_road > 0) then
            village_square_copy = village_square;
         end
         
         -- some buildings are already rotated
         -- size and pos are redundant; they get saved in order to prevent chaos due to later change of the content of the .mts file through the user
         house_row[ #house_row + 1 ] = { house = selected_house, dist_next = space_inbetween, dist_road = space_road,
                                         pos   = { x = house_pos.x, y = house_pos.y, z = house_pos.z },
                                         size  = villages.building_data[ selected_house ].size,
                                         rot   = rotation,
                                         fruit = fruit,
                                         is_branch = is_branch,
                                         village_square = village_square_copy };

         -- the row got longer
         true_length      = current_length   + house_length;
         current_length   = current_length   + house_length + space_inbetween;
         dist_last_branch = dist_last_branch + house_length + space_inbetween;

      -- no more space, so make sure the main loop does not run again
      else
         max_houses = 0;
      end
   end
   

   -- let the road extend into the other direction
   if( inverse_street_dir == 1 ) then 

   
      if( orientation == 0 or orientation == 180 ) then
         start_pos.z = start_pos.z + max_length;
      else
         start_pos.x = start_pos.x + max_length;
      end

 
      -- how much space is left empty at the end of the road?
      local leftover = max_length - true_length;

      -- which value gets modified depends on the orientation
      local move_x = 0;
      local move_z = 0;
      if( orientation == 90 or orientation == 270 ) then
         move_x = leftover;
      else
         move_z = leftover;
      end

      -- apply the movement
      for k,v in pairs( house_row ) do
         house_row[ k ].pos.x = house_row[ k ].pos.x + move_x;
         house_row[ k ].pos.z = house_row[ k ].pos.z + move_z;
      end
   end


   if( #house_row == 0 ) then
      print( ' ERROR: NO HOUSE FOR ROAD. Length: '..tostring( max_length )); -- TODO
      return { {road_length=0, road_width=0} };
   end
   -- store the road length
   house_row[ 1 ].road_length = true_length;
   house_row[ 1 ].road_width  = true_width;
   return house_row;
end



-- the function works only if each road is at least large enough for one house
-- max_houses is a limit for *each* side of the house rows - not for both combined
villages.plan_road_with_house_rows = function( start_pos_orig, orientation, housenames,
                                               interspacing_house_road, interspacing_house_house,
                                               max_length, max_width, max_houses, roadnames, recursion_depth, buildings_offset, village_square )

   -- north/south or east/west are generated the same - inverse_street_dir makes the distinction
   local inverse_street_dir = 0;
   if( orientation == 180 or orientation == 90 ) then
      inverse_street_dir = 1;
      buildings_offset   = -1 * buildings_offset;
   else
      inverse_street_dir = 0;
   end 

   local start_pos = { {}, {}};
   -- start_pos needs to be adjusted - depending on how wide the road is
   start_pos[ 1 ] = { x = start_pos_orig.x, y = start_pos_orig.y, z = start_pos_orig.z };
   start_pos[ 2 ] = { x = start_pos_orig.x, y = start_pos_orig.y, z = start_pos_orig.z };

   -- find out how large the road pieces are (they're required to all have the same size!)
   local road_size  = { x = villages.building_data[ roadnames[ 1 ]].size.x,
                        y = villages.building_data[ roadnames[ 1 ]].size.y,
                        z = villages.building_data[ roadnames[ 1 ]].size.z };


   -- adjust start_pos according to road_size
   if( orientation == 0 or orientation == 180 ) then

      start_pos[1].x = start_pos[1].x + road_size.x;
      start_pos[2].x = start_pos[1].x - road_size.x;

      start_pos[1].z = start_pos[1].z + buildings_offset;
      start_pos[2].z = start_pos[2].z + buildings_offset;
   else
      start_pos[1].z = start_pos[1].z - road_size.x;
      start_pos[2].z = start_pos[1].z + road_size.x;

      start_pos[1].x = start_pos[1].x + buildings_offset;
      start_pos[2].x = start_pos[2].x + buildings_offset;
   end   

   -- the houses on both sides of the road face each other - thus they have opposite orientations
   local orientations = { orientation, orientation };
   if( orientation == 0 or orientation == 180 ) then
      orientations[1] = 0;
      orientations[2] = 180;
   else
      orientations[1] = 90;
      orientations[2] = 270;
   end
 
   -- the whole construct (two house rows + road in the middle) shall not exceed max_width
   local max_row_width = math.floor( max_width - road_size.x ) / 2;

   -- do not create branches if they are not allowed anyway
   local allow_branch  = '';
   if( recursion_depth < 1 ) then
      allow_branch = roadnames[1];
   end

   local house_rows = { {}, {} };

    -- determine the data for the central village square - of which we need only one
   local village_squares = {nil,nil};
   if( recursion_depth < 1 ) then
--      village_squares[ math.random( 1,2 )] = villages.plan_village_square( 'cottages', allow_branch );

      -- all house rows are constructed in positive direction - thus we can add the square only reiiably at one side
      local place_square_at_side = 1;
      if( orientation == 90 or orientation == 270 ) then
         place_square_at_side = 2;
      end
      village_squares[ place_square_at_side ] = villages.plan_village_square( 'cottages', allow_branch );

print('VILLAGE SQUARE TYP: '..minetest.serialize( village_squares ));
   end

   for i = 1,2 do

      if( village_square ~= nil ) then

         local new_index = {1,2};
         local start_with          = village_square.house_rows_square[ i ];
         if( orientation==90 or orientation==270 ) then
            new_index = {2,1};
            start_with             = village_square.house_rows_square[ new_index[i] ];
         end
         --local distance_road_start = village_square.square_length + 1; --length_row[3] + 1; --village_square.square_width;
         --local distance_road_start = village_square.length_row[3] + 1; --village_square.square_width;
         local distance_road_start = village_square.square_width + 1; --village_square.square_width;
         local start_with_length   = distance_road_start + village_square.width_row[ 3 ]+1;

         if( ((orientation==90 or orientation==270) and
             ( (i==2 and villages.building_data[ village_square.house_rows_square[ 3 ][ #village_square.house_rows_square[ 3 ] ]].typ == 'road') 
             or(i==1 and villages.building_data[ village_square.house_rows_square[ 3 ][ 1 ]                                     ].typ == 'road')))

          or ((orientation==0  or orientation==180) and
             ( (i==1 and villages.building_data[ village_square.house_rows_square[ 3 ][ #village_square.house_rows_square[ 3 ] ]].typ == 'road') 
             or(i==2 and villages.building_data[ village_square.house_rows_square[ 3 ][ 1 ]                                     ].typ == 'road')))) then
            distance_road_start = 0;
         else
            start_with[ #start_with+1 ] = housenames[ math.random(1,#housenames )];
         end
         house_rows[ i ] = villages.plan_house_row( start_pos[ i ], orientations[ i ],
                                               housenames, {101,0}, {101,0},
                                               math.floor( max_length * 3.0/4.0), max_row_width, max_houses, inverse_street_dir, allow_branch, 0,
                                               start_with, distance_road_start, 0, village_squares[i], start_with_length );
      else
         house_rows[ i ] = villages.plan_house_row( start_pos[ i ], orientations[ i ],
                                               housenames, interspacing_house_road, interspacing_house_house,
                                               max_length - math.abs(buildings_offset), max_row_width, max_houses, inverse_street_dir, allow_branch, 0, nil,0,0, village_squares[i],0);
      end

      -- handle any new branches that came up
      if( recursion_depth < 1) then 
         for j,v in ipairs( house_rows[ i ] ) do
            if( v.is_branch == 1 ) then
 
               local branch_buildings_offset =  house_rows[ i ][ 1 ].road_width + 2;

               -- the new road shall be no longer than 2/3 that of the old one
               local branch_max_length = math.random( 1, math.floor( max_length * 2.0/3.0));
               -- ...but at least some nodes long (else there won't be enough space for at least one house
               if( branch_max_length < 30 ) then
                  branch_max_length = 30 + math.abs( branch_buildings_offset );
               end 

               local branch_orientation = orientations[i] + 90;
               if( branch_orientation >= 360 ) then
                  branch_orientation = 0;
               end

               -- these need rotation in the opposite direction
               if(     branch_orientation == 90 ) then
                  branch_orientation = 270;
               elseif( branch_orientation == 270 ) then
                  branch_orientation =  90;
               end

               local new_road_pos = {x=v.pos.x, y=v.pos.y, z=v.pos.z};

               if( v.village_square ~= nil) then
                  -- TODO
                  branch_buildings_offset   = 2;
               end
               -- plan the road that branches off to the side
               local branch_road = villages.plan_road_with_house_rows( new_road_pos,
                                               branch_orientation,
                                               housenames, interspacing_house_road, interspacing_house_house,
                                               branch_max_length,
                                               max_width, max_houses, roadnames, (recursion_depth+1), branch_buildings_offset, v.village_square )
               -- save it
               house_rows[ i ][ j ].branch = branch_road;
            end 
         end -- of for
      end -- of if( recursion_depth)
   end

   -- the road can be built the same way - by adding diffrent road parts; interspacing is always 0
   -- no branches allowed here (these are handled on the sides)
   local road_row   = villages.plan_house_row( start_pos_orig,  orientations[ 1 ],
                                               roadnames, {0}, {0},
-- TODO: add length to the road to compensate for branch_buildings_offset?
                                               max_length, road_size.x+1, 100000, inverse_street_dir, nil, 0, nil, 0,0, nil, 0 ); 
   
   -- how long is the road? determine the maximum
   local length = math.max( house_rows[ 1 ][ 1 ].road_length, house_rows[ 2 ][ 1 ].road_length );
   length = math.max(       road_row[   1 ].road_length, length );
   
   return { house_rows   = { house_rows[ 1 ], house_rows[ 2 ], {}, {} },
            road_row     = road_row,
            length       = length,
            orientations = { orientation1, orientation2, nil, nil }
          };
end



-- place one schematic; if replacements is given, write a temporary file for the new schematic
villages.build_house = function( pos, housename, orientation, replacements, new_fruit )

   if( not( housename )) then
      print( 'ERROR! Missiong housename in villages.build_house.');
      return;
   end

   local new_filename = villages.mts_path..housename..'.mts';

   -- churches always come with glass - even if the other buildings can't afoord it
   if( villages.building_data[ housename ].typ == 'church' ) then 
      for i,v in ipairs( replacements ) do
         if( v ~= nil and v[1]=='cottages:glass_pane' and v[2]=='default:fence_wood' ) then
            replacements[ i ] = nil;
         end
      end
   end

   -- houses with farming_plus set to 1 grow farming_plus stuff instead of the cotton they come with
   if( villages.building_data[ housename ].farming_plus == 1 ) then
      if( replacements == nil ) then
         replacements = {};
      end
      
      if( not( new_fruit ) or new_fruit == '' ) then
         new_fruit = 'cotton'; -- fallback
      end 
      -- cotton may come in up to 8 variants (not that they look much diffrent...)
      for i=1,8 do
         
         local new_fruit_name = new_fruit;
         -- farming_plus plants sometimes come in 3 or 4 variants, but not in 8 as cotton does
         -- "surplus" cotton variants will be replaced with the full grown fruit
         if( minetest.registered_nodes[ 'farming_plus:'..new_fruit_name..'_'..i ]) then
            new_fruit_name = new_fruit_name..'_'..i;
            table.insert( replacements, {"farming:cotton_"..i,  'farming_plus:'..new_fruit_name });

         elseif( minetest.registered_nodes[ 'farming:'..new_fruit_name..'_'..i ]) then
            new_fruit_name = new_fruit_name..'_'..i;
            table.insert( replacements, {"farming:cotton_"..i,  'farming:'..new_fruit_name });

         end
      end
   end

   local help_size = { x = villages.building_data[ housename ].size.x,
                       y = villages.building_data[ housename ].size.y,
                       z = villages.building_data[ housename ].size.z };

   if( orientation==90 or orientation==270 ) then
      help_size.x = help_size.z;
      help_size.z = villages.building_data[ housename ].size.x;
   end

   local start_pos =  {x=pos.x, y=(pos.y - villages.building_data[ housename ].burried), z=pos.z};
   local end_pos   =  {x=(start_pos.x + help_size.x),
                       y=(start_pos.y + help_size.y),
                       z=(start_pos.z + help_size.z) };

   -- actually build the house
   minetest.place_schematic( start_pos, new_filename, orientation, replacements );


   local building_size = villages.building_data[ housename ].size;

   for i, v in ipairs( villages.building_data[ housename ].on_constr ) do 

      -- there are only very few nodes which need this special treatment
      local nodes = minetest.find_nodes_in_area( start_pos, end_pos, v);

      -- at the start of this mod, we've already checked that the node and an on_construct function for it exist
      for _, p in ipairs( nodes ) do
         minetest.registered_nodes[ v ].on_construct( p );
      end

   end

   -- write something on signs 
   local signs  = minetest.find_nodes_in_area( start_pos, end_pos, 'default:sign_wall');
   for _, p in ipairs( signs ) do
      -- TODO: write the name of the inhabitants on the signs

      local meta  = minetest.get_meta( p );
      local descr = 'This is '..tostring( housename )..'.';
      if( new_fruit and new_fruit ~= '' ) then

         local pluralname = new_fruit;
         if(     new_fruit == 'rhubarb' or new_fruit=='cotton' ) then
            pluralname = new_fruit;
         elseif( new_fruit == 'tomato' ) then
            pluralname = 'tomatoes';
         elseif( new_fruit == 'strawberry' ) then
            pluralname = 'strawberries';
         else
            pluralname = new_fruit..'s';
         end
         descr = descr..' We grow '..tostring( pluralname )..'!';

      elseif( villages.building_data[ housename ].typ == 'farm_full' ) then
         descr = descr..' We grow wheat.';
      end
      meta:set_string( 'text',     descr );
      meta:set_string( 'infotext', descr );
   end

 
   -- fill chests with content
   for i,v in ipairs( {'cottages:chest_private','cottages:chest_storage', 'cottages:chest_work' } ) do 
      local chests = minetest.find_nodes_in_area( start_pos, end_pos, v );
      for _, p in ipairs( chests ) do
         fill_chest.fill_chest_random( p );
      end
   end

   --print( tostring( pos.x )..':'..tostring( pos.y )..':'..tostring( pos.z )..' '..tostring( orientation )..' -> '..tostring( new_filename ));
end



-- actually build the road in the world
villages.build_road = function( road, replacements )

   -- build the road as such
   for i,v in ipairs( road.road_row ) do
      villages.build_house( v.pos, v.house, v.rot, replacements, v.fruit );
   end

   -- for all houee rows 
   for j,w in ipairs( road.house_rows ) do
 
      -- build house row nr. j
      for i,v in ipairs( road.house_rows[ j ] ) do

         if( v.is_branch ~= 1 or not( v.branch)) then
            villages.build_house( v.pos, v.house, v.rot, replacements, v.fruit );

         -- build branches recursively
         else
            villages.build_road( v.branch, replacements );
         end
      end
   end
end



villages.plan_village_square = function( typ, road )

   -- all this needs to go into the center
   local churches = {};
   local inns     = {};
   local forges   = {}; -- the forge is debatable; at least we put a well next to it!
   local wells    = {};
   local trees    = {};
   local houses   = {};

   -- which buildings of each type are available?
   if( typ == 'cottages' ) then
      -- the churches are all the same - just rotated a bit 
      churches = {'church_1'}; --,'church_2','church_3','church_4'};
      inns     = {'taverne_1','taverne_2'}; -- taverne_3 and taverne_4 are too small for the central village place
      forges   = {'forge_1'};
      wells    = {'well_1','well_2','well_3','well_4','well_5','well_6','well_7','well_8',};
      trees    = {'tree_place_1','tree_place_2','tree_place_3','tree_place_4','tree_place_5','tree_place_6','tree_place_7','tree_place_8','tree_place_9','tree_place_10'};
   end 

   -- select one of each building types
   local church = churches[ math.random( 1, #churches ) ];
   local inn    = inns[     math.random( 1, #inns     ) ];
   local forge  = forges[   math.random( 1, #forges   ) ];
   local well   = wells[    math.random( 1, #wells    ) ];
   local tree   = trees[    math.random( 1, #trees    ) ];
   

   -- arrange the numbers 1-4 in a random pattern
   local help  = {1,2,3}; -- possible positions in the list...
   local sort  = {};

   for i = 1, 2 do
      local nr = math.random( 1, #help );
      sort[ #sort + 1 ] = help[ nr ];
      table.remove( help, nr );
   end
   -- get the last number
   sort[ #sort + 1 ] = help[ 1 ];


   -- the four house rows around the central village place; the 5th represents the place center
   local rows = { {}, {}, {}, {}, {}};
   rows[ sort[ 1 ]] = { church };
   rows[ sort[ 2 ]] = { inn };
   -- the well can be left or right of the forge
   if( math.random(1,2)==1 ) then
      rows[ sort[ 3 ]] = { forge, well };
   else
      rows[ sort[ 3 ]] = { well, forge };
   end
   -- the tree is always in the middle
   rows[ 4 ] = { tree };
 

   -- how much space is needed (regarding street length) for each of the rows?
   local row_min_length = { 0, 0, 0, 0 };
   row_min_length[ sort[ 1 ]] = villages.building_data[ church ].size.z + 2;
   row_min_length[ sort[ 2 ]] = villages.building_data[ inn    ].size.z;
   row_min_length[ sort[ 3 ]] = villages.building_data[ forge  ].size.z + 1  -- space inbetween
                              + villages.building_data[ well   ].size.z;
   
   -- +1 for some distance to the road
   local row_min_width  = { 0, 0, 0, 0 };
   row_min_width[  sort[ 1 ]] = villages.building_data[ church ].size.x+1;
   row_min_width[  sort[ 2 ]] = villages.building_data[ inn    ].size.x+1;

   -- either the forge or the well defines how wide this is
   if( villages.building_data[ forge ].size.x >
       villages.building_data[ well  ].size.x ) then

      row_min_width[sort[ 3]] = villages.building_data[ forge  ].size.x+1;
   else
      row_min_width[sort[ 3]] = villages.building_data[ well   ].size.x+1;
   end

   -- there has to be at least enough space for the tree
   local min_length = villages.building_data[ tree ].size.x + 4;
   local min_width  = villages.building_data[ tree ].size.z + 4;
   -- make it quadratic so that rotation is no problem
   if( min_length < min_width ) then
      min_length = min_width;
   else
      min_width  = min_length;
   end

   -- row 1 and 2 are opposite of each other
   if( row_min_length[ 1 ] > min_length ) then
      min_length = row_min_length[ 1 ];
   end
   if( row_min_length[ 2 ] > min_length ) then
      min_length = row_min_length[ 2 ];
   end
  

   -- row 3 and 4 are opposite each other and at a right angel compared towards row1 and row2
   if( row_min_length[ 3 ] > min_width  ) then
      min_width  = row_min_length[ 3 ];
   end
   local min_total_width  = min_width  + row_min_width[ 1 ] + row_min_width[ 2 ];

   -- we need to add a road that branches off - either at the start or at the end of the 3rd row
   if( math.random(1,2) == 1 ) then
      table.insert( rows[3], 1, road ); -- insert at beginning
   else
      table.insert( rows[3],    road ); -- append
   end
   -- TODO: this may affect min_width/min_length

   return { -- the rows of houses at the square; row 3 is opposite of the main road
            house_rows_square        = rows,
            -- how far away do we have to place the houses of house_rows_square[3] from the main road?
            square_length            = min_length+1,
            -- in case rows[3] is shorter than the place needed for the tree and some space around:
            square_width             = min_width,
            -- how much space do we have do reserve for rows[1]?
            width_row                = row_min_width,
            length_row               = row_min_length,
            -- how much space do we have to leave between road and the house rows of the road that branches off?
            dist_road_branch         = min_length + row_min_width[ 3 ] +2,
          };
end


-- tiny farms are much more common than large ones; in this case: 8 times more common
villages.houses_cottages    =  {'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'farm_tiny_1','farm_tiny_2','farm_tiny_3','farm_tiny_4','farm_tiny_5','farm_tiny_6','farm_tiny_7',
                                'hut_1', 'hut_1', 'hut_1',
                                'farm_full_1','farm_full_2','farm_full_3','farm_full_4','farm_full_5','farm_full_6',
                                'farm_full_1','farm_full_2','farm_full_3','farm_full_4','farm_full_5','farm_full_6',
                                'farm_full_1','farm_full_2','farm_full_3','farm_full_4','farm_full_5','farm_full_6',
                                'well_1', 'well_2', 'well_3', 'well_4', 'well_5', 'well_6', 'well_7', 'well_8',
                                'taverne_3','taverne_4', -- small taverns
 };
                                
villages.houses_taoki       = {
   'default_farm_large',
   'default_farm_small',
   'default_fountain_large',
   'default_house_large',
   'default_house_medium',
   'default_house_small',
   'default_tower',
   'default_fountain_small',
   'default_pole' };





minetest.after( 0, villages.init);

-- contains all it takes to fill chests with random items possibly found in homes
dofile(minetest.get_modpath("villages").."/fill_chest.lua");


minetest.register_chatcommand("road", {
        params = "<orientation>",
        description = "Builds a road with the given orientation (0,90,180 or 270).",
        privs = {},
        func = function(name, param)

                if( param ~= "0" and param ~= "90" and param ~= "180" and param ~= "270" ) then
                   minetest.chat_send_player(name, "This value of orientation is not supported.");
                   return;
                end

--local square = villages.plan_village_square( 'cottages', 'dirtroad_1');
--minetest.chat_send_player( name, minetest.serialize( square ));
--if( 1==1 ) then return; end


                local player = minetest.env:get_player_by_name(name);
                local pos    = player:getpos();

                minetest.chat_send_player(name, "Building road with orientation "..param.." at your position: "..minetest.serialize( pos )..".");
                param = tonumber( param );


                local distances_road = {101,90,70,20,10,0};
--              local distances_road = {101,101,101,101,101,101,90,80,70,60,50,40,30,20,10,0};  -- very wide-spaced
                local distances_houses = {101,60,20,0}; -- never without any distance (because many cottages have fences)
-- TODO: for testing
distances_road = {101,0};
distances_houses = {101,0};
 
                -- usually a dirt road; roughly each 3th street gets build alongside a river
                local street_nodes = {'river_1', 'dirtroad_1', 'black_road_1', 'cobble3_road_1', 'dirtroad_1', 'gravel_road_1',
                                      'grey_road_1', 'small_grey_road_1',  'stonebrick_road_1', 'wood2_road_1'};
                local selected_road = math.random( 1, #street_nodes );
                if( selected_road ==1 ) then
                   street_nodes = {'river_1','river_2','river_3','river_4','river_5','river_6','river_7','river_8','river_9','river_10','river_11'};
                else
                   street_nodes = { street_nodes[ selected_road ] };
                end
                    
                local replacements = {};
                local houses_road = villages.houses_cottages;
                if( math.random( 1,4 )==-1) then -- TODO: disabled for now
                   houses_road  = villages.houses_taoki;
                   replacements = villages.get_replacement_list( 'taoki' ); 
                else
                   replacements = villages.get_replacement_list( 'cottages' );
                end

-- TODO 
--local tmpres = villages.plan_village_square( 'cottages', 'dirtroad_1' );
--print( minetest.serialize( tmpres ));
----                villages.build_road( tmpres, replacements );
--if (1==1) then return; end

                -- plan the road
                local my_road =  villages.plan_road_with_house_rows( {x=pos.x,y=(pos.y+0.5),z=pos.z}, param, houses_road, distances_road, distances_houses,130,90,30,street_nodes,0,0,nil);



                -- actually build it (place the houses etc.)
                villages.build_road( my_road, replacements );
 
                minetest.chat_send_player(name, "ROAD building finished successfully.");
             end
});



