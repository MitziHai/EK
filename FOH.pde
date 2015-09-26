/*
EkClient client = new EkClient();
  Map<String, Card> cardMap = client.getServerCards(server);
  Map<String, Skill> skillMap = client.getServerSkills(server);
  Map<String, Rune> runeMap = client.getServerRunes(server);
  LeagueData leagueData = client.getLeagueData(server);

  FoHPrinter fohPrinter = FoHPrinterFactory.getFoHPrinter("MITZI"); 
  
  fohPrinter.setGameInfo(cardMap, skillMap, runeMap);
  fohPrinter.setEvoNames(evoNames);
  
  String decks = fohPrinter.printDeck(leagueData);
  
  */
  LeagueData leagueData;
  Map<String, servconn.dto.card.Card> cardMap;
  Map<String, Skill> skillMap;
  Map<String, servconn.dto.rune.Rune> runeMap;
  
void FOH()
{
  String PlayerAvatar[] = new String[8];
  int loosers = 0;

  try
  {
    
    radall.checked = true;
    raddi.checked = radkw.checked = radhydra.checked = radew.checked = radewboss.checked = false;
    listresult.listItems.clear();
    listresult.listItems.add( "Downloading decks and match info for server " + servers.listItems.get(servers.currentIndex));
    EkClient client = new EkClient();
    skillMap = client.getServerSkills(servers.listItems.get(servers.currentIndex).toLowerCase());
    cardMap = client.getServerCards(servers.listItems.get(servers.currentIndex).toLowerCase());
    runeMap = client.getServerRunes(servers.listItems.get(servers.currentIndex).toLowerCase());
    leagueData = client.getLeagueData(servers.listItems.get(servers.currentIndex).toLowerCase());


//    ArenaDeckUtils adu = new ArenaDeckUtils("mitzitest@danj.com", "deh206", servers.listItems.get(servers.currentIndex).toLowerCase());
//    adu.setEvoNames(evoNames); // This is your evonames, we had used it before
//    adu.setStart(1); //download from this rank, default:1
//    adu.setAmount(10);//amount of decks to be downloaded, default & max 100
//    String decks = adu.printArenaDecks();
//    println(decks);
    
    

    


    FOHRound = leagueData.getData().getLeagueNow().getRoundNow();
    for (int i=0;i<8;i++) 
      {
        PlayerNames[i].text = leagueData.getData().getLeagueNow().getRoundResult().get(0).get(i).getBattleInfo().getUser().getNickName();
        PlayerAvatar[i] = leagueData.getData().getLeagueNow().getRoundResult().get(0).get(i).getBattleInfo().getUser().getAvatar();
        picPlayerAvatar[ i ].img = loadImage( "PhotoCards\\img_photoCard_" + PlayerAvatar[i] + ".PNG" ) ;
        picPlayerAvatar[i].tint = 255;
        BetData[0][i].text = "";
        if (FOHRound == 1)
          BetData[0][i].text = "Odds: " + leagueData.getData().getLeagueNow().getRoundResult().get(0).get(i).getBetOdds() + "\nTotal " + nfc(Float.parseFloat(leagueData.getData().getLeagueNow().getRoundResult().get(0).get(i).getBetTotal()),0);
        else if (FOHRound == 2) {
          if (!PlayerNames[i].text.equals(leagueData.getData().getLeagueNow().getRoundResult().get(1).get(i/2).getBattleInfo().getUser().getNickName())) {
            picPlayerAvatar[ i ].tint = 50;
            loosers++;
          }
          else {
            BetData[0][i].text = "Odds: " + leagueData.getData().getLeagueNow().getRoundResult().get(1).get(i-loosers).getBetOdds() + "\nTotal " + nfc(Float.parseFloat(leagueData.getData().getLeagueNow().getRoundResult().get(1).get(i-loosers).getBetTotal()),0);
          }
        }
        else if (FOHRound == 3) {
          if (!PlayerNames[i].text.equals(leagueData.getData().getLeagueNow().getRoundResult().get(2).get(i/4).getBattleInfo().getUser().getNickName())) {
            picPlayerAvatar[ i ].tint = 50;
            loosers++;
          }
          else {
            BetData[0][i].text = "Odds: " + leagueData.getData().getLeagueNow().getRoundResult().get(2).get(i-loosers).getBetOdds() + "\nTotal " + nfc(Float.parseFloat(leagueData.getData().getLeagueNow().getRoundResult().get(2).get(i-loosers).getBetTotal()),0);
          }
        }

      }
    
   // RoundNow = leagueData.getData().getLeagueNow().getRoundNow();
    
    listresult.listItems.add("Current Round: " + FOHRound);
    

    FOHDownload = true;
    listresult.listItems.add( "Success. Data downloaded for Server: "+ servers.listItems.get(servers.currentIndex)+". Press Go to Sim.");
  }
  catch(Exception e)
  {
    listresult.listItems.add( "Unsuccesful donwload please see log.txt for details");
    println(e);
  }      
}


void FOH_RUN()
{
  FOHSim = true;
  if (FOHRound == 1) FOHMatch = 4;
  else if (FOHRound == 2) FOHMatch = 2;
  else FOHMatch = 1;
  new Thread(new RunSim()).start();
}

Deck deckFromFOH( int round, int match, int player, boolean clear )
{
  String line ="";
  String evo;
  try {
    BattleInfo battleInfo;
  
    battleInfo = leagueData.getData().getLeagueNow().getRoundResult().get(round-1).get(match*2+player).getBattleInfo();
    List<servconn.dto.league.Card> cardList = battleInfo.getCards();
    List<servconn.dto.league.Rune> runeList = battleInfo.getRunes();
  
    Deck d = new Deck();
    d.name = battleInfo.getUser().getNickName();

    FoHPrinter fohPrinter = FoHPrinterFactory.getFoHPrinter("MITZI"); 
  
    fohPrinter.setGameInfo(cardMap, skillMap, runeMap);
    fohPrinter.setEvoNames(evoNames);
    

    for (servconn.dto.league.Card cardRef : cardList) {
      servconn.dto.card.Card card = cardMap.get(cardRef.getCardId());
      //Card c = cardFromString(card.getCardName()+";"+cardRef.Level)
      line = card.getCardName().trim().replaceAll("[\\p{C}\\p{Z}]", " ").replace("(","[").replace(")","]") + ";" + cardRef.getLevel();
      if (Integer.parseInt(cardRef.getEvolution()) > 0) {
        if (Integer.parseInt(cardRef.getLevel()) < Integer.parseInt(cardRef.getEvolution())+10) {
          line += ";" + ((int)((Integer.parseInt(cardRef.getEvolution())+1)/2));
        }
        evo = skillMap.get(cardRef.getSkillNew()).getName();
        evo = evo.replace("Quick Strike","QS");
        evo = evo.replace("Desperation","D");
        if (evo.lastIndexOf(" ") != -1 && evo.substring(evo.lastIndexOf(" ")+1).matches("\\d+$")) line += ";" + evoNames.get(evo.substring(0,evo.lastIndexOf(" "))) + evo.substring(evo.lastIndexOf(" ")+1);
        else line += ";" + evoNames.get(evo) + 1;
      }
      Card c = cardFromString( line );
      if( c == null && line.length() > 0 )
      {
        listresult.listItems.add( "Invalid card: " + line );
        return null;
      }
      else if( c != null )
      {
        d.cards[ d.numCards ++ ] = c;
      }
    }
    for (servconn.dto.league.Rune runeRef : runeList) {
      servconn.dto.rune.Rune rune = runeMap.get(runeRef.getRuneId());
      line = "Rune: " + rune.getRuneName() + ";" + runeRef.getLevel();
      Rune r = runeFromString( line );
      if( r == null && line.length() > 0 )
      {
        listresult.listItems.add( "Invalid rune: " + line );
        return null;
      }
      else if( r != null )
      {
        d.runes[ d.numRunes ++ ] = r;
      }
    }
    d.level = Integer.parseInt(battleInfo.getUser().getLevel());
    return d;
  }
  catch(Exception e)
  {
    listresult.listItems.add( "Unsuccesful deck creation please see log.txt for details");
    println(e);
    return null;
  }      
}