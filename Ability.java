

enum AType
{
  A_NONE,
  A_ADVANCED_STRIKE,
  A_ARCTIC_POLLUTION,
  A_BACKSTAB,
  A_BARRICADE,
  A_BITE,
  A_BLOODSUCKER,
  A_BLOODTHIRSTY,
  A_BLIGHT,
  A_BLITZ,
  A_BLIZZARD,
  A_CHAIN_ATTACK,
  A_CHAIN_LIGHTNING,
  A_CLEAN_SWEEP,
  A_COMBUSTION,
  A_CONCENTRATION,
  A_CONFUSION,
  A_COUNTERATTACK,
  A_CRAZE,
  A_CURSE,
  A_D_ANNIHILATION,
  A_D_BLIZZARD,
  A_D_CURSE,
  A_D_DESTROY,
  A_D_ELECTRIC_SHOCK,
  A_D_FIRESTORM,
  A_D_FIRE_GOD,
  A_D_GROUP_WEAKEN,
  A_D_HEALING,
  A_D_PLAGUE,
  A_D_PRAYER,
  A_D_REANIMATION,
  A_D_REINCARNATION,
  A_D_REGENERATION,
  A_D_TOXIC_CLOUDS,
  A_D_TRAP,
  A_DAMNATION,
  A_DESTROY,
  A_DEVILS_ARMOR,
  A_DEVILS_BLADE,
  A_DEVILS_CURSE,
  A_DEXTERITY,
  A_DODGE,
  A_DIVINE_PROTECTION,
  A_DUAL_SNIPE,
  A_ELECTRIC_SHOCK,
  A_EVASION,
  A_EXILE,
  A_FEAST_OF_BLOOD,
  A_FIRESTORM,
  A_FIREBALL,
  A_FIRE_GOD,
  A_FIRE_WALL,
  A_FOREST_ATK,
  A_FOREST_HP,
  A_FOREST_FIRE,
  A_FROST_SHOCK,
  A_GLACIAL_BARRIER,
  A_GUARD,
  A_GROUP_BLITZ,
  A_GROUP_CONCENTRATION,
  A_GROUP_COUNTERATTACK,
  A_GROUP_DODGE,
  A_GROUP_EVASION,
  A_GROUP_MORALE,
  A_GROUP_RETALIATION,
  A_GROUP_RESURRECTION,
  A_GROUP_SNIPE,
  A_GROUP_WARPATH,
  A_GROUP_WEAKEN,
  A_HEALING,
  A_HEALING_MIST,
  A_HOT_CHASE,
  A_HYSTERIA,
  A_ICEBALL,
  A_ICE_SHIELD,
  A_ICE_WALL,
  A_IMMUNITY,
  A_IMPEDE,
  A_INFILTRATOR,
  A_INSPIRATION,
  A_JOINT_DEFENSE,
  A_JUNGLE_BARRIER,
  A_LACERATION,
  A_MAGIC_SHIELD,
  A_MAGIC_RAMPART,
  A_MANA_CORRUPTION,
  A_MANIA,
  A_MARTYRDOM,
  A_MARSH_BARRIER,
  A_MOUNTAIN_ATK,
  A_MOUNTAIN_HP,
  A_MOUNTAIN_GLACIER,
  A_NOVA_FROST,
  A_OBSTINACY,
  A_ORIGINS_GUARD,
  A_PARRY,
  A_POWER_SOURCE,
  A_PRAYER,
  A_PLAGUE,
  A_PUNCTURE,
  A_QS_BLIZZARD,
  A_QS_CURSE,
  A_QS_DESTROY,
  A_QS_ELECTRIC_SHOCK,
  A_QS_EXILE,
  A_QS_FIRESTORM,
  A_QS_FIRE_GOD,
  A_QS_GROUP_WEAKEN,
  A_QS_HEALING,
  A_QS_MASS_ATTRITION,
  A_QS_PLAGUE,
  A_QS_PRAYER,
  A_QS_REGENERATION,
  A_QS_REINCARNATION,
  A_QS_TELEPORT,
  A_QS_TOXIC_CLOUDS,
  A_QS_TRAP,
  A_RAGE,
  A_REANIMATION,
  A_REFLECTION,
  A_REGENERATION,
  A_REINCARNATION,
  A_REJUVENATION,
  A_RESISTANCE,
  A_RESURRECTION,
  A_RETALIATION,
  A_GROUP_REFLECTION,
  A_GROUP_REJUVENATION,
  A_SACRIFICE,
  A_SACRED_FLAME,
  A_SEAL,
  A_SELF_DESTRUCT,
  A_SHIELD,
  A_SHIELD_OF_EARTH,
  A_SILENCE,
  A_SLAYER,
  A_SMOG,
  A_SNIPE,
  A_SWAMP_ATK,
  A_SWAMP_HP,
  A_SWAMP_PURITY,
  A_THUNDERBOLT,
  A_TOXIC_CLOUDS,
  A_TRAP,
  A_TUNDRA_ATK,
  A_TUNDRA_HP,
  A_VAMPIRISM,
  A_VENDETTA,
  A_VENOM,
  A_VOLCANO_BARRIER,
  A_WARCRY,
  A_WARPATH,
  A_WEAKEN,
  A_WICKED_LEECH,
};

/*
Enter play:
quickstrike: teleport, exile, destroy
backstab
obstinacy
sacrifice
seal


On death:
resurrection
desperation: destroy
self destruct


Passive:
arctic guard
forest guard
mountain guard
swamp guard
origins guard
guard
mountain force
forest force
northern force
swamp force
power source

on attacked spell:
immunity
magic shield
reflection
resistance


dexterity
divine protection
evasion


Before attack:
snipe
regeneration
advance strike
bite
blizzard
chain lightning
clean sweep
confusion
curse
damnation
  destroy
  devils blade
  devils curse
dual snipe
electric shock
exile
feast of blood
fire god
fire wall
fire ball
firestorm
group weaken
healing
iceball
impede
mana corruption
mania
nova frost
plague
prayer
reanimation
regeneration
reincarnation
sacred flame
smog
snipe
thunderbolt
toxic cloud
trap
venom
warcry
weaken


On Attack:
arctic polution
forest fire
blitz
bloodsucker
chain attack
concentration
hot chase
infiltrator
//lasceration
swamp purity
vendetta
warpath

on attack player:
slayer


After attack:
blight
rejuvination
lacerate
bloodthirsty


when attacked:
counter attack
combustion
craze
devils armor
dodge
glacial barrier
jungle barrier
marsh barrier
volcano barrier
ice shield
parry
retalliation
wicked leach

MISSING

From cards:
Quick Strike: Blizzard
Quick Strike: Curse
Quick Strike: Destroy
Quick Strike: Electric Shock
Quick Strike: Exile
Quick Strike: Firestorm
Quick Strike: Group Weaken
Quick Strike: Teleportation
Quick Strike: Trap
Quick Strike: Plague
Quick Strike: Regeneration
Quick Strike: Reincarnation
Desperation: Annihilation
Desperation: Curse
Desperation: Electric Shock
Desperation: Firestorm
Desperation: Fire God
Desperation: Group Weaken
Desperation: Reanimation
Desperation: Reincarnation

From Evolution:
Quick Strike: Fire God
Quick Strike: Healing
Quick Strike: Prayer
Quick Strike: Toxic Clouds
Desperation: Blizzard
Desperation: Healing
Desperation: Plague
Desperation: Regeneration
Desperation: Toxic Clouds
Desperation: Prayer
Desperation: Trap
*/
