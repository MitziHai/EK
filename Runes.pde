
TreeMap<String, RuneType> runesMap = new TreeMap<String, RuneType>(String.CASE_INSENSITIVE_ORDER);
TreeMap<RType, RuneType> runesMapR = new TreeMap<RType, RuneType>();

TreeMap<AType,AbilityWhen> groupAbilMap = new TreeMap<AType,AbilityWhen>();

static final int PLAYER_IN_PLAY = 0;
static final int PLAYER_GRAVE = 1;
static final int PLAYER_HAND = 2;
static final int PLAYER_DECK = 3;
static final int PLAYER_LIFE = 4;
static final int OPPONENT_IN_PLAY = 5;
static final int OPPONENT_GRAVE = 6;
static final int OPPONENT_HAND = 7;
static final int ROUNDS = 8;
static final int ANY = 9; // Faction type

int hp[] = {1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000};
int atk[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
AType[] a = {AType.A_NONE};
int al[] = {0};
CardType dummy = new CardType( "not a card", hp, atk, 0, 0, 0, 0, a, al );
Card dummyCard = new Card(dummy, 0, AType.A_NONE, 0);

class AbilityWhen
{
  AType abil;
  int when;
  
  AbilityWhen( AType a, int w )
  {
    abil = a;
    when = w;
  }
}

class RuneType
{
  String name = "";
  int numUses = 4;
  int stars = 1;
  RType type;
  AType ability;
  int abilityL[] = new int[5];
  int element;
  int requirement;
  int requirement2;
  int requirementVal;
  int abilityWhen;
  boolean immediate = false;
  
  RuneType( String n, int u, int s, RType t, int e, AType a1, int al1, int al2, int al3, int al4, int al5, int req1, int req2, int reqv, boolean im )
  {
    name = n;
    numUses = u;
    stars = s;
    type = t;
    element = e;
    ability = a1;
    abilityL[0] = al1;
    abilityL[1] = al2;
    abilityL[2] = al3;
    abilityL[3] = al4;
    abilityL[4] = al5;
    requirement = req1;
    requirement2 = req2;
    requirementVal = reqv;
    immediate = im;
    if( !immediate )
    {
      AbilityWhen aw = groupAbilMap.get( ability );
      ability = aw. abil;
      abilityWhen = aw.when;
    }
  }
}

class Rune
{
  boolean selected = false;
  int level = 4;
  RuneType type;
  int remainingUses;
  
  Rune( RuneType rt, int l )
  {
    type = rt;
    remainingUses = rt.numUses;
    level = l;
  }
  
  String toString()
  {
    return "Rune: " + type.name + " ("+level+")";
  }
  
  void checkRune( Player current, Player op, int round )
  {
    if( remainingUses <= 0 )
    {
      if( debug > 2 ) println( "  -" + this + " no uses remaining." );
      return;
    }
    
    boolean activate = false;
    switch( type.requirement )
    {
      case PLAYER_IN_PLAY:
        activate = ( type.requirement2 == ANY && current.playSize() > type.requirementVal )
          || ( type.requirement2 != ANY && current.cardCount[ PLAY ][ type.requirement2 ] > type.requirementVal );
        break;
      
      case PLAYER_GRAVE:
        activate = ( type.requirement2 == ANY && current.graveSize() > type.requirementVal )
          || ( type.requirement2 != ANY && current.cardCount[ GRAVE ][ type.requirement2 ] > type.requirementVal );
        break;
      
      case PLAYER_HAND:
        activate = ( type.requirement2 == ANY && current.handSize() > type.requirementVal )
          || ( type.requirement2 != ANY && current.cardCount[ HAND ][ type.requirement2 ] > type.requirementVal );
        break;
      
      case PLAYER_DECK:
        activate = current.deck.size() < type.requirementVal;
        break;
      
      case PLAYER_LIFE:
        activate = current.hp / (float)current.hpmax < type.requirementVal/100.0;
        break;
      
      case OPPONENT_IN_PLAY:
        activate = ( type.requirement2 == ANY && op.playSize() > type.requirementVal )
          || ( type.requirement2 != ANY && op.cardCount[ PLAY ][ type.requirement2 ] > type.requirementVal );
        break;
      
      case OPPONENT_GRAVE:
        activate = ( type.requirement2 == ANY && op.graveSize() > type.requirementVal )
          || ( type.requirement2 != ANY && op.cardCount[ GRAVE ][ type.requirement2 ] > type.requirementVal );
        break;
      
      case OPPONENT_HAND:
        activate = ( type.requirement2 == ANY && op.handSize() > type.requirementVal )
          || ( type.requirement2 != ANY && op.cardCount[ HAND ][ type.requirement2 ] > type.requirementVal );
        break;
      
      case ROUNDS:
        activate = round > type.requirementVal;
        break;
    };

    if( activate )
    {
      remainingUses -= 1;
      //println(this + " " + type.immediate);
     
      // Are all immediate abilities of timing classification "before attack"?
      // Cast the ability immediately by adding it to a dummy card.
      if( type.immediate )
      {
        dummyCard.resetAll( current );
        dummyCard.abilityNum[ BEFORE_ATTACK ] = 1;
        dummyCard.abilities[ BEFORE_ATTACK ][ 0 ] = type.ability;
        dummyCard.abilityL[ BEFORE_ATTACK ][ 0 ] = type.abilityL[ level ];
        int l = type.abilityL[level];
        switch( type.ability )
        {
          case A_BARRICADE:
            if( current.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            for( Card c : current.inPlay )
            {
              c.ward += 30*l;
              if (debug > 3) println("     Ward applied for "+30*l+" to " + c.toStringNoHp());
            }
            break;
          
          case A_BLIZZARD:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            if( debug > 3 && activate) println( "     Blizzard for " + (20*l));
            dummyCard.damageAll( current, op, 20*l, FROZEN, 30 );
            break;
            
          case A_CHAIN_LIGHTNING:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            if( debug > 3 && activate) println( "     Chain Lightning for " + (25*l));
            dummyCard.damageRandom3( current, op, 25*l, SHOCKED, 40 );
            break;
          
          case A_DAMNATION:
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            op.attacked(20*l*op.playSize(), op, true);
            break;
          
          case A_ELECTRIC_SHOCK:
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            if( debug > 3 && activate) println( "     Electric Shock for " + (25*l));
            dummyCard.damageAll( current, op, 25*l, SHOCKED, 35 );
            break;

          case A_FIREBALL:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            if( debug > 3 && activate) println( "     Fireball for " + (25*l) + "-" + (50*l));
            dummyCard.damageRandom1( current, op, 25*l, 50*l, FIRE, 0 );
            break;
          
          case A_FIRESTORM:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            if( debug > 3 && activate) println( "     Firestorm for " + (25*l) + "-" + (50*l));
            dummyCard.damageAll( current, op, 25*l, 50*l, FIRE, 0 );
            break;
          
          case A_FIRE_GOD:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            if( debug > 3 && activate) println( "     Fireball for " + (20*l));
            for ( Card c : op.inPlay )
            {
              if (!c.immune && !c.fireGod[l]) {
                c.burn += 20*l;
                c.fireGod[l] = true;
              }
            }
            break;
          
          case A_FIRE_WALL:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            if( debug > 3 && activate) println( "     Fire Wall for " + (25*l) + "-" + (50*l));
            dummyCard.damageRandom3( current, op, 25*l, 50*l, FIRE, 0 );
            break;
          
          case A_GROUP_MORALE:
            if( current.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            int amount = 15*l;
            for( Card c : current.inPlay )
            {
              if (debug > 3 ) println("    " + c + " attack increased by " + amount);
              c.atkBuff += amount;
              c.atk += amount;
              c.morale += amount;
            }
            break;
          
          case A_GROUP_WEAKEN:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.weakenAll( current, op, 10*l );
            break;
          
          case A_HEALING:
            Card mostDamaged = null;
            if( current.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            for ( Card c : current.inPlay )
            {
              if ( mostDamaged == null || c.hpBuff - c.hpCurr > mostDamaged.hpBuff - mostDamaged.hpCurr ) mostDamaged = c;
            }
            if ( mostDamaged != null && !mostDamaged.immune )
              mostDamaged.hpCurr = min( mostDamaged.hpCurr + 25*l, mostDamaged.hpBuff );
            break;
          
          case A_ICEBALL:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.damageRandom1( current, op, 20*l, FROZEN, 45 );
            break;
          
          case A_NOVA_FROST:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.damageRandom3( current, op, 20*l, FROZEN, 35 );
            break;
          
          case A_PLAGUE:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.weakenAll( current, op, 5*l );
            dummyCard.damageAll( current, op, 5*l, NO_REFLECT, 0 );
            break;
          
          case A_PRAYER:
            if( debug > 3) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            current.hp = min( current.hpmax, current.hp + 40*l );
            break;
          
          case A_REGENERATION: // Clear spring.
            boolean woundedCards = false;
            for( Card c : current.inPlay )
              woundedCards = woundedCards || c.hpCurr < c.hpMax;
            if( current.playSize() > 0)
            {
              if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
              dummyCard.damageAll( current, current, 25*l, HEAL, 0 );
            }
            else
            {
              activate = false;
              ++ remainingUses;
            }
            break;
          
          case A_SHIELD:
            if( current.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            else {
              Card c = null;
              c = current.inPlay.get((int)random( current.playSize() ));
              c.ward += 50*l;
              if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
              if (debug > 3 && activate) println("     Ward applied for "+(50*l)+" to " + c.toStringNoHp());
            }
            break;
          
          case A_SMOG:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.damageRandom3( current, op, 20*l, POISONED, 20*l );
            break;
          
          case A_THUNDERBOLT:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.damageRandom1( current, op, 25*l, SHOCKED, 50 );
            break;
          
          case A_TOXIC_CLOUDS:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.damageAll( current, op, 20*l, POISONED, 20*l );
            break;
          
          case A_VENOM:
            //if( op.inPlay.isEmpty() ) {activate = false; ++ remainingUses;}
            if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
            dummyCard.damageRandom1( current, op, 20*l, POISONED, 20*l );
            break;
          
        }
      }
      else
      // Add the ability to all of player's cards in play.
      {
        if( current.inPlay.isEmpty() )
        {
          activate = false; 
          ++remainingUses;
        }
        // Add a second ability num counter for number added by runes (to be removed at start of next turn).
        if( debug > 3 && activate) println("  -" + this + " activated.  " + remainingUses + " uses left.");
        for( Card c : current.inPlay )
        {
//          if (type.ability == AType.A_EVASION && type.abilityWhen == ON_ATTACKED_SPELL) println("GOT HERE 2");
          c.abilityL[ type.abilityWhen ][ c.abilityNum[ type.abilityWhen ] ] = type.abilityL[ level ];
          c.abilities[ type.abilityWhen ][ c.abilityNum[ type.abilityWhen ] ++ ] = type.ability;

        }
      }
    }
  }
}

void loadRunes()
{  
  groupAbilMap.put( AType.A_MAGIC_RAMPART, new AbilityWhen( AType.A_MAGIC_SHIELD, ON_ATTACKED_SPELL ) ); 
  groupAbilMap.put( AType.A_GROUP_COUNTERATTACK, new AbilityWhen( AType.A_COUNTERATTACK, ON_ATTACKED ) ); 
  groupAbilMap.put( AType.A_GROUP_REFLECTION, new AbilityWhen( AType.A_REFLECTION, ON_ATTACKED_SPELL ) ); 
  groupAbilMap.put( AType.A_JOINT_DEFENSE, new AbilityWhen( AType.A_PARRY, ON_ATTACKED ) ); 
  groupAbilMap.put( AType.A_RAGE, new AbilityWhen( AType.A_CRAZE, ON_ATTACKED ) ); 
  groupAbilMap.put( AType.A_ICE_WALL, new AbilityWhen( AType.A_ICE_SHIELD, ON_ATTACKED ) ); 
  groupAbilMap.put( AType.A_GROUP_REJUVENATION, new AbilityWhen( AType.A_REJUVENATION, AFTER_ATTACK ) ); 
  groupAbilMap.put( AType.A_MARTYRDOM, new AbilityWhen( AType.A_SELF_DESTRUCT, ON_DEATH ) ); 
  groupAbilMap.put( AType.A_GROUP_SNIPE, new AbilityWhen( AType.A_SNIPE, BEFORE_ATTACK ) ); 
  groupAbilMap.put( AType.A_GROUP_BLITZ, new AbilityWhen( AType.A_BLITZ, ON_ATTACK_CARD ) ); 
  groupAbilMap.put( AType.A_VAMPIRISM, new AbilityWhen( AType.A_BLOODSUCKER, ON_ATTACK_CARD ) ); 
  groupAbilMap.put( AType.A_GROUP_RETALIATION, new AbilityWhen( AType.A_RETALIATION, ON_ATTACKED ) ); 
  groupAbilMap.put( AType.A_HYSTERIA, new AbilityWhen( AType.A_BLOODTHIRSTY, AFTER_ATTACK ) ); 
  groupAbilMap.put( AType.A_GROUP_RESURRECTION, new AbilityWhen( AType.A_RESURRECTION, ON_DEATH ) ); 
  groupAbilMap.put( AType.A_GROUP_CONCENTRATION, new AbilityWhen( AType.A_CONCENTRATION, ON_ATTACK_CARD ) ); 
  groupAbilMap.put( AType.A_GROUP_WARPATH, new AbilityWhen( AType.A_WARPATH, ON_ATTACK_CARD ) ); 
  groupAbilMap.put( AType.A_GROUP_DODGE, new AbilityWhen( AType.A_DODGE, ON_ATTACKED ) ); 
  groupAbilMap.put( AType.A_GROUP_EVASION, new AbilityWhen( AType.A_EVASION, ON_ATTACKED_SPELL ) ); 
  
  runesMap.put( "Coldwave", new RuneType( "Coldwave", 3, 1, RType.R_COLDWAVE, TUNDRA, AType.A_NOVA_FROST, 1, 2, 3, 4, 5, PLAYER_DECK, 0, 2, true ) );
  runesMap.put( "Fire Fist",  new RuneType( "Fire Fist", 3, 1, RType.R_FIRE_FIST, MOUNTAIN, AType.A_FIREBALL, 3, 4, 5, 6, 7, OPPONENT_IN_PLAY, ANY, 2, true ) );
  runesMap.put( "Frost", new RuneType( "Frost", 3, 1, RType.R_FROST, TUNDRA, AType.A_ICEBALL, 3, 4, 5, 6, 7, PLAYER_GRAVE, ANY, 2, true ) );
  runesMap.put( "Heat Wave", new RuneType( "Heat Wave", 3, 1, RType.R_HEAT_WAVE, MOUNTAIN, AType.A_FIRE_WALL, 1, 2, 3, 4, 5, PLAYER_LIFE, 0, 60, true ) );
  runesMap.put( "Methane", new RuneType( "Methane", 3, 1, RType.R_METHANE, SWAMP, AType.A_SMOG, 1, 2, 3, 4, 5, OPPONENT_IN_PLAY, ANY, 1, true ) );
  runesMap.put( "Shock", new RuneType( "Shock", 3, 1, RType.R_SHOCK, FOREST, AType.A_THUNDERBOLT, 3, 4, 5, 6, 7, OPPONENT_GRAVE, ANY, 2, true ) );
  runesMap.put( "Thunderstorm", new RuneType( "Thunderstorm", 3, 1, RType.R_THUNDERSTORM, FOREST, AType.A_CHAIN_LIGHTNING, 1, 2, 3, 4, 5, PLAYER_LIFE, 0, 50, true ) );
  runesMap.put( "Wasteland", new RuneType( "Wasteland", 3, 1, RType.R_WASTELAND, SWAMP, AType.A_VENOM, 3, 4, 5, 6, 7, PLAYER_LIFE, 0, 60, true ) );
  runesMap.put( "Arsenopyrite", new RuneType( "Arsenopyrite", 3, 2, RType.R_ARSENOPYRITE, SWAMP, AType.A_VENOM, 5, 6, 7, 8, 9, ROUNDS, 0, 12, true ) );
  runesMap.put( "Fire Flow", new RuneType( "Fire Flow", 3, 2, RType.R_FIRE_FLOW, MOUNTAIN, AType.A_FIREBALL, 5, 6, 7, 8, 9, ROUNDS, 0, 12, true ) );
  runesMap.put( "Ice Wall", new RuneType( "Ice Wall", 3, 2, RType.R_ICE_WALL, TUNDRA, AType.A_MAGIC_RAMPART, 4, 5, 6, 7, 8, OPPONENT_IN_PLAY, MOUNTAIN, 1, false ) );
  runesMap.put( "Icicle", new RuneType( "Icicle", 3, 2, RType.R_ICICLE, TUNDRA, AType.A_ICEBALL, 5, 6, 7, 8, 9, ROUNDS, 0, 14, true ) );
  runesMap.put( "Leaf", new RuneType( "Leaf", 4, 2, RType.R_LEAF, FOREST, AType.A_SNIPE, 4, 5, 6, 7, 8, ROUNDS, 0, 14, true ) );
  runesMap.put( "Mineral", new RuneType( "Mineral", 3, 2, RType.R_MINERAL, SWAMP, AType.A_SHIELD, 3, 4, 5, 6, 7, OPPONENT_HAND, ANY, 1, true ) );
  runesMap.put( "Red Lotus", new RuneType( "Red lotus", 5, 2, RType.R_RED_LOTUS, MOUNTAIN, AType.A_HEALING, 4, 5, 6, 7, 8, OPPONENT_IN_PLAY, FOREST, 1, true ) );
  runesMap.put( "Thunderbolt", new RuneType( "Thunderbolt", 3, 2, RType.R_THUNDERBOLT, FOREST, AType.A_THUNDERBOLT, 5, 6, 7, 8, 9, OPPONENT_GRAVE, SWAMP, 1, true ) );
  runesMap.put( "Blizzard", new RuneType( "Blizzard", 4, 3, RType.R_BLIZZARD, TUNDRA, AType.A_GROUP_WEAKEN, 3, 4, 5, 6, 7, PLAYER_GRAVE, TUNDRA, 1, true ) );
  runesMap.put( "Charred", new RuneType( "Charred", 4, 3, RType.R_CHARRED, MOUNTAIN, AType.A_FIRE_GOD, 3, 4, 5, 6, 7, PLAYER_GRAVE, MOUNTAIN, 1, true ) );
  runesMap.put( "Clear Spring", new RuneType( "Clear Spring", 4, 3, RType.R_CLEAR_SPRING, TUNDRA, AType.A_REGENERATION, 5, 6, 7, 8, 9, PLAYER_IN_PLAY, TUNDRA, 1, true ) );
  runesMap.put( "Eruption", new RuneType( "Eruption", 4, 3, RType.R_ERUPTION, MOUNTAIN, AType.A_FIRE_WALL, 5, 6, 7, 8, 9, PLAYER_LIFE, 0, 50, true ) );
  runesMap.put( "Fire Forge", new RuneType( "Fire Forge", 4, 3, RType.R_FIRE_FORGE, MOUNTAIN, AType.A_GROUP_COUNTERATTACK, 3, 4, 5, 6, 7, PLAYER_GRAVE, MOUNTAIN, 1, false ) );
  runesMap.put( "Revival", new RuneType( "Revival", 4, 3, RType.R_REVIVAL, FOREST, AType.A_GROUP_MORALE, 4, 5, 6, 7, 8, PLAYER_GRAVE, FOREST, 1, true ) );
  runesMap.put( "Spring Breeze", new RuneType( "Spring Breeze", 4, 3, RType.R_SPRING_BREEZE, FOREST, AType.A_BARRICADE, 4, 5, 6, 7, 8, PLAYER_HAND, FOREST, 1, true ) );
  runesMap.put( "Stone Forest", new RuneType( "Stone Forest", 4, 3, RType.R_STONE_FOREST, SWAMP, AType.A_GROUP_REFLECTION, 5, 6, 7, 8, 9, PLAYER_GRAVE, SWAMP, 1, false ) );
  runesMap.put( "Stonewall", new RuneType( "Stonewall", 4, 3, RType.R_STONEWALL, SWAMP, AType.A_JOINT_DEFENSE, 5, 6, 7, 8, 9, PLAYER_IN_PLAY, SWAMP, 1, false ) );
  runesMap.put( "Swampwater", new RuneType( "Swampwater", 4, 3, RType.R_SWAMP_WATER, SWAMP, AType.A_SMOG, 5, 6, 7, 8, 9, OPPONENT_GRAVE, TUNDRA, 1, true ) );
  runesMap.put( "Tornado", new RuneType( "Tornado", 4, 3, RType.R_TORNADO, FOREST, AType.A_CHAIN_LIGHTNING, 4, 5, 6, 7, 8, PLAYER_LIFE, 0, 60, true ) );
  runesMap.put( "Tsunami", new RuneType( "Tsunami", 4, 3, RType.R_TSUNAMI, TUNDRA, AType.A_RAGE, 4, 5, 6, 7, 8, PLAYER_LIFE, 0, 50, false ) );
  runesMap.put( "Arctic Freeze", new RuneType( "Arctic Freeze", 3, 4, RType.R_ARCTIC_FREEZE, TUNDRA, AType.A_ICE_WALL, 5, 6, 7, 8, 9, PLAYER_GRAVE, TUNDRA, 2, false ) );
  runesMap.put( "Avalanche", new RuneType( "Avalanche", 4, 4, RType.R_AVALANCHE, TUNDRA, AType.A_NOVA_FROST, 6, 7, 8, 9, 10, OPPONENT_IN_PLAY, MOUNTAIN, 1, true ) );
  runesMap.put( "Blood Stone", new RuneType( "Blood Stone", 5, 4, RType.R_BLOOD_STONE, MOUNTAIN, AType.A_GROUP_REJUVENATION, 5, 6, 7, 8, 9, PLAYER_IN_PLAY, MOUNTAIN, 1, false ) );
  runesMap.put( "Burning Soul", new RuneType( "Burning Soul", 6, 4, RType.R_BURNING_SOUL, MOUNTAIN, AType.A_DAMNATION, 6, 7, 8, 9, 10, PLAYER_IN_PLAY, MOUNTAIN, 1, true ) );
  runesMap.put( "Explosion", new RuneType( "Explosion", 5, 4, RType.R_EXPLOSION, MOUNTAIN, AType.A_MARTYRDOM, 4, 5, 6, 7, 8, OPPONENT_IN_PLAY, FOREST, 1, false ) );
  runesMap.put( "Flying Stone", new RuneType( "Flying Stone", 4, 4, RType.R_FLYING_STONE, SWAMP, AType.A_GROUP_SNIPE, 5, 6, 7, 8, 9, PLAYER_GRAVE, SWAMP, 2, false ) );
  runesMap.put( "Holy Well", new RuneType( "Holy Well", 6, 4, RType.R_HOLY_WELL, TUNDRA, AType.A_PRAYER, 5, 6, 7, 8, 9, OPPONENT_GRAVE, MOUNTAIN, 1, true ) );
  runesMap.put( "Quicksand", new RuneType( "Quicksand", 4, 4, RType.R_QUICKSAND, SWAMP, AType.A_PLAGUE, 5, 6, 7, 8, 9, OPPONENT_IN_PLAY, TUNDRA, 1, true ) );
  runesMap.put( "Raised Flag", new RuneType( "Raised Flag", 4, 4, RType.R_RAISED_FLAG, FOREST, AType.A_GROUP_BLITZ, 6, 7, 8, 9, 10, PLAYER_IN_PLAY, FOREST, 1, false ) );
  runesMap.put( "Red Valley", new RuneType( "Red Valley", 5, 4, RType.R_RED_VALLEY, SWAMP, AType.A_VAMPIRISM, 5, 6, 7, 8, 9, PLAYER_IN_PLAY, SWAMP, 1, false ) );
  runesMap.put( "Thunder Shield", new RuneType( "Thunder Shield", 4, 4, RType.R_THUNDER_SHIELD, FOREST, AType.A_GROUP_RETALIATION, 6, 7, 8, 9, 10, PLAYER_IN_PLAY, FOREST, 1, false ) );
  runesMap.put( "Transparency", new RuneType( "Transparency", 4, 4, RType.R_TRANSPARENCY, FOREST, AType.A_HYSTERIA, 5, 6, 7, 8, 9, OPPONENT_IN_PLAY, SWAMP, 1, false ) );
  runesMap.put( "Death Zone", new RuneType( "Death Zone", 5, 5, RType.R_DEATH_ZONE, SWAMP, AType.A_TOXIC_CLOUDS, 6, 7, 8, 9, 10, PLAYER_GRAVE, SWAMP, 1, true ) );
  runesMap.put( "Dirt", new RuneType( "Dirt", 4, 5, RType.R_DIRT, SWAMP, AType.A_GROUP_RESURRECTION, 4, 5, 6, 7, 8, PLAYER_GRAVE, SWAMP, 1, false ) );
  runesMap.put( "Frost Bite", new RuneType( "Frost Bite", 3, 5, RType.R_FROST_BITE, TUNDRA, AType.A_GROUP_CONCENTRATION, 3, 4, 5, 6, 7, PLAYER_GRAVE, TUNDRA, 3, false ) );
  runesMap.put( "Inferno", new RuneType( "Inferno", 5, 5, RType.R_INFERNO, MOUNTAIN, AType.A_FIRESTORM, 6, 7, 8, 9, 10, PLAYER_GRAVE, MOUNTAIN, 1, true ) );
  runesMap.put( "Lightning", new RuneType( "Lightning", 4, 5, RType.R_LIGHTNING, FOREST, AType.A_ELECTRIC_SHOCK, 6, 7, 8, 9, 10, PLAYER_IN_PLAY, FOREST, 1, true ) );
  runesMap.put( "Lore", new RuneType( "Lore", 4, 5, RType.R_LORE, MOUNTAIN, AType.A_GROUP_WARPATH, 6, 7, 8, 9, 10, PLAYER_GRAVE, MOUNTAIN, 2, false ) );
  runesMap.put( "Nimble Soul", new RuneType( "Nimble Soul", 3, 5, RType.R_NIMBLE_SOUL, FOREST, AType.A_GROUP_DODGE, 5, 6, 7, 8, 9, PLAYER_GRAVE, FOREST, 2, false ) );
  runesMap.put( "Ghost Step", new RuneType( "Ghost Step", 5, 5, RType.R_GHOST_STEP, MOUNTAIN, AType.A_GROUP_EVASION, 1, 1, 1, 1, 1, PLAYER_IN_PLAY, MOUNTAIN, 2, false ) );
  runesMap.put( "Permafrost", new RuneType( "Permafrost",4, 5, RType. R_PERMAFROST, TUNDRA, AType.A_BLIZZARD, 6, 7, 8, 9, 10, PLAYER_IN_PLAY, TUNDRA, 1, true ) );
}

Rune runeFromString( String s )
{
  if( s.length() > 6 )
  {
    int level = s.charAt( s.length() - 2 ) - '0';
    s = s.substring( 6, s.length() - 4 );
    if( runesMap.containsKey( s ) )
      return new Rune( runesMap.get( s ), level );
    else
      println(s + "! ");
  }
  return null;
}
