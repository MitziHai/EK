Boolean ArenaDownload;
String ArenaDecks = "";
int ArenaDecksDownloaded = 0;
  
    
void GetArenaDecks()
{
 //<>//
  try
  {
    
    EkClient client = new EkClient();
    skillMap = client.getServerSkills(servers.listItems.get(servers.currentIndex).toLowerCase());
    cardMap = client.getServerCards(servers.listItems.get(servers.currentIndex).toLowerCase());
    runeMap = client.getServerRunes(servers.listItems.get(servers.currentIndex).toLowerCase());
    leagueData = client.getLeagueData(servers.listItems.get(servers.currentIndex).toLowerCase());
    ArenaDeckUtils adu;
    switch (servers.listItems.get(servers.currentIndex)) {
      case "Fury" :
        adu = new ArenaDeckUtils("mitzitest@danj.com", "deh206", servers.listItems.get(servers.currentIndex).toLowerCase());
        break;
      case"Serenity" :
        adu = new ArenaDeckUtils("MitziSerenity@Arena.Account", "1$Mitzi$1", servers.listItems.get(servers.currentIndex).toLowerCase());
        break;
      case"Legacy" :
        adu = new ArenaDeckUtils("jlg@gmail.com", "doomed", servers.listItems.get(servers.currentIndex).toLowerCase());
        break;
      case"Destiny" :
        adu = new ArenaDeckUtils("k.c.dol@hotmail.com", "emin3m", servers.listItems.get(servers.currentIndex).toLowerCase());
        break;
      case "Harmony" :
        adu = new ArenaDeckUtils("schnielsen@gmail.com", "jo210490", servers.listItems.get(servers.currentIndex).toLowerCase());
        break;
      default:
        listresult.listItems.add( "Server " + servers.listItems.get(servers.currentIndex) + " no account. Please pm MitzHai if you have an account you can share on this server");
        return;
    }
    adu.setEvoNames(evoNames); // This is your evonames, we had used it before
    adu.setStart(Integer.parseInt(textStartRank.text)); //download from this rank, default:1
    adu.setAmount(Integer.parseInt(textEndRank.text) - Integer.parseInt(textStartRank.text) + 1);//amount of decks to be downloaded, default & max 100
    ArenaDecks = adu.printArenaDecks();
   }
  catch(Exception e)
  {
    listresult.listItems.add( "Unsuccesful donwload please see log.txt for details");
    println(e);
  }      
  ArenaDownload = true;
  ArenaDecksDownloaded = 1;
  listArenaOpponents.listItems.clear();
  String[] deckList = ArenaDecks.split("\n");
  listArenaOpponents.listItems.add(deckList[0]);
  Boolean NextDeck = false;
  for (String line : deckList) {
    if (line.length() == 1) NextDeck = true;
    else {
      if (NextDeck == true) {
        listArenaOpponents.listItems.add(line);
        ArenaDecksDownloaded++;
      }
      NextDeck = false;
    }
  } 
  listresult.listItems.add( "Success. Data downloaded for Server: "+ servers.listItems.get(servers.currentIndex)+". Press Go to Sim.");
}

void populateArenaDeck(int deck)
{
  int TheDonCount = 0;
  int DragonSummonerCount = 0;
  int SwampRiderCount = 0;
  int BehemothCount = 0;
  int ThunderDragonCount = 0;
  String[] deckList = ArenaDecks.split("\n");
  listArenaDecks.listItems.clear();
  int CurrentDeck = 0;
  int CurrentLine = 0;
  for (String line : deckList) {
    CurrentLine++;
    if (line.length() == 1) {
      CurrentDeck++;
      CurrentLine = 0;
    }
    else if (CurrentLine == 2 && CurrentDeck == deck) {
      ArenaOpponentLeval.text = "Level: " + line;
    }
    else if (CurrentLine > 2  && CurrentDeck == deck) {
      if (line.contains("The Don")) TheDonCount++;
      if (line.contains("Dragon Summoner")) DragonSummonerCount++;
      if (TheDonCount > 0 && line.contains("Swamp Rider;10;0") && SwampRiderCount < 2*TheDonCount) SwampRiderCount++;
      else if (TheDonCount > 0 && line.contains("Behemoth;10;0") && BehemothCount < TheDonCount) BehemothCount++;
      else if (DragonSummonerCount > 0 && line.contains("Thunder Dragon;10;0") && ThunderDragonCount < DragonSummonerCount) ThunderDragonCount++;
      else listArenaDecks.listItems.add(line.substring(0,line.length() - 1));
    }
  }
}



Deck deckFromArena( int opponent )
{
  String evo;
  String[] deckList = ArenaDecks.split("\n");
  int CurrentLine = 0;
  int CurrentDeck = 0;
  int TheDonCount = 0;
  int DragonSummonerCount = 0;
  int SwampRiderCount = 0;
  int BehemothCount = 0;
  int ThunderDragonCount = 0;

  Deck d = new Deck();

  for (String line : deckList) {
    CurrentLine++;
    if (line.length() == 1) {
      CurrentDeck++;
      CurrentLine = 0;
    }
    else if (CurrentLine == 1 && CurrentDeck == opponent) {
       d.name = line.substring(0,line.length() - 1);
;
    }
    else if (CurrentLine == 2 && CurrentDeck == opponent) {
      d.level = Integer.parseInt(line.substring(0,line.length() - 1).replaceAll("\\s",""));
    }
    else if (CurrentLine > 2  && CurrentDeck == opponent) {
      if (line.contains("The Don")) TheDonCount++;
      if (line.contains("Dragon Summoner")) DragonSummonerCount++;
      if (TheDonCount > 0 && line.contains("Swamp Rider;10;0") && SwampRiderCount < 2*TheDonCount) SwampRiderCount++;
      else if (TheDonCount > 0 && line.contains("Behemoth;10;0") && BehemothCount < TheDonCount) BehemothCount++;
      else if (DragonSummonerCount > 0 && line.contains("Thunder Dragon;10;0") && ThunderDragonCount < DragonSummonerCount) ThunderDragonCount++;
      else if (line.contains("Rune: ")) {
        Rune r = runeFromString( line.substring(0,line.length() - 1) );
        if( r == null && line.length() > 0 )
        {
          listresult.listItems.add( "Invalid rune: " + line.substring(0,line.length() - 1) );
          return null;
        }
        else if( r != null )
        {
          d.runes[ d.numRunes ++ ] = r;
        }
      }
      else {
        Card c = cardFromString( line.substring(0,line.length() - 1).replaceAll("[\\p{C}\\p{Z}]", " ") );
        if( c == null && line.length() > 0 )
        {
          listresult.listItems.add( "Invalid card: " + line.substring(0,line.length() - 1) );
          return null;
        }
        else if( c != null )
        {
          d.cards[ d.numCards ++ ] = c;
        }
      }
    }
  }
  return d;
}