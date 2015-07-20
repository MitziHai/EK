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
  
void GetCardListDifferences()
{
  try
  {
    
    radall.checked = true;
    raddi.checked = radew.checked = radewboss.checked = radkw.checked = radhydra.checked = false;
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
    
    
    String faction = "";
    String hp = "";
    String atk = "";
    String skill1 = "";
    String skill2 = "";
    String skill3 = "";
    String skill4 = "";
    String skill5 = "";
    for (servconn.dto.card.Card card: cardMap.values()) {
      if (card.getRace().equals("1"))  faction = "Tundra";
      else if (card.getRace().equals("2"))  faction = "Forest";
      else if (card.getRace().equals("3"))  faction = "Swamp";
      else if (card.getRace().equals("4"))  faction = "Mountain";
      else if (card.getRace().equals("97"))  faction = "Demon";
      else if (card.getRace().equals("100"))  faction = "Demon";
      else faction = "Special";
      hp = card.getHpArray().toString();
      atk = card.getAttackArray().toString();
      
      if (!card.getSkill().equals("") && !card.getSkill().equals("8106")) skill1 = skillMap.get(card.getSkill()).getName().trim();
      else skill1 = " ";

      if (card.getLockSkill1().equals("") || card.getLockSkill1().equals("1905")) {
        skill2 = " ";
        skill5 = " ";
      }
      else if (!card.getLockSkill1().contains("_")) {
        skill2 = skillMap.get(card.getLockSkill1()).getName().trim();
        skill5 = " ";
      }
      else {
        skill2 = skillMap.get(card.getLockSkill1().substring(0,card.getLockSkill1().indexOf("_"))).getName().trim();
        if (card.getLockSkill1().substring(card.getLockSkill1().indexOf("_")+1,card.getLockSkill1().length()).equals("10344")) skill5 = "";
        else skill5 = skillMap.get(card.getLockSkill1().substring(card.getLockSkill1().indexOf("_")+1,card.getLockSkill1().length())).getName().trim();
      }
      if (card.getLockSkill2().equals("") || card.getLockSkill2().equals("1906") || card.getLockSkill2().equals("1903")) {
        skill3 = " ";
        skill4 = " ";
      }
      else if (!card.getLockSkill2().contains("_")) {
        skill3 = skillMap.get(card.getLockSkill2()).getName().trim();
        skill4 = " ";
      }
      else {
        skill3 = skillMap.get(card.getLockSkill2().substring(0,card.getLockSkill2().indexOf("_"))).getName().trim();
        skill4 = skillMap.get(card.getLockSkill2().substring(card.getLockSkill2().indexOf("_")+1,card.getLockSkill2().length())).getName().trim();
      }
      skill1 = skill1.replace("Desperation: ", "D:");
      skill1 = skill1.replace("Desperation: Reanimation", "D: Reanimation");
      skill1 = skill1.replace("Desperation: Destroy", "D: Destroy");
      skill1 = skill1.replace("Quick Strike:", "QS:");
      skill1 = skill1.replace("[Quick Strike]", "QS: ");
      if (skill1.equals("Core of Magic") || skill1.equals("X'mas Elf") || skill1.equals("Lavish Dinner") || skill1.equals("X'mas Atmosphere") || skill1.equals("X'mas Magic") || skill1.equals("Force of Flame") || 
          skill1.equals("Spirit of Evilness") || skill1.equals("Ancient Meteorite") || skill1.equals("Remains of Dragon") || skill1.equals("Unexpected gains") || skill1.equals("Source of Life") || skill1.equals("Legendary Wood") || 
          skill1.equals("X'mas Bell") || skill1.equals("X'mas Hat") || skill1.equals("Call of the Wanderer") || skill1.equals("Lucky Clover") || skill1.equals(" ")
          ) skill1 = "None";
      skill2 = skill2.replace("Desperation: Destroy", "D: Destroy");
      skill2 = skill2.replace("Desperation: Reanimation", "D: Reanimation");
      skill2 = skill2.replace("Desperation: ", "D:");
      skill2 = skill2.replace("Quick Strike:", "QS:");
      skill2 = skill2.replace("[Quick Strike]", "QS: ");
      if (skill2.equals("Core of Magic") || skill2.equals("X'mas Elf") || skill2.equals("Lavish Dinner") || skill2.equals("X'mas Atmosphere") || skill2.equals("X'mas Magic") || skill2.equals("Force of Flame") || 
          skill2.equals("Spirit of Evilness") || skill2.equals("Ancient Meteorite") || skill2.equals("Remains of Dragon") || skill2.equals("Unexpected gains") || skill2.equals("Source of Life") || skill2.equals("Legendary Wood") || 
          skill2.equals("X'mas Bell") || skill2.equals("X'mas Hat") || skill2.equals("Call of the Wanderer") || skill2.equals("Lucky Clover") || skill2.equals(" ")
          ) skill2 = "None";
      skill3 = skill3.replace("Desperation: Destroy", "D: Destroy");
      skill3 = skill3.replace("Desperation: Reanimation", "D: Reanimation");
      skill3 = skill3.replace("Desperation: ", "D:");
      skill3 = skill3.replace("Quick Strike:", "QS:");
      skill3 = skill3.replace("[Quick Strike]", "QS: ");
      if (skill3.equals("Core of Magic") || skill3.equals("X'mas Elf") || skill3.equals("Lavish Dinner") || skill3.equals("X'mas Atmosphere") || skill3.equals("X'mas Magic") || skill3.equals("Force of Flame") || 
          skill3.equals("Spirit of Evilness") || skill3.equals("Ancient Meteorite") || skill3.equals("Remains of Dragon") || skill3.equals("Unexpected gains") || skill3.equals("Source of Life") || skill3.equals("Legendary Wood") || 
          skill3.equals("X'mas Bell") || skill3.equals("X'mas Hat") || skill3.equals("Call of the Wanderer") || skill3.equals("Lucky Clover") || skill3.equals(" ")
          ) skill3 = "None";
      skill4 = skill4.replace("Desperation: Destroy", "D: Destroy");
      skill4 = skill4.replace("Desperation: Reanimation", "D: Reanimation");
      skill4 = skill4.replace("Desperation: ", "D:");
      skill4 = skill4.replace("Quick Strike:", "QS:");
      skill4 = skill4.replace("[Quick Strike]", "QS: ");
      if (skill4.equals("Core of Magic") || skill4.equals("X'mas Elf") || skill4.equals("Lavish Dinner") || skill4.equals("X'mas Atmosphere") || skill4.equals("X'mas Magic") || skill4.equals("Force of Flame") || 
          skill4.equals("Spirit of Evilness") || skill4.equals("Ancient Meteorite") || skill4.equals("Remains of Dragon") || skill4.equals("Unexpected gains") || skill4.equals("Source of Life") || skill4.equals("Legendary Wood") || 
          skill4.equals("X'mas Bell") || skill4.equals("X'mas Hat") || skill4.equals("Call of the Wanderer") || skill4.equals("Lucky Clover") || skill4.equals(" ")
          ) skill4 = "None";
      hp = card.getHpArray().toString();
      hp = hp.substring(1,hp.length()-1);
      atk = card.getAttackArray().toString();
      atk = atk.substring(1,atk.length()-1);     
      String CardName = card.getCardName().trim().replaceAll("[\\p{C}\\p{Z}]", " ").replace("(","[").replace(")","]");
        println("\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","   + skill5.replace("None"," ") + ","  + 
          hp + ","  + atk + "\",");
//println(CardName);
//      if(!cardsMap.containsKey(CardName))
//        println("NAME:\n\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","  + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (Integer.parseInt(card.getCost()) != cardsMap.get(CardName).cost)
//        println("COST:\n\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","  + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (Integer.parseInt(card.getColor()) !=cardsMap.get(CardName).stars)
//        println("STARS:\n\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","  + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (!faction.equals(cardsMap.get(CardName).faction == FOREST ? "Forest": 
//                cardsMap.get(CardName).faction == SWAMP ? "Swamp" : 
//                cardsMap.get(CardName).faction == TUNDRA ? "Tundra" : 
//                cardsMap.get(CardName).faction == MOUNTAIN ? "Mountain" : 
//                cardsMap.get(CardName).faction == DEMON ? "Demon" : "Special"))
//        println("FACTION:\n\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","  + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (Integer.parseInt(card.getWait()) != cardsMap.get(CardName).timer)
//        println("TIMER:\n\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","  + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (!skill1.equals(abilityName.get(cardsMap.get(CardName).abilities[0]) + 
//              ( !Character.isDigit(skill1.charAt(skill1.length() - 1)) ? "" : " " + cardsMap.get(CardName).abilityL[0])))
//        println("SKILL1:" + skill1 + " " + abilityName.get(cardsMap.get(CardName).abilities[0]) + " " + cardsMap.get(CardName).abilityL[0] + "\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","   + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (!skill2.equals(abilityName.get(cardsMap.get(CardName).abilities[1]) + 
//              (!Character.isDigit(skill2.charAt(skill2.length() - 1)) ? "" : " " + cardsMap.get(CardName).abilityL[1])))
//        println("skill2:" + skill2 + " " +abilityName.get(cardsMap.get(CardName).abilities[1]) + " " + cardsMap.get(CardName).abilityL[1] + "\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","  +  skill5.replace("None"," ") + ","  +
//          hp + ","  + atk + "\",");
//      else if (!skill3.equals(abilityName.get(cardsMap.get(CardName).abilities[2]) + 
//              (!Character.isDigit(skill3.charAt(skill3.length() - 1)) ? "" : " " + cardsMap.get(CardName).abilityL[2])))
//        println("skill3:" + skill3 + " " +abilityName.get(cardsMap.get(CardName).abilities[2]) + " " + cardsMap.get(CardName).abilityL[2] + "\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","   + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (!skill4.equals(abilityName.get(cardsMap.get(CardName).abilities[3]) + 
//              (!Character.isDigit(skill4.charAt(skill4.length() - 1)) ? "" : " " + cardsMap.get(CardName).abilityL[3])))
//        println("skill4:" + skill4 + " " +abilityName.get(cardsMap.get(CardName).abilities[3]) + " " + cardsMap.get(CardName).abilityL[3] + "\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","   + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (!hp.equals(Arrays.toString(cardsMap.get(CardName).hp).replace("[","").replace("]","")))
//        println("hp:" + "\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","   + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
//      else if (!atk.equals(Arrays.toString(cardsMap.get(CardName).atk).replace("[","").replace("]","")))
//        println("atk:" + "\"" + CardName + "," + card.getCost() + "," + card.getColor() + "," + faction + "," + card.getWait()  + "," + skill1.replace("None"," ") + "," + skill2.replace("None"," ") + "," + skill3.replace("None"," ") + "," + skill4.replace("None"," ") + ","   + skill5.replace("None"," ") + ","  + 
//          hp + ","  + atk + "\",");
    }
  }
  catch(Exception e)
  {
    listresult.listItems.add( "Unsuccesful donwload please see log.txt for details");
    println(e);
  }      
}
  
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
      line = card.getCardName() + ";" + cardRef.getLevel();
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

