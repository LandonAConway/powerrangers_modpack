morphinggrid.registered_rangertypes = {}
rangertype = {}

function morphinggrid.register_rangertype(name, rangertypedef)
  rangertypedef.name = name
  rangertypedef.weapons = rangertypedef.weapons or {}
  morphinggrid.registered_rangertypes[name] = rangertypedef
  --table.insert(morphinggrid.registered_rangertypes, rangertypedef)
end

function morphinggrid.get_rangertype(name)
  for i, v in pairs(morphinggrid.registered_rangertypes) do
    if v.name == name then
      return v
    end
  end
  return nil
end

function morphinggrid.get_registered_rangertypes()
  return morphinggrid.registered_rangertypes
end