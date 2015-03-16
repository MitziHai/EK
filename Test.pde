
void test()
{
  // Test card setup
  int h[] = {1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000,1000};
  int a[] = {100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100};
  AType ab[] = {AType.A_NONE};
  int al[] = {1};
  CardType ct1 = new CardType("test card1", h, a, SPECIAL, 100, 1, 10, ab, al);
  CardType ct2 = new CardType("test card2", h, a, SPECIAL, 100, 1, 10, ab, al);
  Card c1;
  Card c2;
  Card c3;
  
  // Test player setup
  Player tp1 = new Player(1000);
  Player tp2 = new Player(1000);
  
  
  // A_ADVANCED_STRIKE,
  AType ab2[] = {AType.A_ADVANCED_STRIKE};
  ct1 = new CardType("test card1", h, a, SPECIAL, 100, 1, 10, ab2, al);
  c1 = new Card( ct1, 10, AType.A_NONE, 0 );
  c2 = new Card( ct1, 10, AType.A_NONE, 0 );
  c3 = new Card( ct1, 10, AType.A_NONE, 0 );
  c1.time = 10;
  c2.time = 11;
  tp1.hand.add(c1);
  tp1.hand.add(c2);
  tp1.inPlay.add(c3);
  tp1.board[0] = c3;
  tp1.playTurn(tp2,0);
  if( c2.time == 9 ) println( "PASS: advanced strike" ); else println( "FAIL: Advance strike. Timer " + c2.time + ", expected 9." );
  
  AType ab3[] = {AType.A_ICE_SHIELD,AType.A_PARRY};
  int al3[] = {10,10};
  ct1 = new CardType("test card1", h, h, SPECIAL, 100, 1, 10, ab3, al3);
  c1 = new Card( ct1, 10, AType.A_NONE, 0 );
  c2 = new Card( ct1, 10, AType.A_NONE, 0 );
  tp1 = new Player(1000);
  tp2 = new Player(1000);
  tp1.addToPlay(c1);
  tp2.addToPlay(c2);
  tp1.playTurn(tp1,0);
  if( c1.hpCurr == 1000 ) println( "PASS: Ice shield/Parry pass" ); else println( "FAIL: Ice shield/Parry failed. Health " + c2.hpCurr + ", expected 1000." );
  
  AType ab4[] = {AType.A_PARRY,AType.A_ICE_SHIELD};
  int al4[] = {10,10};
  ct1 = new CardType("test card1", h, h, SPECIAL, 100, 1, 10, ab4, al4);
  c1 = new Card( ct1, 10, AType.A_NONE, 0 );
  c2 = new Card( ct1, 10, AType.A_NONE, 0 );
  tp1 = new Player(1000);
  tp2 = new Player(1000);
  tp1.addToPlay(c1);
  tp2.addToPlay(c2);
  tp1.playTurn(tp1,0);
  if( c1.hpCurr == 1000 ) println( "PASS: Parry/Ice shield pass" ); else println( "FAIL: Parry/Ice shield failed. Health " + c2.hpCurr + ", expected 1000." );
  
  // A_ARCTIC_POLUTION,
  // A_BACKSTAB,
  // A_BITE,
  // A_BLOODSUCKER,
  // A_BLOODTHIRSTY,
  // A_BLIGHT,
  // A_BLITZ,
  // A_BLIZZARD,
  // A_CHAIN_ATTACK,
  // A_CHAIN_LIGHTNING,
  // A_CLEAN_SWEEP,
  // A_COMBUSTION,
  // A_CONCENTRATION,
  // A_CONFUSION,
  // A_COUNTERATTACK,
  // A_CRAZE,
  // A_CURSE,
  // A_D_REANIMATE,
  // A_D_REINCARNATE,
  // A_D_DESTROY,
  // A_DAMNATION,
  // A_DESTROY,
  // A_DEVILS_ARMOR,
  // A_DEVILS_BLADE,
  // A_DEVILS_CURSE,
  // A_DEXTERITY,
  // A_DODGE,
  // A_DIVINE_PROTECTION,
  // A_DUAL_SNIPE,
  // A_ELECTRIC_SHOCK,
  // A_EVASION,
  // A_EXILE,
  // A_FEAST_OF_BLOOD,
  // A_FIRESTORM,
  // A_FIREBALL,
  // A_FIRE_GOD,
  // A_FIRE_WALL,
  // A_FOREST_ATK,
  // A_FOREST_HP,
  // A_FOREST_FIRE,
  // A_GLACIAL_BARRIER,
  // A_GUARD,
  // A_GROUP_WEAKEN,
  // A_HEALING,
  // A_HOT_CHASE,
  // A_ICEBALL,
  // A_ICE_SHIELD,
  // A_IMMUNITY,
  // A_IMPEDE,
  // A_INFILTRATOR,
  // A_JUNGLE_BARRIER,
  // A_LACERATION,
  // A_MAGIC_SHIELD,
  // A_MANA_CORRUPTION,
  // A_MANIA,
  // A_MARSH_BARRIER,
  // A_MOUNTAIN_ATK,
  // A_MOUNTAIN_HP,
  // A_MOUNTAIN_GLACIER,
  // A_NOVA_FROST,
  // A_OBSTINACY,
  // A_ORIGINS_GUARD,
  // A_PARRY,
  // A_POWER_SOURCE,
  // A_PRAYER,
  // A_PLAGUE,
  // A_QS_DESTROY,
  // A_QS_EXILE,
  // A_QS_PRAYER,
  // A_QS_REGENERATE,
  // A_QS_REINCARNATE,
  // A_QS_TELEPORT,
  // A_REANIMATION,
  // A_REFLECTION,
  // A_REGENERATION,
  // A_REINCARNATION,
  // A_REJUVINATE,
  // A_RESISTANCE,
  // A_RESURRECTION,
  // A_RETALIATION,
  // A_SACRIFICE,
  // A_SACRED_FLAME,
  // A_SEAL,
  // A_SELF_DESTRUCT,
  // A_SLAYER,
  // A_SMOG,
  // A_SNIPE,
  // A_SWAMP_ATK,
  // A_SWAMP_HP,
  // A_SWAMP_PURITY,
  // A_THUNDERBOLT,
  // A_TOXIC_CLOUDS,
  // A_TRAP,
  // A_TUNDRA_ATK,
  // A_TUNDRA_HP,
  // A_VENDETTA,
  // A_VENOM,
  // A_VOLCANO_BARRIER,
  // A_WARCRY,
  // A_WARPATH,
  // A_WEAKEN,
  // A_WICKED_LEECH,

  // Runes
  // A_ARCTIC_FREEZE,
  // A_BLOOD_STONE,
  // A_CLEAR_SPRING,
  // A_FROST_BITE,
  // A_RED_VALLEY,
  // A_LORE,
  // A_LEAF,
  // A_REVIVAL,
  // A_FIRE_FORGE,
  // A_STONEWALL,
  // A_SPRING_BREEZE,
  // A_THUNDER_SHIELD,
  // A_NIMBLE_SOUL,
  // A_DIRT,
  // A_FLYING_STONE,
  // A_TSUNAMI;

  
}
