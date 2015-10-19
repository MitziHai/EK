
import java.io.*;

static final int FOREST = 0;
static final int SWAMP = 1;
static final int TUNDRA = 2;
static final int MOUNTAIN = 3;
static final int DEMON = 4;
static final int SPECIAL = 5;

TreeMap<String, CardType> cardsMap = new TreeMap<String, CardType>(String.CASE_INSENSITIVE_ORDER);
TreeMap<String, Integer> factions = new TreeMap<String, Integer>(String.CASE_INSENSITIVE_ORDER);
TreeMap<Integer, String> factionsName = new TreeMap<Integer, String>();
String error = "";
void loadCards()
{
  int index3 = 0;
  int index4 = 0;
  int index5 = 0;
  try
  {
    File f = new File("CardsList2.txt");
    if(!f.exists()) 
    {
      PrintWriter writer = new PrintWriter("CardsList2.txt", "UTF-8");
      for( int i = 0; i < cardList.length; ++ i )
      {
        writer.println(cardList[i]);
      }
      error = "written";
      writer.close();
    }
    
    factions.put("Forest", FOREST);
    factions.put("Tundra", TUNDRA);
    factions.put("Swamp", SWAMP);
    factions.put("Mountain", MOUNTAIN);
    factions.put("Demon", DEMON);
    factions.put("Special", SPECIAL);
    factionsName.put(FOREST, "Forest");
    factionsName.put(TUNDRA, "Tundra");
    factionsName.put(SWAMP, "Swamp");
    factionsName.put(MOUNTAIN, "Mountain");
    factionsName.put(DEMON, "Demon");
    factionsName.put(SPECIAL, "Special");
   
    boolean firstLine = true;
    BufferedReader br = createReader("CardsList2.txt");
    for (String line; (line = br.readLine()) != null; )
    {
      if ( firstLine )
      {
        firstLine = false;
        continue;
      }
      StringTokenizer defaultTokenizer = new StringTokenizer(line, ",");
      String data[] = new String [42];
      int i = 0;
      while (defaultTokenizer.hasMoreTokens () && i < 42 )
      {
        data[ i ++ ] = defaultTokenizer.nextToken().trim();
      }
      int hp[] = new int[16];
      int atk[] = new int[16];
      for ( int j = 0; j < 16; ++ j )
      {
        hp[j] = Integer.parseInt( data[ 10+j ] );
        atk[j] = Integer.parseInt( data[ 16+10+j ] );
      }
      AType abil[] = {
        AType.A_NONE, AType.A_NONE, AType.A_NONE, AType.A_NONE, AType.A_NONE
      };
      int abilLvl[] = {
        -1, -1, -1, -1, -1
      };
      for ( int j = 0; j < 5; ++ j )
      {
        String a = data[5+j];
        if (a.length() > 1 )
        {
          char last = a.charAt(a.length() - 1);
          int l = 1;
          if ( last == '0' )
          {
            a = a.substring(0, a.length()-3);
            l = 10;
          }
          else if ( last >= '1' && last <= '9' )
          {
            a = a.substring(0, a.length()-2);
            l = last - '1' + 1;
          }
          abil[ j ] = abilities.get( a );
          //if ( abil[ j ] == null ) println( data[0] + " " + a);
          abilLvl[j] = l;
        }
      }
      CardType ct = new CardType(data[0], hp, atk, factions.get(data[3]), Integer.parseInt(data[1]), Integer.parseInt(data[2]), Integer.parseInt(data[4]), abil, abilLvl);

      cardsMap.put( ct.name, ct );
      if (ct.stars == 3)  {
        ListHydraCard1.listItems.add( ct.name );
        if (Event3Star.equals(ct.name)) ListHydraCard1.currentIndex = index3; 
        index3++;
      }
      if (ct.stars == 4)  {
        ListHydraCard2.listItems.add( ct.name );
        if (Event4Star.equals(ct.name)) ListHydraCard2.currentIndex = index4;
        listMeritCard1.listItems.add (ct.name);
        if (MeritCard1.equals(ct.name)) listMeritCard1.currentIndex = index4 + index5;
        listMeritCard2.listItems.add (ct.name);
        if (MeritCard2.equals(ct.name)) listMeritCard2.currentIndex = index4 + index5;
        index4++;
      }
      if (ct.stars == 5)  {
        ListHydraCard3.listItems.add( ct.name );
        if (Event5Star.equals(ct.name)) ListHydraCard3.currentIndex = index5;
        listMeritCard1.listItems.add (ct.name);
        if (MeritCard1.equals(ct.name)) listMeritCard1.currentIndex = index4 + index5;
        listMeritCard2.listItems.add (ct.name);
        if (MeritCard2.equals(ct.name)) listMeritCard2.currentIndex = index4 + index5;
        index5++;
      }
    }
    br.close();
  }
  catch( Exception e )
  {
    println(e);
    error = ""+e;
  }

  //cards.listItems.addAll(cardsMap.keySet());
  Iterator it = cardsMap.entrySet().iterator();
  while (it.hasNext ())
  {
    Map.Entry pairs = (Map.Entry)it.next();
    cards.listItems.add((String)pairs.getKey() + ";10");
  }

  //println(cardsMap.get("Mars")+ " " +cardsMap.get("Mars").abilityL[0]);
}

class AbilityWhen2
{
  int w1;
  int w2;
  int w3;
}

AbilityWhen2 getAbilityWhen( AType ability )
{
  int when = NEVER;
  int when2 = NEVER;
  int when3 = NEVER;
  switch( ability )
  {
  case A_ADVANCED_STRIKE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_APOCALYPSE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_ARCTIC_POLLUTION: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_BACKSTAB: 
    when = ON_ENTER; 
    when2 = NEVER; 
    break;
  case A_BITE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_BLOODY_BATTLE: 
    when = ON_ATTACK_CARD; 
    when2 = ON_ATTACK_PLAYER; 
    break;
  case A_BLOODSUCKER: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_BLOODTHIRSTY: 
    when = AFTER_ATTACK; 
    when2 = NEVER; 
    break;
  case A_BLIGHT: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_BLITZ: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_BLIZZARD: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_CERBERUS: 
    when = BEFORE_ATTACK; 
    when2 = ON_ATTACKED; 
    break;
  case A_CHAIN_ATTACK: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_CHAIN_LIGHTNING: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_CLEAN_SWEEP: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_COMBUSTION: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_CONCENTRATION: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_CONFUSION:
    when = BEFORE_ATTACK;
    when2 = NEVER;
    break;
  case A_CORRUPTION:
    when = BEFORE_ATTACK;
    when2 = NEVER;
    break;
  case A_COUNTERATTACK:
    when = ON_ATTACKED;
    when2 = NEVER;
    break;
  case A_CRAZE:
    when = ON_ATTACKED;
    when2 = NEVER;
    break;
  case A_CURSE: 
    when = BEFORE_ATTACK;
    when2 = NEVER; 
    break;
  case A_D_REANIMATION:
  case A_D_ANNIHILATION:
  case A_D_BLIZZARD:
  case A_D_CURSE:
  case A_D_DESTROY:
  case A_D_ELECTRIC_SHOCK:
  case A_D_FIRESTORM:
  case A_D_FIRE_GOD:
  case A_D_GROUP_WEAKEN:
  case A_D_HEALING:
  case A_D_PLAGUE:
  case A_D_PRAYER:
  case A_D_REGENERATION:
  case A_D_REINCARNATION:
  case A_D_TOXIC_CLOUDS:
  case A_D_TRAP:
    when = ON_DEATH; 
    when2 = NEVER; 
    break;
  case A_DAMNATION: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_DEATH_MARKER: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_DESTROY: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_DEVILS_ARMOR: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_DEVILS_BLADE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_DEVILS_CURSE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_DEXTERITY: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_DIVINE_PROTECTION: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    when3 = NEVER; 
    break;
  case A_DODGE: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_DONS_BODYGUARD: 
    when = ON_DEATH; 
    when2 = NEVER; 
    break;
  case A_DOUBLE_WINGS: 
    when = ON_ENTER; 
    when2 = NEVER; 
    break;
  case A_DREAD_ROAR: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_DUAL_SNIPE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_ELECTRIC_SHOCK: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_EVASION: 
    when = ON_ATTACKED_SPELL; 
    when2 = NEVER; 
    break;
  case A_EXILE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_FEAST_OF_BLOOD: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_FIRESTORM: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_FIREBALL: 
    when = BEFORE_ATTACK; 
    when2 = NEVER;
    break;
  case A_FIRE_GOD: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_FIRE_WALL: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_FOREST_ATK: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_FOREST_HP: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_FOREST_FIRE: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_FROST_SHOCK: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_GANG_UP: 
    when = ON_ENTER; 
    when2 = NEVER; 
    break;
  case A_GLACIAL_BARRIER: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_GUARD: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_GROUP_WEAKEN: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_HEALING: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_HEALING_MIST: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_HOT_CHASE: 
    when = ON_ATTACK_CARD; 
    when2 = ON_ATTACK_PLAYER; 
    break;
  case A_ICEBALL: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_ICE_SHIELD: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_IMMUNITY:
    break;
  case A_IMPEDE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_INFILTRATOR: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_JUNGLE_BARRIER: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_LACERATION: 
    when = AFTER_ATTACK; 
    when2 = NEVER; 
    break;
  case A_LAST_CHANCE: 
    when = ON_DEATH; 
    when2 = NEVER; 
    break;
  case A_MAGIC_SHIELD: 
    when = ON_ATTACKED_SPELL; 
    when2 = NEVER; 
    break;
  case A_MANA_BURN: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_MANA_CORRUPTION: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_MANIA: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_MARSH_BARRIER: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_MASS_ATTRITION:
    when = BEFORE_ATTACK;
    when2 = NEVER;
    break;
  case A_MOUNTAIN_ATK: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_MOUNTAIN_HP: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_MOUNTAIN_GLACIER: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_NOVA_FROST: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_OBSTINACY: 
    when = ON_ENTER; 
    when2 = NEVER; 
    break;
  case A_ORIGINS_GUARD: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_PARRY: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_POWER_SOURCE: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_PRAYER: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_PLAGUE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_PUNCTURE: 
    when = AFTER_ATTACK; 
    when2 = NEVER; 
    break;
  case A_PURIFICATION: 
    when = BEGIN_TURN; 
    when2 = NEVER; 
    break;
  case A_QS_BLIZZARD:
  case A_QS_CURSE:
  case A_QS_DESTROY:
  case A_QS_ELECTRIC_SHOCK:
  case A_QS_EXILE:
  case A_QS_FIRESTORM:
  case A_QS_FIRE_GOD:
  case A_QS_GROUP_WEAKEN:
  case A_QS_HEALING:
  case A_QS_PLAGUE:
  case A_QS_PRAYER:
  case A_QS_PURIFICATION:
  case A_QS_REGENERATION:
  case A_QS_REINCARNATION:
  case A_QS_TELEPORT:
  case A_QS_TOXIC_CLOUDS:
  case A_QS_TRAP:
  case A_QS_MASS_ATTRITION:
    when = ON_ENTER;
    when2 = NEVER;
    break;
  case A_REANIMATION: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_REFLECTION: 
    when = ON_ATTACKED_SPELL; 
    when2 = NEVER; 
    break;
  case A_REGENERATION: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_REINCARNATION: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_REJUVENATION: 
    when = AFTER_ATTACK; 
    when2 = NEVER; 
    break;
  case A_RESISTANCE: 
    break;
  case A_RESURRECTION: 
    when = ON_DEATH; 
    when2 = NEVER; 
    break;
  case A_RETALIATION: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_SACRIFICE: 
    when = ON_ENTER; 
    when2 = NEVER; 
    break;
  case A_SACRED_FLAME: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_SEAL: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_SELF_DESTRUCT: 
    when = ON_DEATH; 
    when2 = NEVER; 
    break;
  case A_SHIELD_OF_EARTH: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_SILENCE:
    when = BEFORE_ATTACK; 
    break;
  case A_SLAYER: 
    when = ON_ATTACK_PLAYER; 
    when2 = NEVER; 
    break;
  case A_SMOG: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_SNIPE: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_SUMMON_DRAGON: 
    when = ON_ENTER; 
    when2 = NEVER; 
    break;
  case A_SWAMP_ATK: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_SWAMP_HP: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_SWAMP_PURITY: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_THUNDERBOLT: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_TOXIC_CLOUDS: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_TRAP: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_TUNDRA_ATK: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_TUNDRA_HP: 
    when = ON_ENTER; 
    when2 = ON_DEATH; 
    break;
  case A_VENDETTA: 
    when = ON_ATTACK_CARD; 
    when2 = ON_ATTACK_PLAYER; 
    break;
  case A_VENOM: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_VOLCANO_BARRIER: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  case A_WARCRY: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_WARPATH: 
    when = ON_ATTACK_CARD; 
    when2 = NEVER; 
    break;
  case A_WEAKEN: 
    when = BEFORE_ATTACK; 
    when2 = NEVER; 
    break;
  case A_WICKED_LEECH: 
    when = ON_ATTACKED; 
    when2 = NEVER; 
    break;
  }
  
  AbilityWhen2 aw = new AbilityWhen2();
  aw.w1 = when;
  aw.w2 = when2;
  aw.w3 = when3;
  return aw;
}

class CardType
{
  String name = "";
  String suffix = "";
  int hp[] = new int[15];
  int atk[] = new int[15];
  int cost;
  int timer;
  int stars;
  AType[] abilities;
  int[] abilityL;
  int faction;
  boolean resist = false;
  boolean immune = false;
  boolean canReanim = true;
  AType[][] abilitiesWhen = new AType[NUM_WHEN][5];
  int[][] abilitiesLevel = new int[NUM_WHEN][5];
  int[][] abilitiesReq = new int[NUM_WHEN][5];
  int[] abilitiesNum = new int[NUM_WHEN];

  CardType( String n, int hp[], int atk[], int f, int c, int s, int t, AType[] a, int[] al )
  {
    // Init
    stars = s;
    name = n;
    this.hp = hp;
    this.atk = atk;
    cost = c;
    timer = t;
    abilities = a;
    abilityL = al;
    faction = f;

    // Sort abilities into "when" lists.
    /* static final int BEFORE_ATTACK = 0;
     static final int AFTER_ATTACK = 1;
     static final int ON_ATTACK_PLAYER = 2;
     static final int ON_ATTACK_CARD = 3;
     static final int ON_ATTACKED = 4;
     static final int ON_ENTER = 5;
     static final int ON_DEATH = 6;
     static final int ON_ATTACKED_SPELL = 7;
     static final int NUM_WHEN = 8;*/
    if ( abilities == null ) return;

    Abil abil[] = new Abil[ abilities.length ];
    for ( int i = 0; i < abilities.length; ++ i )
    {
      abil[i] = new Abil();
      abil[i].a = abilities[i];
      abil[i].l = abilityL[i];
    }

    //for ( int i = 0; i < NUM_WHEN; ++ i )
      //Arrays.sort(abil, abilityPriority);

    for ( int i = 0; i < abil.length; ++ i )
    {
      int when = NEVER;
      int when2 = NEVER;
      int when3 = NEVER;
      if ( abil[ i ].a == null ) continue;
      AbilityWhen2 aw = getAbilityWhen( abil[ i ].a );
      when = aw.w1;
      when2 = aw.w2;
      when3 = aw.w3;
      
      if( abil[ i ].a == AType.A_REANIMATION || abil[ i ].a == AType.A_D_REANIMATION || abil[ i ].a == AType.A_IMMUNITY )
        canReanim = false;
        
      if( abil[ i ].a == AType.A_IMMUNITY )
        immune = true;
        
      if( abil[ i ].a == AType.A_RESISTANCE )
        resist = true;

      if ( when > -1 )
      {
        abilitiesReq[ when ][ abilitiesNum[ when ] ] = min( ( i+0 ) * 5, 10 );
        abilitiesWhen[ when ][ abilitiesNum[ when ] ] = abil[ i ].a;
        abilitiesLevel[ when ][ abilitiesNum[ when ] ++ ] = abil[ i ].l;
      }
      if ( when2 > -1 )
      {
        abilitiesReq[ when2 ][ abilitiesNum[ when2 ] ] = min( ( i+0 ) * 5, 10 );
        abilitiesWhen[ when2 ][ abilitiesNum[ when2 ] ] = abil[ i ].a;
        abilitiesLevel[ when2 ][ abilitiesNum[ when2 ] ++ ] = abil[ i ].l;
      }
      if ( when3 > -1 )
      {
        abilitiesReq[ when3 ][ abilitiesNum[ when3 ] ] = min( ( i+0 ) * 5, 10 );
        abilitiesWhen[ when3 ][ abilitiesNum[ when3 ] ] = abil[ i ].a;
        abilitiesLevel[ when3 ][ abilitiesNum[ when3 ] ++ ] = abil[ i ].l;
      }
    }
  }

  String toString()
  {
    return name + ", " + cost + ", " + stars + ", " + factionsName.get( faction ) + ", " + timer;
  }
}

static final int NEVER = -1;
static final int BEFORE_ATTACK = 0;
static final int AFTER_ATTACK = 1;
static final int ON_ATTACK_PLAYER = 2;
static final int ON_ATTACK_CARD = 3;
static final int ON_ATTACKED = 4;
static final int ON_ENTER = 5;
static final int ON_DEATH = 6;
static final int ON_ATTACKED_SPELL = 7;
static final int BEGIN_TURN = 8;
static final int NUM_WHEN = 9;

static final String statusNames[] = {"frozen", "shocked", "trapped", "confused", "silenced", "reanimated sickness", "lacerated", "stunned", "corrupted", "dread roar", "last chance", "death marker", "heal","healing mist","destroy", "snipe", "non-reflectable","poison","fire","blood","none","mana corruption"};
static final int FROZEN = 0;
static final int SHOCKED = 1;
static final int TRAPPED = 2;
static final int CONFUSED = 3;
static final int SILENCED = 4;
static final int SICK = 5;
static final int LACERATED = 6;
static final int STUNNED = 7;
static final int CORRUPT = 8;
static final int DREAD_ROAR = 9;
static final int LAST_CHANCE = 10;
static final int DEATH_MARKER = 11;
static final int HEAL = 12;
static final int HEAL_MIST = 13;
static final int DESTROY = 14;
static final int NO_IMMUNE = 15;
static final int NO_REFLECT = 16;
static final int POISONED = 17;
static final int FIRE = 18;
static final int BLOOD = 19;
static final int NONE = 20;
static final int MANA_CORRUPTION = 21;

static final int STATUS_SIZE = 12;
static final int COMBUST_SIZE = 11;

class Card
{
  CardType type;
  int pos = 0;
  int lvl;
  int hpCurr;
  int hpBuff;
  int last_chance;
  int hpMax;
  int atk;
  int atkBuff;
  int atkMax;
  int burn;
  int cost;
  Card summoner;

  int faction;
  boolean fireGod[] = {false, false, false, false, false, false, false, false, false, false, false};
  boolean combust[] = {false, false, false, false, false, false, false, false, false, false, false};
  int combustion = 0;
  int poison;
  boolean status[] = new boolean[ STATUS_SIZE ];
  boolean summoned = false;
  int time;
  int atkNow;
  int buffGuardOffset = 0;
  int buffAttackOffset = 0;
  int buffSummonedOffset = 0;
  int dmgTaken;
  int dmgDone[] = new int[ 40 ];
  int dmgCalculated[] = new int[ 40 ];
  int backstab = 0;
  int ward = 0;
  boolean infiltrator = false;
  Card attacker;
  float bloodsuck;
  int retaliate[] = new int[ 3 ];
  boolean selected = false;
  boolean dead = false;
  boolean reflective = false;
  boolean magicshield = false;
  boolean dex = false;
  boolean evasion = false;
  boolean resist = false; // Prevents teleport/exile/destroy
  boolean immune = false; // Prevents ability damage, but not exile/teleport/etc
  boolean reanimated = false; // Prevent a card from resurrecting itself twice.
  boolean alreadySealed = false; // Prevent seal from working twice.
  boolean cleanSweeped = false; // Hack used to make chain attack targets not get lacerated. This will not work if cards have both lacerate and chain attack.
  float chain = 1;
  int craze = 0;
  float wickedLeech = 0;
  float dmgMult = 1;
  int dmgMax = 100000;
  int dmgMinus = 0;
  AType evo;
  int evoLevel;
  int wash;
  int morale;
  
  int totalGlitchCount = 0;

  Card targets[] = new Card[ 40 ];
  int targetNum = 0;

  AType[][] abilities = new AType[ NUM_WHEN ][ 10 ];
  int[][] abilityL = new int[ NUM_WHEN ][ 10 ];
  boolean[][] abilitySilenced = new boolean[ NUM_WHEN ][ 10 ];
  int[] abilityNum = new int[ NUM_WHEN ];
  int[] abilityNumOrig = new int[NUM_WHEN];
  Card divineProtect[] = new Card[3];
  int divineProVal = 0;

  Card( CardType t, int l, AType evo, int evoLevel, int w )
  {
    resist = t.resist;
    immune = t.immune;
    lvl = l;
    type = t;
    wash = w;
    if (w == 0) this.cost = t.cost + (l>10?(int)((l - 9)/2):0);
    else this.cost = t.cost + w;
    hpMax = t.hp[lvl];
    buffGuardOffset = 0;
    buffAttackOffset = 0;
    buffSummonedOffset = 0;
    atkMax = t.atk[lvl];
    this.evo = evo;
    this.evoLevel = evoLevel;
    
    this.faction = t.faction;
    
    for ( int i = 0; i < NUM_WHEN; ++ i )
    {
      abilityNum[ i ] = type.abilitiesNum[ i ];
      abilityNumOrig[ i ] = type.abilitiesNum[ i ];
      System.arraycopy( type.abilitiesWhen[ i ], 0, abilities[ i ], 0, type.abilitiesWhen[ i ].length );
      System.arraycopy( type.abilitiesLevel[ i ], 0, abilityL[ i ], 0, type.abilitiesLevel[ i ].length );
      
      for ( int j = 0; j < abilityNum[ i ]; ++ j )
      {
        abilitySilenced[i][j] = false;
        if ( lvl < type.abilitiesReq[ i ][ j ] )
        {
          -- abilityNum[ i ];
          -- abilityNumOrig [ i ];
          if ( type.abilitiesWhen[ i ][ j ] == AType.A_IMMUNITY )
            immune = false;
          if ( type.abilitiesWhen[ i ][ j ] == AType.A_RESISTANCE )
            resist = false;
        }
      }
    }
    
    if( evo != AType.A_NONE && evo != null && evoLevel > 0 && lvl >= 10 )
    {
      AbilityWhen2 aw = getAbilityWhen( evo );
      if( aw.w1 != NEVER )
        {
        abilityL[ aw.w1 ][ abilityNum[ aw.w1 ] ] = evoLevel;
        abilitySilenced[ aw.w1 ][ abilityNum[ aw.w1 ] ] = false;
        abilities[ aw.w1 ][ abilityNum[ aw.w1 ] ++ ] = evo;
        abilityNumOrig[ aw.w1 ] ++;
      }
      if( aw.w2 != NEVER )
        {
        abilityL[ aw.w2 ][ abilityNum[ aw.w2 ] ] = evoLevel;
        abilitySilenced[ aw.w2 ][ abilityNum[ aw.w2 ] ] = false;
        abilities[ aw.w2 ][ abilityNum[ aw.w2 ] ++ ] = evo;
        abilityNumOrig[ aw.w2 ] ++;
      }
      if( aw.w3 != NEVER )
        {
        abilityL[ aw.w3 ][ abilityNum[ aw.w3 ] ] = evoLevel;
        abilitySilenced[ aw.w3 ][ abilityNum[ aw.w3 ] ] = false;
        abilities[ aw.w3 ][ abilityNum[ aw.w3 ] ++ ] = evo;
        abilityNumOrig[ aw.w3 ] ++;
      }
      if( evo == AType.A_RESISTANCE ) resist = true;
      if( evo == AType.A_IMMUNITY ) immune = true;
    }
  }

  void resetAll(Player own)
  {        
    hpCurr = hpBuff = hpMax + own.hpBuff[ type.faction ] - buffGuardOffset;
    atk = atkBuff = atkMax + own.atkBuff[ type.faction ] - buffAttackOffset; // + buffSummonedOffset;
    dex = false;
    dead = false;
    evasion = false;
    reanimated = false;
    infiltrator = false;
    last_chance = 0;
    bloodsuck = 0;
    time = type.timer;
    backstab = 0;
    ward = 0;
    burn = 0;
    faction = type.faction;
    for (int i = 0; i < COMBUST_SIZE; ++ i) {
      fireGod[i] = false;
      combust[i] = false;
    }
    poison = 0;
    morale = 0;
    for ( int i = 0; i < STATUS_SIZE; ++ i )
      status[ i ] = false;
    alreadySealed = false;
    divineProtect[ 0 ] = divineProtect[ 1 ] = divineProtect[ 2 ] = null;
    totalGlitchCount = 0;
    System.arraycopy( abilityNumOrig, 0, abilityNum, 0, abilityNumOrig.length );
    for (int i=0;i< NUM_WHEN; i++)
      for (int j=0;j<abilityNum[i];j++)
        abilitySilenced[i][j] = false;
  }

  int subtractHealth( Player own, Player op, int h )
  {
    int dmg = 0;
    boolean wasDead = dead;
    if (ward > 0 && h > 0 && debug) println("       " + min(h, ward) + " damage mitigated by " + toStringNoHp() + "'s ward");
    dmg = max( 0, h - ward );
    ward -= ( h - dmg );
    dmg = min( dmg, hpCurr );
    hpCurr -= dmg;
    dead = hpCurr <= 0;
    if ( !wasDead && dead ) died(own, op,false);
    return dmg;
  }

  void attack( Player own, Player op, int pos )
  {
    boolean isStunned = status[STUNNED];
    if ( dead ) { 
      //println("dead card attacking!!! "+this+ " " +hpCurr+" " +dead);
      //Card c = null;
      //c.atk = 0;
      return;
    }
    if ( debug )
      println("  -" + toStringNoHp() + "'s turn." );
    reanimated = false;
    if ( !status[ SICK ] )
    {
      this.pos = pos;
      bloodsuck = 0;
      dex = false;
      evasion = false;
      cleanSweeped = false;
      chain = 1;


      if ( status[ CONFUSED ] )
      {
        if (status[DREAD_ROAR]) {
          atkNow = atk/2;
          if (debug) println("     " + toStringNoHp() + " attack is halfed due to dread roar. New attack is: " + atkNow );
        }
        if ( debug) println("     " + toStringNoHp() + " attacks its controller for " + atkNow );
        own.attacked( atkNow, op, false );
      }
      else
      {
        if ( !status[ FROZEN ] && !status[ TRAPPED ] && !status[STUNNED])
        {
          atkNow = atk + backstab;
          backstab = 0;

          checkAbilities(own, op, BEFORE_ATTACK,-1);
        }

        if ( !dead && !status[ FROZEN ] && !status[ TRAPPED ] && !status[ SHOCKED ]  && !status[STUNNED] && (op.hp > 0 || op.invul)  && (own.hp > 0 || own.invul))  
        {
          // Attack Player
          if ( op.board[ pos ] == null || op.board[ pos ].dead  )
          {
            checkAbilities(own, op, ON_ATTACK_PLAYER,-1);
            if (status[DREAD_ROAR]) {
              atkNow = atkNow - atk/2;
              if (debug) println("     " + toStringNoHp() + " losses half it's base attack due to dread roar. New attack is: " + atkNow );
            }
            if ( debug ) println("     " + toStringNoHp() + " attacks player for " + atkNow );
            op.attacked( atkNow, own, false ); //should be own not op
            targetNum = 0;
          }
          else
            // Attack card
          {
            targets[ 0 ] = op.board[ pos ];
            targetNum = 1;
            checkAbilities(own, op, ON_ATTACK_CARD,-1);
            if (status[DREAD_ROAR]) {
              atkNow = atkNow - atk/2;
              if (debug) println("     " + toStringNoHp() + " losses half it's base attack due to dread roar. New attack is: " + atkNow );
            }
            for ( int i = 0; i < targetNum; ++ i )
            {
              dmgDone[ i ] = targets[ i ].attacked(op, own, atkNow, this, infiltrator, bloodsuck, i );
              if ( i == 0 )
              {
                atkNow = dmgCalculated[ 0 ];
                atkNow *= chain;
              }
              if( dead ) break;
            }
          }
        }

        // After attack
        if ( !dead && !status[ FROZEN ] && !status[ TRAPPED ] )
          checkAbilities(own, op, AFTER_ATTACK,-1);
      }
    }
    subtractHealth( own, op, poison + burn );
    if( debug )
    {
      if( poison > 0 ) println( "     " + toStringNoHp() + " takes " + poison + " poison damage." );
      if( burn > 0 ) println( "     " + toStringNoHp() + " takes " + burn + " burn damage." );
    }
    poison = 0;
    if (fireGod[0] == true) {
      fireGod[0] = false;
      burn -= 200;
    }
    if (status[CORRUPT]) {
      own.cardCount[ PLAY ][ faction ] -= 1;
      faction = type.faction;
      own.cardCount[ PLAY ][ faction ] += 1;
      status[CORRUPT] = false;
    }
    status[ FROZEN ] = false;
    status[ SHOCKED ] = false;
    status[ TRAPPED ] = false;
    if (isStunned) status[ STUNNED ] = false;
    status[ CONFUSED ] = false;
    status[ DREAD_ROAR] = false;
    status[SILENCED] = false;
    for (int i=0;i< NUM_WHEN; i++)
      for (int j=0;j<abilityNum[i];j++)
        abilitySilenced[i][j] = false;
  }

  // own is player owning this card, opponent is attacker
  int attacked( Player own, Player op, int dmg, Card attacker, boolean infil, float suck, int AttackID )
  {
    dmgTaken = dmg;
    this.attacker = attacker;
    retaliate[ 0 ] = retaliate[ 1 ] = retaliate[ 2 ] = 0;
    dmgMult = 1;
    dmgMax = hpCurr * 10;
    dmgMinus = 0;
    craze = 0;
    wickedLeech = 0;
    combustion = 0;
    if ( debug )
      println("     " + attacker.toStringNoHp() + " attacks " + toStringNoHp() + " for " + dmgTaken);
    checkAbilities( own, op, ON_ATTACKED,-1);
    //dmgCalculated caculates damage done with abilities
    dmgTaken = min(( int)(dmgTaken * dmgMult)- dmgMinus, dmgMax ) ;
    if (status[LAST_CHANCE]) {
      dmgTaken = 0;
      if (debug)       println("       Damage prevented by " + toStringNoHp() + " last chance");
    }
    attacker.dmgCalculated[AttackID] = dmgTaken;
    //dmgTaken reduces damage to damage done to kill card if applicable
    dmgTaken = subtractHealth( own, op, dmgTaken );

    // Bloodsucker heals attacker based on actual damage done, immediately following attack.
    if (debug && suck * dmgTaken > 0) 
      println("     " + attacker.toStringNoHp() + " bloodsucker ability heals for " + ((int)min( attacker.hpCurr + suck * dmgTaken, attacker.hpBuff ) - attacker.hpCurr) + ". Remaining hp: " + (int)min( attacker.hpCurr + suck * dmgTaken, attacker.hpBuff ) + " / " + attacker.hpBuff);
    attacker.hpCurr = (int)min( attacker.hpCurr + suck * dmgTaken, attacker.hpBuff );
    // Counterattack and retaliate damage stored and applied to attacker after bloodsucker healing.
    if( dmgTaken > 0)
    {
      int nowPos = attacker.pos; // Position can change part way through retaliate if the retaliate kills a desperation destroy card which kills a goddess of order which reanimates it - change to attacker position
      for ( int i = nowPos - 1, j = 0; i <= nowPos + 1; ++ i, ++j )
      {
        if ( i >= 0 && i < op.board.length && op.board[ i ] != null && retaliate[ j ] > 0 )
        {
          boolean dex = false;
          for ( int k = 0; k < op.board[ i ].abilityNum[BEFORE_ATTACK]; ++ k ) {
            AType a = op.board[ i ].abilities[ BEFORE_ATTACK ][ k ];
            if (!op.board[ i ].abilitySilenced[ BEFORE_ATTACK ][ k ])
              switch (a) { 
                case A_DEXTERITY:
                  dex = true;
                break;
            }
          }
          if (!dex && !op.board[i].status[LAST_CHANCE]) {
            if (debug) println("       " + op.board[i] + " takes " + retaliate[j] + " damage.");
            if ((radewboss.checked || raddi.checked) && own.isP1) own.merit += retaliate[j]; 
            op.board[ i ].subtractHealth( op, own, retaliate[ j ] );
          }
          else if (debug && dex) println("       " + op.board[i] + " avoids " + retaliate[j] + " damage due to dexterity."); 
          else if (debug) println("       " + op.board[i] + " avoids " + retaliate[j] + " damage due to last chance."); 
        }
      }
      atk += craze;
      totalGlitchCount += craze;
      if (!immune && combustion > 0 && !combust[combustion]) {
        burn += 25*combustion;
        combust[combustion] = true;
      }
      int reduced = ( int )( wickedLeech * attacker.atk );
      attacker.atk -= reduced;
      atk += reduced;
      attacker.totalGlitchCount += reduced;

      if ( debug && wickedLeech > 0 ) println("     " + attacker.toStringNoHp() + " loses " + reduced + " attack to " + toStringNoHp() + "'s Wicked Leach");
    }
    if ( (radewboss.checked || raddi.checked) && !own.isP1 )
    {
      op.merit += dmgTaken;
    }
    return dmgTaken;
  }
  
/*
Abilities: Immunity, Resist, Reflection, Magic Shield
Attacks: Frozen, Shocked, Trapped, Confused, Sick, Lacerated, Corrupt, Heal, Heal Mist, Dstroy, No_immune, No_reflect, poisoned, fire, blood, noe

Statuses: FROZEN, SHOCKED, TRAPPED, CONFUSED, SICK, LACERATED
Seperate Variables: BURNED, POISON, immune, resist, 

  FROZEN: Blizzard (all), Iceball (Random 1), Nova Frost (Random 3)
  SHOCKED: Chain Lightning (Random 3), Electric Shock (All), Thunderbolt (Random 1)
  TRAPPED: Seal (All), Trap (Random 1, 2 or 3 depending on level)
  CONFUSED: Confusion (Random 1), 
  SICK: Used for summing sickness (card reanimated cant attack)
  LACERATED: Used for lacerated card status
  CORRUPT: Mana Corruption (Random 1)
  HEAL: Regeneration (All), (NOTE: Heal, QS_Heal, D_Heal all do not call attacked spell)
  HEALING MIST: HealMist (self and 2 adjacent...doesn't call attacked spell)
  DESTROY: Destroy (Random 1, Does 99,999,999 damage)
  NO_IMMUNE: Devils Blade (Lowest 1), Snipe (Lowest 1), Dual Snipe (Lowest 2)
  NO_REFLECT: Plague (Damage, All), Blight (Damage, Attacked Opponent, does not use attacked spell)
  POISONED: Toxic Clouds (All), Smog (Random 3), Venom (Random 1)
  FIRE: Firestorm (All), Self Destruct (Opponent and 2 adjacent), 
  BLOOD: Bite (Random 1), Feast of Blood (All), 
  NONE: NONE...IS THIS USED???
*/

  // own is player owning this card, opponent is attacker
  int attackedSpell( Player own, Player op, int dmg, Card attacker, int effect, int chance )
  {
    dmgTaken = 0;
    if (status[LAST_CHANCE] && effect != HEAL && effect != STUNNED) {
      if (debug ) {
        if (effect == TRAPPED)
          println("       Last chance prevented trap to " +  toStringNoHp() );
        else if( effect == CONFUSED )
          println("       Last chance prevented confused to " + toStringNoHp() );
        else if( effect == DESTROY )
          println("       Last chance prevented destroy to " + toStringNoHp() );
        else  // FROZEN, SHOCKED, NO_REFLECT, POISONED, FIRE, BLOOD
          println("       Last chance prevented " + dmg + " damage to " +  toStringNoHp() );
      }
      return dmgTaken;
    }
    else if ( (!status[SILENCED] && immune  && !(effect == STUNNED)) || effect == NO_IMMUNE || effect == MANA_CORRUPTION)  // If card is immune and not ability is not stunning (affects immunity but doesn't affect evasion) or damage is snipe or Devils Blade, or mana corruption 
    {
      if ( effect == NO_IMMUNE )
      {
        if (debug) println("       " + dmg + " unavoidable damage  to " + toStringNoHp());
        dmgTaken = subtractHealth( own, op, dmg );
      }
      else if (effect == MANA_CORRUPTION)  // Mana Corruption deals chance * dmg damage to card
      {
        dmgTaken = subtractHealth( own, op, dmg * (immune ? chance : 1) );
        if( debug ) println("       Mana corruption/Burn/Cerberus dealt " + dmg*(immune ? chance : 1) + " to " + (immune ? "immune " : "") + "card " + toStringNoHp() );
      }
      else if (debug ) // all other damages should be prevented by immunity
      {
        if (effect == TRAPPED)
          println("       Immunity prevented trap to " +  toStringNoHp() );
        else if( effect == CONFUSED )
          println("       Immunity prevented confused to " + toStringNoHp() );
        else if( effect == DESTROY )
          println("       Immunity prevented destroy to " + toStringNoHp() );
        else if (effect == HEAL)
          println("       Immunity prevented " + dmg + " healing to " +  toStringNoHp() );
        else if (effect == HEAL)
          println("       Immunity prevented " + dmg + " healing to " +  toStringNoHp() );
        else  // FROZEN, SHOCKED, NO_REFLECT, POISONED, FIRE, BLOOD
          println("       Immunity prevented " + dmg + " damage to " +  toStringNoHp() );
      }

      if ( (radewboss.checked || raddi.checked) && !own.isP1 )
        op.merit += dmgTaken;

      return dmgTaken;
      }
    else if (effect == DESTROY) {  // Abilities affected by resistance
      if( resist ) {
        if (debug) println("         Resist prevented Destroy on " + toStringNoHp() );
      } 
      else if (status[LAST_CHANCE]) {
        if (debug ) println("         Last Chance prevented Destroy on " + toStringNoHp() );
      }
      else {
        dead = true;
        died(own,op,true);
        if (debug) println("       Destroyed " + toStringNoHp() );
      }
      dmg = 0;
      return dmg;
    }
    else if (effect == HEAL) {  // abilities affected by Laceration
      if( status[ LACERATED ] )
      {
        if( debug) println("       Healed of " + dmg + " failed on lacerated card " + toStringNoHp() );
      }
      else
      {
        if( debug) println("       Healed " + (min( hpBuff, hpCurr + dmg ) - hpCurr) + " to " + toStringNoHp() );
        hpCurr = min( hpBuff, hpCurr + dmg );
      }
      return 0;
    }
    else if (effect == NO_REFLECT) {  // abilities that are not affected by reflection and/or magic shield

      dmgTaken = subtractHealth( own, op, dmg );

      if (debug) println("       " + dmgTaken + " " + statusNames[effect] + " damage to " + toStringNoHp() );

      if ( (raddi.checked || radewboss.checked) && !own.isP1 )
        op.merit += dmgTaken;

      return dmgTaken;
    }
    else if (effect == POISONED) {  // abilities that are not affected by reflection and/or magic shield
      if( debug) println("       Applied " + chance + " poison to " + toStringNoHp() );
      poison += chance;

      dmgTaken = subtractHealth( own, op, dmg );

      if ( (radewboss.checked || raddi.checked) && !own.isP1 )
        op.merit += dmgTaken;

      return dmgTaken;
    }
      
    // Find out if there is magic shield or reflective abilities on targeted card
    int magic_shield = 0;
    int reflective = 0;
    boolean evasion = false;
    for ( int i = 0; i < abilityNum[ON_ATTACKED_SPELL]; ++ i ) {
      AType a = abilities[ ON_ATTACKED_SPELL ][ i ];
      switch (a) { 
        case A_MAGIC_SHIELD:
          magic_shield = max(magic_shield,abilityL[ON_ATTACKED_SPELL][i]);
        break;
        case A_REFLECTION:
          reflective = max(reflective,abilityL[ON_ATTACKED_SPELL][i]);;
        break;
        case A_EVASION:
          evasion = true;
        break;
      }
    }  // SHOULD BELOW BE type.faction or just faction (queston is does corruption affect demons and remove some of their innate protections)
    if (effect == TRAPPED || effect == CONFUSED || effect == STUNNED) {  // abilities affected by evasion but not by magic shield and/or reflection
      if( evasion) { if ( debug) println("         " + statusNames[effect] + " prevented by " + toStringNoHp() + "'s evasion"); }
      else if( immune && type.faction == DEMON) { if ( debug) println("         " + statusNames[effect] + " prevented by " + toStringNoHp() + "'s demon immunity"); }
      else if( status[LAST_CHANCE]) { if (debug ) println("         " + statusNames[effect] + " prevented by " + toStringNoHp() + "'s last chance"); }
      else if (random( 0, 100 ) <= chance) {
        if( debug ) println("       " + statusNames[effect] + " applied to " + toStringNoHp() );
        status[ effect ] = true;
      }
      else if (debug ) println("       " + statusNames[effect] + " not applied to " + toStringNoHp() + " by chance");
      return 0;
    }
    else if (reflective > 0) {
      dmgTaken = 30*reflective;
      attacker.subtractHealth( op, own, dmgTaken );
      if( debug ) {
        println( "     " + toStringNoHp() + "'s Reflection");
        println("         Reflected " + dmgTaken + " damage to " + attacker.toStringNoHp() );
      }

      if ( (radewboss.checked || raddi.checked) && !op.isP1 )
        own.merit += dmgTaken;

      dmgTaken = 0;

      return dmgTaken;

    }
    else { // no reflection
      if (magic_shield > 0) { // reduce damage if there was magic shield
        dmg = min(dmg, 160 - 10 * magic_shield);
        if (debug) println( "       " + toStringNoHp() + "'s Magic Shield reduces damage to maximum of " + (160 - 10*magic_shield));
      }
      dmgTaken = subtractHealth( own, op, dmg );
      
      if (debug) println("       " + dmgTaken + " " + statusNames[effect] + " damage to " + toStringNoHp() );

      if (effect == FROZEN || effect == SHOCKED) {
        if( evasion ) { if (debug) println("         " + statusNames[effect] + " prevented by " + toStringNoHp() + "'s evasion"); }
        else if (random( 0, 100 ) <= chance) {
          if( debug ) println("         " + statusNames[effect] + " applied to " + toStringNoHp() );
          status[ effect ] = true;
        }
        else if (debug) println("         " + statusNames[effect] + " not applied to " + toStringNoHp() + " by chance");
      }

      if (effect == BLOOD) {
        if (debug) println( "       " + attacker.toStringNoHp() + " heals " + (min( attacker.hpCurr + dmgTaken, attacker.hpBuff ) - attacker.hpCurr) + " from Feast of Blood");
        attacker.hpCurr = min( attacker.hpCurr + dmgTaken, attacker.hpBuff );
      }

      if ( (radewboss.checked || raddi.checked) && !own.isP1 )
        op.merit += dmgTaken;

      return dmgTaken;

    }
  }
  

  void died(Player own, Player op, boolean destroyed)
  {
    if( debug ) println( "     Died: " + this);
    if (destroyed) checkAbilities(own, op, ON_DEATH,DESTROY);
    else checkAbilities(own,op,ON_DEATH,-1);
    if (!status[LAST_CHANCE]) {
      if (status[DEATH_MARKER]) {
        if (debug ) println("       Death Marker on dying card");
        if (own.board[pos+1] != null ) own.board[pos+1].attackedSpell(own,op,300,this,NO_REFLECT,0);
        if (pos > 0 && own.board[pos-1] != null ) own.board[pos-1].attackedSpell(own,op,300,this,NO_REFLECT,0);
      }
      if (status[CORRUPT]) 
      {        
        status[CORRUPT] = false;
        own.cardCount[ PLAY ][ faction ] -= 1;
        faction = type.faction;
        own.cardCount[ PLAY ][ faction ] += 1;
      }
      if (!reanimated && !summoned) own.addToGrave( this );
      else if (summoned) own.addToSummoned(this);
      own.removeFromPlay(this);
    }
  }

  void checkAbilities( Player own, Player op, int when, int effect )
  {
    for ( int i = 0; i < abilityNum[ when ]; ++ i )
    {
      if ((own.hp <= 0 && !own.invul) || (op.hp <= 0 && !op.invul)) break;
      AType a = abilities[ when ][ i ];
      if ( a == null) continue;
      int l = abilityL[ when ][ i ];
      if ( when == BEFORE_ATTACK )
      {
        if (!dead && !abilitySilenced[when][i] )
        switch( a )
        {
        case A_ADVANCED_STRIKE:
          Card longest = null;
          for ( Card c : own.hand )   
          {
            if ( longest == null || c.time > longest.time ) longest = c;
          }
          if ( longest != null )
          {
            longest.time -= l;
            if( debug ) println( "     Advanced Strike reduces time of " + longest.toStringNoHp() + " by " + l);
          }
          break;

        case A_APOCALYPSE:
          if( debug ) println( "     Apocolypse for " + (150+(60*op.playSize())) + " plus 200 burn");
          damageAll( own, op, (150+(60*op.playSize())), FIRE, 0 );
          for ( Card c : op.inPlay )
          {
            if (!c.immune ) {
              c.fireGod[0] = true;
              c.burn += 200;
            }
          }
          break;


        case A_BITE:
          if( debug ) println( "     Bite for " + (20*l));
          hpCurr = min( hpCurr + damageRandom1( own, op, 20*l, BLOOD, 0 ), hpBuff );
          break;

        case A_BLIZZARD:
          if( debug ) println( "     Blizzard for " + (20*l));
          damageAll( own, op, 20*l, FROZEN, 30 );
          break;

        case A_CERBERUS:
          if( debug ) println( "     Cerberus for 120");
          damageRandom3( own, op, 120, MANA_CORRUPTION, 3 );
          break;

        case A_CHAIN_LIGHTNING:
          if( debug ) println( "     Chain Lightning for " + (25*l));
          damageRandom3( own, op, 25*l, SHOCKED, 40 );
          break;

        case A_CONFUSION:
          if( debug ) println( "     Confusion, " + (30+5*l) + "% chance");
          damageRandom1( own, op, 0, CONFUSED, 30+5*l );
          break;

        case A_CORRUPTION:
          if( debug ) println( "     Corruption");
          for ( Card c : op.inPlay )
          {
            if (c.faction != DEMON) {
              c.status[CORRUPT] = true;
              op.cardCount[ PLAY ][ c.faction ] -= 1;
              c.faction = SWAMP;
              op.cardCount[ PLAY ][ c.faction ] += 1;
            }
          }
          break;

        case A_CURSE:
          if( debug ) println( "     Curse for " + (40*l));
          op.attacked(40*l, own, true);
          break;

        case A_DAMNATION:
          if( debug ) println( "     Damnation for " + (20*l*op.playSize()));
          op.attacked(20*l*op.playSize(), own, true);
          break;

        case A_DEATH_MARKER:
          if ( op.board[ pos ] != null && !op.board[pos].immune)
          {
            Card c = op.board[ pos ];
            if( c != null )
            {
              if( debug ) println( "     Death Marker placed on " + c.toStringNoHp());
              c.status[DEATH_MARKER] = true;
            }
          }
          break;

        case A_DESTROY:
          if( debug ) println( "     Destroy");
          damageRandom1( own, op, 99999999, DESTROY, 100 );
          break;

        case A_DEVILS_BLADE:
          if( debug ) println( "     Devil's Blade for " + (2000));
          damageLowest1( own, op, 2000, NO_IMMUNE, 100 );
          break;

        case A_DEVILS_CURSE:
          if( debug ) println( "     Devil's Curse for " + (1000));
          op.attacked( 1000, own, true );
          break;

        case A_DEXTERITY:
          if( debug ) println( "     Dexterity");
          dex = true;
          break;

        case A_DREAD_ROAR:
          if( debug ) println( "     Dread Roar");
          for ( Card c : op.inPlay )
          {
            if (c.faction != DEMON) {
              c.status[DREAD_ROAR] = true;
            }
          }
          break;

        case A_DUAL_SNIPE:
          if( debug ) println( "     Dual Snipe for " + (25*l));
          damageLowest2( own, op, 25*l, NO_IMMUNE, 100 );
          break;

        case A_ELECTRIC_SHOCK:
          if( debug ) println( "     Electric Shock for " + (25*l));
          damageAll( own, op, 25*l, SHOCKED, 35 );
          break;

        case A_EXILE:
          if ( op.board[ pos ] != null && !op.board[ pos ].resist && !op.board[pos].immune)
          {
            Card c = op.board[ pos ];
            if( c != null )
            {
              if( debug ) println( "     Exile " + c.toStringNoHp());
              op.removeFromPlay( c );
              op.guards.remove( c );
              op.deck.add( c );
              long seed = System.nanoTime();              
              Collections.shuffle(op.deck, new Random(seed));
              c.checkAbilities( own, op, ON_DEATH,-1 );
            }
          }
          break;

        case A_FEAST_OF_BLOOD:
          if( debug ) println( "     Feast of Blood");
          int hpAdd = damageAll( own, op, 20*l, BLOOD, 0 );

          break;

        case A_FIRE_GOD:
          if( debug ) println( "     Fire God for " + (20*l));
          for ( Card c : op.inPlay )
          {
            if (!c.immune && !c.fireGod[l]) {
              c.burn += 20*l;
              c.fireGod[l] = true;
            }
          }
          break;

        case A_FIRE_WALL:
          if( debug ) println( "     Fire Wall for " + (25*l) + "-"+ (50*l));
          damageRandom3( own, op, 25*l, 50*l, FIRE, 0 );
          break;

        case A_FIREBALL:
          if( debug ) println( "     Fire Ball for " + (25*l) + "-" + (50*l));
          damageRandom1( own, op, 25*l, 50*l, FIRE, 0 );
          break;

        case A_FIRESTORM:
          if( debug ) println( "     Firestorm for " + (25*l) + "-" + (50*l));
          damageAll( own, op, 25*l, 50*l, FIRE, 0 );
          break;

        case A_FROST_SHOCK:
          if( debug ) println( "     Frost Shock for " + (40+10*l+(5+5*l)*op.playSize()));
          damageAll( own, op, (40+10*l+(5+5*l)*op.playSize()), FROZEN, 50 );
          break;

        case A_GROUP_WEAKEN:
          if( debug ) println( "     Group Weaken for " + (10*l));
          weakenAll( own, op, 10*l );
          break;

        case A_HEALING:
          Card mostDamaged = null;
          for ( Card c : own.inPlay )
          {
            if ( mostDamaged == null || c.hpBuff - c.hpCurr > mostDamaged.hpBuff - mostDamaged.hpCurr ) mostDamaged = c;
          }
          if ( mostDamaged != null )
          {
            if( mostDamaged.immune )
            {
              if( debug ) println( "     Healing " + mostDamaged.toStringNoHp() + " for " + (25*l) + " failed due to immunity");
            }
            else if( mostDamaged.status[ LACERATED ] )
            {
              if( debug ) println( "     Healing " + mostDamaged.toStringNoHp() + " for " + (25*l) + " failed due to laceration");
            }
            else
            {
              if( debug ) println( "     Healing " + mostDamaged.toStringNoHp() + " for " + (min( mostDamaged.hpCurr + 25*l, mostDamaged.hpBuff ) - mostDamaged.hpCurr));
              mostDamaged.hpCurr = min( mostDamaged.hpCurr + 25*l, mostDamaged.hpBuff );
            }
          }
          break;
          
        case A_HEALING_MIST:
          if( debug ) println( "     Healing Mist self for " + (80+20*l));
          hpCurr = min( hpCurr + 80 + 20*l, hpBuff );
          if( pos > 0 && own.board[ pos - 1 ] != null && !own.board[ pos - 1 ].status[ LACERATED ] )
          {
            if( debug ) println( "     Healing Mist " + own.board[ pos - 1 ].toStringNoHp() + " for " + (80+20*l));
            own.board[ pos - 1 ].hpCurr = min( own.board[ pos - 1 ].hpCurr + 80 + 20*l, own.board[ pos - 1 ].hpBuff );
          }
          if( pos < own.board.length && own.board[ pos + 1 ] != null  && !own.board[ pos + 1 ].status[ LACERATED ] )
          {
            if( debug ) println( "     Healing Mist " + own.board[ pos + 1 ].toStringNoHp() + " for " + (80+20*l));
            own.board[ pos + 1 ].hpCurr = min( own.board[ pos + 1 ].hpCurr + 80 + 20*l, own.board[ pos + 1 ].hpBuff );
          }
          break;

        case A_ICEBALL:
          if( debug ) println( "     Iceball for " + (20*l));
          damageRandom1( own, op, 20*l, FROZEN, 45 );
          break;

        case A_IMPEDE:
          Card lowestWait = null;
          for ( Card c : op.hand )
          {
            if ( lowestWait == null || c.time < lowestWait.time ) lowestWait = c;
          }
          if ( lowestWait != null )
          {
            if( debug ) println( "     Impede " + lowestWait.toStringNoHp() + " by " + l);
            lowestWait.time += l;
          }
          
          break;

        case A_MANA_CORRUPTION:
          if( debug ) println( "     Mana corruption for " + (20*l));
          damageRandom1( own, op, 20*l, MANA_CORRUPTION, 3 );
          break;

        case A_MANA_BURN:
          if( debug ) println( "     Mana Burn for " + (20*l));
          damageRandom3( own, op, 20*l, MANA_CORRUPTION, 3 );
          break;

        case A_MANIA:
          if( debug ) println( "     Mania for " + (20*l));
          atkBuff += 20*l;
          atk += 20*l;
          atkNow += 20*l;
          subtractHealth( own, op, 20*l );
          break;

        case  A_MASS_ATTRITION:
          for ( Card c : op.hand ) {
            c.time += l;
            if (debug) println( "     Mass Attrition increased time of " + c.toStringNoHp() + " by " + l);
          }
          break;

        case A_NOVA_FROST:
          if( debug ) println( "     Nova Frost for " + (20*l));
          damageRandom3( own, op, 20*l, FROZEN, 35 );
          break;

        case A_PLAGUE:
          if( debug ) println( "     Plague for " + (5*l));
          weakenAll( own, op, 5*l );
          damageAll( own, op, 5*l, NO_REFLECT, 0 );
          break;

        case A_PRAYER:
          if( debug ) println( "     Prayer for " + (40*l));
          own.hp = min( own.hpmax, own.hp + 40*l );
          break;

        case A_REANIMATION:
          if( own.graveReanim.size() > 0 )
          {
            Card toReanim = own.graveReanim.get( ( int )random( 0, own.graveReanim.size() ) );
            own.removeFromGrave( toReanim );
            own.addToPlay( toReanim );
            toReanim.status[ SICK ] = true;
            if( debug ) println( "     Reanimation targetting " + toReanim.toStringNoHp());
            toReanim.checkAbilities( own, op, ON_ENTER, -1 );
          }
          else if( debug ) println( "     Reanimation targetting nothing");
          break;

        case A_REGENERATION:
          if( debug ) println( "     Regeneration for " + (25*l));
          damageAll( own, own, 25*l, HEAL, 0 );
          break;

        case A_REINCARNATION:
          for ( int j = 0; j < l && !own.grave.isEmpty(); ++ j )
          {
            int k = (int)random( 0, own.graveSize() );
            Card c = own.removeFromGrave( k );
            c.resetAll(own);
            if( debug ) println( "     Reincarnation targetting " + c.toStringNoHp());            
            own.deck.add( c ); //
          }
          break;

        case A_SACRED_FLAME:
          for ( int j = 0; j < l && !op.grave.isEmpty(); ++ j )
          {
            Card removed = op.removeFromGrave( (int)random( op.graveSize() ) );
            if( debug ) println( "     Sacred Flame removes " + removed.toStringNoHp());
          }
          break;

        case A_SEAL:
          if( !alreadySealed )
          {
            alreadySealed = true;
            if( debug ) println( "     Seal all");
            damageAll( own, op, 0, TRAPPED, 100 );
          }
          break;

        case A_SILENCE:
          if (op.board[ pos ] == null && debug) println("       No Target for silence");
          if ( op.board[ pos ] != null ) {
            if( debug ) println( "     Silence");
            Card c = op.board[ pos ];
            if (c.type.faction == DEMON) {
               if (debug) println("       Demons can not be silenced");
            }
            else 
            {
              c.status[SILENCED] = true;
              for (int j=0; j<NUM_WHEN;j++)
                for (int k=0; k<c.abilityNum[j];k++)
                  c.abilitySilenced[j][k] = true;
              if (debug) println("       " + c.toStringNoHp() + " is silenced.");
            }
          }
          break;

        case A_SMOG:
          if( debug ) println( "     Smog for " + (20*l));
          damageRandom3( own, op, 20*l, POISONED, 20*l );
          break;

        case A_SNIPE:
          if( debug ) println( "     Snipe for " + (30*l));
          damageLowest1( own, op, 30*l, NO_IMMUNE, 0 );
          break;

        case A_THUNDERBOLT:
          if( debug ) println( "     Thunderbolt for " + (25*l));
          damageRandom1( own, op, 25*l, SHOCKED, 50 );
          break;

        case A_TOXIC_CLOUDS:
          if( debug ) println( "     Toxic Clouds for " + (20*l));
          damageAll( own, op, 20*l, POISONED, 20*l );
          break;

        case A_TRAP:
          if( debug ) println( "     Trap");
          if ( l == 1 )
            damageRandom1( own, op, 0, TRAPPED, 65 );
          else if ( l == 2 )
            damageRandom2( own, op, 0, TRAPPED, 65 );
          else if ( l == 3 )
            damageRandom3( own, op, 0, TRAPPED, 65 );
          else if ( l == 4 )
            damageRandom4( own, op, 0, TRAPPED, 65 );
          else if ( l == 5 )
            damageRandom5( own, op, 0, TRAPPED, 65 );
          break;

        case A_VENOM:
          if( debug ) println( "     Venom for " + (20*l));
          damageRandom1( own, op, 20*l, POISONED, 20*l );
          break;

        case A_WARCRY:
          if( debug ) println( "     Warcry for " + (1*l));
          for ( Card c : own.hand )
          {
            c.time -= l;
          }
          break;
        }
      }
      else if ( when == BEGIN_TURN )
      {
        if (!abilitySilenced[when][i] ) 
        switch( a )
        {
          case A_PURIFICATION:
            if( debug ) println( "     Purification");
            for ( Card c : own.inPlay ) {
              c.burn = 0;
              for (int j = 0; j <= 9; ++ j) {
                c.fireGod[j] = false;
                c.combust[j] = false;
              }
              c.poison = 0;
              if (c.status[CORRUPT]) {
                own.cardCount[ PLAY ][ c.faction ] -= 1;
                c.faction = c.type.faction;
                own.cardCount[ PLAY ][ c.faction ] += 1;
              }
              for ( int j = 0; j <= 8; ++ j ) {
                if (j != SILENCED) c.status[ j ] = false;
              }
            }
            break;
        }
      }
      else if ( when == AFTER_ATTACK )
      {
        if (!abilitySilenced[when][i] ) 
        switch( a )
        {
        case A_REJUVENATION:
          if ( !status[ LACERATED ] )
          {
            if( debug ) println( "     Rejuvenation for " + (min( hpBuff, hpCurr+l*30 ) - hpCurr));
            hpCurr = min( hpBuff, hpCurr+l*30 );
          }
          else if( debug ) println( "     Rejuvenation for 0 due to laceration");
          break;

        case A_BLIGHT:
          for ( int j = 0; j < targetNum; ++ j )
          {
            if ( dmgDone[ j ] > 0 && !targets[ j ].immune )
            {
              if( debug ) println( "     Blight for " + (10*l));
              targets[ j ].atk -= 10*l;
              targets[ j ].subtractHealth( op, own, 10*l );
            }
          }
          break;

        case A_BLOODTHIRSTY:
          for ( int j = 0; j < targetNum; ++ j )
          {
            if ( dmgDone[ j ] > 0 )
            {
              if( debug ) println( "     Bloodthirsty for " + (10*l));
              atk += 10*l;
              atkBuff += 10*l;
            }
          }
          break;

        case A_LACERATION:
          for ( int j = 0; j < targetNum; ++ j )
          {
            if( debug && (cleanSweeped || j == 0)) println( "     Laceration applied to "+targets[ j ].toStringNoHp());
            if ( dmgDone[ j ] > 0 && ( cleanSweeped || j == 0 ) ) targets[ j ].status[ LACERATED ] = true;
          }
          break;

        case A_PUNCTURE:
          for ( int j = 0; j < targetNum; ++ j )
          {
            if( debug ) println( "     Puncture for " + (int)(dmgDone[ j ] * 0.15 * l));
            op.attacked( (int)( dmgDone[ j ] * 0.15 * l ), own, false );
          }
          break;
        }
      }
      else if ( when == ON_ATTACK_PLAYER )
      {
        if (!abilitySilenced[when][i] ) 
        switch( a )
        {
        case A_SLAYER:
          if( debug ) println( "     Slayer increases attack by " + (0.15f*l*atk));
          atkNow += 0.15f * l * atk;
          break;

        case A_BLOODY_BATTLE:
          if ( op.board[ pos ] == null)
          {
            if( debug ) println( "     Bloody Battle increases attack by " + (( 0 + l*0.15 ) * atk));
            atkNow += max(0,hpMax - hpCurr);
          }
          break;

        case A_HOT_CHASE:
          if( debug ) println( "     Hot Chase increases attack by " + (( 40 + l*10 ) * op.graveSize()));
          atkNow += ( 40 + 10*l ) * op.graveSize();
          break;
        case A_VENDETTA:
          if( debug ) println( "     Vendetta increases attack by " + (( 40 + l*10 ) * own.graveSize()));
          atkNow += ( 40 + 10*l ) * own.graveSize();
          break;


        }
      }
      else if ( when == ON_ATTACK_CARD )
      {
        if (!abilitySilenced[when][i]) 
        switch( a )
        {
        case A_ARCTIC_POLLUTION:
          if ( op.board[ pos ] != null && op.board[ pos ].faction == TUNDRA )
          {
            if( debug ) println( "     Arctic pollution increases attack by " + (( 0.15 + l*0.15 ) * atk));
            atkNow += ( 0.15 + l*0.15 ) * atk;
          }
          break;

        case A_FOREST_FIRE:
          if ( op.board[ pos ] != null && op.board[ pos ].faction == FOREST )
          {
            if( debug ) println( "     Forest Fire increases attack by " + (( 0.15 + l*0.15 ) * atk));
            atkNow += ( 0.15 + l*0.15 ) * atk;
          }
          break;

        case A_BLITZ:
          if ( op.board[ pos ] != null
            && ( op.board[ pos ].burn > 0
            || op.board[ pos ].poison > 0
            || op.board[ pos ].status[ SHOCKED ]
            || op.board[ pos ].status[ FROZEN ] ) )
          {
            if( debug ) println( "     Blitz increases attack by " + (( 0 + l*0.15 ) * atk));
            atkNow += ( l*0.15 ) * atk;
          }
          break;

        case A_BLOODY_BATTLE:
          if ( op.board[ pos ] != null)
          {
            if( debug ) println( "     Bloody Battle increases attack by " + (hpMax - hpCurr));
            atkNow += max(0,hpMax - hpCurr);
          }
          break;

        case A_BLOODSUCKER:
          bloodsuck = 0.1 * l;
          break;

        case A_CHAIN_ATTACK:
          if ( op.board[ pos ] != null )
          {
            if( debug ) println( "     Chain Attack on primary target " + op.board[ pos ].toStringNoHp() );
            String name = op.board[ pos ].type.name;
            chain = 1 + 0.25*l;
            for ( Card c : op.inPlay )
            {
              String name2 = c.type.name;
              //if ( c.type.name.equals( op.board[ pos ].type.name ) && c != op.board[ pos ] )
              if( name.equals( name2 ) && c != op.board[ pos ] )
              {
                if( debug ) println( "     Chain Attack on additional target " + c.toStringNoHp());
                targets[ targetNum ++ ] = c;
              }
            }
          }
          break;

        case A_CLEAN_SWEEP:
          if ( op.board[ pos ] != null )
          {
            if ( pos > 0 && op.board[ pos - 1 ] != null )
            {
              if( debug ) println( "     Clean sweep adds target " + op.board[ pos - 1 ].toStringNoHp());
              targets[ targetNum ++ ] = op.board[ pos - 1 ];
              cleanSweeped = true;
            }
            if ( pos < 9 && op.board[ pos + 1 ] != null )
            {
              if( debug ) println( "     Clean sweep adds target " + op.board[ pos + 1 ].toStringNoHp());
              targets[ targetNum ++ ] = op.board[ pos + 1 ];
              cleanSweeped = true;
            }
          }
          break;

        case A_CONCENTRATION:
          if ( op.board[ pos ] != null && random(0, 100)<50)
          {
            if( debug ) println( "     Concentration increases attack by " + (( l*0.2 ) * atk));
            atkNow += 0.2 * l * atk;
          }
          break;

        case A_HOT_CHASE:
          if( debug ) println( "     Hot Chase increases attack by " + (( 40 + l*10 ) * op.graveSize()));
          atkNow += ( 40 + 10*l ) * op.graveSize();
          break;

        case A_INFILTRATOR:
          if( debug ) println( "     Infiltrator");
          infiltrator = true;
          break;

        case A_MOUNTAIN_GLACIER:
          if ( op.board[ pos ] != null && op.board[ pos ].faction == MOUNTAIN )
          {
            if( debug ) println( "     Mountain Glacier increases attack by " + (( 0.15 + l*0.15 ) * atk));
            atkNow += ( 0.15 + l*0.15 ) * atk;
          }
          break;

        case A_SWAMP_PURITY:
          if ( op.board[ pos ] != null && op.board[ pos ].faction == SWAMP )
          {
            if( debug ) println( "     Swamp Purity increases attack by " + (( 0.15 + l*0.15 ) * atk));
            atkNow += ( 0.15 + l*0.15 ) * atk;
          }
          break;

        case A_VENDETTA:
          if( debug ) println( "     Vendetta increases attack by " + (( 40 + l*10 ) * own.graveSize()));
          atkNow += ( 40 + 10*l ) * own.graveSize();
          break;

        case A_WARPATH:
          if ( op.board[ pos ] != null && op.board[ pos ].hpCurr > hpCurr )
          {
            if( debug ) println( "     Warpath increases attack by " + (( l*0.15 ) * atk));
            atkNow += ( 0.15*l ) * atk;
          }
          break;
        }
      }
      else if ( when == ON_ATTACKED )
      {
        if (!abilitySilenced[when][i]) 
        switch( a )
        {
        case A_CERBERUS:
          if( debug ) println( "     " + toStringNoHp() + "'s Cerberus reduces damage by 30%");
          dmgMult *= 0.7;
          break;

        case A_COUNTERATTACK:
          if( debug ) println( "     " + toStringNoHp() + " Counterattack for " + (30*l));
          retaliate[ 1 ] += 30 * l;
          break;

        case A_COMBUSTION:
          if( debug ) println( "     " + toStringNoHp() + " Combustion for " + (25*l));
          combustion = l;
          break;

        case A_CRAZE:
          if( debug ) println( "     " + toStringNoHp() + " Craze for " + (10*l));
          craze += 10 * l;
          break;

        case A_DEVILS_ARMOR:
          if( debug ) println( "     " + toStringNoHp() + " Devil's Armor for " + (1500));
          for ( int j = 0; j < 3; ++ j )
            retaliate[ j ] += 1500;
          break;

        case A_DODGE:
          if( attacker.infiltrator )
          {
            if( debug ) println( "       Infiltrator prevents " + toStringNoHp() + "'s dodge");
          }
          else if ( random(0, 100) < 20+5*l )
          {
            if( debug ) println( "       " + toStringNoHp() + " uses Dodge and avoids damage.");
            dmgTaken = 0;
          }
          else if( debug ) println( "       " + toStringNoHp() + "'s Dodge fails");
          break;

        case A_GLACIAL_BARRIER:
          if ( attacker.faction == MOUNTAIN )
          {
            if( debug ) println( "       " + toStringNoHp() + "'s Glacial Berrier decreases attack by " + (1 - ( 0.15 + 0.05 * l )) + "%");
            dmgMult *= 1 - ( 0.15 + 0.05 * l );
          }
          break;

        case A_JUNGLE_BARRIER:
          if ( attacker.faction == SWAMP )
          {
            if( debug ) println( "       " + toStringNoHp() + "'s Jungle Barrier decreases attack by " + (1 - ( 0.15 + 0.05 * l )) + "%");
            dmgMult *= 1 - ( 0.15 + 0.05 * l );
          }
          break;

        case A_MARSH_BARRIER:
          if ( attacker.faction == TUNDRA )
          {
            if( debug ) println( "       " + toStringNoHp() + "'s Marsh Barrier decreases attack by " + (1 - ( 0.15 + 0.05 * l )) + "%");
            dmgMult *= 1 - ( 0.15 + 0.05 * l );
          }
          break;

        case A_SHIELD_OF_EARTH:
          if( debug ) println( "       " + toStringNoHp() + " Shield of Earth stuns attcking card " + attacker.toStringNoHp());
          attacker.attackedSpell (op, own, 0, this, STUNNED, 100);
          break;

        case A_VOLCANO_BARRIER:
          if ( attacker.faction == FOREST )
          {
            if( debug ) println( "       " + toStringNoHp() + "'s Volcano Barrier decreases attack by " + (1 - ( 0.15 + 0.05 * l )) + "%");
            dmgMult *= 1 - ( 0.15 + 0.05 * l );
          }
          break;

        case A_ICE_SHIELD:
          if( attacker.infiltrator )
          {
            if( debug ) println( "       Infiltrator prevents " + toStringNoHp() + "'s ice shield");
          }
          else
          {
            if( debug && dmgMax > 190 - 10 * l) println( "       " + toStringNoHp() + "'s Ice Shield reduces damage to " + (190 - 10 * l));
            else if (debug)  println( "       " + toStringNoHp() + "'s Ice Shield no affect as damage is less than reduced to number");
            dmgMax = min( dmgMax, 190 - 10 * l );
          }
          break;

        case A_PARRY:
          if( debug ) println( "     " + toStringNoHp() + "'s Parry reduces damage by " + (20*l));
          dmgMinus += 20 * l;
          break;

        case A_RETALIATION:
          if( debug ) println( "     " + toStringNoHp() + " Retaliation for " + (20*l));
          for ( int j = 0; j < 3; ++ j )
            retaliate[ j ] += 20 * l;
          break;

        case A_WICKED_LEECH:
          if( debug ) println( "     " + toStringNoHp() + " Wicked Leech for " + (3*l) + "%");
          wickedLeech = 0.03 * l;
          break;
        }
      }
      else if ( when == ON_ENTER )
      {
        switch( a )
        {
        case A_DOUBLE_WINGS:
          boolean failed = false;
          for ( Card c : own.inPlay )
          {
            if (c.summoner == this && c.type.name.equals("Nuriel")) {
              if( debug ) println( "     Gang Up! fails due to a Nuriel already being on the field for this card");
              failed = true;
            }
            if (c.summoner == this && c.type.name.equals("Winged Exile")) {
              if( debug ) println( "     Gang Up! fails due to a Winged Exile already being on the field for this card");
              failed = true;
            }
          }
          if (!failed) 
          {
            if( debug ) println( "     Double Wings summons Nuriel and a Winged Exile");
            for ( int k = 0; k < own.summoned.size(); ++ k )
            {
              Card c = own.summoned.get( k );
              if ( c.summoner == this && c.type.name.equals("Nuriel"))
              {
                c.hpCurr = c.hpBuff = c.hpMax + own.hpBuff[ c.faction ] - c.buffGuardOffset;
                c.atk = c.atkBuff = c.atkMax + own.atkBuff[ c.faction ] - c.buffAttackOffset + c.buffSummonedOffset;
                own.addToPlay( c );
                own.removeFromSummoned( k -- );
                c.checkAbilities(own, op, ON_ENTER, -1);
                if (this.status[ SICK ]) c.status[SICK] = true;
              }
              if ( c.summoner == this && c.type.name.equals("Winged Exile"))
              {
                c.hpCurr = c.hpBuff = c.hpMax + own.hpBuff[ c.faction ] - c.buffGuardOffset;
                c.atk = c.atkBuff = c.atkMax + own.atkBuff[ c.faction ] - c.buffAttackOffset + c.buffSummonedOffset;
                own.addToPlay( c );
                own.removeFromSummoned( k -- );
                c.checkAbilities(own, op, ON_ENTER, -1);
                if (this.status[ SICK ]) c.status[SICK] = true;
              }
            }
          }
         break;
        case A_GUARD:
          if( debug ) println( "     Guard enter play");
          own.guards.add( this );
          break;
        case A_SUMMON_DRAGON:
          failed = false;
          for ( Card c : own.inPlay )
          {
            if (c.summoner == this && c.type.name.equals("Thunder Dragon")) {
              if( debug ) println( "     Summon Dragon fails due to Thunder Dragon already being on the field for this card");
              failed = true;
            }
          }
          if (!failed) 
          {
            if( debug) println( "     Summon Dragon summons Thunder Dragon");
            for ( int k = 0; k < own.summoned.size(); ++ k )
            {
              Card c = own.summoned.get( k );
              if ( c.summoner == this )
              {
                c.hpCurr = c.hpBuff = c.hpMax + own.hpBuff[ c.faction ] - c.buffGuardOffset;
                c.atk = c.atkBuff = c.atkMax + own.atkBuff[ c.faction ] - c.buffAttackOffset + c.buffSummonedOffset;
                own.addToPlay( c );
                own.removeFromSummoned( k -- );
                c.checkAbilities(own, op, ON_ENTER, -1);
                if (this.status[ SICK ]) c.status[SICK] = true;
              }
            }
          }
          break;
        case A_GANG_UP:
          failed = false;
          for ( Card c : own.inPlay )
          {
            if (c.summoner == this && c.type.name.equals("Swamp Rider")) {
              if( debug ) println( "     Gang Up! fails due to a Swamp Rider already being on the field for this card");
              failed = true;
            }
          }
          if (!failed) 
          {
            if( debug ) println( "     Gang Up! summons two Swamp Riders");
            for ( int k = 0; k < own.summoned.size(); ++ k )
            {
              Card c = own.summoned.get( k );
              if ( c.summoner == this && c.type.name.equals("Swamp Rider"))
              {
                c.hpCurr = c.hpBuff = c.hpMax + own.hpBuff[ c.faction ] - c.buffGuardOffset;
                c.atk = c.atkBuff = c.atkMax + own.atkBuff[ c.faction ] - c.buffAttackOffset + c.buffSummonedOffset;
                own.addToPlay( c );
                own.removeFromSummoned( k -- );
                c.checkAbilities(own, op, ON_ENTER, -1);
                if (this.status[ SICK ]) c.status[SICK] = true;
              }
            }
          }
         break;
       case A_QS_BLIZZARD:
          if( debug ) println( "     QS: BLizzard for " + (20*l));
          damageAll( own, op, 20*l, FROZEN, 30 );
          break;

        case A_QS_CURSE:
          if( debug ) println( "     QS: Curse for " + (40*l));
          op.attacked(40*l, op, true);
          break;

        case A_QS_DESTROY:
          if( debug ) println( "     QS: Destroy");
          damageRandom1( own, op, 99999999, DESTROY, 100 );
          break;

        case A_QS_ELECTRIC_SHOCK:
          if( debug ) println( "     QS: Electric Shock for " + (25*l));
          damageAll( own, op, 25*l, SHOCKED, 35 );
          break;

        case A_QS_EXILE:
          if ( op.board[ pos ] != null && !op.board[ pos ].resist && !op.board[ pos ].immune )
          {
            Card c = op.board[ pos ];
            if( c != null )
            {
              if( debug ) println( "     QS: Exile " + c.toStringNoHp() );
              op.removeFromPlay( c );
              op.guards.remove( c );
              op.deck.add( c );
              long seed = System.nanoTime();              
              Collections.shuffle(op.deck, new Random(seed));
              c.checkAbilities( own, op, ON_DEATH, -1 );
            }
          }
          break;

        case A_QS_FIRESTORM:
          if( debug ) println( "     QS: Firestorm for " + (25*l)+"-"+(50*l));
          damageAll( own, op, 25*l, 50*l, FIRE, 0 );
          break;

        case A_QS_FIRE_GOD:
          if( debug ) println( "     QS: Fire God for " + (20*l));
          for ( Card c : op.inPlay )
          {
            if (!c.immune && !c.fireGod[l]) {
              c.burn += 20*l;
              c.fireGod[l] = true;
            }
          }
          break;

        case A_QS_GROUP_WEAKEN:
          if( debug ) println( "     QS: Group Weaken for " + (10*l));
          weakenAll( own, op, 10*l );
          break;

        case A_QS_HEALING:
          Card mostDamaged = null;
          for ( Card c : own.inPlay )
          {
            if ( mostDamaged == null || c.hpBuff - c.hpCurr > mostDamaged.hpBuff - mostDamaged.hpCurr ) mostDamaged = c;
          }
          if ( mostDamaged != null )
          {
            if( mostDamaged.immune )
            {
              if( debug ) println( "     QS: Healing " + mostDamaged.toStringNoHp() + " for " + (25*l) + " failed due to immunity");
            }
            else if( mostDamaged.status[ LACERATED ] )
            {
              if( debug ) println( "     QS: Healing " + mostDamaged.toStringNoHp() + " for " + (25*l) + " failed due to laceration");
            }
            else
            {
              if( debug ) println( "     QS: Healing " + mostDamaged.toStringNoHp() + " for " + (25*l));
              mostDamaged.hpCurr = min( mostDamaged.hpCurr + 25*l, mostDamaged.hpBuff );
            }
          }
          break;

        case  A_QS_MASS_ATTRITION:
          if( debug )
          { 
            for ( Card c : op.hand )
              println( "     QS: Mass Attrition increased time of " + c.toStringNoHp() + " by " + l);
          }
          for ( Card c : op.hand )
            c.time += l;
          break;

        case A_QS_PLAGUE:
          if( debug ) println( "     QS: Plague for " + (5*l));
          weakenAll( own, op, 5*l );
          damageAll( own, op, 5*l, NO_REFLECT, 0 );
          break;

        case A_QS_PRAYER:
          if( debug ) println( "     QS: Prayer for " + (40*l));
          own.hp = min( own.hpmax, own.hp + 40*l );
          break;

        case A_QS_PURIFICATION:
          if( debug ) println( "     QS: Purification");
          for ( Card c : own.inPlay ) {
            c.burn = 0;
            for (int j = 0; j <= 9; ++ j) {
              c.fireGod[j] = false;
              c.combust[j] = false;
            }
            c.poison = 0;
            if (c.status[CORRUPT]) {
              own.cardCount[ PLAY ][ c.faction ] -= 1;
              c.faction = c.type.faction;
              own.cardCount[ PLAY ][ c.faction ] += 1;
            }
            for ( int j = 0; j <= 8; ++ j ) {
              if (j != SILENCED) c.status[ j ] = false;
            }
          }
          break;

        case A_QS_REGENERATION:
          if( debug ) println( "     QS: Regeneration for " + (25*l));
          damageAll( own, own, 25*l, HEAL, 0 );
          break;

        case A_QS_REINCARNATION:
          for ( int j = 0; j < l && !own.grave.isEmpty(); ++ j )
          {
            Card c = own.removeFromGrave( (int)random( own.graveSize() ) );
            own.deck.add( c );
            if( debug ) println( "     QS: Reincarnation targeting " + c.toStringNoHp());
          }
          break;

        case A_QS_TOXIC_CLOUDS:
          if( debug ) println( "     QS: Toxic Clouds for " + (20*l));
          damageAll( own, op, 20*l, POISONED, 20*l );
          break;

        case A_QS_TRAP:
          if( debug ) println( "     QS: Trap " + l);
          if ( l == 1 )
            damageRandom1( own, op, 0, TRAPPED, 65 );
          else if ( l == 2 )
            damageRandom2( own, op, 0, TRAPPED, 65 );
          else if ( l == 3 )
            damageRandom3( own, op, 0, TRAPPED, 65 );
          break;

        case A_BACKSTAB:
          if( debug ) println( "     Backstab for " + (40*l));
          backstab = 40*l;
          break;

        case A_QS_TELEPORT:
          Card longest = null;
          int longIndex = 0;
          for ( int j = 0; j < op.handSize(); ++ j )
          {
            Card c = op.hand.get( j );
            if ( longest == null || c.time > longest.time ) longest = c;
          }
          if ( longest != null && !(longest.resist || longest.immune))
          {
            if( debug ) println( "     QS: Teleport targetting " + longest.toStringNoHp() );
            op.removeFromHand( longest );
            op.addToGrave( longest );
          }
          else if (longest == null && debug ) println( "     QS: Teleport no targets");     
          else if (debug ) println( "     QS: Teleport targetting " + longest.toStringNoHp() + " fails due to target having resistance/immunity");     
          break;

        case A_OBSTINACY:
          if( debug ) println( "     Obstinacy for " + (50*l));
          own.hp = min( own.hpmax, own.hp - 50*l );
          own.checkDead();
          break;

        case A_SACRIFICE:
          if ( !own.inPlay.isEmpty() )
          {
            int index = ( ( ( int )random( 0, own.playSize() - 1 ) + pos + 1 ) % ( own.playSize() ) );
            int j = 1;
            Card c = own.inPlay.get( index );
            while( c.dead && j < own.playSize() - 1 )
            {
              int index2 = ( ( index + j++ ) % ( own.playSize() ) );
              c = own.inPlay.get( index2 );
            }
            
            if ( !c.immune && c != this && !c.dead )
            {
              if( debug ) println( "     Sacrifice targetting " + c.toStringNoHp() );
              this.atk = (int)(( 1 + 0.20+0.10*l )*this.atkMax + (this.atk-this.atkMax));
              this.atkBuff = (int)(( 1 + 0.20+0.10*l )*this.atkMax + (this.atkBuff-this.atkMax));
              this.hpCurr = (int)(( 1 + 0.20+0.10*l )*this.hpMax + (this.hpCurr-this.hpMax));
              this.hpBuff = (int)(( 1 + 0.20+0.10*l )*this.hpMax + (this.hpBuff-this.hpMax));
              //own.removeFromPlay( c );
              //own.addToGrave( c );
              c.hpCurr = -1000;
              c.dead = true;
              c.died(own, op,true);
            }
            else if( debug && c.immune) println( "     Sacrifice failed targetting immune card " + c.toStringNoHp() );
          }
          break;

        case A_TUNDRA_ATK:
          if( debug ) println( "     Tundra attack gain by " + (25*l));
          applyBuffAtk( own, TUNDRA, 25*l );
          break;

        case A_TUNDRA_HP:
          if( debug ) println( "     Tundra health gain by " + (50*l));
          applyBuffHp( own, TUNDRA, 50*l );
          break;

        case A_MOUNTAIN_ATK:
          if( debug ) println( "     Mountain attack again by " + (25*l));
          applyBuffAtk( own, MOUNTAIN, 25*l );
          break;

        case A_MOUNTAIN_HP:
          if( debug ) println( "     Mountain health gain by " + (50*l));
          applyBuffHp( own, MOUNTAIN, 50*l );
          break;

        case A_SWAMP_ATK:
          if( debug ) println( "     Swamp attack gain by " + (25*l));
          applyBuffAtk( own, SWAMP, 25*l );
          break;

        case A_SWAMP_HP:
          if( debug ) println( "     Swamp health gain by " + (50*l));
          applyBuffHp( own, SWAMP, 50*l );
          break;

        case A_FOREST_ATK:
          if( debug ) println( "     Forest attack gain by " + (25*l));
          applyBuffAtk( own, FOREST, 25*l );
          break;

        case A_FOREST_HP:
          if( debug ) println( "     Forest health gain by " + (50*l));
          applyBuffHp( own, FOREST, 50*l );
          break;

        case A_ORIGINS_GUARD:
          if( debug ) println( "     Origins guard gain by " + (40*l));
          for ( int j = 0; j < 4; ++ j )
            applyBuffHp( own, j, 40*l );
          break;

        case A_POWER_SOURCE:
          if( debug ) println( "     Power source gain by " + (20*l));
          for ( int j = 0; j < 4; ++ j )
            applyBuffAtk( own, j, 20*l );
          break;

        case A_DIVINE_PROTECTION:
          if( debug ) println( "     Divine Protection on self gain by " + (50*l));
          divineProVal = 50*l;
          if ( pos > 0 && !own.board[ pos - 1 ].dead )
          {
            divineProtect[ 0 ] = own.board[ pos - 1 ];
            divineProtect[ 0 ].hpBuff += divineProVal;
            if( divineProtect[ 0 ].hpCurr < divineProtect[ 0 ].hpBuff)
              divineProtect[ 0 ].hpCurr = min(divineProtect[0].hpBuff, divineProtect[0].hpCurr + divineProVal);
          if( debug) println( "     Divine Protection on " + divineProtect[ 0 ].toStringNoHp() + " gain by " + (50*l));
          }
          else
            divineProtect[ 0 ] = null;
            
          divineProtect[ 1 ] = this;
          divineProtect[ 1 ].hpCurr += divineProVal;
          divineProtect[ 1 ].hpBuff += divineProVal;
          break;
        }
      }
      else if ( when == ON_DEATH )
      {
        switch( a )
        {
        case A_DONS_BODYGUARD:
          if ( dead && !abilitySilenced[when][i]) 
          {
            boolean failed = false;
            for ( Card c : own.inPlay )
            {
              if (c.summoner == this && c.type.name.equals("Behemoth")) {
                if( debug ) println( "     The Don's Bodyguard fails due to a Behemoth already being on the field for this card");
                failed = true;
              }
            }
            if (!failed) 
            {
              if( debug ) println( "     The Don's Bodyguard summons a Behemoth");
              for ( int k = 0; k < own.summoned.size(); ++ k )
              {
                Card c = own.summoned.get( k );
                if ( c.summoner == this && c.type.name.equals("Behemoth"))
                {
                  c.hpCurr = c.hpBuff = c.hpMax + own.hpBuff[ c.faction ] - c.buffGuardOffset;
                  c.atk = c.atkBuff = c.atkMax + own.atkBuff[ c.faction ] - c.buffAttackOffset + c.buffSummonedOffset;
                  own.addToPlay( c );
                  own.removeFromSummoned( k-- );
                  c.checkAbilities(own, op, ON_ENTER, -1);
                  if (this.status[ SICK ]) c.status[SICK] = true;
                }
              }
            }
          }
          break;
        case A_GUARD:
          if( debug ) println( "     Guard leave play");
          own.guards.remove( this );
          break;

        case A_LAST_CHANCE:
          if ( dead  && !abilitySilenced[when][i] && effect != DESTROY && last_chance == 0)
          {
            if( debug ) println( "     " + toStringNoHp() + " gets a Last Chance. HP set to 1");
            hpCurr = 1;
            last_chance++;
            dead = false;
            this.status[LAST_CHANCE] = true;
          }
          break;


        case A_RESURRECTION:
          if ( dead && summoned == false && reanimated == false && !abilitySilenced[when][i])
          {
            if( random( 0, 100 ) <= 30+l*5 )
            {
              if( debug ) println( "       " + toStringNoHp() + " Resurrection successful");
              own.addToHand(this);
              reanimated = true;
            }
            else if( debug ) println( "       " + toStringNoHp() + " Resurrection chance failed.");
          }
          break;

        case A_D_BLIZZARD:
          if ( dead  && !abilitySilenced[when][i])
          {
          if( debug ) println( "     D: Blizzard for " + (20*l));
            damageAll( own, op, 20*l, FROZEN, 30 );
          }
          break;

        case A_D_CURSE:
          if ( dead  && !abilitySilenced[when][i])
          {
          if( debug ) println( "     D: Curse for " + (40*l));;
            op.attacked(40*l, op, true);
          }
          break;

        case A_D_ANNIHILATION:
        case A_D_DESTROY:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Destroy");
            damageRandom1( own, op, 99999999, DESTROY, 100 );
          }
          break;

        case A_D_ELECTRIC_SHOCK:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Electric Shock for " + (25*l));
            damageAll( own, op, 25*l, SHOCKED, 35 );
          }
          break;

        case A_D_FIRESTORM:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Firestorm for " + (25*l)+"-"+(50*l));
            damageAll( own, op, 25*l, 50*l, FIRE, 0 );
          }
          break;

        case A_D_FIRE_GOD:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Fire God for " + (20*l));
            for ( Card c : op.inPlay )
            {
              if (!c.immune && !c.fireGod[l]) {
                c.burn += 20*l;
                c.fireGod[l] = true;
              }
            }
          }
          break;

        case A_D_GROUP_WEAKEN:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Group Weaken for " + (10*l));
            weakenAll( own, op, 10*l );
          }
          break;

        case A_D_HEALING:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Healing for " + (25*l));
            Card mostDamaged = null;
            for ( Card c : own.inPlay )
            {
              if ( (mostDamaged == null || c.hpBuff - c.hpCurr > mostDamaged.hpBuff - mostDamaged.hpCurr) && c != this ) mostDamaged = c;
            }
            if ( mostDamaged != null )
            {
              if( mostDamaged.immune )
              {
                if( debug ) println( "     D: Healing " + mostDamaged.toStringNoHp() + " for " + (25*l) + " failed due to immunity");
              }
              else if( mostDamaged.status[ LACERATED ] )
              {
                if( debug ) println( "     D: Healing " + mostDamaged.toStringNoHp() + " for " + (25*l) + " failed due to laceration");
              }
              else
              {
                if( debug ) println( "     D: Healing " + mostDamaged.toStringNoHp() + " for " + (25*l));
                mostDamaged.hpCurr = min( mostDamaged.hpCurr + 25*l, mostDamaged.hpBuff );
              }
            }
          }
          break;

        case A_D_PLAGUE:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Plague for " + (5*l));
            weakenAll( own, op, 5*l );
            damageAll( own, op, 5*l, NO_REFLECT, 0 );
          }
          break;

        case A_D_PRAYER:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Prayer for " + (40*l));
            own.hp = min( own.hpmax, own.hp + 40*l );
          }
          break;

        case A_D_REANIMATION:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( own.graveReanim.size() > 0 )
            {
              Card toReanim = own.graveReanim.get( ( int )random( 0, own.graveReanim.size() ) );
              if( debug ) println( "     D: Reanimation targetting " + toReanim.toStringNoHp());
              own.removeFromGrave( toReanim );
              own.addToPlay( toReanim );
              toReanim.status[ SICK ] = true;
              toReanim.checkAbilities( own, op, ON_ENTER, -1 );
            }
            else if( debug ) println( "     D: Reanimation targetting nothing");
          }
          break;

        case A_D_REGENERATION:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Regeneration for " + (25*l));
            damageAll( own, own, 25*l, HEAL, 0 );
          }
          break;

        case A_D_REINCARNATION:
          if ( dead  && !abilitySilenced[when][i])
          {
            for ( int j = 0; j < l && !own.grave.isEmpty(); ++ j )
            {
              Card c = own.removeFromGrave( (int)random( own.graveSize() ) );
              own.deck.add( c );
              if( debug ) println( "     D: Reincarnation targetting " + c.toStringNoHp());
            }
          }
          break;

        case A_D_TOXIC_CLOUDS:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Toxic Clouds for " + (20*l));
            damageAll( own, op, 20*l, POISONED, 20*l );
          }
          break;

        case A_D_TRAP:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     D: Trap");
            if ( l == 1 )
              damageRandom1( own, op, 0, TRAPPED, 65 );
            else if ( l == 2 )
              damageRandom2( own, op, 0, TRAPPED, 65 );
            else if ( l == 3 )
              damageRandom3( own, op, 0, TRAPPED, 65 );
          }
          break;

        case A_TUNDRA_ATK:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Tundra attack loss of " + (25*l));
            
            applyBuffAtk( own, TUNDRA, -25*l - buffAttackOffset );
          }
          else if (abilitySilenced[when][i]) buffAttackOffset += 25*l;
          break;

        case A_TUNDRA_HP:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Tundra health loss of " + (50*l));
            applyBuffHp( own, TUNDRA, -50*l - buffGuardOffset);
          }    
          else if (abilitySilenced[when][i]) buffGuardOffset += 50*l;
          break;

        case A_MOUNTAIN_ATK:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Mountain attack loss of " + (25*l));
            applyBuffAtk( own, MOUNTAIN, -25*l - buffAttackOffset );
          }
          else if (abilitySilenced[when][i]) buffAttackOffset += 25*l;
          break;

        case A_MOUNTAIN_HP:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Mountain health loss of " + (50*l));
            applyBuffHp( own, MOUNTAIN, -50*l - buffGuardOffset);
          }
          else if (abilitySilenced[when][i]) buffGuardOffset += 50*l;
          break;

        case A_SWAMP_ATK:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Swamp attack loss of " + (25*l));
            applyBuffAtk( own, SWAMP, -25*l - buffAttackOffset);
          }
          else if (abilitySilenced[when][i]) buffAttackOffset += 25*l;
          break;

        case A_SWAMP_HP:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Swamp health loss of " + (50*l));
            applyBuffHp( own, SWAMP, -50*l - buffGuardOffset);
          }
          else if (abilitySilenced[when][i]) buffGuardOffset += 50*l;
          break;

        case A_FOREST_ATK:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Forest attack loss of " + (25*l));
            applyBuffAtk( own, FOREST, -25*l - buffAttackOffset);
          }
          else if (abilitySilenced[when][i]) buffAttackOffset += 25*l;
          break;

        case A_FOREST_HP:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Forest health loss of " + (50*l));
            applyBuffHp( own, FOREST, -50*l - buffGuardOffset);
          }
          else if (abilitySilenced[when][i]) buffGuardOffset += 50*l;
          break;

        case A_ORIGINS_GUARD:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Origins Guard loss of " + (40*l));
            for ( int j = 0; j < 4; ++ j )
              applyBuffHp( own, j, -40*l - buffGuardOffset);
          }
          else if (abilitySilenced[when][i]) buffGuardOffset += 40*l;
          break;

        case A_POWER_SOURCE:
          if (!abilitySilenced[when][i]) {
            if( debug ) println( "     Power Source loss of " + (20*l));
            for ( int j = 0; j < 4; ++ j )
              applyBuffAtk( own, j, -20*l - buffAttackOffset);
          }
          else if (abilitySilenced[when][i]) buffAttackOffset += 20*l;
          break;

        case A_SELF_DESTRUCT:
          if ( dead  && !abilitySilenced[when][i])
          {
            if( debug ) println( "     Self-Destruct for " + (40*l));
            for ( int j = max( 0, pos - 1); j <= min( op.board.length - 1, pos + 1 ); ++ j )
              if ( op.board[ j ] != null ) op.board[ j ].attackedSpell( op, own, 40*l, this, FIRE, 0 );
          }
          break;

        case A_DIVINE_PROTECTION:
          if (!abilitySilenced[when][i]) 
            for ( int j = 0; j <= 2; ++ j )
            {
              if ( divineProtect[ j ] != null )
              {
              if( debug ) println( "     Divine Protection loss on " + divineProtect[ j ].toStringNoHp());
                divineProtect[ j ].hpBuff -= divineProVal;
                divineProtect[ j ].hpCurr = min( divineProtect[ j ].hpCurr, divineProtect[ j ].hpBuff );
              }
            }
          break;
        }
      }
      else if ( when == ON_ATTACKED_SPELL )
      {
        if (!abilitySilenced[when][i]) 
        switch( a )
        {
        case A_IMMUNITY:
          if( debug ) println( "     Immunity");
          dmgTaken = 0;
          break;

        case A_MAGIC_SHIELD:
          int d = dmgTaken;
          if(effect != MANA_CORRUPTION && effect != NO_REFLECT) { // magic shield disabled if corruption damage
            dmgTaken = min( dmgTaken, 160 - 10*l );
            if( debug && d > dmgTaken ) println( "       " + toStringNoHp() + "'s Magic Shield reduces to maximum of " + (160 - 10*l));
          }
          break;

        case A_REFLECTION:
          if (effect != NO_REFLECT && effect != TRAPPED) {
            if( debug ) println( "     " + toStringNoHp() + "'s Reflection");
            dmgTaken = 30*l;
            reflective = true;
          }
          break;
        }
      }
    }
  }

  void applyBuffHp( Player own, int faction, int amount )
  {
    own.hpBuff[ faction ] += amount;
    for ( Card c : own.inPlay )
    {
      if ( c == this || c.faction != faction ) continue;
      c.hpBuff += amount;
      if ( amount > 0 )
        c.hpCurr += amount;
      else if( c.hpCurr > c.hpBuff )
        c.hpCurr = max( c.hpCurr+amount, c.hpBuff );
    }
  }

  void applyBuffAtk( Player own, int faction, int amount )
  {
    own.atkBuff[ faction ] += amount;
    for ( Card c : own.inPlay )
    {
      if ( c == this || c.faction != faction ) continue;
      c.atkBuff += amount;
      if ( amount > 0 )
        c.atk += amount;
      else if( c.atk > c.atkBuff )
      {
        
        int used = min(-amount, c.totalGlitchCount);
        c.totalGlitchCount = max(0, c.totalGlitchCount - used );
        c.atk = max( c.atk-max(-amount - used, 0), c.atkBuff );
        c.atkBuff = c.atk;
      }
    }
  }

  void weakenAll( Player own, Player target, int amount )
  {
    if (target.playSize() == 0 && debug ) println("       No Targets");
    for ( Card c : target.inPlay )
    {
      if ( !c.immune ) {
        c.atk = max( 0, c.atk - amount );
        if (debug) println("       " + c.toStringNoHp() + " looses " + amount + " attack due to weaken");
      }
      else if (debug) println("       Immunity prevented weaken on " + c);
      
    }
  }

  int damageAll( Player own, Player target, int dmg, int effect, int chance )
  {
    int ret = 0;

    if (target.playSize() == 0 && debug) println("       No Targets");
    for ( int i = 0; i < 40; ++ i )
    {
      Card c = target.board[ i ];
      if ( c != null && !c.dead )
        ret += c.attackedSpell( target, own, dmg, this, effect, chance );
      if( dead && effect == BLOOD) return ret; //Cards continue their spell attack even if died except for feast of blood
    }
    return ret;
  }

  int damageAll( Player own, Player target, int dmgMin, int dmgMax, int effect, int chance )
  {
    int ret = 0;
    if (target.playSize() == 0 && debug) println("       No Targets");
    for ( int i = 0; i < 40; ++ i )
    {
      Card c = target.board[ i ];
      int dmg = (int)random( dmgMin, dmgMax );
      if ( c != null && !c.dead )
        ret += c.attackedSpell( target, own, dmg, this, effect, chance );
      if( dead && effect == BLOOD) return ret; //Cards continue their spell attack even if died except for feast of blood
    }
    return ret;
  }

  void damageRandom3( Player own, Player target, int dmg, int effect, int chance )
  {
    int list[] = { 
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
    };
    if (target.playSize() == 0 && debug) println("       No Targets");
    
    ArrayList< Card > targets = new ArrayList< Card >();
    for ( int i = 0; i < min( 3, target.playSize() ); ++ i )
    {
      int index = (int)random(0, target.playSize() - i ); //list[(int)random(0, target.playSize() - i - 1)];
      targets.add( target.inPlay.get( list[index] ) );
      
      list[index] = list[target.playSize()-i -1 ];
    }
    for ( Card c : targets )
    {
      c.attackedSpell( target, own, dmg, this, effect, chance );
      //if( dead ) return;  Cards continue their spell attack even if died
    }
  }

  void damageRandom4( Player own, Player target, int dmg, int effect, int chance )
  {
    int list[] = { 
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
    };
    if (target.playSize() == 0 && debug) println("       No Targets");
    
    ArrayList< Card > targets = new ArrayList< Card >();
    for ( int i = 0; i < min( 4, target.playSize() ); ++ i )
    {
      int index = (int)random(0, target.playSize() - i ); //list[(int)random(0, target.playSize() - i - 1)];
      targets.add( target.inPlay.get( list[index] ) );
      
      list[index] = list[target.playSize()-i -1 ];
    }
    for ( Card c : targets )
    {
      c.attackedSpell( target, own, dmg, this, effect, chance );
      //if( dead ) return;  Cards continue their spell attack even if died
    }
  }

  void damageRandom5( Player own, Player target, int dmg, int effect, int chance )
  {
    int list[] = { 
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
    };
    if (target.playSize() == 0 && debug) println("       No Targets");
    
    ArrayList< Card > targets = new ArrayList< Card >();
    for ( int i = 0; i < min( 5, target.playSize() ); ++ i )
    {
      int index = (int)random(0, target.playSize() - i ); //list[(int)random(0, target.playSize() - i - 1)];
      targets.add( target.inPlay.get( list[index] ) );
      
      list[index] = list[target.playSize()-i -1 ];
    }
    for ( Card c : targets )
    {
      c.attackedSpell( target, own, dmg, this, effect, chance );
      //if( dead ) return;  Cards continue their spell attack even if died
    }
  }

  void damageRandom3( Player own, Player target, int dmgMin, int dmgMax, int effect, int chance )
  {
    int list[] = { 
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
    };
    if (target.playSize() == 0 && debug) println("       No Targets");
    ArrayList< Card > targets = new ArrayList< Card >();
    for ( int i = 0; i < min( 3, target.playSize() ); ++ i )
    {
      int index = (int)random(0, target.playSize() - i ); //list[(int)random(0, target.playSize() - i - 1)];
      targets.add( target.inPlay.get( list[index] ) );
      
      list[index] = list[target.playSize()-i -1 ];
    }
    for ( Card c : targets )
    {
      int dmg = (int)random( dmgMin, dmgMax );
      c.attackedSpell( target, own, dmg, this, effect, chance );
      //if( dead ) return;  Cards continue their spell attack even if died
    }
  }

  void damageRandom2( Player own, Player target, int dmgMin, int dmgMax, int effect, int chance )
  {
    if (target.playSize() == 0 && debug) println("       No Targets");
    if ( !target.inPlay.isEmpty() )
    {
      int dmg = (int)random( dmgMin, dmgMax );
      int index = (int)random( target.playSize() );
      target.inPlay.get( index ).attackedSpell( target, own, dmg, this, effect, chance );
      if ( target.playSize() > 1 /*&& !dead */)
      {
        dmg = (int)random( dmgMin, dmgMax );
        //index = ( index + (int)random( target.playSize() - 1 ) ) % target.playSize();
        int index2 =  (int)random( target.playSize() - 1 ) ;
        if (index2 == index) index2 = target.playSize() - 1;
        target.inPlay.get( index2 ).attackedSpell( target, own, dmg, this, effect, chance );
      }
    }
  }

  void damageRandom2( Player own, Player target, int dmg, int effect, int chance )
  {    
    if (target.playSize() == 0 && debug) println("       No Targets");
    if ( !target.inPlay.isEmpty() )
    {
      int index = (int)random( target.playSize() );
      target.inPlay.get( index ).attackedSpell( target, own, dmg, this, effect, chance );
      if ( target.playSize() > 1 /*&& !dead*/ )
      {
        //index = ( index + (int)random( target.playSize() - 1 ) ) % target.playSize();
        int index2 =  (int)random( target.playSize() - 1 ) ;
        if (index2 == index) index2 = target.playSize() - 1;
        target.inPlay.get( index2 ).attackedSpell( target, own, dmg, this, effect, chance );
      }
    }
  }

  int damageRandom1( Player own, Player target, int dmgMin, int dmgMax, int effect, int chance )
  {
    int dmg = (int)random( dmgMin, dmgMax );
    if (target.playSize() == 0 && debug) println("       No Targets");
    if ( !target.inPlay.isEmpty() )
      return target.inPlay.get( (int)random( target.playSize() ) ).attackedSpell( target, own, dmg, this, effect, chance );
    return 0;
  }

  int damageRandom1( Player own, Player target, int dmg, int effect, int chance )
  {
    if (target.playSize() == 0 && debug) println("       No Targets");
    if ( !target.inPlay.isEmpty() )
      return target.inPlay.get( (int)random( target.playSize() ) ).attackedSpell( target, own, dmg, this, effect, chance );
    return 0;
  }

  int damageLowest1( Player own, Player target, int dmg, int effect, int chance )
  {
    if (target.playSize() == 0 && debug) println("       No Targets");
    Card lowest = null;
    for ( int i = 0; i < target.playSize(); ++ i )
    {
      if ( lowest == null || target.inPlay.get(i).hpCurr <= lowest.hpCurr ) lowest = target.inPlay.get(i);
    }
    if ( lowest != null )
      return lowest.attackedSpell( target, own, dmg, this, effect, chance );
    return 0;
  }

  int damageLowest2( Player own, Player target, int dmg, int effect, int chance )
  {
    if (target.playSize() == 0 && debug) println("       No Targets");
    Card lowest1 = null;
    Card lowest2 = null;
    int dmgDone = 0;
    for ( int i = 0; i < target.playSize(); ++ i )
    {
      if ( lowest1 == null || target.inPlay.get(i).hpCurr < lowest1.hpCurr) 
      {
        lowest2 = lowest1;
        lowest1 = target.inPlay.get(i);
      }
      else if (lowest2 == null || target.inPlay.get(i).hpCurr < lowest2.hpCurr)
        lowest2 = target.inPlay.get(i);       
    }
    if ( lowest1 != null )
      dmgDone = lowest1.attackedSpell( target, own, dmg, this, effect, chance );
    if ( lowest2 != null )
      dmgDone += lowest2.attackedSpell( target, own, dmg, this, effect, chance );
    return dmgDone;
  }
  
  String toStringNoHp()
  {
    if ( evo != AType.A_NONE )
      return type.name + "-" + evoNames.get( abilityName.get( evo ) ) + evoLevel + " (" + lvl + ")";// + "[t"+time+"]" + abilityL[0];
    return type.name + " (" + lvl + ")";// + "["+atk+", "+hp+"]" + abilityL[0];
  }

  String toString()
  {
    if ( isRun && debug )
    {
      if( evo == AType.A_NONE )
        return type.name + " (" + lvl + ") " + "[Attack: "+atk+" / " + atkMax +", Health: "+ hpCurr+" / " + hpMax + "]";
      else return type.name + "-" + evoNames.get( abilityName.get( evo ) ) + evoLevel + " (" + lvl + ") " + "[Attack: "+atk+" / " + atkMax +", Health: "+ hpCurr+" / " + hpMax + "]";
    }
    if ( evo != AType.A_NONE )
      return type.name + ";" + lvl + ((wash > 0) ? (";" + wash):"") + ";" + evoNames.get( abilityName.get( evo ) ) + evoLevel;// + "[t"+time+"]" + abilityL[0];
    return type.name + ";" + lvl + ((wash > 0) ? (";" + wash):"");// + "["+atk+", "+hp+"]" + abilityL[0];
  }
}

Card old_cardFromString( String s )
{
  // Get level
  int level = -1;
  if( s.length() < 1 ) return null;
  if ( s.charAt( s.length() - 1 ) == ')' )
  {
    if ( s.charAt( s.length() - 3 ) == '(' )
    {
      level = s.charAt( s.length() - 2 ) - '0';
      s = s.substring( 0, s.length() - 4 );
    }
    else if ( s.charAt( s.length() - 4 ) == '(' )
    {
      level = 10 + s.charAt( s.length() - 2 ) - '0';
      s = s.substring( 0, s.length() - 5 );
    }
  }
  // If it failed to find the level, try without brackets. Search for any numbers at all.
  if( level == -1 )
  {
   level = 10;
    String news = s.toLowerCase();
    news = news.substring(max(0,news.lastIndexOf(' ')),news.length());
    for( char ch = 0; ch <= 255; ++ ch )
    {
      if( ch < '0' || ch > '9' )
        news = news.replace( ""+ch, "" );
    }
    try{ 
      //println("bob" + news);
      level = Integer.parseInt(news); 
    } catch( Exception e ) {}
    s = s.replace( level + "", "" );
  }
  s = s.trim();
  
  // Get evolution
  String e = "";
  AType evo = AType.A_NONE;
  int evoL = 0;
  
  int evoStart = s.lastIndexOf('-');
  int evoEnd = s.length();//s.lastIndexOf(' ');
  if( evoEnd == -1 ) evoEnd = s.length();
  if( evoStart > -1 && evoStart < evoEnd ) e = s.substring( evoStart, evoEnd ); 
  if( e.length() > 0 )
  {
    if( e.charAt( e.length() - 1 ) == '0' )
    {
      e = e.substring( 1, e.length() - 2 );
      evoL = 10;
    }
    else
    {
      char last = e.charAt( e.length() - 1 );
      if( last >= '0' && last <= '9' )
      {
      e = e.substring( 1, e.length() - 1 );
      evoL = s.charAt( s.length() - 1 ) - '0';
      }
      else
      {
        e = e.substring( 1, e.length() );
        evoL = 1;
      }
    }
    String evoName = evoNamesR.get( e );
    if( evoName == null )
    {
      evo = AType.A_NONE;
    }
    else
    {
      evo = abilities.get( evoName );
      if( evo == null ) 
      {
        evo = AType.A_NONE;
      }
      else
      {
        s = s.substring(0, evoStart);
      }
    }
  }
  if( evoL <= 0 ) evo = AType.A_NONE;
  
  // Create card
  if ( cardsMap.containsKey( s ) )
    return new Card( cardsMap.get( s ), level, evo, evoL, -1 );
    
  // If card not found, search for any card with its first n initials equal to the string where n is string length.
  String initials;
  char ch;
  for( String cardName : cardsMap.keySet() )
  {
    // Get initials of card
    initials = "";
    for( int i = 0; i < cardName.length(); ++ i )
    {
      ch = cardName.charAt ( i );
      if( Character.isUpperCase( ch ) || (i > 0 && cardName.charAt ( i - 1 ) == ' ' ) || i == 0 ) initials = initials + ch;
    }
    if( initials.substring( 0, min( s.length(), initials.length() ) ).toLowerCase().equals( s.toLowerCase() ) )
      return new Card( cardsMap.get( cardName ), level, evo, evoL, -1 );
  }
  return null;
}


Card cardFromString( String s )
{
  
  AType evo = AType.A_NONE;
  int evoL = 1;
  int cost = -1;
  int level = 10;
  int wash = 0;
  Boolean found = false;
  String st[] = s.split(";");
  String e = "";
    
  String enteredName = st[0];
  if (st.length > 1) {
    if (st.length == 4) {
      if (!st[1].matches("\\d+$") || !st[2].matches("\\d+$")) return null;
      else {
        level = Integer.parseInt(st[1]);
        wash = Integer.parseInt(st[2]);
        e = st[3];
      }
    }
    else if (st.length == 2)
    {
      if (st[1].matches("\\d+$")) {
        level = Integer.parseInt(st[1]);
        wash = 0;
      }
      else {
        level = 10;
        wash = 0;
        e = st[1];
      }
    }
    else if (st.length == 3)
    {
      if (!st[1].matches("\\d+$")) return null;
      else if(st[2].matches("\\d+$")) {
        level = Integer.parseInt(st[1]);
        wash = Integer.parseInt(st[2]);
      }
      else {
        level = 10;
        e = st[2];
        if (Integer.parseInt(st[1]) > 3) level = Integer.parseInt(st[1]);
        else wash = Integer.parseInt(st[1]); 
      }
    }
    else return null;
  }    
  if (!cardsMap.containsKey(enteredName)) 
  {
    String initals[] = enteredName.split(" ");
    for( String cardName : cardsMap.keySet() )
    {
      found = true;
      String cardParts[] = cardName.split(" ");
      if (cardParts.length != initals.length) found = false;
      for (int i=0; i<initals.length && found; i++) {
        if (initals[i].length() <= cardParts[i].length() && initals[i].length() > 0) {
          if (!initals[i].toLowerCase().equals(cardParts[i].toLowerCase().substring(0,initals[i].length()))) found = false;
        }
        else found = false;
      }
      if (found) {enteredName = cardName; break;}
    }
  }
  else found = true;
  if( e.length() > 0 )
  {
    if( e.charAt( e.length() - 1 ) == '0' )
    {
      e = e.substring( 0, e.length() - 2 );
      evoL = 10;
    }
    else
    {
      char last = e.charAt( e.length() - 1 );
      if( last >= '0' && last <= '9' )
      {
        evoL = last - '0';
        e = e.substring( 0, e.length() - 1 );
       }
      else
      {
        e = e.substring( 0, e.length() );
        evoL = 1;
      }
    }
    String evoName = evoNamesR.get( e );
    if( evoName == null )
    {
      evo = AType.A_NONE;
    }
    else
    {
      evo = abilities.get( evoName );
      if( evo == null ) 
      {
        evo = AType.A_NONE;
      }
    }
  }
  if( evoL <= 0 ) evo = AType.A_NONE;
  if (found) return new Card(cardsMap.get(enteredName),level,evo,evoL,wash);
  else return null;
}