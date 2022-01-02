morphinggrid.grid_doc.registered_documentations = {}

function morphinggrid.grid_doc.register_documentation(name, def)
	morphinggrid.grid_doc.registered_documentations[name] = def
end

morphinggrid.grid_doc.register_type("documentations", {
	description = "Documentations",
	
	formspec = function(player, name)
		local itemdef = morphinggrid.grid_doc.registered_documentations[name]
		local player_name = player:get_player_name()
		
		local f = "label[5.4,0.6;Name: "..(minetest.formspec_escape(itemdef.description or name)).."]"..
		"style[description;border=false]"..
		"box[5.4,0.8;14.4,12;#0f0f0f]"..
		"textarea[5.4,0.8;14.4,12;description;;"..(minetest.formspec_escape(itemdef.about) or "No description.").."]"
		
		return f
	end,
	
	get_items = function()
		local t = {}
		for k, v in pairs(morphinggrid.grid_doc.registered_documentations) do
			table.insert(t, {desc=v.description or k, name=k, data={k}})
		end
		table.sort(t, function(a,b) return a.name < b.name end)
		return t
	end,
	
	filter = function(text, name)
		local item = morphinggrid.grid_doc.registered_documentations[name]
		if string.find(name, text) or string.find(item.description or name, text)
			or string.find(item.about, text) then
			return true
		end
		return false
	end
})

--documentations
morphinggrid.grid_doc.register_documentation("introduction", {
	description = "Introduction",
	about = "The Morphing Grid ([morphinggrid] mod) is an API that is responsible for creating the Power Rangers"..
	
			". Without it, there would "..
			
			"be no Power Rangers. "..
			
			"The Morphing Grid contains the power of the rangers that can be harnessed by a civilian. There are many different kinds "..
			
			"of power rangers. Each ranger is assigned to a team."..
			
			" The Morphing Grid cannot be accessed without a morpher, or an object which "..
			
			"has a connection to it. 'Morphing' is a term used to describe the action of "..
			
			"becoming a power ranger, while 'Demorphing' means to become a civilian again. The usage of a morpher is the most common way to access "..
			
			"the Morphing Grid. A morpher is usually a handheld device which contains a direct link to the Morphing Grid, or it contains an object "..
			
			"with a link to the Morphing Grid… so without one of them, "..
			
			"a person or player cannot become a power ranger since it is what gives the player their powers unless you are an admin and have the 'morphinggrid' priv."
})

morphinggrid.grid_doc.register_documentation("morphing_and_demorphing", {
	description = "Morphing & Demorphing",
	about = "'Morphing' is a term used to describe the action of becoming a power ranger, while 'demorphing' means to "..
	
	"become a civilian again. To morph, you will need a morpher. Once you have one, you can usually click while holding "..
	
	"the morpher to morph. To demorph, you just need to type '/demorph' in the chat console. ".. 
	
	"When you are morphed, you will need to pay close attention to your armors 'wear'. "..
	
	"If you let your armor wear all the way, you will automatically demorph, and you will loose your powers which "..
	
	"means that you might not be able to morph again for a while (depending on how hard of a hit you took) "..
	
    "When you are not morphed, your powers will "..
	
	"regenerate and the next time you morph, your armor will be stronger. The longer you wait, the stronger your "..
	
	"armor will be the next time you morph."
})

morphinggrid.grid_doc.register_documentation("morpher_slots", {
	description = "Morpher Slots",
	about = "Morpher slots is a special feature much like crafting. The concept of morpher slots is supposed to "..
	
	"be used as if you are inserting an item into a morpher. A morpher is used as a vessle to directly connect to, "..
	
	"the morphing grid but a morpher in and of itself does not have a direct connection to the Morphing Grid. This is "..
	
	"where Grid Items come into play. A grid item is any item that has a direct connection to the Morphing Grid. "..
	
	"Some morphers have slots where grid items can be interted into, some have the grid items built into them, "..
	
	"and other morphers are actual grid items (in which case it isn't just a 'vessle'). "..
	
	"To access morpher slots, just hold your morpher (or place your prefered morpher in the single slot of the morphers "..
	
	"inventory accessed by typing '/morphers') and type '/morpher slots'. This should bring up a formspec."
})