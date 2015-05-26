import servconn.*;
import servconn.dto.*;
import servconn.dto.rune.*;
import servconn.dto.skill.*;
import servconn.sim.*;
import servconn.dto.login.*;
import servconn.util.*;
import servconn.dto.card.*;
import servconn.client.*;
import servconn.dto.league.*;




/*

 MISSING FEATURES
 - tab to select next text field
 - FORGOT TO IMPLEMENT HEALING MIST!!
 
 Bugs found in arcannis sim:
 - reincarnation always takes card from bottom of graveyard
 - reanimation can never take last card in graveyard
 
 KNOWN BUGS:
- added percentages to graph view
- fixed: mouse coordinates issue in resized windows
- fixed: players at negative health can no longer lose more health
- fixed: cards reanimated on your opponents turn can now attack on your turn
- fixed: uneven distribution of selected reanimation targets
- fixed: reincarnation now places card on top of deck such that it is drawn next
- fixed: snipe and devil's blade now target rightmost card of those with equal health
     NOTE: THIS IS WRONG. IT HAS SOME WEIRD UNPREDICTABLE PATTERN....
- fixed: vendetta and hot chase we set to not affect attack versus players

- player no longer dies if healed to over 0 health before end of turn
- not fixed: chain attack should not apply lacerate

 
 - abilities to check: bloodsucker, clean sweep, lacerate, sacred flame, backstab, bite, blitz, blight, combustion, damnation, dual snipe, evasion, firegod, healing mist, hot chase, infiltrator, mania, obstinacy, reflection, sacrifice, self-destruct, warpath, warcry, vendetta, weaken, group weaken
 - card cost not adjusted for those over level 10
 - divine protection is crashy and wrong
   *1. Enter play: max hp of cards on left side and itself. Full health cards increase current health
   *2. Leave play, decrease max hp of cards left and right side. Set current to lower of current and max health.
   *3. New card enters beside it: gains buff. Check divine protect field of card to the left when entering.
   *4. Card beside it dies:
     *a. Dying card checks if it is equal to divine protection [2] of left card or [0] of right card. If yes, set those to null.
     *b. Cards shift left at start and end of turn.
     *c. When shifting left, check if self has divine protection [1] and none in [0]; add buff to card to left
     *d. Also check if card to the left has divine protection [1] and none in [2]: add buff to self.
 
 */

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorCompletionService;
import java.nio.*;

int debug = 0; 
boolean evoTab = true;

long numMatch = 10000;
String server = "";
Boolean FOHDownload = false;
Boolean FOHSim = false;
int FOHRound = -1;
int FOHMatch = -1;

class Mutex {
}

Mutex m = new Mutex();
long totalwin = 0;
long totalloss = 0;
long totalgames = 0;
Player player1;
Player player2;

String DecksFileName = "decks_Demons.txt";

int deckCost = 0;
int demonCost = 0;
long totalmerit;
long totalrounds;
long totalroundswins;
long totalroundslosses;
double totalmpm;
long totalmeritMax;
long totalmeritMin;
double totalmeritAvg;
double totalroundsAvg;
long totalroundsMin;
long totalroundsMax;
long totalWinMax;
long totalWinMin;
//String WorstLog;
PGraphics pg = new PGraphics();
boolean control = false;
boolean pressC = false;
boolean pressV = false;
String Event3Star = "";
String Event4Star = "";
String Event5Star = "";

void setup()
{
  try {new File("log.txt").delete();} catch (Exception e) {}
  try{System.setOut(new PrintStream(new BufferedOutputStream(new FileOutputStream("log.txt"))));} catch(Exception e){}
  
  size( 1280, 768+32 );
  pg = new PGraphics();
  pg = createGraphics(1280, 768+32);
  loadAbils();
  loadSettings();
  setupUI();
  loadCards();
  loadRunes();
  loadDecks("decks_KW.txt",false,KWdecksList);
  loadDecks("decks_Hydra.txt",false,HydradecksList);
  loadDecks("decks_Demons.txt",false,DemondecksList);
  loadDecks("decks_Thiefs.txt",false,ThiefdecksList);
  loadDecks(DecksFileName,true,DemondecksList);
  frame.setResizable(true);

  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      saveDecks();
      saveSettings();
    }
  }
  ));

  loadLevel();
  //test();
}

void loadSettings() {
  try
  {   
    File f = new File("settings.txt");
    if(f.exists()) 
    {
      BufferedReader br = createReader("settings.txt");
      DecksFileName = br.readLine();
      Event3Star = br.readLine();
      Event4Star = br.readLine();
      Event5Star = br.readLine();
      numMatch = Integer.parseInt(br.readLine());
      server = br.readLine();
      br.close();
    }
  }
  catch( Exception e )
  {
    println(e);
  }
}

void saveSettings() {
  try
  {   
    PrintWriter writer = new PrintWriter("settings.txt", "UTF-8");
    BufferedReader br = createReader("settings.txt");
    writer.println(DecksFileName);
    writer.println(ListHydraCard1.listItems.get(ListHydraCard1.currentIndex));
    writer.println(ListHydraCard2.listItems.get(ListHydraCard2.currentIndex));
    writer.println(ListHydraCard3.listItems.get(ListHydraCard3.currentIndex));
    writer.println(numMatch);
    writer.println(servers.listItems.get(servers.currentIndex));
    writer.close();
  }
  catch( Exception e )
  {
    println(e);
  }
}

public static double choose(int x, int y) 
{
  if (y < 0 || y > x) return 0;
  if (y > x/2) 
  {
    y = x - y;
  }
  double answer = 1.0;
  for (int i = 1; i <= y; i++) 
  {
    answer *= (x + 1 - i);
    answer /= i;           // humor 280z80
  }
  return answer;
}

static boolean isRun = false;
static boolean StopMe = false;
static boolean Pause = false;

String resultText = "";
String fullResultText = "";
boolean multideck = false;
ExecutorService executor = Executors.newFixedThreadPool(16);
ExecutorCompletionService ecs = new ExecutorCompletionService(executor);

class RunSim implements Runnable
{
  void run()
  {
    numMatch = numberRuns.lastNum;
    if ( numMatch == 1 ) debug = 4; 
    else debug = 0;
    resultText = "";
    fullResultText = "";
    listresult.listItems.clear();
    listresult.scroll = 0;

    if (!FOHSim) deckp1 = deckFromUI( 0, true );
    else deckp1 = deckFromFOH(FOHRound, 0, 0, true);
    if ( deckp1 == null ) return;

    if (!FOHSim) deckp2 = deckFromUI( 1, true );
    else deckp2 = deckFromFOH(FOHRound, 0, 1, true);
    if ( deckp2 == null ) return; 

    if ( deckp1.numCards == 0 || deckp2.numCards == 0 ) return;

    // Do not run if already running!
    if ( isRun ) return;
    isRun = true;
    StopMe = false;
    
    int playerDeckCost = costPerLevel[ (int)textLevel[ 0 ].lastNum ];
    int nC = deckp1.numCards;
    int nR = deckp1.numRunes;
    int kC = min(10, deckp1.numCards);
    int kR = min(4, deckp1.numRunes);
    int bestC = 0;
    int bestR = 0;
    float bestScore = 0;
    long iterCount = 0;
    multideck = deckp1.numCards > 10 || deckp1.numRunes > 4 || (checkMultisim.checked && !FOHSim);
    int selectedCards = 0;
    int selectedRunes = 0;
    int card = 0; 
    int rune = 0;
    resultsBest = null;
    resultsTracked = new ArrayList< Result >();
                   // println("HERE 5 size: " + resultsTracked.size());

    // Find the duplicate cards in the deck to lower the number of combinations.
    int duplicatesUsed[] = new int[50]; // Number of each card used in the current deck.
    int duplicatesSelected[] = new int[50]; // Number of each card used in the current deck.
    int duplicatesUsedBest[] = new int[50]; // Number of each card used in the best found deck.
    int duplicatesCount[] = new int[50]; // The number of each card found in the player 1 deck list.
    Card duplicatesCards[][] = new Card[50][50]; // List of the card objects, where first dimension is one per unique card and second is the cards.
    // For each card in deck.
    for ( int i = 0; i < deckp1.numCards; ++ i )
    {
      // For each unique card in duplicate list.
      for ( int j = 0; j < deckp1.numCards; ++ j )
      {
        // If this is an empty duplicate slot, then this card is thus far unique. Add it to its own list.
        if ( duplicatesCards[ j ][ 0 ] == null )
        {
          duplicatesCards[ j ][ duplicatesCount[ j ] ++ ] = deckp1.cards[ i ];
          if( deckp1.cards[ i ].selected )
            ++ duplicatesSelected[ j ]; 
          break;
        }
        // If this card is a duplicate of it, add it to the list for that unique card.
        else if ( duplicatesCards[ j ][ 0 ].toString().equals( deckp1.cards[ i ].toString() ) )
        {
          duplicatesCards[ j ][ duplicatesCount[ j ] ++ ] = deckp1.cards[ i ];
          if( deckp1.cards[ i ].selected )
            ++ duplicatesSelected[ j ]; 
          break;
        }
      }
    }
    
    for ( int i = 0; i < deckp1.numRunes; ++ i )
    {
      if (deckp1.runes[i].selected) selectedRunes |= 1<<i;
    }
    
   
    // Estimate the number of deck combinations as sum of n choose k for k = 10-3 to 10
    double iterMax = 1;
    int cTotal = 0;
    int iterRunes = 1;
    if ( multideck )
    {
      for ( int i = 0; i < deckp1.numCards; ++ i )
      {
            //println("Max Iterations: " + iterMax + "\n");
            //println("Duplicates Count: " + duplicatesCount[ i ] + "\n");
            //println("Max Iterations: " + iterMax + "\n");
        if(duplicatesCount[ i ]>0)
        {
          iterMax *= (1+(duplicatesCount[ i ] - duplicatesSelected[i]));
        }
      }
      for ( int i = 0; i < deckp1.numRunes; ++ i )
      {
        if (deckp1.runes[i].selected) selectedRunes |= 1<<i;
        iterMax *= 2 - (deckp1.runes[i].selected ? 1 : 0);
        iterRunes *= 2;
      }
      //-- iterMax;
    }
    else if (FOHSim) {
      iterMax = FOHMatch;
    }
          //  println("Max Iterations: " + iterMax + "\n");

    int cR = 0; 
    
    boolean cardsDone = false;

    if( multideck )
    {
      duplicatesUsed[ 0 ] = 1;  
      String s = "" + (iterCount/(double)iterMax*100);
      listresult.listItems.clear();
      listresult.listItems.add( "Working... Completion: " + s.substring(0, min(s.length(), 5)) + " %" );
    }
    else
    {
      //WorstLog = "";
      for( int j = 0; j < min( 10, deckp1.numCards ); ++ j )
        duplicatesUsed[ j ] = duplicatesCount[ j ];
    }
      // For each card combination:
    while ( !cardsDone && !StopMe && !(FOHSim))
    {
      //println(Arrays.toString(duplicatesUsed));
      // Check if card count for this deck is valid.
      int cardCount = 0;
      for( int j = 0; j < deckp1.numCards && !StopMe; ++ j )
        cardCount += duplicatesUsed[ j ];
      
      if( cardCount <= 10 && cardCount >= min( deckp1.numCards - 3, 7 ) )
      {
        // Check if all selected cards are present.
        boolean selectedPresent = true;
        for( int j = 0; j < deckp1.numCards && selectedPresent; ++ j )
        {
          selectedPresent = duplicatesUsed[ j ] >= duplicatesSelected[ j ];
        }
        if( selectedPresent ) // if we have all selected cards
        {
          cR = 0; // start with no runes selected
          if (!multideck) cR = (1 << nR) -1; //unless we are not doing multi deck
          // For each rune combination:
          while ( cR < (1<<nR) && !StopMe)
          {
            // If combination includes all selected runes, construct the deck and simulate games for that deck.
            if(  ( selectedRunes & cR ) == selectedRunes  )
            {
              iterCount++;
              Deck testDeck = constructDeck( duplicatesUsed, duplicatesCards, cR );
              if( testDeck.cost <= playerDeckCost || FOHSim) // PLAYER 1 DECK COST HERE
              {
                String decklist = "";
                float score = iterate( testDeck, deckp2, bestScore, multideck);
                if (checkMultisimResults.checked) {
                  println("");
                  String str = "----- Deck #" + iterCount + " -----";
                  println("--------------------" + str + " --------------------");
                  for (int i=0;i<testDeck.numCards;i++) println("     " + testDeck.cards[i].toString());
                  for (int i=0;i<testDeck.numRunes;i++) println("     " + testDeck.runes[i].toString());
                  println("     ----------------- Stats -----------------");
                  println("Score (MPM/Win Percentage) for this deck: " + nfc((float)score,2));
                  if (raddi.checked){
                    println("     Avg Merit: " + nfc((float)totalmeritAvg,2) + "\tMax Merit: " + nfc((float)totalmeritMax,0) + "\tMin Merit: " + nfc((float)totalmeritMin,0));
                    println("     Avg Rounds: " + nfc((float)totalroundsAvg,2) + "\t\tMax Rounds: " + nfc((float)totalroundsMax,0) + "\t\tMin Rounds: " + nfc((float)totalroundsMin,0));
                    int counter = 0;
                    int barValues1[] = new int[ 10 ];
                    int barValues2[] = new int[ 10 ];
                    double meritPerBar = ((totalmeritMax - totalmeritMin)/10);
                    double roundsPerBar = ((totalroundsMax - totalroundsMin)/10);
                    for( Result res : resultsTracked )
                    {
                      ++ counter;
                      ++ barValues1[ min( (int)((res.score - totalmeritMin)/ meritPerBar), 9 ) ];
                      ++ barValues2[ min( (int)((res.rounds - totalroundsMin) / roundsPerBar), 9 ) ];
                    }
                    println("     Merit                   \t\tRounds");
                    for (int i=0; i< 10; i ++)
                    {
                      println("     [" + nfc((float)(totalmeritMin+i*meritPerBar),0) + "-" + nfc((float)(totalmeritMin+(i+1)*meritPerBar),0) + "] - " + nfc(barValues1[i]*100.0/((float)counter),2) + "%\t[" + nfc((float)(totalroundsMin+i*roundsPerBar),0) + "-" + nfc((float)(totalroundsMin+(i+1)*roundsPerBar),0) + "] - " + nfc(barValues2[i]*100.0/((float)counter),2) + "%");
                    }
                  }
                }
                if ( score > bestScore )
                {
                  bestScore = score;
                  System.arraycopy( duplicatesUsed, 0, duplicatesUsedBest, 0, duplicatesUsed.length );
                  bestR = cR;
                  resultsBest = resultsTracked;
                  //println("HERE size: " + resultsTracked.size());
                }
                resultsTracked = new ArrayList< Result >();
              }
              else if( !multideck )
              {
                listresult.listItems.clear();
                listresult.listItems.add( "Error: player 1 deck cost exceeded." );
              }
              if ( multideck )
              {
                synchronized( listresult )
                {
                  String s = "" + (iterCount/(double)iterMax*100);
                  listresult.listItems.clear();
                  listresult.listItems.add( "Working... Completion: " + s.substring(0, min(s.length(), 5)) + " %" );
                }
              }
            }
    
            // Only show completion by number of completed deck combinations for multisim mode.
            int runesIn = 0;
            do
            {
              runesIn = 0;
              cR++;
              int a = cR;
              while(a > 0 )
              {
                runesIn += a & 1;
                a >>= 1;
              }
            }
            while (cR < (1 << nR) && runesIn != min(4,deckp1.numRunes));
          }
        }
      }
        // Go to next combination of cards.
        // Increment duplicatesUsed[ 0 ] by one. If greater than duplicatesCount[ 0 ], carry over. Repeat until no carry.
      boolean carry = false;
      int index = 0;
      do
      {
        ++ duplicatesUsed[ index ];
        ++ cardCount;
        carry = (duplicatesUsed[ index ] > duplicatesCount[ index ] || cardCount > 10 );
        if ( carry )
        {
          cardCount -= duplicatesUsed[ index ];
          duplicatesUsed[ index ] = 0;
          ++ index;
        }
      } 
      while ( carry && index < deckp1.numCards );
      cardsDone = index == deckp1.numCards;
    }
    int CurrentMatch = 0;
    while (FOHSim && CurrentMatch < FOHMatch) {
      deckp1 = deckFromFOH(FOHRound, CurrentMatch, 0, true);
      deckp2 = deckFromFOH(FOHRound, CurrentMatch, 1, true);
      if ( deckp1 == null ) {
        fullResultText += "Error in constucting player 1s deck for match: " + (CurrentMatch + 1);
        break;
      }
      if ( deckp2 == null ) {
        fullResultText += "Error in constucting player 2s deck for match: " + (CurrentMatch + 1);
        break;
      }
      float score = iterate( deckp1, deckp2, bestScore, multideck);
      fullResultText += resultText;
      fullResultText += "\n";
      CurrentMatch++;
    }
    if (FOHSim) resultText = fullResultText;
    
    
    
    
    if( resultText.length() > 1 )
    {
      listresult.listItems.clear();
      StringTokenizer tokenizer = new StringTokenizer(resultText, "\n");
      while (tokenizer.hasMoreTokens ())
        listresult.listItems.add( tokenizer.nextToken() );
    }
    // Print out winning best deck.
    if ( multideck )
    {
      synchronized( listresult )
      {
        listresult.listItems.add( "Best Deck: " );
        Deck bestDeck = constructDeck( duplicatesUsedBest, duplicatesCards, bestR );
        String t = "";
        for ( int j = 0; j < bestDeck.numCards; ++ j )
        {
          String evo = bestDeck.cards[ j ].evo == AType.A_NONE ? "" : ( "-" + evoNames.get( abilityName.get( bestDeck.cards[ j ].evo ) ) + bestDeck.cards[ j ].evoLevel + " (" + bestDeck.cards[ j ].lvl + ")" );
          t += bestDeck.cards[ j ].type.name + evo + (j<bestDeck.numCards-1?", ":"");
          if ( j == 3 || j == 7 )
          {
            listresult.listItems.add( t );
            t = "";
          }
        }
        if ( t.length() > 0 )
        {
          listresult.listItems.add( t );
          t = "";
        }
        for ( int j = 0; j < bestDeck.numRunes; ++ j )
          t += bestDeck.runes[ j ].type.name + (j<bestDeck.numRunes-1?", ":"");
        if ( t.length() > 0 )
        {
          listresult.listItems.add( t );
          t = "";
        }
      }
    }
    if( resultsBest == null )
    {
      resultsBest = resultsTracked;
      resultsTracked = null;
    }
    isRun = false;
    FOHSim = false;
    butgo.text = "      Go!";
  }

  // duplicatesUsed, duplicatesCards, cR
  Deck constructDeck( int[] used, Card[][] cards, int r )
  {
    Deck d = new Deck();
    for ( int i = 0; i < used.length; ++ i )
      for( int j = 0; j < used[ i ]; ++ j )
      {
        d.cards[ d.numCards ++ ] = cards[ i ][ j ];
        d.cost += cards[ i ][ j ].cost;
      }

    for ( int i = 0; i < deckp1.numRunes; ++ i )
      if ( ( ( 1 << i ) & r ) > 0 )
        d.runes[ d.numRunes ++ ] = deckp1.runes[ i ];
    d.name = deckp1.name;
    return d;
  }


  Deck constructDeckGospers( int c, int r )
  {
    Deck d = new Deck();
    for ( int i = 0; i < deckp1.numCards; ++ i )
      if ( ( ( 1 << i ) & c ) > 0 )
        d.cards[ d.numCards ++ ] = deckp1.cards[ i ];

    for ( int i = 0; i < deckp1.numRunes; ++ i )
      if ( ( ( 1 << i ) & r ) > 0 )
        d.runes[ d.numRunes ++ ] = deckp1.runes[ i ];
    return d;
  }


  // NOTE: This method is rather optimized. It functions as fast as can be expected to finish a number of matches.
  // The executor completion service is very fast for managing a pool of threads to complete a task.

  // For multisim, it cannot run one thread for one deck combination and another thread for another combination
  // without a massive rewrite to how the scores are stored. It only supports one score right now. I can see no
  // advantage to changing this.
  float iterate(Deck d1, Deck d2, float bestScore, boolean multisim)
  {
    // Setup counters
    player1 = new Player( hpPerLevel[ (FOHSim?d1.level:(int)textLevel[ 0 ].lastNum )] );
    player2 = new Player( hpPerLevel[ (FOHSim?d2.level:(int)textLevel[ 1 ].lastNum )] );
    totalmpm = totalroundsAvg = 0;
    totalmeritMax = totalroundsMax = 0;
    totalmeritMin = totalroundsMin = 9999999999L;
    totalmerit = totalrounds = 0;
    totalwin = totalroundswins = 0;
    totalloss = totalroundslosses = 0;
    totalgames = 0 ;

    // Setup players
    for ( int i = 0; i < min(10,d1.numCards); ++ i )
    {
      player1.deck.add( d1.cards[ i ] );
    }
    for ( int i = 0; i < min(4,d1.numRunes); ++ i )
    {
      player1.runes[ i ] = new Rune( d1.runes[ i ].type, d1.runes[ i ].level );
    }
    player1.numRunes = d1.numRunes;
    deckCost = 0;
    demonCost = 0;
    for ( Card c : player1.deck )
    {
      deckCost += c.cost;
      demonCost += c.type.cost;
    }

    for ( int i = 0; i < min(10,d2.numCards); ++ i )
    {
      player2.deck.add( d2.cards[ i ] );
    }
    for ( int i = 0; i < min(4,d2.numRunes); ++ i )
    {
      player2.runes[ i ] = new Rune( d2.runes[ i ].type, d2.runes[ i ].level );
    }
    player2.numRunes = d2.numRunes;
    player1.name = d1.name;
    player2.name = d2.name;
    long startTime = System.currentTimeMillis();
    long patience = 1000 * 60 * 60;

    // Begin threads.
    int cores = 2*8;
    if (checkSingleThread.checked ) cores = 1;
    // debug = 4;  // To single thread and print all info to log uncomment this line
    int perCore = (int)ceil(numMatch / cores);

    // Method 2 part 1 of 3. BETTER Recreate new fixed thread pool for every deck combination.
    /*executor = Executors.newFixedThreadPool(cores);*/
    for ( int i = 0; i < cores; ++ i )
    {
      Thread t;
      // Method 1 part 1 of 2. BAD Create a new thread per core instead of using a thread pool.
      /*if(i==cores-1)
       t = new Thread(new Game(numMatch-perCore*(cores-1)));
       else
       t = new Thread(new Game(perCore));
       t.start();*/
      //t = new Thread(new Game2());
      //t.start();

      // Method 2 part 2 of 3. BETTER Creating workers in pool.
      /*Runnable worker = new Game(perCore);
       executor.execute(worker);*/

      // Method 3 part 1 of 2. BEST Add workers to completion service to avoid re-creating thread pool.
      //println(perCore + " " + cores);
      Runnable worker;
      if(i==cores-1)
        worker = new Game(numMatch-perCore*(cores-1),i);
      else
        worker = new Game(perCore,i);
      ecs.submit(worker, null);
    }

    // Method 2 part 3 of 3. BETTER Shutdown and wait for termination of thread pool.
    /*executor.shutdown();
     while (!executor.isTerminated()) {} */

    // Wait for completion of threads.
    boolean done = false;
    // Method 1 part 2 of 2. Only need to loop, delay, and synchronize when not using either thread pool technique.
    while( ecs.poll() == null )
    {
      delay(0);
      synchronized(m)
      {
        done = numMatch <= (radkw.checked ? totalloss : (radhydra.checked ? totalwin : totalwin + totalloss));
        String c = "";
        if (!radkw.checked && !radhydra.checked) c = (""+((totalwin + totalloss)/(float)numMatch*100));
        else c = (""+((radkw.checked ? totalloss : totalwin)/(float)numMatch*100));
        if ( !multideck )
        {
          synchronized( listresult )
          {
            listresult.listItems.clear();
            listresult.listItems.add( "Working... Completion: " + c.substring(0, min(5, c.length())) + " %" );
          }
        }
      }
    }
    // Method 3 part 2 of 2. BEST Wait for completion service to complete every task.
    try 
    {
      for (int i = 0; i < cores-1; i++) 
      {
        ecs.take();
      }
    } 
    catch (InterruptedException e ) 
    {
    }

    // Display result.
    float score = 0;
    //if (debug > 0) println(WorstLog);
    if ( radall.checked || FOHSim)
    {
      score = ((100*totalwin/(float)(totalwin + totalloss)));
      if ( score >= bestScore )
        resultText = nfc(totalwin + totalloss,0) + " matches completed\n" + d1.name +" wins " + 
          (100*totalwin/(float)(totalwin + totalloss))+"% of the matches against " + d2.name;
    }
    else if ( raddi.checked )
    {
      score = totalmerit / ( (totalwin + totalloss) * (demonCost*2+60)/60.0 );
      if ( score >= bestScore )
      {
        totalmpm = totalmerit / ( (totalwin + totalloss) * (demonCost*2+60)/60.0 );
        /*if( multisim )
         resultText = "Average merit per minute: " + totalmpm;// + "\n";
         else*/
        {
          totalmeritAvg = totalmerit / (double)(totalwin + totalloss);
          totalroundsAvg = totalrounds / (double)(totalwin + totalloss);

          resultText = nfc(totalwin + totalloss,0) + " matches completed\n" + "Average merit per minute: " + nfc((float)totalmpm,2) + 
            "  Cooldown Time: " + floor((demonCost*2+60)/60.0) + ":" + nf((demonCost*2+60) - 60* floor((demonCost*2+60)/60.0),2) + "\n" + 
            "Maximum merit: " + nfc((int)totalmeritMax) +
            " Minimum merit: " + nfc((int)totalmeritMin) + "\n" +
            "Average merit: " + nfc((float)totalmeritAvg,2) + "\n" + 
            "Maximum rounds: " + totalroundsMax +
            " Minimum rounds: " + totalroundsMin + "\n" +
            "Average rounds: " + nfc((int)totalroundsAvg,2) + "\n";
        }
      }
    }
    else if ( radkw.checked )
    {
      score = totalwin/(float)max(1, totalloss);
      if ( score >= bestScore )
      {
        String c = String.format("%1$,.5f", totalwin/(float)max(1, totalloss));
        resultText = nfc(totalloss,0) + " lives completed\n" + (textdeck[0].textIn == "Unamed" ? "Player 1" : textdeck[0].textIn) + " wins " + c.substring(0, min(10, c.length())) +" matches per life.";
      }
    }
    else if ( radhydra.checked )
    {
      score = max(1, totalwin)/(float)(totalloss + totalwin);
      if ( score >= bestScore )
      {
        String c = String.format("%1$,.5f", (totalloss + totalwin)/(float)max(1, totalwin));
        resultText = nfc(totalwin,0) + " hydras defeated\n" + (textdeck[0].textIn == "Unamed" ? "Player 1" : textdeck[0].textIn) + " takes " + c.substring(0, min(10, c.length())) +" attacks to kill Hydra.";
      }
    }
    return score;
  }

}


int uiTab = 0;
void draw()
{
  pg.beginDraw();
  //pg.background(255);
  pg.image( imgBackground, 0, 0, 1280, 800 );
  pg.stroke(240, 205, 175);
  pg.strokeWeight(1);
  pg.line(0, 32, width*2, 32);

  for ( Control c : uiTabs )
  {
    c.draw(pg);
  }

  /*pg.fill(255);
   pg.noStroke();
   pg.rect(uiTabs.get(uiTab).x+1,uiTabs.get(uiTab).y+1,uiTabs.get(uiTab).w-1,uiTabs.get(uiTab).h);
   pg.textSize(uiTabs.get(uiTab).font);
   pg.fill(1);
   pg.text(uiTabs.get(uiTab).text, uiTabs.get(uiTab).x+uiTabs.get(uiTab).font/2+1, uiTabs.get(uiTab).y+uiTabs.get(uiTab).font*1.1);
   pg.strokeWeight(1);*/

  if ( uiTab == 0 )
  {
    for ( Control c : ui )
    {
      synchronized( c ) 
      {
        c.draw(pg);
      }
    }
  }
  else if ( uiTab == 1 )
  {
    for ( Control c : ui )
    {
      c.draw(pg);
    }

    // Draw cost, timer, attack, and health using special fonts.
    drawEKnumber( pg, (int)cardCost.lastNum, labelCardCost.x, labelCardCost.y, false, 0.8 ); 
    drawEKnumber( pg, (int)cardTime.lastNum, labelCardTime.x, labelCardTime.y, true, 0.5 );
    drawEKnumber( pg, (int)cardAtk[ 0 ].lastNum, labelCardAttack.x, labelCardAttack.y, true, 0.76 );
    drawEKnumber( pg, (int)cardHp[ 0 ].lastNum, labelCardHealth.x, labelCardHealth.y, true, 0.77 );
  }
  else if ( uiTab == 2 )
  {
    for ( Control c : ui )
    {
      c.draw(pg);
    }
    
    drawGraph(pg);
  }
  else
  {
    for ( Control c : ui )
    {
      c.draw(pg);
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
}

int mousex;
int mousey;
void mouseMoved()
{
  mousex = (int)(mouseX/(float)width*1280);
  mousey = (int)(mouseY/(float)height*800);
  for ( Control c : ui )
  {
    c.handleMouseMove();
  }
  for ( Control c : uiTabs )
  {
    c.handleMouseMove();
  }
}

void mouseDragged()
{
  mousex = (int)(mouseX/(float)width*1280);
  mousey = (int)(mouseY/(float)height*800);
  for ( Control c : ui )
  {
    c.handleMouseMove();
  }
}

void mousePressed()
{
  //mouseX = (int)(mouseX/(float)width*1280);
  //mouseY = (int)(mouseY/(float)height*800);
  draggedList = null;
  for ( Control c : ui )
  {
    if ( droppedList != null && droppedList != c ) continue;
    c.handleMousePressed();
  }
  for ( Control c : uiTabs )
  {
    c.handleMousePressed();
  }
}

void mouseReleased()
{
  //mouseX = (int)(mouseX/(float)width*1280);
  //mouseY = (int)(mouseY/(float)height*800);
  for ( Control c : ui )
  {
    if ( droppedList != null && droppedList != c ) continue;
    c.handleMouseReleased();
  }
  for ( Control c : uiTabs )
  {
    c.handleMouseReleased();
  }
}

void keyPressed()
{
  for ( Control c : ui )
  {
    c.handleKeyboard();
  }

  if ( key == '1' && selectedText == null && selectedList != deckList[0] && selectedList != deckList[1] )
    addCardsToDeck(0);
  if ( key == '2' && selectedText == null && selectedList != deckList[0] && selectedList != deckList[1]  )
    addCardsToDeck(1);

  if  (key == ESC) key = 0; 
  if ( key == CODED && keyCode == CONTROL ) control = true;
  if ( key == 'c' || key == 'C' ) pressC = true;
  if ( key == 'c' || key == 'C' ) pressV = true;
}

void keyReleased()
{
  if ( key == CODED && keyCode == CONTROL ) control = false;
  if ( key == 'c' || key == 'C' ) pressC = false;
  if ( key == 'c' || key == 'C' ) pressV = false;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if ( selectedList != null && selectedList.hasScroll)
  {
    if (selectedList.scroll + e * float(selectedList.h-selectedList.lineSize) / (selectedList.listItems.size()-selectedList.h/selectedList.lineSize) >= 0)
      selectedList.scroll += e * float(selectedList.h-selectedList.lineSize) / (selectedList.listItems.size()-selectedList.h/selectedList.lineSize);
  }
}

