class Game2 implements Runnable
{
  void run()
  {
  }
}
class Game implements Runnable
{
  long t = 0;
  long win = 0;
  long loss = 0;

  long meritTotal = 0;
  long meritMax = 0;
  long meritMin = 9999999999L;
  long roundsTotal = 0;
  long roundsMin = 9999999999L;
  long roundsMax = 0;
  long winStreak = 0;

  Player p1;

  void run()
  {
    
    p1 = new Player(player1);
    for ( int i = 0; i < t; ++ i )
    {
      if (radkw.checked) 
      {
    //println("i: " + i);
    //println("t: " + t);
        while(!p1.dead) 
        {
          playMatch(i%2);
          p1.checkDead();
        }
        p1 = new Player(player1);
      } 
      else
        playMatch(i % 2);
      if ( i % 10000 == 0 )
      {
        totalUpMatches();
      }
    }
    //println( t + " matches averaging " + (t==0?0:(total / (float)t)) + " milliseconds and totalling " + total +".");
    totalUpMatches();
  }

  void totalUpMatches()
  {
    synchronized( m )
    {
      if ( raddi.checked || radkw.checked )
      {
        totalmerit += meritTotal;
        totalmeritMax = totalmeritMax > meritMax ? totalmeritMax : meritMax;
        totalmeritMin = totalmeritMin < meritMin ? totalmeritMin : meritMin;
      }
      totalrounds += roundsTotal;
      totalroundsMax = totalroundsMax > roundsMax ? totalroundsMax : roundsMax;
      totalroundsMin = totalroundsMin < roundsMin ? totalroundsMin : roundsMin;
      meritTotal = roundsTotal = 0;


     // println("Loss: " + loss);
     // println("Wins: " + win);
      totalloss += loss;
      totalwin += win;
      loss = 0; 
      win = 0;
    }
  }

  Game( long times )
  {
    t = times;
  }

  void playMatch( int f )
  {
    if( debug > 0 )
    {
      println("-----------------------------------");
      println("--------- Starting match ----------");
      println("-----------------------------------");
      println("");
    }
    if ( radkw.checked )
      p1.resetForKW();
    else
      p1 = new Player(player1);
    Player p2 = new Player(player2);

    int round;
    boolean done = false;
    round = 0;
    int goFirst = !raddi.checked && f == 1?1:0;
    p1.isP1 = true;
    while ( !done )
    {
      round ++;
      if ( debug > 0 )
      {
        String deck1 = "";
        for( int i = 0; i < p1.deck.size(); ++ i )
        {
          deck1 += p1.deck.get(i).type.name;
          if( i < p1.deck.size()-1 )
            deck1 += ", ";
        }
        String hand1 = "";
        for( int i = 0; i < p1.hand.size(); ++ i )
        {
          hand1 += p1.hand.get(i).type.name + " (Time: " + p1.hand.get(i).time + ")";
          if( i < p1.hand.size()-1 )
            hand1 += ", ";
        }
        String grave1 = "";
        for( int i = 0; i < p1.grave.size(); ++ i )
        {
          grave1 += p1.grave.get(i).type.name;
          if( i < p1.grave.size()-1 )
            grave1 += ", ";
        }
        String play1 = "";
        for( int i = 0; i < p1.inPlay.size(); ++ i )
        {
          play1 += "\n      "+p1.inPlay.get(i);
          Card c = p1.inPlay.get(i);
          boolean add_comma = false;
          play1 += "[";
          for (int j = 0; j < 6; j++) {// 6 is size of status array
            if (c.status[j] && j != SICK) {// don't print out reanimated sickness status
              if (add_comma) play1 += ", ";
              play1 += statusNames[j];
              add_comma = true;
            } 
          }
          if (c.burn > 0) {
              if (add_comma) play1 += ", ";
              play1 += "burning-" + c.burn;
              add_comma = true;
          }
          if (c.poison > 0) {
              if (add_comma) play1 += ", ";
              play1 += "poisoned-" + c.poison;
              add_comma = true;
          }
          if (c.ward > 0) {
              if (add_comma) play1 += ", ";
              play1 += "ward-" + c.ward;
              add_comma = true;
          }
          play1 += "]";
          if( i < p1.inPlay.size()-1 )
            play1 += ",";
        }

        String deck2 = "";
        for( int i = 0; i < p2.deck.size(); ++ i )
        {
          deck2 += p2.deck.get(i).type.name;
          if( i < p2.deck.size()-1 )
            deck2 += ", ";
        }
        String hand2 = "";
        for( int i = 0; i < p2.hand.size(); ++ i )
        {
          hand2 += p2.hand.get(i).type.name + " (Time: " + p2.hand.get(i).time + ")";
          if( i < p2.hand.size()-1 )
            hand2 += ", ";
        }
        String grave2 = "";
        for( int i = 0; i < p2.grave.size(); ++ i )
        {
          grave2 += p2.grave.get(i).type.name;
          if( i < p2.grave.size()-1 )
            grave2 += ", ";
        }
        String play2 = "";
        for( int i = 0; i < p2.inPlay.size(); ++ i )
        {
          play2 += "\n      "+p2.inPlay.get(i);
          Card c = p2.inPlay.get(i);
          boolean add_comma = false;
          play2 += "[";
          for (int j = 0; j < 6; j++) {// 6 is size of status array
            if (c.status[j] && j != SICK) {// don't print out reanimated sickness status
              if (add_comma) play2 += ", ";
              play2 += statusNames[j];
              add_comma = true;
            } 
          }
          if (c.burn > 0) {
              if (add_comma) play2 += ", ";
              play2 += "burning-" + c.burn;
              add_comma = true;
          }
          if (c.poison > 0) {
              if (add_comma) play2 += ", ";
              play2 += "poisoned-" + c.poison;
              add_comma = true;
          }
          if (c.ward > 0) {
              if (add_comma) play2 += ", ";
              play2 += "ward-" + c.ward;
              add_comma = true;
          }
          play2 += "]";
          if( i < p2.inPlay.size()-1 )
            play2 += ",";
        }
        
        println("");
        println("---------- Start of Turn ----------");
        println("Start of Round #" + round + " for Player "+ (round % 2==goFirst?((p1.name == "unamed") ? "1" : p1.name):((p2.name == "unamed") ? "2" : p2.name)) + " as follows");
        if( raddi.checked && (round % 2==goFirst?1:2) == 1 )
          println("Player merit: " + p1.merit);
        println("---------- Start of Turn ----------");
        println("Player " + ((p1.name == "unamed") ? "1" : p1.name) + ":");
        println("   Health: " + p1.hp);
        println("   Deck  (" + p1.deck.size() + "): " + deck1);
        println("   Hand  (" + p1.hand.size() + "): " + hand1);
        println("   Grave (" + p1.grave.size() + "): " + grave1);
        println("   Play  (" + p1.inPlay.size() + "): " + play1);
        print("   Runes (" + p1.numRunes + "): " );
        for (int i = 0; i < p1.numRunes; ++ i) {
          if ((i+1) == p1.numRunes) print(p1.runes[i].type.name + " (" + p1.runes[i].level + ") [Uses Left:" + p1.runes[i].remainingUses + "]");
          else print(p1.runes[i].type.name + " (" + p1.runes[i].level + ") [Uses Left:" + p1.runes[i].remainingUses + "], ");
        }
        println("");
        println("");
        println("Player " + ((p2.name == "unamed") ? "2" : p2.name) + ":");
        println("   Health: " + p2.hp);
        println("   Deck  (" + p2.deck.size() + "): " + deck2);
        println("   Hand  (" + p2.hand.size() + "): " + hand2);
        println("   Grave (" + p2.grave.size() + "): " + grave2);
        println("   Play  (" + p2.inPlay.size() + "): " + play2);
        print("   Runes (" + p2.numRunes + "): " );
        for (int i = 0; i < p2.numRunes; ++ i) {
          if ((i+1) == p2.numRunes) print(p2.runes[i].type.name + " (" + p2.runes[i].level + ") [Uses Left:" + p2.runes[i].remainingUses + "]");
          else print(p2.runes[i].type.name + " (" + p2.runes[i].level + ") [Uses Left:" + p2.runes[i].remainingUses + "], ");
        }
        println("");
        println("");
        println("Turn actions:");
      }
        
      if ( round % 2 == goFirst )
      {
        if ( round > 50 ) { 
          p1.hp -= 50 + 30 * (round-51);
          if( debug > 1 ) println( "Player takes " + (50 + 30 * (round-51)) + " unavoidable damage from round number." );
          p1.checkDead();
        }
        if (!p1.dead) {
          p1.playTurn(p2, round);
          p1.checkDead();
        }
      }
      else
      {
        if ( round > 50 ) { 
          p2.hp -= 50 + 30 * (round-51);
          if( debug > 1 ) println( "Player takes " + (50 + 30 * (round-51)) + " unavoidable damage from round number." );
          p2.checkDead();
        }
        if (!p2.dead || raddi.checked) {
          p2.playTurn(p1, round);
          p2.checkDead();
        }
      }
      
      done = ((p1.hp <= 0&&!p1.invul) || (!raddi.checked && p2.hp <= 0 && !p2.invul));
      done = done || (p2.inPlay.isEmpty() && p2.deck.isEmpty() && p2.hand.isEmpty());
      done = done || (p1.inPlay.isEmpty() && p1.deck.isEmpty() && p1.hand.isEmpty());
      
        
      if ( done && debug > 0 )
      {
        String deck1 = "";
        for( int i = 0; i < p1.deck.size(); ++ i )
        {
          deck1 += p1.deck.get(i).type.name;
          if( i < p1.deck.size()-1 )
            deck1 += ", ";
        }
        String hand1 = "";
        for( int i = 0; i < p1.hand.size(); ++ i )
        {
          hand1 += p1.hand.get(i).type.name + " (Time: " + p1.hand.get(i).time + ")";
          if( i < p1.hand.size()-1 )
            hand1 += ", ";
        }
        String grave1 = "";
        for( int i = 0; i < p1.grave.size(); ++ i )
        {
          grave1 += p1.grave.get(i).type.name;
          if( i < p1.grave.size()-1 )
            grave1 += ", ";
        }
        String play1 = "";
        for( int i = 0; i < p1.inPlay.size(); ++ i )
        {
          play1 += "\n      "+p1.inPlay.get(i);
          Card c = p1.inPlay.get(i);
          boolean add_comma = false;
          play1 += "[";
          for (int j = 0; j < 6; j++) {// 6 is size of status array
            if (c.status[j] && j != SICK) {// don't print out reanimated sickness status
              if (add_comma) play1 += ", ";
              play1 += statusNames[j];
              add_comma = true;
            } 
          }
          if (c.burn > 0) {
              if (add_comma) play1 += ", ";
              play1 += "burning-" + c.burn;
              add_comma = true;
          }
          if (c.poison > 0) {
              if (add_comma) play1 += ", ";
              play1 += "poisoned-" + c.poison;
              add_comma = true;
          }
          if (c.ward > 0) {
              if (add_comma) play1 += ", ";
              play1 += "ward-" + c.ward;
              add_comma = true;
          }
          play1 += "]";
          if( i < p1.inPlay.size()-1 )
            play1 += ",";
        }
        String deck2 = "";
        for( int i = 0; i < p2.deck.size(); ++ i )
        {
          deck2 += p2.deck.get(i).type.name;
          if( i < p2.deck.size()-1 )
            deck2 += ", ";
        }
        String hand2 = "";
        for( int i = 0; i < p2.hand.size(); ++ i )
        {
          hand2 += p2.hand.get(i).type.name + " (Time: " + p2.hand.get(i).time + ")";
          if( i < p2.hand.size()-1 )
            hand2 += ", ";
        }
        String grave2 = "";
        for( int i = 0; i < p2.grave.size(); ++ i )
        {
          grave2 += p2.grave.get(i).type.name;
          if( i < p2.grave.size()-1 )
            grave2 += ", ";
        }
        String play2 = "";
        for( int i = 0; i < p2.inPlay.size(); ++ i )
        {
          play2 += "\n      "+p2.inPlay.get(i);
          Card c = p2.inPlay.get(i);
          boolean add_comma = false;
          play2 += "[";
          for (int j = 0; j < 6; j++) {// 6 is size of status array
            if (c.status[j] && j != SICK) {// don't print out reanimated sickness status
              if (add_comma) play2 += ", ";
              play2 += statusNames[j];
              add_comma = true;
            } 
          }
          if (c.burn > 0) {
              if (add_comma) play2 += ", ";
              play2 += "burning-" + c.burn;
              add_comma = true;
          }
          if (c.poison > 0) {
              if (add_comma) play2 += ", ";
              play2 += "poisoned-" + c.poison;
              add_comma = true;
          }
          if (c.ward > 0) {
              if (add_comma) play2 += ", ";
              play2 += "ward-" + c.ward;
              add_comma = true;
          }
          play2 += "]";
          if( i < p2.inPlay.size()-1 )
            play2 += ",";
        }
        
        
        println("");
        println("----------- End of Match -----------");
        println("End of Match after round #" + round + " as follows");
        if( raddi.checked && (round % 2==goFirst?1:2) == 1 )
          println("Player merit: " + p1.merit);
        println("----------- End of Match -----------");
        println("Player 1:");
        println("   Health: " + p1.hp);
        println("   Deck  (" + p1.deck.size() + "): " + deck1);
        println("   Hand  (" + p1.hand.size() + "): " + hand1);
        println("   Grave (" + p1.grave.size() + "): " + grave1);
        println("   Play  (" + p1.inPlay.size() + "): " + play1);
        print("   Runes (" + p1.numRunes + "): " );
        for (int i = 0; i < p1.numRunes; ++ i) {
          if ((i+1) == p1.numRunes) print(p1.runes[i].type.name + " (" + p1.runes[i].level + ") [Uses Left:" + p1.runes[i].remainingUses + "]");
          else print(p1.runes[i].type.name + " (" + p1.runes[i].level + ") [Uses Left:" + p1.runes[i].remainingUses + "], ");
        }
        println("");
        println("Player 2:");
        println("   Health: " + p2.hp);
        println("   Deck  (" + p2.deck.size() + "): " + deck2);
        println("   Hand  (" + p2.hand.size() + "): " + hand2);
        println("   Grave (" + p2.grave.size() + "): " + grave2);
        println("   Play  (" + p2.inPlay.size() + "): " + play2);
        print("   Runes (" + p2.numRunes + "): " );
        for (int i = 0; i < p2.numRunes; ++ i) {
          if ((i+1) == p2.numRunes) print(p2.runes[i].type.name + " (" + p2.runes[i].level + ") [Uses Left:" + p2.runes[i].remainingUses + "]");
          else print(p2.runes[i].type.name + " (" + p2.runes[i].level + ") [Uses Left:" + p2.runes[i].remainingUses + "], ");
        }
        println("");
        println("");
      }
    }

    // Player has died in di mode.
    if ( raddi.checked && ( (p1.hp <= 0&&!p1.invul) ||(p1.inPlay.isEmpty() && p1.deck.isEmpty() && p1.hand.isEmpty()) ) )
    {
      meritTotal += p1.merit;
      meritMax = p1.merit > meritMax ? p1.merit : meritMax;
      meritMin = p1.merit < meritMin ? p1.merit : meritMin;
      roundsTotal += round;
      roundsMax = round > roundsMax ? round : roundsMax;
      roundsMin = round < roundsMin ? round : roundsMin;
      
      synchronized( resultsTracked )
      {
        if( resultsTracked.size() < 1000000 )
        {
          resultsTracked.add( new Result( p1.merit, round ) );
        }
      }
                 //   println("HERE2 size: " + resultsTracked.size());

      ++ win;
    }
    // Match over in kw/arena mode
    else
    {
      roundsTotal += round;
      roundsMax = round > roundsMax ? round : roundsMax;
      roundsMin = round < roundsMin ? round : roundsMin;
      if( !radkw.checked )
      {
        synchronized( resultsTracked )
        {
          if( resultsTracked.size() < 1000000 )
          {
            resultsTracked.add( new Result( 0, round ) );
          }
        }
      }
      if ( (p2.hp <= 0 && !p2.invul)||(p2.inPlay.isEmpty() && p2.deck.isEmpty() && p2.hand.isEmpty()) )
      {
        ++ win;
        ++ winStreak;
      }
      else
      {
        ++ loss;
 /*       if ( radkw.checked )
        {
          p1 = new Player(player1);
          synchronized( resultsTracked )
          {
            if( resultsTracked.size() < 1000000 )
            {
              resultsTracked.add( new Result( winStreak, round ) );
            }
          }
          meritMax = winStreak > meritMax ? winStreak : meritMax;
          meritMin = winStreak < meritMin ? winStreak : meritMin;
        }
   */     winStreak = 0;
      }
    }
  }
}

