minetest.register_chatcommand("grid_doc", {
	description = "Shows a documentation of the Morphing Grid.",
	func = function(name)
		 morphinggrid.grid_doc.show_formspec(name, 1, 1)
	end
})