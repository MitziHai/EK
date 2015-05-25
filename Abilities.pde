

TreeMap<String, AType> abilities = new TreeMap<String, AType>(String.CASE_INSENSITIVE_ORDER);
TreeMap<AType, String> abilityName = new TreeMap<AType, String>();
TreeMap< String, String > evoNames = new TreeMap< String, String >(String.CASE_INSENSITIVE_ORDER);
TreeMap< String, String > evoNamesR = new TreeMap< String, String >(String.CASE_INSENSITIVE_ORDER);

// dodge, ice shield, then parry, then retaliate/counter/devils armor/craze


class Abil
{
  AType a;
  int l;
};

Comparator abilityPriority = new Comparator<Abil>() {
  
  // Order:
  // 1. Glacial/Jungle/Volcano/Marsh barrier
  // 2. Ice shield
  // 3. Parry
  // 4. Retaliation, craze, counter attack in no specific order

  public int compare(Abil a1, Abil a2) {
    AType e1 = a1.a;
    AType e2 = a2.a;
    if( e1 == null ) return 1;
    if( e2 == null ) return -1;
    int a = e1.ordinal();
    int b = e2.ordinal();
    if( e1 == AType.A_GLACIAL_BARRIER || e1 == AType.A_JUNGLE_BARRIER || e1 == AType.A_VOLCANO_BARRIER || e1 == AType.A_MARSH_BARRIER ) a += 1000;
    if( e2 == AType.A_GLACIAL_BARRIER || e2 == AType.A_JUNGLE_BARRIER || e2 == AType.A_VOLCANO_BARRIER || e2 == AType.A_MARSH_BARRIER ) b += 1000;
    if( e1 == AType.A_DODGE || e1 == AType.A_ICE_SHIELD || e1 == AType.A_PARRY ) a += 2000;
    if( e2 == AType.A_DODGE || e2 == AType.A_ICE_SHIELD || e2 == AType.A_PARRY ) b += 2000;
    if( e1 == AType.A_RETALIATION || e1 == AType.A_COUNTERATTACK || e1 == AType.A_DEVILS_ARMOR || e1 == AType.A_CRAZE ) a += 3000;
    if( e2 == AType.A_RETALIATION || e2 == AType.A_COUNTERATTACK || e2 == AType.A_DEVILS_ARMOR || e2 == AType.A_CRAZE ) b += 3000;
    
    return a - b;
  }
};

void loadAbils()
{
  abilities.put( "None", AType.A_NONE );
  abilities.put( "Advanced Strike", AType.A_ADVANCED_STRIKE );
  abilities.put( "Arctic Pollution", AType.A_ARCTIC_POLLUTION );
  abilities.put( "Arctic Guard", AType.A_TUNDRA_HP );
  abilities.put( "Backstab", AType.A_BACKSTAB );
  abilities.put( "Bite", AType.A_BITE );
  abilities.put( "Bloodsucker", AType.A_BLOODSUCKER );
  abilities.put( "Bloodthirsty", AType.A_BLOODTHIRSTY );
  abilities.put( "Blight", AType.A_BLIGHT );
  abilities.put( "Blitz", AType.A_BLITZ );
  abilities.put( "Blizzard", AType.A_BLIZZARD );
  abilities.put( "Chain Attack", AType.A_CHAIN_ATTACK );
  abilities.put( "Chain Lightning", AType.A_CHAIN_LIGHTNING );
  abilities.put( "Clean Sweep", AType.A_CLEAN_SWEEP );
  abilities.put( "Combustion", AType.A_COMBUSTION );
  abilities.put( "Concentration", AType.A_CONCENTRATION );
  abilities.put( "Confusion", AType.A_CONFUSION );
  abilities.put( "Counterattack", AType.A_COUNTERATTACK );
  abilities.put( "Craze", AType.A_CRAZE );
  abilities.put( "Curse", AType.A_CURSE );
  abilities.put( "D: Annihilation", AType.A_D_ANNIHILATION );
  abilities.put( "D: Blizzard", AType.A_D_BLIZZARD );
  abilities.put( "D: Curse", AType.A_D_CURSE );
  abilities.put( "D: Destroy", AType.A_D_DESTROY );
  abilities.put( "D: Electric Shock", AType.A_D_ELECTRIC_SHOCK );
  abilities.put( "D: Firestorm", AType.A_D_FIRESTORM );
  abilities.put( "D: Fire God", AType.A_D_FIRE_GOD );
  abilities.put( "D: Group Weaken", AType.A_D_GROUP_WEAKEN );
  abilities.put( "D: Healing", AType.A_D_HEALING );
  abilities.put( "D: Plague", AType.A_D_PLAGUE );
  abilities.put( "D: Prayer", AType.A_D_PRAYER );
  abilities.put( "D: Reanimation", AType.A_D_REANIMATION );
  abilities.put( "D: Regeneration", AType.A_D_REGENERATION );
  abilities.put( "D: Reincarnation", AType.A_D_REINCARNATION );
  abilities.put( "D: Toxic Clouds", AType.A_D_TOXIC_CLOUDS );
  abilities.put( "D: Trap", AType.A_D_TRAP );
  abilities.put( "Damnation", AType.A_DAMNATION );
  abilities.put( "Destroy", AType.A_DESTROY );
  abilities.put( "Devil's Armor", AType.A_DEVILS_ARMOR );
  abilities.put( "Devil's Blade", AType.A_DEVILS_BLADE );
  abilities.put( "Devil's Curse", AType.A_DEVILS_CURSE );
  abilities.put( "Dexterity", AType.A_DEXTERITY );
  abilities.put( "Dodge", AType.A_DODGE );
  abilities.put( "Divine Protection", AType.A_DIVINE_PROTECTION );
  abilities.put( "Dual Snipe", AType.A_DUAL_SNIPE );
  abilities.put( "Electric Shock", AType.A_ELECTRIC_SHOCK );
  abilities.put( "Evasion", AType.A_EVASION );
  abilities.put( "Exile", AType.A_EXILE );
  abilities.put( "Feast of Blood", AType.A_FEAST_OF_BLOOD );
  abilities.put( "Firestorm", AType.A_FIRESTORM );
  abilities.put( "Fireball", AType.A_FIREBALL );
  abilities.put( "Fire God", AType.A_FIRE_GOD );
  abilities.put( "Fire Wall", AType.A_FIRE_WALL );
  abilities.put( "Forest Force", AType.A_FOREST_ATK );
  abilities.put( "Forest Guard", AType.A_FOREST_HP );
  abilities.put( "Forest Fire", AType.A_FOREST_FIRE );
  abilities.put( "Frost Shock", AType.A_FROST_SHOCK );
  abilities.put( "Glacial Barrier", AType.A_GLACIAL_BARRIER );
  abilities.put( "Guard", AType.A_GUARD );
  abilities.put( "Group Weaken", AType.A_GROUP_WEAKEN );
  abilities.put( "Healing", AType.A_HEALING );
  abilities.put( "Healing Mist", AType.A_HEALING_MIST );
  abilities.put( "Hot Chase", AType.A_HOT_CHASE );
  abilities.put( "Iceball", AType.A_ICEBALL );
  abilities.put( "Ice Shield", AType.A_ICE_SHIELD );
  abilities.put( "Immunity", AType.A_IMMUNITY );
  abilities.put( "Impede", AType.A_IMPEDE );
  abilities.put( "Infiltrator", AType.A_INFILTRATOR );
  abilities.put( "Jungle Barrier", AType.A_JUNGLE_BARRIER );
  abilities.put( "Laceration", AType.A_LACERATION );
  abilities.put( "Magic Shield", AType.A_MAGIC_SHIELD );
  abilities.put( "Mana Corruption", AType.A_MANA_CORRUPTION );
  abilities.put( "Mania", AType.A_MANIA );
  abilities.put( "Marsh Barrier", AType.A_MARSH_BARRIER );
  abilities.put( "Mountain Force", AType.A_MOUNTAIN_ATK );
  abilities.put( "Mountain Guard", AType.A_MOUNTAIN_HP );
  abilities.put( "Mountain Glacier", AType.A_MOUNTAIN_GLACIER );
  abilities.put( "Northern Force", AType.A_TUNDRA_ATK );
  abilities.put( "Nova Frost", AType.A_NOVA_FROST );
  abilities.put( "Obstinacy", AType.A_OBSTINACY );
  abilities.put( "Origins Guard", AType.A_ORIGINS_GUARD );
  abilities.put( "Parry", AType.A_PARRY );
  abilities.put( "Prayer", AType.A_PRAYER );
  abilities.put( "Plague", AType.A_PLAGUE );
  abilities.put( "Puncture", AType.A_PUNCTURE );
  abilities.put( "Power Source", AType.A_POWER_SOURCE );
  abilities.put( "QS: Blizzard", AType.A_QS_BLIZZARD );
  abilities.put( "QS: Curse", AType.A_QS_CURSE );
  abilities.put( "QS: Destroy", AType.A_QS_DESTROY );
  abilities.put( "QS: Electric Shock", AType.A_QS_ELECTRIC_SHOCK );
  abilities.put( "QS: Exile", AType.A_QS_EXILE );
  abilities.put( "QS: Firestorm", AType.A_QS_FIRESTORM );
  abilities.put( "QS: Fire God", AType.A_QS_FIRE_GOD );
  abilities.put( "QS: Group Weaken", AType.A_QS_GROUP_WEAKEN );
  abilities.put( "QS: Healing", AType.A_QS_HEALING );
  abilities.put( "QS: Mass Attrition", AType.A_QS_MASS_ATTRITION );
  abilities.put( "QS: Plague", AType.A_QS_PLAGUE );
  abilities.put( "QS: Prayer", AType.A_QS_PRAYER );
  abilities.put( "QS: Regeneration", AType.A_QS_REGENERATION );
  abilities.put( "QS: Reincarnation", AType.A_QS_REINCARNATION );
  abilities.put( "QS: Teleportation", AType.A_QS_TELEPORT );
  abilities.put( "QS: Toxic Clouds", AType.A_QS_TOXIC_CLOUDS );
  abilities.put( "QS: Trap", AType.A_QS_TRAP );
  abilities.put( "Reanimation", AType.A_REANIMATION );
  abilities.put( "Reflection", AType.A_REFLECTION );
  abilities.put( "Regeneration", AType.A_REGENERATION );
  abilities.put( "Reincarnation", AType.A_REINCARNATION );
  abilities.put( "Rejuvenation", AType.A_REJUVENATION );
  abilities.put( "Resistance", AType.A_RESISTANCE );
  abilities.put( "Resurrection", AType.A_RESURRECTION );
  abilities.put( "Retaliation", AType.A_RETALIATION );
  abilities.put( "Sacrifice", AType.A_SACRIFICE );
  abilities.put( "Sacred Flame", AType.A_SACRED_FLAME);
  abilities.put( "Seal", AType.A_SEAL );
  abilities.put( "Self-Destruct", AType.A_SELF_DESTRUCT );
  abilities.put( "Shield of Earth", AType.A_SHIELD_OF_EARTH );
  abilities.put( "Silence", AType.A_SILENCE );
  abilities.put( "Slayer", AType.A_SLAYER );
  abilities.put( "Smog", AType.A_SMOG );
  abilities.put( "Snipe", AType.A_SNIPE );
  abilities.put( "Swamp Force", AType.A_SWAMP_ATK );
  abilities.put( "Swamp Guard", AType.A_SWAMP_HP );
  abilities.put( "Swamp Purity", AType.A_SWAMP_PURITY );
  abilities.put( "Thunderbolt", AType.A_THUNDERBOLT );
  abilities.put( "Toxic Clouds", AType.A_TOXIC_CLOUDS );
  abilities.put( "Trap", AType.A_TRAP );
  abilities.put( "Vendetta", AType.A_VENDETTA );
  abilities.put( "Venom", AType.A_VENOM );
  abilities.put( "Volcano Barrier", AType.A_VOLCANO_BARRIER );
  abilities.put( "Warcry", AType.A_WARCRY );
  abilities.put( "Warpath", AType.A_WARPATH );
  abilities.put( "Weaken", AType.A_WEAKEN );
  abilities.put( "Wicked Leech", AType.A_WICKED_LEECH );

  Iterator it = abilities.entrySet().iterator();
  while (it.hasNext()) {
      Map.Entry pairs = (Map.Entry)it.next();
      abilityName.put((AType)pairs.getValue(), (String)pairs.getKey());
  }
  
  evoNames.put( "Advanced Strike", "as" );
  evoNames.put( "Arctic Guard", "ag" );
  evoNames.put( "Arctic Pollution", "ap" );
  evoNames.put( "Backstab", "stab" );
  evoNames.put( "Bite", "bite" );
  evoNames.put( "Blight", "bli" );
  evoNames.put( "Blitz", "blz" );
  evoNames.put( "Blizzard", "bzd" );
  evoNames.put( "Bloodsucker", "bs" );
  evoNames.put( "Bloodthirsty", "blt" );
  evoNames.put( "Chain Attack", "ca" );
  evoNames.put( "Chain Lightning", "cl" );
  evoNames.put( "Clean Sweep", "cs" );
  evoNames.put( "Combustion", "cmb" );
  evoNames.put( "Concentration", "con" );
  evoNames.put( "Confusion", "cf" );
  evoNames.put( "Counterattack", "cnt" );
  evoNames.put( "Craze", "cz" );
  evoNames.put( "Curse", "crs" );
  evoNames.put( "D: Annihilation", "d:a" );
  evoNames.put( "D: Blizzard", "d:bzd" );
  evoNames.put( "D: Curse", "d:crs" );
  evoNames.put( "D: Destroy", "d:des" );
  evoNames.put( "D: Electric Shock", "d:es" );
  evoNames.put( "D: Fire God", "d:fgd" );
  evoNames.put( "D: Firestorm", "d:fs" );
  evoNames.put( "D: Group Weaken", "d:gw" );
  evoNames.put( "D: Healing", "d:h" );
  evoNames.put( "D: Plague", "d:plg" );
  evoNames.put( "D: Regeneration", "d:reg" );
  evoNames.put( "D: Toxic Clouds", "d:tc" );
  evoNames.put( "D: Prayer", "d:pyr" );
  evoNames.put( "D: Trap", "d:trp" );
  evoNames.put( "Damnation", "damn" );
  evoNames.put( "Destroy", "des" );
  evoNames.put( "Devil's Armor", "da" );
  evoNames.put( "Devil's Blade", "db" );
  evoNames.put( "Devil's Curse", "dc" );
  evoNames.put( "Dexterity", "dex" );
  evoNames.put( "Dodge", "dge" );
  evoNames.put( "Divine Protection", "dp" );
  evoNames.put( "Dual Snipe", "ds" );
  evoNames.put( "Electric Shock", "es" );
  evoNames.put( "Evasion", "eva" );
  evoNames.put( "Exile", "exi" );
  evoNames.put( "Feast of Blood", "fob" );
  evoNames.put( "Fire Wall", "fw" );
  evoNames.put( "Fireball", "fb" );
  evoNames.put( "Fire God", "fgd" );
  evoNames.put( "Firestorm", "fs" );
  evoNames.put( "Forest Fire", "ffi" );
  evoNames.put( "Forest Force", "ff" );
  evoNames.put( "Forest Guard", "fg" );
  evoNames.put( "Frost Shock", "frs" );
  evoNames.put( "Glacial Barrier", "gb" );
  evoNames.put( "Guard", "grd" );
  evoNames.put( "Group Weaken", "gw" );
  evoNames.put( "Healing", "h" );
  evoNames.put( "Healing Mist", "hm" );
  evoNames.put( "Hot Chase", "hc" );
  evoNames.put( "Iceball", "ib" );
  evoNames.put( "Ice Shield", "ice" );
  evoNames.put( "Immunity", "imm" );
  evoNames.put( "Impede", "imp" );
  evoNames.put( "Infiltrator", "infl" );
  evoNames.put( "Jungle Barrier", "jb" );
  evoNames.put( "Laceration", "lct" );
  evoNames.put( "Magic Shield", "ms" );
  evoNames.put( "Mana Corruption", "mc" );
  evoNames.put( "Mania", "man" );
  evoNames.put( "Marsh Barrier", "mb" );
  evoNames.put( "Mountain Force", "mf" );
  evoNames.put( "Mountain Glacier", "mgr" );
  evoNames.put( "Mountain Guard", "mg" );
  evoNames.put( "Nova Frost", "nv" );
  evoNames.put( "Obstinacy", "obs" );
  evoNames.put( "Origins Guard", "og" );
  evoNames.put( "Northern Force", "nf" );
  evoNames.put( "Parry", "pry" );
  evoNames.put( "Plague", "plg" );
  evoNames.put( "Prayer", "pyr" );
  evoNames.put( "Puncture", "punc" );
  evoNames.put( "Power Source", "ps" );
  evoNames.put( "QS: Blizzard", "q:bzd" );
  evoNames.put( "QS: Curse", "q:crs" );
  evoNames.put( "QS: Destroy", "q:des" );
  evoNames.put( "QS: Electric Shock", "q:es" );
  evoNames.put( "QS: Exile", "q:exl" );
  evoNames.put( "QS: Fire God", "q:fgd" );
  evoNames.put( "QS: Firestorm", "q:fs" );
  evoNames.put( "QS: Group Weaken", "q:gw" );
  evoNames.put( "QS: Healing", "q:h" );
  evoNames.put( "QS: Plague", "q:plg" );
  evoNames.put( "QS: Regeneration", "q:reg" );
  evoNames.put( "QS: Teleportation", "q:tel" );
  evoNames.put( "QS: Toxic Clouds", "q:tc" );
  evoNames.put( "QS: Prayer", "q:pyr" );
  evoNames.put( "QS: Trap", "q:trp" );
  evoNames.put( "Reanimation", "rean" );
  evoNames.put( "Reflection", "ref" );
  evoNames.put( "Regeneration", "reg" );
  evoNames.put( "Reincarnation", "rein" );
  evoNames.put( "Rejuvenation", "rej" );
  evoNames.put( "Retaliation", "ret" );
  evoNames.put( "Resurrection", "rez" );
  evoNames.put( "Resistance", "res" );
  evoNames.put( "Sacrifice", "sac" );
  evoNames.put( "Sacred Flame", "sdf");
  evoNames.put( "Seal", "seal" );
  evoNames.put( "Self-Destruct", "sd" );
  evoNames.put( "Shield of Earth", "soe" );
  evoNames.put( "Silence", "sil" );
  evoNames.put( "Slayer", "slay" );
  evoNames.put( "Smog", "smog" );
  evoNames.put( "Snipe", "snp" );
  evoNames.put( "Swamp Force", "sf" );
  evoNames.put( "Swamp Guard", "sg" );
  evoNames.put( "Swamp Purity", "sp" );
  evoNames.put( "Thunderbolt", "tb" );
  evoNames.put( "Toxic Clouds", "tc" );
  evoNames.put( "Trap", "trp" );
  evoNames.put( "Vendetta", "vend" );
  evoNames.put( "Venom", "ven" );
  evoNames.put( "Volcano Barrier", "vb" );
  evoNames.put( "Warcry", "wc" );
  evoNames.put( "Warpath", "wp" );
  evoNames.put( "Weaken", "weak" );
  evoNames.put( "Wicked Leech", "wl" );
  
  
  it = evoNames.entrySet().iterator();
  while (it.hasNext()) {
      Map.Entry pairs = (Map.Entry)it.next();
      evoNamesR.put((String)pairs.getValue(), (String)pairs.getKey());
  }
}
