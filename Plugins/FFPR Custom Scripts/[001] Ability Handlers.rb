Battle::AbilityEffects::OnBeingHit.add(:CONTACTFREEZE,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    next if user.burned? || battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(target)
    if user.pbCanFrostbite?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} froze {3}!", target.pbThis, target.abilityName, user.pbThis(true))
      end
      user.pbFrostbite(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:SHARPSTONE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :ROCK
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:REFURBISH,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :STEEL
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:EXTREMECOLD,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :ICE
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:CRYSTALIZE,
  proc { |ability, user, target, move, mults, power, type|
    if user.hp <= user.totalhp / 3 && type == :ICE
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::OnBeingHit.add(:UNFEATHERED,
  proc { |ability, user, target, move, battle|
    next if !move.physicalMove?
    next if !target.pbCanLowerStatStage?(:ATTACK, target) && !target.pbCanLowerStatStage?(:SPECIAL_ATTACK, target) &&
            !target.pbCanRaiseStatStage?(:SPEED, target)
    battle.pbShowAbilitySplash(target)
    target.pbLowerStatStageByAbility(:SPEED, 2, target, false)
    target.pbRaiseStatStageByAbility(:ATTACK,
       (Settings::MECHANICS_GENERATION >= 7) ? 1, target, false)
    target.pbRaiseStatStageByAbility(:SPECIAL_ATTACK,
       (Settings::MECHANICS_GENERATION >= 7) ? 1, target, false) 
    battle.pbHideAbilitySplash(target)
  }
)