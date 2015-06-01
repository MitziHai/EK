
import java.util.*;

static final int HAND = 0;
static final int GRAVE = 1;
static final int PLAY = 2;

class Player
{
  boolean isP1 = false;
  String name = "";
  int merit;
  int hpmax;
  int hp;
  int initative;
  boolean dead = false;
  ArrayList< Card > hand = new ArrayList< Card >();
  ArrayList< Card > deck = new ArrayList< Card >();
  ArrayList< Card > inPlay = new ArrayList< Card >(); // Collection of cards in play which does not maintain empty slots until end of turn. Used to pick random targets.
  ArrayList< Card > grave = new ArrayList< Card >();
  ArrayList< Card > graveReanim = new ArrayList< Card >();
  ArrayList< Card > guards = new ArrayList< Card >();

  boolean invul = false;
  int numRunes = 0;
  Rune runes[] = new Rune[ 4 ];

  Card board[] = new Card[15]; // Maintains position until end of turn. Implemented for exile.
  int hpBuff[] = new int[ 6 ];
  int atkBuff[] = new int[ 6 ];
  
  int cardCount[][] = new int[3][6]; // [ HAND/GRAVE/PLAY ][ SWAMP/FOREST/ETC ]

  Player(int h) {
    hp=hpmax=h;
    checkDead();
    invul = (h == 0);
  }

  Player( Player p, boolean isPlayer )
  {
    name = p.name;
    initative = p.hp;
    if (p.hp == 0) initative += 999999;
    for ( Card c : p.deck )
    {
      if( c == null ) break;
      Card c2 = new Card( c.type, c.lvl, c.evo, c.evoLevel,c.cost );
      if (ListHydraCard1 != null && ListHydraCard1.listItems.get(ListHydraCard1.currentIndex) == c2.type.name && radhydra.checked && isPlayer) {c2.hpMax = (int)(c2.hpMax*1.5); c2.atkMax = (int)(c2.atkMax*1.5);}
      if (ListHydraCard2 != null && ListHydraCard2.listItems.get(ListHydraCard2.currentIndex) == c2.type.name && radhydra.checked && isPlayer) {c2.hpMax = (int)c2.hpMax*2; c2.atkMax = (int)c2.atkMax*2; }
      if (ListHydraCard3 != null && ListHydraCard3.listItems.get(ListHydraCard3.currentIndex) == c2.type.name && radhydra.checked && isPlayer) {c2.hpMax = (int)c2.hpMax*3; c2.atkMax = (int)c2.atkMax*3;  }
      c2.lvl = c.lvl;
      c2.resetAll(this);
      deck.add( c2 );
      
      initative += c2.type.hp[c2.lvl] + c2.type.atk[c2.lvl];
    }
    for( int i = 0; i < p.numRunes; ++ i )
    {
      runes[ i ] = new Rune( p.runes[ i ].type, p.runes[ i ].level );
    }
    numRunes = p.numRunes;
    merit = 0;
    hpmax = hp = p.hp;
    invul = (hpmax == 0);
    checkDead();
    long seed = System.nanoTime();
    Collections.shuffle(deck, new Random(seed));
    
    for ( int i = 0; i < board.length; ++ i )
    {
      board[ i ] = null;
    }
  }
  
  void resetForKW()
  {
    deck.addAll(hand);
    deck.addAll(inPlay);
    hand.clear();
    inPlay.clear();
    grave.clear();
    graveReanim.clear();
    guards.clear();
    hpmax = hp;
    for( Card c : deck )
    {
      c.atkMax = min( min( c.atk, c.atkBuff ), c.atkMax );
      c.hpMax = min( min( c.hpCurr, c.hpBuff ), c.hpMax );
      c.ward = 0;
    }
    for( int i = 0; i < board.length; ++ i )
      board[ i ] = null;
    for( int i = 0; i < numRunes; ++ i )
      runes[ i ].remainingUses = runes[ i ].type.numUses;
    for( int i = 0; i < 3; ++ i )
      for( int j = 0; j < 6; ++ j )
        cardCount[ i ][ j ] = 0;
    for( int i = 0; i < hpBuff.length; ++ i )
    {
      hpBuff[ i ] = 0;
      atkBuff[ i ] = 0;
    }
    checkDead();
  }
  
  void checkDead()
  {
    dead = dead || ( hp <= 0 && !invul ) || (deck.isEmpty() && hand.isEmpty() && inPlay.isEmpty());
  }

  void playTurn(Player op, int round)
  {
    // First, draw.
    if ( deck.size() > 0 && handSize() < 5 && (hp > 0 || invul) && (op.hp > 0 || op.invul))
    {
      Card c = deck.remove( deck.size() - 1 );
      if(debug>0)
        println("   Draw:"+c);
      c.resetAll(this);
      addToHand( c );
      c.time++;
    }
    
    // Second, reduce all timers in hand and play any 0 timer card.
    for ( int i = 0; i < hand.size(); ++ i )
    {
      Card c = hand.get( i );
      if ( --c.time <= 0 )
      {
        c.hpCurr = c.hpBuff = c.hpMax + hpBuff[ c.type.faction ] - c.buffGuardOffset;
        c.atk = c.atkBuff = c.atkMax + atkBuff[ c.type.faction ] - c.buffAttackOffset;
        addToPlay( c );
        removeFromHand( i -- );
        c.checkAbilities(this, op, ON_ENTER, -1);
      }
      if ((hp <=0 && !invul) || (op.hp <=0 && !op.invul)) break;
    }
    for( Card c : op.hand )
    {
      -- c.time;
    }
    
    // Third, reset runes, activate runes, then compact empty slots from dead cards.
    for( Card c : inPlay )
    {
      System.arraycopy( c.abilityNumOrig, 0, c.abilityNum, 0, c.abilityNumOrig.length );
      c.ward = 0;
      c.atk -= c.morale;
      c.atkBuff -= c.morale;
      if( c.atk > c.atkBuff )
      {
        c.atk = max( c.atk - c.morale, c.atkBuff );
      }
      c.morale = 0;
      c.status[ SICK ] = false;
    }
    for( int i = 0; i < numRunes; ++ i ) {
      runes[ i ].checkRune( this, op, round );
      if ((hp <= 0 && !invul) || (op.hp <= 0 && !op.invul)) break;
    }
    removeDeadCards( op );

    // Fourth, each card attacks.
    for ( int i = 0; i < board.length; ++ i )
    {
      Card c = board[ i ];
      if ( c != null)
        c.attack( this, op, i );
      if ((hp <=0 && !invul) || (op.hp <= 0 && !op.invul)) break;
    }

    // Last, dead cards again and compact the board.
    removeDeadCards( op );
    checkDead();
  }
  
  void removeDeadCards(Player op)
  {
    /*for ( int i = 0; i < inPlay.size(); ++ i )
    {
      Card c = inPlay.get( i );
      if ( c.hp <= 0 || c.dead )
      {
        grave.add( c );
        c.checkAbilities(this, op, ON_DEATH);
        inPlay.remove( i-- );
      }
    }
    for ( int i = 0; i < op.inPlay.size(); ++ i )
    {
      Card c = op.inPlay.get( i );
      if ( c.hp <= 0 || c.dead )
      {
        op.grave.add( c );
        c.checkAbilities(op, this, ON_DEATH);
        op.inPlay.remove( i-- );
      }
    }*/
    
    // Compact the board array.
    Player players[] = { this, op };
    for ( int i = 0; i < board.length; ++ i )
    {
      for( Player p : players )
      {
        if ( i < p.inPlay.size() )
        {
          p.board[ i ] = p.inPlay.get(i);
          p.board[ i ].pos = i;
          if( i > 0 && p.board[ i ].divineProVal > 0 )
          {
            if( p.board[ i ].divineProtect[ 0 ] == null )
            {
              p.board[ i ].divineProtect[ 0 ] = p.board[ i - 1 ];
              if( p.board[ i - 1 ].hpCurr == p.board[ i - 1 ].hpBuff )
                p.board[ i - 1 ].hpCurr += p.board[ i ].divineProVal;
              p.board[ i - 1 ].hpBuff += p.board[ i ].divineProVal;
            }
            else if( p.board[ i ].divineProtect[ 0 ] != p.board[ i - 1 ] )
            {
              println( "ERROR 1 IN DIVINE PROTECT! Please report this!");
            }
          }
          if( i > 0 && p.board[ i - 1 ].divineProVal > 0)
          {
            if( p.board[ i - 1 ].divineProtect[ 2 ] == null )
            {
              p.board[ i - 1 ].divineProtect[ 2 ] = p.board[ i ];
              if( p.board[ i ].hpCurr == p.board[ i ].hpBuff )
                p.board[ i ].hpCurr += p.board[ i - 1 ].divineProVal;
              p.board[ i ].hpBuff += p.board[ i - 1 ].divineProVal;
            }
            else if( p.board[ i - 1 ].divineProtect[ 2 ] != p.board[ i ] )
            {
              println( "ERROR 2 IN DIVINE PROTECT! Please report this!" );
            }
          }
        }
        else
          p.board[ i ] = null;
      }
    }
  }

  void attacked( int dmg, Player op, boolean belowZero )
  {
    if ( guards.size() > 0 )
    {
      if( debug > 2 ) println("       Player attacked with " + guards.size() + " guard cards in play.");
      for ( int i = 0; i < guards.size() && dmg > 0; ++ i )
      {
        Card c = guards.get( i );
        if( !inPlay.contains( c ) || c.dead )
        {
          guards.remove( i -- );
          continue;
        }
        int mitigate = min( dmg, c.hpCurr );
        dmg = max( 0, dmg - mitigate );

        c.subtractHealth( this, op, mitigate );
        if( c.dead ) -- i;
        if( debug > 2 ) println("       " + c.toStringNoHp() + "'s guard mitigated " + mitigate + " and " + dmg + " remains");
      }
    }
    if ( dmg > 0 && hp > 0)
    {
      hp -= dmg;
      if( debug > 2 ) println("       Player took " + dmg + " damage.");
      if( !belowZero )
      {
        hp = max( hp, 0 );
      }
    }
    //checkDead(); only at end of turn apparently
  }
  
  // HAND
  void addToHand( Card c )
  {
    if( handSize() < 5 )
    {
      hand.add( c );
      cardCount[ HAND ][ c.type.faction ] += 1;
      c.time = c.type.timer;
    }
    else
    {
      deck.add( c );
    }
  }
  
  void removeFromHand( Card c )
  {
    if( hand.remove( c ) )
      cardCount[ HAND ][ c.type.faction ] -= 1;
  }
  
  Card removeFromHand( int i )
  {
    Card c = hand.remove( i );
    cardCount[ HAND ][ c.type.faction ] -= 1;
    return c;
  }
  
  int handSize()
  {
    return hand.size();
  }
  
  // IN PLAY
  void addToPlay( Card c )
  {
    if( debug > 3 ) println( "   Enter Play: " + c);
    c.pos = inPlay.isEmpty() ? 0 : inPlay.get( inPlay.size() - 1 ).pos + 1;
    inPlay.add( c );
    cardCount[ PLAY ][ c.type.faction ] += 1;
    board[ c.pos ] = c;
    c.resetAll(this);
    
    // If there is a card before this card with divine protection, buff this card with divine protection.
    if( c.pos > 0 && inPlay.size() > 1 )
    {
      Card cardBeforeMe = inPlay.get( inPlay.size() - 2 ); // was -2
      if( cardBeforeMe.divineProtect[ 1 ] != null && !cardBeforeMe.dead )
      {
        cardBeforeMe.divineProtect[ 2 ] = c;
        c.hpCurr += cardBeforeMe.divineProVal;
        c.hpBuff += cardBeforeMe.divineProVal;
        if (debug > 3) println("     Divine Protection on " + c.toStringNoHp() + " by coming in next to " + cardBeforeMe.toStringNoHp() + " for " + cardBeforeMe.divineProVal);
      }
    }
  }
  
  // Do not do this, it messes up the positions!
  /*void addToPlay( Card c, int i )
  {
    c.pos = i;
    inPlay.add( i, c );
    cardCount[ PLAY ][ c.type.faction ] += 1;
    board[ c.pos ] = c;
    c.resetAll(this);
    if( debug > 3 ) println( "   Enter Play: " + c);
  }*/
  
  void removeFromPlay( Card c )
  {
    if( debug > 3 ) println( "     Leave Play: " + c);
    int index = inPlay.indexOf( c );
    if( index != -1 )
    {
      if( index > 0 )
      {
        Card before = inPlay.get( index - 1 );
        before.divineProtect[ 2 ] = null;
      }
      if( index < inPlay.size() - 1 )
      {
        Card after = inPlay.get( index + 1 );
        after.divineProtect[ 0 ] = null;
      }
      board[ c.pos ] = null;
      cardCount[ PLAY ][ c.type.faction ] -= 1;
      inPlay.remove( index );
    }
  }
  
  Card removeFromPlay( int i )
  {
    Card c = board[ i ];
    if( c == null ) return null;
    if( debug > 3 ) println( "   Leave Play: " + c);
    inPlay.remove( c );
    cardCount[ PLAY ][ c.type.faction ] -= 1;
    board[ i ] = null;
    return c;
  }
  
  int playSize()
  {
    return inPlay.size();
  }
  
  // GRAVE
  void addToGrave( Card c )
  {
    if( debug > 3 ) println( "       Enter Grave: " + c);
    grave.add( c );
    if( c.type.canReanim ) graveReanim.add( c );
    cardCount[ GRAVE ][ c.type.faction ] += 1;
  }
  
  void removeFromGrave( Card c )
  {
    if( grave.remove( c ) )
    {
      if( debug > 3 ) println( "       Leave Grave: " + c);
      cardCount[ GRAVE ][ c.type.faction ] -= 1;
      if( c.type.canReanim ) graveReanim.remove( c );
    }
  }
  
  Card removeFromGrave( int i )
  {
    Card c = grave.remove( i );
    if( debug > 3 ) println( "     Leave Grave: " + c);
    cardCount[ GRAVE ][ c.type.faction ] -= 1;
    if( c.type.canReanim ) graveReanim.remove( c );
    return c;
  }
  
  int graveSize()
  {
    return grave.size();
  }
  
  String toString()
  {
    return "Player[" + hp + "]";
  }
}

static final int hpPerLevel[] = {
  0, 1000, 1070, 1140, 1210, 1280, 1350, 1420, 1490, 1560, 1630, 
  1800, 1880, 1960, 2040, 2120, 2200, 2280, 2360, 2440, 2520, 
  2800, 2890, 2980, 3070, 3160, 3250, 3340, 3430, 3520, 3610, 
  4000, 4100, 4200, 4300, 4400, 4500, 4600, 4700, 4800, 4900, 
  5400, 5510, 5620, 5730, 5840, 5950, 6060, 6170, 6280, 6390, 
  7000, 7120, 7240, 7360, 7480, 7600, 7720, 7840, 7960, 8080, 
  8800, 8930, 9060, 9190, 9320, 9450, 9580, 9710, 9840, 9970, 
  10800, 10940, 11080, 11220, 11360, 11500, 11640, 11780, 11920, 12060, 
  13000, 13150, 13300, 13450, 13600, 13750, 13900, 14050, 14200, 14350, 
  15400, 15560, 15720, 15880, 16040, 16200, 16360, 16520, 16680, 16840, 
  17000, 17160, 17320, 17480, 17640, 17800, 17960, 18120, 18280, 18440, 
  18600, 18760, 18920, 19080, 19240, 19400, 19560, 19720, 19880, 20040, 
  23800, 23990, 24180, 24370, 24560, 24750, 24940, 25130, 25320, 25510, 
  27000, 27200, 27400, 27600, 27800, 28000, 28200, 28400, 28600, 28800, 
  30400, 30610, 30820, 31030, 31240, 31450, 31660, 31870, 32080, 32290,
};


static final int costPerLevel[] = {
  999999, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 
  43, 46, 49, 52, 55, 58, 61, 64, 67, 70, 
  72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 
  92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 
  112, 114, 116, 118, 120, 122, 124, 126, 128, 130, 
  131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 
  141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 
  151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 
  161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 
  171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 
  181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 
  191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 
  201, 23990, 24180, 24370, 24560, 24750, 24940, 25130, 25320, 25510, 
  27000, 27200, 27400, 27600, 27800, 28000, 28200, 28400, 28600, 28800, 
  30400, 30610, 30820, 31030, 31240, 31450, 31660, 31870, 32080, 32290,
};

