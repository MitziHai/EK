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
  String MyLog;

  Player p1;
  Player p2;
  


  void run()
  {
    
    for ( int i = 0; i < t; ++ i )
    {
      if (radkw.checked) 
      {
        p1 = new Player(player1, true);
        p2 = new Player(player2, false);
        while(!p1.dead) 
        {
          playMatch(0);
          p1.checkDead();
          p2 = new Player(player2,false);
          p1.resetForKW();
          if (win >= 1000) break;
        }
        p1 = new Player(player1,true);
      } 
      else if (radhydra.checked)
      {
        p1 = new Player(player1,true);
        p2 = new Player(player2,false);
        while(!p2.dead) 
        {
          playMatch(1);
          p2.checkDead();
          p1 = new Player(player1,true);
          p2.resetForKW();
          if (win >= 1000) break;
        }
        p2 = new Player(player2,false);
      } 
      else {
        p1 = new Player(player1,true);
        p2 = new Player(player2,false);
        playMatch(i % 2);
      }
      if ( i % 10000 == 0 || radkw.checked || radhydra.checked)
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
      if ( raddi.checked)
      {
        totalmerit += meritTotal;
        totalmeritMax = totalmeritMax > meritMax ? totalmeritMax : meritMax;
        totalmeritMin = totalmeritMin < meritMin ? totalmeritMin : meritMin;
      }
      totalrounds += roundsTotal;
      totalroundsMax = totalroundsMax > roundsMax ? totalroundsMax : roundsMax;
      totalroundsMin = totalroundsMin < roundsMin ? totalroundsMin : roundsMin;
      meritTotal = roundsTotal = 0;


      totalloss += loss;
      totalwin += win;
      totalgames += (radhydra.checked ? max(1,loss) : max(1,win));
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

    int round;
    int winner = 0;
    boolean done = false;
    round = 0;
    int goFirst = p1.initative >= p2.initative ? 1 : 0; //!raddi.checked && f == 1?1:0;
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
        println("Start of Round #" + round + " for Player "+ (round % 2==goFirst?((p1.name == "Unamed") ? "1" : p1.name):((p2.name == "Unamed") ? "2" : p2.name)) + " as follows");
        if( raddi.checked && (round % 2==goFirst?1:2) == 1 )
          println("Player merit: " + p1.merit);
        println("---------- Start of Turn ----------");
        println("Player " + ((p1.name == "Unamed") ? "1" : p1.name) + ":");
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
        println("Player " + ((p2.name == "Unamed") ? "2" : p2.name) + ":");
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
          p2.checkDead();
        }
        else winner = 2;
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
          p1.checkDead();
        }
        else winner = 1;
      }
      
      if ( round % 2 == goFirst ) winner = ((p2.inPlay.isEmpty() && p2.deck.isEmpty() && p2.hand.isEmpty()) || (!raddi.checked && p2.hp <= 0 && !p2.invul)) ? 1 : 0;
      else winner = ((p1.inPlay.isEmpty() && p1.deck.isEmpty() && p1.hand.isEmpty()) || (p1.hp <= 0&&!p1.invul)) ? 2 : 0;
      
      done = done || (winner > 0);

    }

    if (debug > 0 )
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
      else if (winner == 1)
        println ("!!!!!!!!!!!!!!!!!!!!!!Player " + ((p1.name == "Unamed") ? "1" : p1.name) + " is the winner!!!!!!!!!!!!!!!!!!!!!!");
      else 
        println ("!!!!!!!!!!!!!!!!!!!!!!Player " + ((p2.name == "Unamed") ? "1" : p2.name) + " is the winner!!!!!!!!!!!!!!!!!!!!!!");
      println("----------- End of Match -----------");
      println("Player " + ((p1.name == "Unamed") ? "1" : p1.name) + ":");
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
      println("Player " + ((p2.name == "Unamed") ? "2" : p2.name) + ":");
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
      ++ win;
    }
    // Match over in kw/arena mode
    else
    {
      roundsTotal += round;
      roundsMax = round > roundsMax ? round : roundsMax;
      roundsMin = round < roundsMin ? round : roundsMin;
      if( !radkw.checked && !radhydra.checked)
      {
        synchronized( resultsTracked )
        {
          if (win > 1000) done = true; 
          if( resultsTracked.size() < 1000000 )
          {
            resultsTracked.add( new Result( 0, round ) );
          }
        }
      }
      if ( winner == 1 )
      {
        ++ win;
        ++ winStreak;
      }
      else
      {
        ++ loss;
        winStreak = 0;
      }
    }
  }
}

