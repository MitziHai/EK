
class Deck
{
  String name;
  int numCards;
  Card cards[] = new Card[ 50 ];
  int numRunes;
  Rune runes[] = new Rune[ 50 ];
  int level;
  int cost;
}

Deck deckFromUI( int p )
{
  Deck d = new Deck();
  
  d.name = textdeck[ p ].textIn;
  for( int i = 0; i < deckList[p].listItems.size(); ++ i )
  {
    String line = deckList[p].listItems.get( i );
    if( line.substring( 0, Math.min( line.length(), 6 ) ).toLowerCase().equals( "rune: " ) && d.numRunes < 50 )
    {
      Rune r = runeFromString( line );
      if( r == null && line.length() > 0 )
      {
        listresult.listItems.clear();
        listresult.listItems.add( "Invalid rune: " + line );
        return null;
      }
      else if( r != null )
      {
        d.runes[ d.numRunes ++ ] = r;
        deckList[ p ].listItems.set( i, r.toString() );
      }
      if (deckList[p].current.contains (i)) r.selected = true;
    }
    else if( d.numCards < 50 )
    {
      Card c = cardFromString( line );
      if( c == null && line.length() > 0 )
      {
        listresult.listItems.clear();
        listresult.listItems.add( "Invalid card: " + line );
        return null;
      }
      else if( c != null )
      {
        d.cards[ d.numCards ++ ] = c;
        deckList[ p ].listItems.set( i, c.toString() );
      }
      if (deckList[p].current.contains (i)) c.selected = true;
    }
  }
  d.level = (int)textLevel[ p ].lastNum;
  return d;
}

void deckToUI( int d, int p )
{
  Deck deck = savedDecks.get( d ); 
  textdeck[ p ].textIn = deck.name;
  deckList[ p ].listItems.clear();
  for( int i = 0; i < deck.numCards; ++ i )
  {
    deckList[ p ].listItems.add( deck.cards[ i ] + "" );
  }
  for( int i = 0; i < deck.numRunes; ++ i )
  {
    deckList[ p ].listItems.add( deck.runes[ i ] + "" );
  }
  textLevel[ p ].lastNum = textLevel[ p ].num = deck.level;
  textLevel[ p ].textIn = ""+deck.level;
}

void saveDecks()
{
  try
  {    
    PrintWriter writer = new PrintWriter(DecksFileName, "UTF-8");
    writer.println( textLevel[ 0 ].num );
    writer.println( textLevel[ 1 ].num );
    writer.println();
    for( Deck d : savedDecks )
    {
      if( d.name.length() < 1 ) continue;
      writer.println( d.name );
      writer.println( d.level );
      for( int i = 0; i < d.numCards && d.cards[ i ] != null; i ++ )
      {
        writer.println( d.cards[ i ] + "" );
      }
      for( int i = 0; i < d.numRunes && d.runes[ i ] != null; i ++ )
      {
        writer.println( "Rune: " + d.runes[ i ].type.name + " ("+d.runes[ i ].level+")" );
      }
      writer.println("");
    }
    writer.close();
  }
  catch( Exception e )
  {
  }
}

public static boolean isNumeric(String str)  
{  
  try  
  {  
    int d = Integer.parseInt(str);  
  }  
  catch(NumberFormatException nfe)  
  {  
    return false;  
  }  
  return true;  
}

void loadLevel()
{
  textLevel[ 0 ].num = textLevel[ 0 ].lastNum = 90;
  textLevel[ 0 ].num = textLevel[ 1 ].lastNum = 90;
  try
  {
    File f = new File(DecksFileName);
    if(!f.exists()) 
    {
      PrintWriter writer = new PrintWriter(DecksFileName, "UTF-8");
      writer.println("");
    }
    
    BufferedReader br = createReader(DecksFileName);
    Deck d = new Deck();
    int i = 0;
    String l1 = br.readLine();
    textLevel[ 0 ].textIn = ""+ (textLevel[ 0 ].num = textLevel[ 0 ].lastNum = Integer.parseInt(l1));
    String l2 = br.readLine();
    textLevel[ 1 ].textIn = ""+ (textLevel[ 1 ].num = textLevel[ 1 ].lastNum = Integer.parseInt(l2));
  }
  catch( Exception e )
  {
    textLevel[ 0 ].num = textLevel[ 0 ].lastNum = 60;
    textLevel[ 0 ].num = textLevel[ 1 ].lastNum = 60;
  }
  labelh[0].text = "Health: " + hpPerLevel[ (int)textLevel[ 0 ].lastNum ];
  labelh[1].text = "Health: " + hpPerLevel[ (int)textLevel[ 1 ].lastNum ];
}
    
void loadSelectedDecks(File selection) {
  if (selection != null) {  
    DecksFileName = selection.getAbsolutePath();
    loadDecks(DecksFileName, true, null);
    decks.scroll = 0;
  }
}
    
void loadDecks(String FileName, boolean load, String decksList[])
{
  try
  {   
    File f = new File(FileName);
    if(!f.exists()) 
    {
      PrintWriter writer = new PrintWriter(FileName, "UTF-8");
      for( int i = 0; i < decksList.length; ++ i )
      {
        writer.println(decksList[i]);
      }
      writer.close();
    }
    
    if (load) {
      savedDecks.clear();
      decks.listItems.clear();
      BufferedReader br = createReader(FileName);
      Deck d = new Deck();
      int i = 0;
      br.readLine(); br.readLine(); br.readLine();
      for (String line; (line = br.readLine()) != null; ) 
      {
        if( line.length() < 1 )
        {
          //println("!" + d + " " + d.name );
          savedDecks.add( d );
          decks.listItems.add( d.name );
          d = new Deck();
          i = 0;
          continue;
        }
        if( i == 0 )
        {
          d.name = line;
        }
        else if( i == 1 && isNumeric( line ) )
        {
          d.level = Integer.parseInt( line );
        }
        else if( line.substring( 0, Math.min( line.length(), 6 ) ).toLowerCase().equals( "rune: " ) )
        {
          Rune r = runeFromString( line );
          if( r != null )
            d.runes[ d.numRunes ++ ] = r; 
        }
        else
        {
         // if( line.indexOf( '[' ) > 0 )
         //   line = line.substring( 0, line.indexOf( '[' ) - 1 );
          Card c = cardFromString( line );
          if( c != null )
            d.cards[ d.numCards ++ ] = c;
        }
        ++ i;
      }
      br.close();
    }
  }
  catch( Exception e )
  {
    println(e);
  }
}
