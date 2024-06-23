#===============================================================================
# Power Wash
#===============================================================================
# Removes trapping moves, entry hazards and Leech Seed on user/user's side.
# Paralyzes the target.
#-------------------------------------------------------------------------------
class Battle::Move::RemoveUserBindingAndEntryHazardsParalyzeTarget < Battle::Move::ParalyzeTarget
  def pbEffectAfterAllHits(user, target)
    return if user.fainted? || target.damageState.unaffected
    if user.effects[PBEffects::Trapping] > 0
      trapMove = GameData::Move.get(user.effects[PBEffects::TrappingMove]).name
      trapUser = @battle.battlers[user.effects[PBEffects::TrappingUser]]
      @battle.pbDisplay(_INTL("{1} got free of {2}'s {3}!", user.pbThis, trapUser.pbThis(true), trapMove))
      user.effects[PBEffects::Trapping]     = 0
      user.effects[PBEffects::TrappingMove] = nil
      user.effects[PBEffects::TrappingUser] = -1
    end
    if user.effects[PBEffects::LeechSeed] >= 0
      user.effects[PBEffects::LeechSeed] = -1
      @battle.pbDisplay(_INTL("{1} shed Leech Seed!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StealthRock]
      user.pbOwnSide.effects[PBEffects::StealthRock] = false
      @battle.pbDisplay(_INTL("{1} blew away stealth rocks!", user.pbThis))
    end
    if defined?(PBEffects::Steelsurge) && user.pbOwnSide.effects[PBEffects::Steelsurge]
      user.pbOwnSide.effects[PBEffects::Steelsurge] = false
      @battle.pbDisplay(_INTL("{1} blew away the pointed steel!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::Spikes] > 0
      user.pbOwnSide.effects[PBEffects::Spikes] = 0
      @battle.pbDisplay(_INTL("{1} blew away spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0
      user.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
      @battle.pbDisplay(_INTL("{1} blew away poison spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StickyWeb]
      user.pbOwnSide.effects[PBEffects::StickyWeb] = false
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!", user.pbThis))
    end
  end
end

#===============================================================================
# Speed Demon
#===============================================================================
# The user's Speed (and its Speed stat stages) are used instead of the
# user's Attack (and Attack stat stages) to calculate damage.
#===============================================================================
class Battle::Move::UseUserSpeedInsteadOfUserAttack < Battle::Move
  def pbGetAttackStats(user, target)
    return user.defense, user.stages[:SPEED] + Battle::Battler::STAT_STAGE_MAXIMUM
  end
end