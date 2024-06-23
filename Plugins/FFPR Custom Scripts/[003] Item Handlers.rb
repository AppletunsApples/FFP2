# Super Capsule
temHandlers::UseOnPokemon.add(:SUPERCAPSULE, proc { |item, qty, pkmn, scene|
  if scene.pbConfirm(_INTL("Do you want to change {1}'s Ability?", pkmn.name))
    abils = pkmn.getAbilityList
    ability_commands = []
    abil_cmd = 0
    abil1 = nil
    abil2 = nil
    abils.each do |i|
      abil1 = i[0] if i[1] == 0
      abil2 = i[0] if i[1] == 1
    end
    for i in abils
      ability_commands.push(((i[1] < 2) ? "" : "(H) ") + GameData::Ability.get(i[0]).name)
    end
    if abil1.nil? || abil2.nil? || pkmn.isSpecies?(:ZYGARDE)
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    cmd = pbMessage("Which ability do you want for your Pokémon?", ability_commands, 0, nil, 0)
    pkmn.ability = abils[cmd][0]
    pkmn.ability_index = abils[abil_cmd][1]
    pkmn.ability = nil
    scene.pbDisplay(_INTL("{1}'s ability changed to {2}!", pkmn.name, pkmn.ability.name))
  next true
  end
})

# Dazzling Mint
ItemHandlers::UseOnPokemon.add(:DAZZLINGMINT, proc { |item, qty, pkmn, scene|
  scene.pbDisplay(_INTL("Select a new nature for {1}.", pkmn.name))
  commands = []
  ids = []
  GameData::Nature.each do |nature|
    next if pkmn.nature == nature.id
    commands.push(_INTL("{1}", nature.name))
    ids.push(nature.id)
  end
  commands.push(_INTL("Cancel"))
  msg = _INTL("{1}'s nature: {2}", pkmn.name, pkmn.nature.name)
  cmd = scene.pbShowCommands(_INTL("Give which nature?\n#{msg}", pkmn.name), commands, 0)
  next false if cmd < 0 || cmd >= commands.length - 1
  pkmn.nature = ids[cmd]
  pkmn.calc_stats
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was given the {2} nature.", pkmn.name, pkmn.nature.name))
  next true
})
