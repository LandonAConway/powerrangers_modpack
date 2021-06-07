morphinggrid.grid_doc.registered_documentations = {}

function morphinggrid.grid_doc.register_documentation(name, def)
	morphinggrid.grid_doc.registered_documentations[name] = def
end

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

morphinggrid.grid_doc.register_type("documentations", {
	description = "Documentations",
	
	formspec = function(player, name)
		local itemdef = morphinggrid.grid_doc.registered_documentations[name]
		local player_name = player:get_player_name()
		
		local f = "label[5.4,0.6;Name: "..(itemdef.description or name).."]"..
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