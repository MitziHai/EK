
ArrayList< Control > uiDeck = new ArrayList< Control >();
ArrayList< Control > uiHelp = new ArrayList< Control >();
ArrayList< Control > uiCard = new ArrayList< Control >();
ArrayList< Control > uiResults = new ArrayList< Control >();
ArrayList< Control > uiSettings = new ArrayList< Control >();
ArrayList< Control > uiFOH = new ArrayList< Control >();
ArrayList< Control > uiTabs = new ArrayList< Control >();
ArrayList< Control > ui = uiDeck;
TextField selectedText = null;
ListBox selectedList = null;
DropList droppedList = null;
ListBox draggedList = null;

static final int BUTTON_ADD_CARD_1 = 1;
static final int BUTTON_ADD_CARD_2 = 2;
static final int BUTTON_REMOVE_CARD_1 = 3;
static final int BUTTON_REMOVE_CARD_2 = 4;
static final int BUTTON_SAVE_1 = 5;
static final int BUTTON_SAVE_2 = 6;
static final int BUTTON_LOAD_1 = 7;
static final int BUTTON_LOAD_2 = 8;
static final int BUTTON_DELETE = 9;
static final int SEARCH_TEXT = 10;
static final int SEARCH_FACTION = 11;
static final int SEARCH_STAR = 12;
static final int SEARCH_RUNE = 13;
static final int SEARCH_CARD = 14;
static final int TEXT_LEVEL_1 = 15;
static final int TEXT_LEVEL_2 = 16;
static final int BUTTON_GO = 17;
static final int BUTTON_REMOVE_ALL_1 = 18;
static final int BUTTON_REMOVE_ALL_2 = 19;
static final int TAB1 = 20;
static final int TAB2 = 21;
static final int TAB3 = 22;
static final int TEXT_TIME = 23;
static final int TEXT_COST = 24;
static final int TEXT_NAME = 25;
static final int BUTTON_ADD_ABILITY_1 = 26;
static final int BUTTON_ADD_ABILITY_2 = 27;
static final int BUTTON_ADD_ABILITY_3 = 28;
static final int BUTTON_ADD_ABILITY_4 = 29;
static final int BUTTON_SAVE_CARD = 30;
static final int BUTTON_SAVE_CARDS = 31;
static final int BUTTON_LOAD_CARD = 32;
static final int BUTTON_CARD_FILL = 33;
static final int BUTTON_ABILITY_CLEAR = 34;
static final int TAB4 = 35;
static final int TAB5 = 36;
static final int BUTTON_LOAD_DECKS = 37;
static final int BUTTON_PAUSE = 38;
static final int BUTTON_CONVERT = 39;
static final int BUTTON_GET_FOH_DECKS = 40;
static final int TAB6 = 41;
static final int SERVER_SELECT = 42;
static final int NUMBER_RUNS = 43;
static final int BUTTON_SAVERESULTS = 44;
static final int BUTTON_CARDDIFF = 45;
static final int BUTTON_ADD_ABILITY_5 = 46;

PImage imgHpAtkNum[] = new PImage[10];
PImage imgCostNum[] = new PImage[10];
PImage imgIcons[] = new PImage[5];
PImage imgButton1;
PImage imgButton2;
PImage imgButtonLarge;
PImage imgTab[] = new PImage[2];
PImage imgDropList[] = new PImage[3];
PImage imgBackground;
PImage imgCheckbox[] = new PImage[2];
PImage imgRadio[] = new PImage[2];
PImage imgTextField[] = new PImage[4];
PImage imgFrame[] = new PImage[2];
PImage imgScroll;
PImage imgSelected[] = new PImage[2];

boolean cardMatch(String s, String sf )
{
  return s.toLowerCase().contains( sf.toLowerCase() )
    || sf.length() < 1
    || sf.equals("");
}


void filterEvos( boolean stricter )
{
  evoList.scroll = cards.scrollStart = 0;
  // If the filters are only stricter than previous (text only), filter the current list instead of starting a new list.
  evoList.listItems.clear();
    evoList.listItems.add( "None" );
  for ( String s : evoNames.keySet() )
    if (evoNamesEvo.get(s) || !checkEvo.checked) evoList.listItems.add( s + " (" + evoNames.get(s) + ")" );

}

void filterCards( boolean stricter )
{
  cards.scroll = cards.scrollStart = 0;
  // If the filters are only stricter than previous (text only), filter the current list instead of starting a new list.
  if ( stricter )
  {
    ArrayList< String > oldList = new ArrayList< String >(cards.listItems);
    cards.listItems.clear();
    for ( String s : oldList )
    {
      if ( s.contains( searchf.text ) || searchf.text.length() < 1 || searchf.text == "" )
      {
        cards.listItems.add( s );
      }
    }
  }
  else
  {
    cards.listItems.clear();
    Card enteredCard = cardFromString( searchf.textIn );

    if ( cardsCheck.checked )
    {
      Iterator it = cardsMap.entrySet().iterator();
      while (it.hasNext ())
      {
        Map.Entry pairs = (Map.Entry)it.next();
        CardType c = (CardType)pairs.getValue();
        if ( stars.currentIndex == 0 || c.stars == 6 - stars.currentIndex )
        {
          if ( faction.currentIndex == 0 || c.faction == faction.currentIndex - 1 )
          {
            boolean matchedByInitials = ( enteredCard != null && c.name.equals( enteredCard.type.name ) );
            if ( levels.currentIndex == 0 )
            {
              String s = c.name + ";10";
              //println(s + " " + searchf.text + " " + s.contains( searchf.textIn ) );
              if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                cards.listItems.add(s);
            }
            else if ( levels.currentIndex == 1 )
            {
              String s = c.name + ";0";
              //println(s + " " + searchf.text + " " + s.contains( searchf.textIn ) );
              if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                cards.listItems.add(s);
            }
            else if ( levels.currentIndex == 2 )
            {
              String s = c.name + ";4";
              //println(s + " " + searchf.text + " " + s.contains( searchf.textIn ) );
              if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                cards.listItems.add(s);
            }
            else if ( levels.currentIndex == 3 )
            {
              String s = c.name + ";5";
              if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                cards.listItems.add(s);
            }
            else if ( levels.currentIndex == 4 )
            {
              String s = c.name + ";10";
              if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                cards.listItems.add(s);
            }
            else if ( levels.currentIndex == 5 )
            {
              String s = c.name + ";15";
              if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                cards.listItems.add(s);
            }
            else if ( levels.currentIndex == 6 )
            {
              for ( int i = 10; i <= 15; ++ i )
              {
                String s = c.name + ";" + i;
                if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                  cards.listItems.add(s);
              }
            }
            else if ( levels.currentIndex == 7 )
            {
              for ( int i = 0; i <= 15; ++ i )
              {
                String s = c.name + ";" + i;
                if ( cardMatch( s, searchf.textIn ) || matchedByInitials )
                  cards.listItems.add(s);
              }
            }
          }
        }
      }
    }
    if ( runesCheck.checked )
    {
      Iterator it = runesMap.entrySet().iterator();
      while (it.hasNext ())
      {
        Map.Entry pairs = (Map.Entry)it.next();
        RuneType r = ((RuneType)pairs.getValue());
        if ( stars.currentIndex == 0 || r.stars == stars.currentIndex )
        {
          if ( levels.currentIndex == 7 )
          {
            for ( int i = 0; i <= 4; ++ i )
            {
              String s = "Rune: " + r.name + ";"+i;
              if ( s.toLowerCase().contains( searchf.textIn.toLowerCase() ) || searchf.text.length() < 1 || searchf.text.equals("") )
              {
                cards.listItems.add(s);
              }
            }
          }
          else if ( levels.currentIndex == 1 )
          {
            String s = "Rune: " + r.name + ";0";
            if ( s.toLowerCase().contains( searchf.textIn.toLowerCase() ) || searchf.text.length() < 1 || searchf.text.equals("") )
              cards.listItems.add(s);
          }
          else //if ( levels.currentIndex == 2 )
          {
            String s = "Rune: " + r.name + ";4";
            if ( s.toLowerCase().contains( searchf.textIn.toLowerCase() ) || searchf.text.length() < 1 || searchf.text.equals("") )
              cards.listItems.add(s);
          }
        }
      }
    }
  }
  cards.current.clear();
  if ( cards.listItems.size() > 0 ) cards.current.add( 0 );
}

ArrayList< Deck > savedDecks = new ArrayList< Deck >();
Deck deckp1 = new Deck();
Deck deckp2 = new Deck();

Control fohDeck;
Control fohPlayer;
Control fohLevel;
Control fohDeckCost;
Control fohInitativeCost;
Control fohHealth;

ListBox cards;
ListBox deckList[] = new ListBox[2];
Control search;
TextField searchf;
Checkbox runesCheck;
Checkbox cardsCheck;
DropList faction;
DropList stars;
DropList levels;
DropList listThreads;
TextField textLevel[] = new TextField[2];
TextField textdeck[] = new TextField[2];
ListBox decks;
RadioButton radall;
RadioButton raddi;
RadioButton radkw;
RadioButton radew;
RadioButton radewboss;
RadioButton radhydra;
Control labelh[] = new Control[2];
ListBox listresult;
TextField numberRuns;
Control labelc[] = new Control[2];
Checkbox checkMultisim;
Checkbox checkMultisimResults;
Checkbox checkKWDefend;
Checkbox checkEvo;
Checkbox checkSingleThread;
Checkbox checkSetOrder;
Checkbox checkDebug;
ListBox evoList;
DropList ListHydraCard1;
DropList ListHydraCard2;
DropList ListHydraCard3;
DropList servers;
Control labelSetOrder;
TextField textEvo;

DropList listMeritCard1;
DropList listMeritCard2;
Control labelMeritCards;

Picture picPlayerAvatar[] = new Picture[8];
Control PlayerNames[] = new Control[8];
Control BetData[][] = new Control[3][8];

CardType editedCard;
TextField cardHp[] = new TextField[ 16 ];
TextField cardAtk[] = new TextField[ 16 ];
TextField cardName;
TextField cardTime;
TextField cardCost;
DropList cardFaction;
DropList cardStars;
Control cardAbility[] = new Control[5];
Button cardAbilitySet[] = new Button[5];
Checkbox cardLocked;
Button cardLoad;
Button cardSave;
Button cardsSave;
Button butgo;
Button butCardDiff;
Button butConvert;
Button butSaveResults;
Picture pic;
Picture picStars[] = new Picture[5];
Control labelCardName;
Control labelCardCost;
Control labelCardTime;
Control labelCardAttack;
Control labelCardHealth;
Control labelMultiSim;
Control labelKWSim;
Button autofillCard;
Button abilityClear;
TextField textAutofill1;
TextField textAutofill2;

void setupUI()
{
  // Help tab
  //ListBox helpText = new ListBox( "", 32, 32+32, 1280-64, 800-64-32, 0 );
  Control helpText = new Control( "", 32, 32+32, 1280-64, 800-64-32, 0 );
  helpText.font = 14;
  helpText.text =  "Important Information:\n";
  helpText.text += "- In this version I have implemented an initative cost = (Player Health + Sum of Card HP + Sum of Card Atk).\n";
  helpText.text += "- The higher initative determines which player goes first.\n";
  helpText.text += "- In order to make sure demons work properly set your demons player (not card) level to 0 (invulnerable).\n";
  helpText.text += "\n";
  helpText.text +=  "Modes:\n";
  helpText.text += "- Arena results show the win percentage of player one beating player 2.\n";
  helpText.text += "- Demon results shows the minimum, maximum, average, and per minute merit and rounds. Add a demon card to player two. Player 2's level is ignored.\n";
  helpText.text += "- Kingdom War results shows the number of times player one can win against player two without resetting the cards.\n";
  helpText.text += "- Find best deck will try all deck combinations for player one's card list, testing only those which contain the currently selected cards.\n";
  helpText.text += "   More than 10 cards or 4 runes may be entered, but it is very slow.\n";
  helpText.text += "\n";
  helpText.text += "Adding cards to decks\n";
  helpText.text += "- The cards list can be filtered by name, level, stars, faction, and cards or runes at the bottom of the left column.\n";
  helpText.text += "- When typing without a text field selected, typed characters will go to the search field.\n";
  helpText.text += "- Select cards to add to a deck by clicking them. Select multiple cards by holding ctrl or shift.\n";
  helpText.text += "- To add an evolution, select an ability in the evolution list and enter an ability level at the bottom of the second column.\n";
  helpText.text += "- Cards can be added to player one and two by either clicking the add button, dragging the cards, or pressing the one or two key.\n";
  helpText.text += "- To remove a card, either press the remove button, press the delete key, drag it back to the cards list, or drag it into another deck.\n";
  helpText.text += "- Change the player's level at the top of the deck list. The player level for player two is ignored for demon mode. Set level 0 to make a player invulnerable.\n";
  helpText.text += "- To change the evolution of a card in a player's deck, first select the card(s) to change and then double click on an evolution in the list.\n";
  helpText.text += "- To adjust the level of a card in a player's deck, first select the card(s) to adjust and then press the up or down arrow keys.\n";
  helpText.text += "- Press save or drag a player's deck to the deck list to save a deck. Drag a deck to a player or press load to load.\n";
  helpText.text += "\n";
  helpText.text += "Editing Cards\n";
  helpText.text += "- Cards can be edited either by opening cardslist2.txt or by using the card editor tab of this interface.\n";
  helpText.text += "- To edit an existing card, select the card from the cards list and click load.\n";
  helpText.text += "- Save a card by clicking save. Be sure to also save the card list to not lose the changes.\n";
  helpText.text += "- Edit a card's abilities by clicking an ability from the list, entering an ability level at the bottom, and clicking Set to Selected.\n";
  helpText.text += "- To quickly fill the attack and health of a card, enter the stats only for any two levels. Then, enter those two level numbers in the\n";
  helpText.text += "   auto fill section. Clicking the auto fill button will automatically fill out the attack and health for the remaining levels by\n";
  helpText.text += "   extrapolating from the values for the two chosen levels.\n";
  uiHelp.add( helpText );
  
  
  
  
  
  PImage img = loadImage( "numbers.png" );
  imgCostNum = new PImage[10];
  for ( int i = 0; i < 10; ++ i )
  {
    imgCostNum[ i ] = new PImage(i == 0 ? 25 : 24, 29);
    //imgCostNum[ i ].copy( img, (i * 24) + (i > 0 ? 1 : 0), 0, (i == 0 ? 25 : 24), 29, 0, 0, i == 0 ? 25 : 24, 29 );
    imgCostNum[ i ] = img.get( (i * 24) + (i == 1 ? 1 : 0), 0, (i == 0 ? 25 : (i == 1 ? 23 : 24)), 29 );
  }
  imgHpAtkNum = new PImage[10];
  for ( int i = 0; i < 10; ++ i )
  {
    imgHpAtkNum[ i ] = new PImage(i == 0 ? 25 : 24, i == 0 ? 30 : 29);
    //imgHpAtkNum[ i ].copy( img, (i * 24), 68, (i == 0 ? 25 : 24), i == 0 ? 30 : 29, 0, 0, i == 0 ? 25 : 24, i == 0 ? 30 : 29 );
    imgHpAtkNum[ i ] = img.get( (i * 24) + (i == 1 ? 1 : 0), 68, (i == 0 ? 25 : (i == 1 ? 23 : 24)), i == 0 ? 30 : 29 );
  }
  imgIcons = new PImage[5];
  for ( int i = 0; i < 5; ++ i )
  {
    imgIcons[ i ] = new PImage(35, 37);
    imgIcons[ i ].copy( img, 35*i, 29, 35, 37, 0, 0, 35, 37 );
  }
  imgButton1 = loadImage( "button1.png" );
  imgButton2 = loadImage( "button2.png" );
  imgButtonLarge = loadImage( "button_wide.png" );
  imgTab = new PImage[2];
  imgTab[ 0 ] = loadImage( "tab_selected.png" );
  imgTab[ 1 ] = loadImage( "tab_unselected.png" );
  imgDropList = new PImage[3];
  imgDropList[ 0 ] = loadImage( "dropList_large.png" );
  imgDropList[ 1 ] = loadImage( "dropList_small.png" );
  imgDropList[ 2 ] = loadImage( "dropList_dropped.png" );
  imgBackground = loadImage( "background2.png" );
  imgCheckbox = new PImage[2];
  imgCheckbox[ 0 ] = loadImage( "checkbox_checked.png" );
  imgCheckbox[ 1 ] = loadImage( "checkbox_unchecked.png" );
  imgRadio = new PImage[2];
  imgRadio[ 0 ] = loadImage( "radio_checked.png" );
  imgRadio[ 1 ] = loadImage( "radio_unchecked.png" );
  imgTextField = new PImage[4];
  imgTextField[ 0 ] = loadImage( "textField_tiny.png" );
  imgTextField[ 1 ] = loadImage( "textField_small.png" );
  imgTextField[ 2 ] = loadImage( "textField_medium.png" );
  imgTextField[ 3 ] = loadImage( "textField_large.png" );
  imgFrame[ 0 ] = loadImage( "frame_ui.png" );
  imgFrame[ 1 ] = loadImage( "frame_ui_wide.png" );
  imgScroll = loadImage( "scroll.png" );
  imgSelected = new PImage[2];
  imgSelected[ 0 ] = loadImage( "selectedItem.png" );
  imgSelected[ 1 ] = loadImage( "selectedItem2.png" );

  // Tabs
  Button tab1 = new Button( "  Deck Editor", 8, 8, 128, 24, TAB1);
  tab1.isTab = true;
  uiTabs.add(tab1);
  Button tab2 = new Button( "  Card Editor", 144, 8, 128, 24, TAB2);
  tab2.isTab = true;
  uiTabs.add(tab2);
  Button tab3 = new Button( "     Results", 280, 8, 128, 24, TAB3);
  tab3.isTab = true;
  uiTabs.add(tab3);
  Button tab4 = new Button( "     Settings", 416, 8, 128, 24, TAB4);
  tab4.isTab = true;
  uiTabs.add(tab4);
  Button tab5 = new Button( "       FOH", 552, 8, 128, 24, TAB5);
  tab5.isTab = true;
  uiTabs.add(tab5);
  Button tab6 = new Button( "       Help", 688, 8, 128, 24, TAB6);
  tab6.isTab = true;
  uiTabs.add(tab6);

  // Deck editor

  int uiTop = 32;
  int offsetLeft = 0;

  if ( evoTab )
  {
    offsetLeft = 256;

    evoList = new ListBox( "", 256, 16+uiTop, 240, 624 - 32*3 + 8, 0 );
    evoList.listItems.add( "None" );
    for ( String s : evoNames.keySet() )
      if (evoNamesEvo.get(s)) evoList.listItems.add( s + " (" + evoNames.get(s) + ")" );
    evoList.multiselect = false;
    uiDeck.add( evoList );
    uiCard.add( evoList );

    Control labelEvo = new Control( "Evolution level:", 256, evoList.y + evoList.h + 4, 240, 24, 0 );
    uiDeck.add( labelEvo );
    uiCard.add( labelEvo );

    checkEvo = new Checkbox( "Show Only Valid Evos", 256, evoList.y + evoList.h + 8 + 16 + 4+32, 240, 24, 0 );
    checkEvo.checked = true;
    uiDeck.add( checkEvo );
    uiCard.add( checkEvo );

    textEvo = new TextField( "1", 256, evoList.y + evoList.h + 8 + 16 + 4, 240, 24, 0 );
    textEvo.isNumeric = true;
    textEvo.max = 10;
    uiDeck.add( textEvo );
    uiCard.add( textEvo );
  }


  listresult = new ListBox("", 512, 640+16+uiTop, 600+offsetLeft-96, 104, 0);
  uiDeck.add( listresult );
  uiFOH.add( listresult);
  butSaveResults = new Button( "   Save\n Results", 512-96, 640+16+uiTop, 85, 60, BUTTON_SAVERESULTS );
  uiDeck.add( butSaveResults );
  uiFOH.add( butSaveResults);

  Control line = new Control( "--------------------------------------------------------------------------------------------------------------------------------------------", 0, 640+uiTop, width, 24, 0 );
  uiDeck.add( line );
  uiFOH.add( line );

  radall = new RadioButton( "Show Arena Results", 16, line.y+24-6, 200, 24, 0 );
  radall.checked = true;
  uiDeck.add( radall );
  raddi = new RadioButton( "Show Demon Results", 16, line.y+24*2-4, 200, 24, 0 );
  uiDeck.add( raddi );
  radkw = new RadioButton( "Show KW Results", 16, line.y+24*3-2, 200, 24, 0 );
  uiDeck.add( radkw );
  radhydra = new RadioButton( "Show Hydra Results", 16, line.y+24*4, 200, 24, 0 );
  uiDeck.add( radhydra );
  radew = new RadioButton( "Show EW Results", 16+200, line.y+24*3-2, 200, 24, 0 );
  uiDeck.add( radew );
  radewboss = new RadioButton( "Show EWB Results", 16+200, line.y+24*4, 200, 24, 0 );
  uiDeck.add( radewboss );
  radall.setNext = raddi;
  radall.setStart = radall;
  raddi.setNext = radkw;
  raddi.setStart = radall;
  radkw.setNext = radhydra;
  radkw.setStart = radall;
  radhydra.setNext = radew;
  radhydra.setStart = radall;
  radew.setNext = radewboss;
  radew.setStart = radall;
  radewboss.setNext = null;
  radewboss.setStart = radall;
  checkMultisim = new Checkbox( "Find best deck", 230, line.y+24-6, 180, 24, 0 );
  uiDeck.add( checkMultisim );
  labelSetOrder = new Control( "Card Order", 16, uiTop+360, 240, 24, 0 );
  uiSettings.add(labelSetOrder);
  checkSetOrder = new Checkbox( "Play cards in set order", 16, uiTop+390, 240, 24, 0 );
  uiSettings.add( checkSetOrder );


  labelMultiSim = new Control( "Multi Sim Additional Options", 16, uiTop+10, 240, 24, 0 );
  uiSettings.add(labelMultiSim);
  checkMultisimResults = new Checkbox( "Print All Results of Find Best Deck to Logfile", 16, uiTop+40, 240, 24, 0 );
  uiSettings.add( checkMultisimResults );
  labelKWSim = new Control( "Hydra Simulation Options\n   Choose the three event cards you want:\n                    3 *                                    4 *                                5*", 16, uiTop+100, 240, 24, 0 );
  uiSettings.add(labelKWSim);

  labelMeritCards = new Control( "Choose Merit cards for Demon Invasion", 740, uiTop+100, 240, 24, 0 );
  uiSettings.add(labelMeritCards);
  listMeritCard1 = new DropList( "Choose Merit Card 1", 740, uiTop+130, 240, 24, 0 );
  listMeritCard2 = new DropList( "Choose Merit Card 2", 956, uiTop+130, 240, 24, 0 );
  uiSettings.add(listMeritCard1);
  uiSettings.add(listMeritCard2);

 
  Control labelConvertLegacy = new Control( "Convert Old Version Decks", 16, uiTop+220, 240, 24, 0 );
  uiSettings.add(labelConvertLegacy);
  butConvert = new Button( "Convert", 36, uiTop+250, 160, 32, BUTTON_CONVERT );
  butConvert.font = 18;
  butConvert.type = 2;
  uiSettings.add( butConvert );

  Control labelCardDiff = new Control( "Check Card Database Differences", 320, uiTop+220, 240, 24, 0 );
  uiSettings.add(labelCardDiff);
  butCardDiff = new Button( "Check Cards", 340, uiTop+250, 160, 32, BUTTON_CARDDIFF );
  butCardDiff.font = 18;
  butCardDiff.type = 2;
  uiSettings.add( butCardDiff );

  Control labelRunOptions = new Control( "Run Options", 16, uiTop+290, 280, 24, 0 );
  uiSettings.add(labelRunOptions);

  checkDebug = new Checkbox( "Run Debug Mode (also single threaded)", 360, uiTop+320, 240, 24, 0 );
  uiSettings.add( checkDebug );


  
  for ( int i = 0; i < 8; ++ i )
  {
    PlayerNames [i] = new Control("",60+(640*(i>3?1:0)), uiTop+80+(i%4)*136, 64, 64, 0);
    picPlayerAvatar[ i ] = new Picture("test", 64+(640*(i>3?1:0)), uiTop+104+(i%4)*136, 64, 64, 1,loadImage( "PhotoCards\\img_photoCard_0.PNG" ) );
    uiFOH.add( picPlayerAvatar[ i ] );
    uiFOH.add( PlayerNames[ i ] );
    for (int j = 0; j < 3; j++) {
      BetData[j][i] = new Control("",(int)(60+(640*((i>3?1:0)+(i>3?-0.25*j:0.25*j)))), (int)(uiTop+80+((j==2?1.5:j*0.5) +i%4)*136+88), 64, 64, 0);
      BetData[j][i].font = 14;
      uiFOH.add(BetData[j][i]);
    } 
  }

  fohPlayer = new Control("Player: ",900, uiTop+80, 64, 64, 0);
  uiFOH.add(fohPlayer);
  fohLevel = new Control("Level: ",900, uiTop+110, 64, 64, 0);
  uiFOH.add(fohLevel);
  fohHealth = new Control("Health: ",900, uiTop+140, 64, 64, 0);
  uiFOH.add(fohHealth);
  fohInitativeCost = new Control("Initative: ",900, uiTop+170, 64, 64, 0);
  uiFOH.add(fohInitativeCost);
  fohDeckCost = new Control("Deck Cost: ",900, uiTop+200, 64, 64, 0);
  uiFOH.add(fohDeckCost);
  fohDeck = new Control("Deck: ",900, uiTop+240, 64, 64, 0);
  uiFOH.add(fohDeck);

  servers = new DropList( "", 512, uiTop+24, 224, 24, SERVER_SELECT );
  servers.listItems.addAll(Arrays.asList(new String[] {
    "Chaos", "Harmony", "Legacy", "Destiny", "Fury", "Serenity", "Skorn", "Apollo"
  }
  ));
  uiFOH.add(servers);
  
  
  Button butFOHDecks = new Button( "Get FOH Info", 36, line.y+24, 160, 32, BUTTON_GET_FOH_DECKS );
  butFOHDecks.font = 18;
  butFOHDecks.type = 2;
  uiFOH.add( butFOHDecks );

  numberRuns = new TextField(Integer.toString((int)numMatch), 275, line.y+42, 128, 24, NUMBER_RUNS); //( "Go!", 256+64, line.y+32+24, 80, 64, BUTTON_GO );
  numberRuns.isNumeric = true;
  numberRuns.lastNum = numberRuns.num = numMatch;
  numberRuns.max = 1000000;
  uiDeck.add( numberRuns );
  uiFOH.add( numberRuns );
  Control runsLabel = new Control( "Runs:", 226, line.y+42, 128, 32, 0);
  uiDeck.add( runsLabel );
  uiFOH.add (runsLabel);


  cards = new ListBox( "Cards", 16, 16+uiTop, 224, 408, 0 );
  cards.lineSize = 24;
  cards.font = 13.25;
  uiDeck.add( cards );
  uiCard.add( cards );

  search = new Control( "Search:", 16, cards.y+cards.h+8, 224, 32, 0 );
  uiDeck.add( search );
  uiCard.add( search );
  searchf = new TextField( "", 16, cards.y+cards.h+8+32, 224, 24, SEARCH_TEXT );
  uiDeck.add( searchf );
  uiCard.add( searchf );
  runesCheck = new Checkbox( "Show Runes", 16, cards.y+cards.h+8+32*5, 224, 24, SEARCH_RUNE );
  runesCheck.checked = true;
  uiDeck.add( runesCheck );
  uiCard.add( runesCheck );
  cardsCheck = new Checkbox( "Show Cards", 16, cards.y+cards.h+8+32*6, 224, 24, SEARCH_CARD );
  cardsCheck.checked = true;
  uiDeck.add( cardsCheck );
  uiCard.add( cardsCheck );
  faction = new DropList( "", 16, cards.y+cards.h+8+32*4, 224, 24, SEARCH_FACTION );
  faction.listItems.addAll(Arrays.asList(new String[] {
    "All Factions", "Forest", "Swamp", "Tundra", "Mountain", "Demon", "Special"
  }
  ));
  uiDeck.add( faction );
  uiCard.add( faction );
  stars = new DropList( "", 16, cards.y+cards.h+8+32*3, 224, 24, SEARCH_STAR );
  stars.listItems.addAll(Arrays.asList(new String[] {
    "All Stars", "5 Star", "4 Star", "3 Star", "2 Star", "1 Star"
  }
  ));
  uiDeck.add( stars );
  uiCard.add( stars );
  levels = new DropList( "", 16, cards.y+cards.h+8+32*2, 224, 24, SEARCH_STAR );
  levels.listItems.addAll(Arrays.asList(new String[] {
    "Level 10", "Level 0", "Level 4", "Level 5", "Level 10", "Level 15", "Level 10 to 15", "All Levels"
  }
  ));
  uiDeck.add( levels );
  uiCard.add( levels );

  for ( int i = 1; i <= 2; ++ i )
  {
    int left = ( i == 1 ? 256 : 512 ) + offsetLeft;
    Control labell1 = new Control( "Level: ", left, 48+uiTop, 224, 24, 0 );
    uiDeck.add( labell1 );
    textLevel[i-1] = new TextField( "60", left+80, 48+uiTop, 128, 24, TEXT_LEVEL_1+i-1 );
    textLevel[i-1].isNumeric = true;
    textLevel[i-1].lastNum = 60;
    textLevel[i-1].num = 60;
    textLevel[i-1].min = 0;
    uiDeck.add( textLevel[i-1] );
    labelh[i-1] = new Control( "Health: 8080", left, 76+uiTop, 224, 24, 0 );
    uiDeck.add( labelh[i-1] );
    Control labeld1 = new Control( "Player " + i + ": ", left, 12+uiTop, 224, 24, 0 );
    uiDeck.add( labeld1 );
    textdeck[i-1] = new TextField( "Unamed", left+80, 12+uiTop, 128, 24, 0 );
    uiDeck.add( textdeck[i-1] );
    labelc[ i - 1 ] = new Control( "Deck (Demon) Cost: 0 (0)\nInitative Cost: 0", left, 104+uiTop, 224, 24, 0 );
    uiDeck.add( labelc[ i - 1 ] );
    deckList[i-1] = new ListBox( "", left, 160+uiTop, 240, 336, 0 );
    deckList[i-1].lineSize = 24;
    uiDeck.add( deckList[i-1] );
    Control butadd1 = new Button( "         Add Card to Deck", left, 540-28+uiTop, 240, 32, BUTTON_ADD_CARD_1+i-1 );
    uiDeck.add( butadd1 );
    Control butrem1 = new Button( "Remove Card", left, 588-28+uiTop, 115, 32, BUTTON_REMOVE_CARD_1+i-1 );
    uiDeck.add( butrem1 );
    Control butrem2 = new Button( " Remove All", left+125, 588-28+uiTop, 115, 32, BUTTON_REMOVE_ALL_1+i-1 );
    uiDeck.add( butrem2 );
    Control butsave1 = new Button( "              Save Deck", left, 636-28+uiTop, 240, 32, BUTTON_SAVE_1+i-1 );
    uiDeck.add( butsave1 );
  }
  

  Control labsav = new Control( "Saved Decks", 768+offsetLeft, 16+uiTop, 256, 24, 0 );
  uiDeck.add( labsav );
  decks = new ListBox( "Decks", 768+offsetLeft, 40+uiTop, 240, 456, 0 );
  decks.lineSize = 24;
  decks.multiselect = false;
  uiDeck.add( decks );
  Control butload1 = new Button( "      Load Deck as Player 1", 768+offsetLeft, 456+40+16+uiTop, 240, 32, BUTTON_LOAD_1 );
  uiDeck.add( butload1 );
  Control butload2 = new Button( "      Load Deck as Player 2", 768+offsetLeft, 456+40+16+32+16+uiTop, 240, 32, BUTTON_LOAD_2 );
  uiDeck.add( butload2 );
  Control butdel = new Button( " Delete Deck", 768+offsetLeft, 456+40+16+32+16+16+32+uiTop, 115, 32, BUTTON_DELETE );
  uiDeck.add( butdel );
  Control butdeckfile = new Button( " Load Decks", 768+offsetLeft+125, 456+40+16+32+16+16+32+uiTop, 115, 32, BUTTON_LOAD_DECKS );
  uiDeck.add( butdeckfile );

  Control labThreads = new Control( "Threads:", 32, uiTop+320, 240, 24, 0 );
  uiSettings.add( labThreads );
  listThreads = new DropList( "Threads:", 128, uiTop+320, 240, 24, 0 );
  uiSettings.add( listThreads );
  listThreads.listItems.addAll(Arrays.asList(new String[] {
    "1", "2", "4", "8", "16","32","64","128","256","512","1024"
  }
  ));  

  ListHydraCard1 = new DropList( "Choose Hydra Event Card 1", 16, uiTop+180, 240, 24, 0 );
  ListHydraCard2 = new DropList( "Choose Hydra Event Card 2", 216, uiTop+180, 240, 24, 0 );
  ListHydraCard3 = new DropList( "Choose Hydra Event Card 3", 416, uiTop+180, 240, 24, 0 );
  uiSettings.add(ListHydraCard1);
  uiSettings.add(ListHydraCard2);
  uiSettings.add(ListHydraCard3);

  uiSettings.add(servers);

  butgo = new Button( "    Go!", 256+148, line.y+32+56, 100, 32, BUTTON_GO );
  butgo.font = 18;
  butgo.type = 2;
  uiDeck.add( butgo );
  uiFOH.add (butgo);

  // Card editor
  int column1 = 256; // Image
  int column2 = 595; // Card stats

  int a[] = {
    350, 370, 390, 410, 430, 450, 470, 490, 510, 530, 550, 570, 590, 610, 630, 650
  };
  int h[] = {
    750, 805, 860, 915, 970, 1025, 1080, 1135, 1190, 1245, 1300, 1355, 1410, 1465, 1520, 1575
  };
  AType ab[] = { 
    AType.A_NONE, AType.A_NONE, AType.A_NONE, AType.A_NONE, AType.A_NONE
  };
  int al[] = { 
    0, 0, 0, 0, 0
  };
  editedCard = new CardType( "Name", h, a, FOREST, 14, 1, 4, ab, al);

  Control ca = new Control("Attack level 0 - 15", offsetLeft + column2 + 0 * 132, 336 + -1 * 28 + uiTop, 128, 24, 0 );
  uiCard.add( ca );
  Control ch = new Control("Health level 0 - 15", offsetLeft + column2 + 0 * 132, 336 + 144 -1 * 28 + uiTop, 128, 24, 0 );
  uiCard.add( ch );
  for ( int i = 0; i < 16; ++ i )
  {
    int over = i % 4;
    int down = i / 4;
    Control label1 = new Control(""+i, offsetLeft + column2 + over * 105 - 3, 336 + down * 28 + uiTop, 101, 24, 0 );
    label1.font = 14;
    label1.col = color(200, 200, 255);
    uiCard.add( label1 );
    cardAtk[ i ] = new TextField(""+a[i], offsetLeft + column2 + over * 105 + 18, 336 + down * 28 + uiTop, 101 - 18, 24, 0 );
    cardAtk[ i ].isNumeric = true;
    cardAtk[ i ].max = 9999;
    cardAtk[ i ].num = cardAtk[ i ].lastNum = a[i];
    cardAtk[ i ].font = 14;
    uiCard.add( cardAtk[ i ] );

    Control label2 = new Control(""+i, offsetLeft + column2 + over * 105 - 3, 336 + down * 28 + 144 + uiTop, 101, 24, 0 );
    label2.font = 14;
    label2.col = color(200, 200, 255);
    uiCard.add( label2 );
    cardHp[ i ] = new TextField(""+h[i], offsetLeft + column2 + over * 105+18, 336 + down * 28 + 144 + uiTop, 101 - 18, 24, 0 );
    cardHp[ i ].isNumeric = true;
    cardHp[ i ].num = cardHp[ i ].lastNum = h[i];
    cardHp[ i ].max = 9999999;
    cardHp[ i ].font = 14;
    uiCard.add( cardHp[ i ] );
  }
  Control cn = new Control( "Card Name:", offsetLeft + column1 + 8, 16 + uiTop, 58, 24, 0 );
  uiCard.add( cn );
  cardName = new TextField("Name", offsetLeft + column1+12, 16 + 24 + uiTop, 240, 24, TEXT_NAME );
  cardName.maxText = 20;
  uiCard.add( cardName );
  Control cc = new Control( "Cost:", offsetLeft + column2 + 0, 16 + uiTop, 58, 24, 0 );
  uiCard.add( cc );
  cardCost = new TextField("14", offsetLeft + column2 + 0, 16 + 24 + uiTop, 110, 24, TEXT_COST );
  cardCost.isNumeric = true;
  cardCost.max = 99;
  cardCost.lastNum = cardCost.num = 14;
  uiCard.add( cardCost );

  Control ct = new Control( "Timer:", offsetLeft + column1 + 8, 16+550+22 + uiTop, 58, 24, 0 );
  uiCard.add( ct );
  cardTime = new TextField("4", offsetLeft + column1+12, ct.h + ct.y, 110, 24, TEXT_TIME );
  cardTime.isNumeric = true;
  cardTime.lastNum = cardTime.num = 4;
  cardTime.max = 99;
  uiCard.add( cardTime );

  Control cf = new Control( "Faction:", offsetLeft + column2 + 0, 16 + cardCost.y + cardCost.h, 58, 24, 0 );
  uiCard.add( cf );
  cardFaction = new DropList( "", offsetLeft + column2 + 0, 0 + cf.y + cf.h, 171, 24, 0 );
  cardFaction.listItems.addAll(Arrays.asList(new String[] {
    "Forest", "Swamp", "Tundra", "Mountain", "Demon", "Special"
  }
  ));

  Control cs = new Control( "Stars:", offsetLeft + column1 + 8 + cardName.w + 16, 16 + uiTop, 58, 24, 0 );
  uiCard.add( cs );
  cardStars = new DropList( "", offsetLeft + column1 + 8 + cardName.w + 16, 16 + 24 + uiTop, 64, 24, 0 );
  cardStars.listItems.addAll(Arrays.asList(new String[] {
    "1", "2", "3", "4", "5"
  }
  ));

  for ( int i = 0; i < 5; ++ i )
  {
    cardAbility[ i ] = new Control( "Ability " + (i+1) + ": None", offsetLeft + column2 + 0, 36 * i + 4 + cardFaction.y + cardFaction.h, 80, 24, 0 );
    uiCard.add( cardAbility[ i ] );
    cardAbilitySet[ i ] = new Button( " Set to Selected", offsetLeft + column2 + 192 + 84, 36 * i + 4 + cardFaction.y + cardFaction.h, 140, 32, BUTTON_ADD_ABILITY_1 + i );
    uiCard.add( cardAbilitySet[ i ] );
  }
  pic = new Picture( "", offsetLeft + column1 + 8, 16+24+24+24 + uiTop, (int)(385*0.8), (int)(580*0.8), 0, loadImage( "frame_forest.png" ) );
  uiCard.add( pic );

  for ( int i = 0; i < 5; ++ i )
  {
    picStars[ i ] = new Picture("", offsetLeft + column1 + 8+80+i*29, 16+24+24+24+40 + uiTop, (int)(40*0.8), (int)(41*0.8), 0, i == 0 ? loadImage( "star.png" ) : null );
    uiCard.add( picStars[ i ] );
  }
  labelCardName = new Control("Name", offsetLeft + column1 + 8+74, 16+24+24+24+7 + uiTop, (int)(40*0.8), (int)(41*0.8), 0 );
  labelCardName.font = 25;
  labelCardName.col = color(255);
  uiCard.add( labelCardName );
  labelCardCost = new Control("", offsetLeft + column1 + 258, 16+24+24+24+32 + uiTop, (int)(40*0.8), (int)(41*0.8), 0 );
  labelCardCost.font = 25;
  labelCardCost.col = color(235, 200, 15);
  uiCard.add( labelCardCost );
  labelCardTime = new Control("", offsetLeft + column1 + 8+28, 16+24+24+24+370 + uiTop, (int)(40*0.8), (int)(41*0.8), 0 );
  labelCardTime.font = 25;
  labelCardTime.col = color(235, 200, 15);
  uiCard.add( labelCardTime );
  labelCardAttack = new Control("", offsetLeft + column1 + 8+222, 16+24+24+24+365 + uiTop, (int)(40*0.8), (int)(41*0.8), 0 );
  labelCardAttack.font = 25;
  labelCardAttack.col = color(255);
  uiCard.add( labelCardAttack );
  labelCardHealth = new Control("", offsetLeft + column1 + 8+130, 16+24+24+24+404 + uiTop, (int)(40*0.8), (int)(41*0.8), 0 );
  labelCardHealth.font = 25;
  labelCardHealth.col = color(255);
  uiCard.add( labelCardHealth );

  cardLoad = new Button( "            Load Card", 16, cards.y+cards.h+8+32+192, 224, 32, BUTTON_LOAD_CARD );
  uiCard.add( cardLoad );
  cardsSave = new Button( "        Save Cards List", cardLoad.x, cardLoad.y + 48, cardLoad.w, cardLoad.h, BUTTON_SAVE_CARDS );
  uiCard.add( cardsSave );
  cardSave = new Button( "               Save Card", cardTime.x, cardTime.y + 48, 240, 32, BUTTON_SAVE_CARD );
  uiCard.add( cardSave );
  autofillCard = new Button( "   Auto fill Attack and Health", cardHp[ 12 ].x, cardSave.y, 256, 32, BUTTON_CARD_FILL );
  uiCard.add( autofillCard );
  Control labelAutofill = new Control( "Fill based on levels:", cardHp[ 12 ].x, autofillCard.y - (36+32), 128, 24, 0 );
  uiCard.add( labelAutofill );
  textAutofill1 = new TextField( "0", cardHp[ 12 ].x, labelAutofill.y + 32, 104, 24, 0 );
  textAutofill1.isNumeric = true;
  textAutofill1.min = 0;
  textAutofill1.max = 15;
  textAutofill1.lastNum = textAutofill1.num = 0;
  uiCard.add( textAutofill1 );
  Control labelAutofill2 = new Control( "and", textAutofill1.x + textAutofill1.w + 4, textAutofill1.y, textAutofill1.w, textAutofill1.h, 0 );
  uiCard.add( labelAutofill2 );
  textAutofill2 = new TextField( "10", textAutofill1.x + textAutofill1.w + 48, textAutofill1.y, textAutofill1.w, textAutofill1.h, 0 );
  textAutofill2.isNumeric = true;
  textAutofill2.min = 0;
  textAutofill2.max = 15;
  textAutofill2.lastNum = textAutofill2.num = 10;
  uiCard.add( textAutofill2 );
  abilityClear = new Button( " Clear Abilities", cardAbilitySet[0].x, cardAbilitySet[0].y - 36-16, cardAbilitySet[0].w, cardAbilitySet[0].h, BUTTON_ABILITY_CLEAR );
  uiCard.add( abilityClear );


  uiCard.add( cardFaction );
  uiCard.add( cardStars );
  showAbilities();
  
  
  
  // Results graph
  uiResults.add(listresult);
  lineGraph = new RadioButton ("Line Graph", 32, 800-96, 300, 32,0 );
  uiResults.add(lineGraph);
  barGraph = new RadioButton ("Bar Graph", 32, 800-64, 300, 32,0 );
  barGraph.checked = true;
  uiResults.add(barGraph);
  lineGraph.setStart = lineGraph;
  lineGraph.setNext = barGraph;
  barGraph.setStart = lineGraph;
  barGraph.setNext = null;
  
  Control barlabel = new Control("Number of bars",32,800-32,96,24,0 );
  uiResults.add(barlabel);
  numBars = new TextField("",32+128+8,800-32,96,24,0 );
  numBars.isNumeric = true;
  numBars.min = 5;
  numBars.max = 40;
  numBars.textIn = ""+(numBars.lastNum = numBars.num = 20);
  uiResults.add(numBars);
  
  verticalZero = new Checkbox("Vertical axis from 0", 32+128+32, 800-96, 300, 24,0 );
  uiResults.add(verticalZero);
}

class Control
{
  boolean mouseOn;
  boolean clicked;
  boolean focus;

  String text = "";
  int x;
  int y;
  int w;
  int h;
  color col = color(240, 205, 175);
  float font = 16;
  int id;
  int type;

  Control() {
  }

  Control( String t, int xx, int yy, int ww, int hh, int i )
  {
    x = xx;
    y = yy;
    w = ww;
    h = hh;
    text = t;
    id = i;
  }

  void draw(PGraphics pg)
  {
    pg.textSize( font );
    pg.fill(col);
    pg.text( text, x+font/2-3, y+font+2 );
  }

  void handleMouseMove()
  {
    mouseOn = mouseIsOn();
  }

  void handleMousePressed()
  {
    clicked = mouseIsOn();
    focus = mouseIsOn();
  }

  void handleMouseReleased()
  {
    clicked = false;
  }

  void handleKeyboard() {
  }

  boolean mouseIsOn()
  {
    return ( mousex > x && mousex < x + w && mousey > y && mousey < y + h );
  }
}

class Button extends Control
{  
  boolean isTab = false;

  Button( String t, int xx, int yy, int ww, int hh, int i )
  {
    super(t, xx, yy, ww, hh, i);
  }

  void draw(PGraphics pg)
  {
    /*if( clicked )
     pg.fill( 192 );
     else
     pg.noFill();
     pg.stroke(0);
     pg.strokeWeight(mouseOn ? 2 : 1);
     pg.rect(x, y, w, h);
     pg.strokeWeight(1);
     if(!isTab)
     pg.rect(x+3, y+3, w-6, h-6);
     
     pg.textSize( font );
     pg.fill(col);*/
    if ( mouseOn ) pg.tint( 300, 300, 300 );
    pg.pushMatrix();
    if ( clicked )
    {
      pg.translate( 2, 2 );
      pg.tint( 150 );
    }
    if ( isTab )
    {
      if ( ( uiTab == 0 && id == TAB1 ) || ( uiTab == 1 && id == TAB2 ) || ( uiTab == 2 && id == TAB3 ) || ( uiTab == 3 && id == TAB4 ) || ( uiTab == 4 && id == TAB5 ) || ( uiTab == 5 && id == TAB6 ))
        pg.image( imgTab[ 0 ], x, y, w, h );
      else
        pg.image( imgTab[ 1 ], x, y, w, h );
    }
    else
    {
      if ( type == 2 )
        pg.image( imgButton2, x, y, w, h );
      else if ( w > 128 ) 
        pg.image( imgButtonLarge, x, y, w, h );
      else
        pg.image( imgButton1, x, y, w, h );
    }
    pg.noTint();
    pg.textSize(font);
    pg.fill(col);
    if (!isTab)
      pg.text( text, x+font/2+1, y+font*1.3 );
    else
      pg.text( text, x+font/2+1, y+font*1.1 );
    pg.popMatrix();
  }

  void handleMouseMove()
  {
    super.handleMouseMove();
  }

  void handleMousePressed()
  {
    super.handleMousePressed();
  }

  void handleMouseReleased()
  {
    if ( mouseIsOn() && clicked )
    {
      switch( id )
      {
      case TAB1:
        ui = uiDeck;
        uiTab = 0;
        break;

      case TAB2:
        ui = uiCard;
        uiTab = 1;
        break;

      case TAB3:
        ui = uiResults;
        uiTab = 2;
        break;

      case TAB4:
        ui = uiSettings;
        uiTab = 3;
        break;

      case TAB5:
        ui = uiFOH;
        uiTab = 4;
        break;

      case TAB6:
        ui = uiHelp;
        uiTab = 5;
        break;

      case BUTTON_ADD_CARD_1:
        addCardsToDeck(0);
        break;

      case BUTTON_ADD_CARD_2:
        addCardsToDeck(1);
        break;

      case BUTTON_REMOVE_CARD_1:
        Collections.sort(deckList[0].current, Collections.reverseOrder());
        for ( Integer i : deckList[0].current )
        {
          //println(i);
          if( i >= 0 && i < deckList[0].listItems.size())
            deckList[0].listItems.remove( (int)i );
        }
        deckList[0].current.clear();
        showDeckCost( 0, true );
        break;

      case BUTTON_REMOVE_CARD_2:
        Collections.sort(deckList[1].current, Collections.reverseOrder());
        for ( Integer i : deckList[1].current )
        {
          if( i >= 0  && i < deckList[1].listItems.size())
            deckList[1].listItems.remove( (int)i );
        }
        deckList[1].current.clear();
        showDeckCost( 1, true );
        break;

      case BUTTON_REMOVE_ALL_1:
        deckList[0].current.clear();
        deckList[0].listItems.clear();
        deckp1 = deckFromUI( 0, true );
        labelc[ 0 ].text = "Deck/Init cost: 0/0";
        deckList[0].scroll = 0;
        break;

      case BUTTON_REMOVE_ALL_2:
        deckList[1].current.clear();
        deckList[1].listItems.clear();
        deckp1 = deckFromUI( 1, true );
        labelc[ 1 ].text = "Deck/Init cost: 0/0";
        deckList[1].scroll = 0;
        break;

      case BUTTON_SAVE_1:
        Deck d = deckFromUI( 0, true );
        if( d == null ) return;
        if ( decks.listItems.contains( textdeck[ 0 ].textIn ) )
        {
          savedDecks.set( decks.listItems.indexOf( textdeck[ 0 ].textIn ), d );
        }
        else
        {
          savedDecks.add( d );
          decks.listItems.add( textdeck[ 0 ].textIn );
        }
        saveDecks();
        break;

      case BUTTON_SAVE_2:
        Deck d1 = deckFromUI( 1,true );
        if( d1 == null ) return;
        if ( decks.listItems.contains( textdeck[ 1 ].textIn ) )
        {
          savedDecks.set(  decks.listItems.indexOf( textdeck[ 1 ].textIn ), d1 );
        }
        else
        {
          savedDecks.add( d1 );
          decks.listItems.add( textdeck[ 1 ].textIn );
        }
        saveDecks();
        break;

      case BUTTON_LOAD_1:
        if ( decks.current.size() > 0 )
        {
          deckToUI( decks.current.get(0), 0 );
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
        break;

      case BUTTON_LOAD_2:
        if ( decks.current.size() > 0 )
        {
          deckToUI( decks.current.get(0), 1 );
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
        break;

      case BUTTON_DELETE:
        if ( decks.current.size() > 0 )
        {
          decks.listItems.remove( (int)decks.current.get(0) );
          savedDecks.remove( (int)decks.current.get(0) );
          saveDecks();
        }
        break;

      case BUTTON_CONVERT:
        selectInput("Select a decks file to convert:", "convertSelectedDecks");
        break;

      case BUTTON_SAVERESULTS:
        selectInput("Select a a file to save decks and results to:", "saveResults");
        break;

      case BUTTON_GET_FOH_DECKS:
          FOH();
        break;

      case BUTTON_CARDDIFF:
          GetCardListDifferences();
        break;

      case BUTTON_LOAD_DECKS:
        selectInput("Select a decks file to load:", "loadSelectedDecks");
        break;

//      case BUTTON_PAUSE:
//        if (isRun && !Pause) {
//          butPause.text = "Resume!";
//          Pause = true;
//        }
//        else if (isRun) {
//          butPause.text = " Pause!";
//          Pause = false;
//        }
//        break;
        
        

      case BUTTON_GO:
        if (isRun) {
          butgo.text = "    Go!";
          StopMe = true;
        }
        else {
          butgo.text = "   Stop!";
          if (uiTab == 4 && FOHDownload) FOH_RUN();
          else if (uiTab == 4) {
            listresult.listItems.clear();
            listresult.listItems.add( "Please select a server and Get FOH Info before attempting to sim!");
            butgo.text = "      Go!";
          }
          else new Thread(new RunSim()).start();
        }
        break;
        
      case BUTTON_ADD_ABILITY_1:
        AType abil = AType.A_NONE;
        if ( evoList.current.size() > 0 && evoList.current.get(0) > 0 )
        {
          String el = evoList.listItems.get( (int)evoList.current.get( 0 ) );
          el = el.substring( 0, el.lastIndexOf(' ') );
          abil = abilities.get( el );
        }
        editedCard.abilities[ 0 ] = abil;
        editedCard.abilityL[ 0 ] = (int)textEvo.lastNum;
        showAbilities();
        break;
        
      case BUTTON_ADD_ABILITY_2:
        AType ability = AType.A_NONE;
        if ( evoList.current.size() > 0 && evoList.current.get(0) > 0 )
        {
          String el = evoList.listItems.get( (int)evoList.current.get( 0 ) );
          el = el.substring( 0, el.lastIndexOf(' ') );
          ability = abilities.get( el );
        }
        editedCard.abilities[ 1 ] = ability;
        editedCard.abilityL[ 1 ] = (int)textEvo.lastNum;
        showAbilities();
        break;
        
      case BUTTON_ADD_ABILITY_3:
        AType ability2 = AType.A_NONE;
        if ( evoList.current.size() > 0 && evoList.current.get(0) > 0 )
        {
          String el = evoList.listItems.get( (int)evoList.current.get( 0 ) );
          el = el.substring( 0, el.lastIndexOf(' ') );
          ability2 = abilities.get( el );
        }
        editedCard.abilities[ 2 ] = ability2;
        editedCard.abilityL[ 2 ] = (int)textEvo.lastNum;
        showAbilities();
        break;
        
      case BUTTON_ADD_ABILITY_4:
        AType abil3 = AType.A_NONE;
        if ( evoList.current.size() > 0 && evoList.current.get(0) > 0 )
        {
          String el = evoList.listItems.get( (int)evoList.current.get( 0 ) );
          el = el.substring( 0, el.lastIndexOf(' ') );
          abil3 = abilities.get( el );
        }
        editedCard.abilities[ 3 ] = abil3;
        editedCard.abilityL[ 3 ] = (int)textEvo.lastNum;
        showAbilities();
        break;
        
      case BUTTON_ADD_ABILITY_5:
        AType abil4 = AType.A_NONE;
        if ( evoList.current.size() > 0 && evoList.current.get(0) > 0 )
        {
          String el = evoList.listItems.get( (int)evoList.current.get( 0 ) );
          el = el.substring( 0, el.lastIndexOf(' ') );
          abil4 = abilities.get( el );
        }
        editedCard.abilities[ 4 ] = abil4;
        editedCard.abilityL[ 4 ] = (int)textEvo.lastNum;
        showAbilities();
        break;
        
      case BUTTON_SAVE_CARD:
        int atk[] = new int[16];
        int hp[] = new int[16];
        for( int i = 0; i <= 15; ++ i )
        {
          atk[ i ] = (int)cardAtk[ i ].lastNum;
          hp[ i ] = (int)cardHp[ i ].lastNum;
        }
        CardType cardToAdd = new CardType( 
          cardName.textIn, 
          hp, 
          atk, 
          cardFaction.currentIndex, 
          (int)cardCost.lastNum, 
          cardStars.currentIndex + 1, 
          (int)cardTime.lastNum,
          editedCard.abilities,
          editedCard.abilityL
        );
        cardsMap.remove( cardName.textIn );
        cardsMap.put( cardName.textIn, cardToAdd );
        filterCards(false);
        try
        {
          String factions[] = { "Forest", "Swamp", "Tundra", "Mountain", "Demon", "Special" };
          PrintWriter writer = new PrintWriter("CardsList2.txt", "UTF-8");
          writer.println(
            "Card Name,Party Cost,Stars,Kingdom,Initial Wait,Level 0 Skill,Level 5 Skill,Level 10 Skill,Level 99 Skill,HP Stat Progression (level 0-15),Attack Stat Progression (level 0-15)"
          );
          for( CardType c : cardsMap.values() )
          {
            String stringHp = "";
            String stringAtk = "";
            for( int i = 0; i <= 15; ++ i )
            {
              stringHp = stringHp + c.hp[i] + (i<15?", ":"");
              stringAtk = stringAtk + c.atk[i] + (i<15?", ":"");
            }
            writer.println(
              c.name + "," +
              c.cost + "," +
              c.stars + "," +
              factions[ c.faction ] + "," +
              c.timer + "," +
              (c.abilities[0] == AType.A_NONE || c.abilities[0] == null ? " " : (abilityName.get( c.abilities[0] ) + " " + c.abilityL[0])) + "," +
              (c.abilities[1] == AType.A_NONE || c.abilities[1] == null ? " " : (abilityName.get( c.abilities[1] ) + " " + c.abilityL[1])) + "," +
              (c.abilities[2] == AType.A_NONE || c.abilities[2] == null ? " " : (abilityName.get( c.abilities[2] ) + " " + c.abilityL[2])) + "," +
              (c.abilities[3] == AType.A_NONE || c.abilities[3] == null ? " " : (abilityName.get( c.abilities[3] ) + " " + c.abilityL[3])) + "," +
              (c.abilities[4] == AType.A_NONE || c.abilities[4] == null ? " " : (abilityName.get( c.abilities[4] ) + " " + c.abilityL[4])) + "," +
              stringHp + "," +
              stringAtk
            );
          }
          error = "written";
          writer.close();
        }
        catch( Exception e )
        {
          println( e );
        }
        break;
        
      case BUTTON_SAVE_CARDS:
        try
        {
          String factions[] = { "Forest", "Swamp", "Tundra", "Mountain", "Demon", "Special" };
          PrintWriter writer = new PrintWriter("CardsList2.txt", "UTF-8");
          writer.println(
            "Card Name,Party Cost,Stars,Kingdom,Initial Wait,Level 0 Skill,Level 5 Skill,Level 10 Skill,Level 99 Skill,HP Stat Progression (level 0-15),Attack Stat Progression (level 0-15)"
          );
          for( CardType c : cardsMap.values() )
          {
            String stringHp = "";
            String stringAtk = "";
            for( int i = 0; i <= 15; ++ i )
            {
              stringHp = stringHp + c.hp[i] + (i<15?", ":"");
              stringAtk = stringAtk + c.atk[i] + (i<15?", ":"");
            }
            writer.println(
              c.name + "," +
              c.cost + "," +
              c.stars + "," +
              factions[ c.faction ] + "," +
              c.timer + "," +
              (c.abilities[0] == AType.A_NONE || c.abilities[0] == null ? " " : (abilityName.get( c.abilities[0] ) + " " + c.abilityL[0])) + "," +
              (c.abilities[1] == AType.A_NONE || c.abilities[1] == null ? " " : (abilityName.get( c.abilities[1] ) + " " + c.abilityL[1])) + "," +
              (c.abilities[2] == AType.A_NONE || c.abilities[2] == null ? " " : (abilityName.get( c.abilities[2] ) + " " + c.abilityL[2])) + "," +
              (c.abilities[3] == AType.A_NONE || c.abilities[3] == null ? " " : (abilityName.get( c.abilities[3] ) + " " + c.abilityL[3])) + "," +
              stringHp + "," +
              stringAtk
            );
          }
          error = "written";
          writer.close();
        }
        catch( Exception e )
        {
          println( e );
        }
        break;
        
      case BUTTON_LOAD_CARD:
        if( cards.current.isEmpty() ) return;
        String line = cards.listItems.get( cards.current.get( 0 ) );
        if ( line.substring( 0, Math.min( line.length(), 6 ) ).equals( "Rune: " ) ) return;
        
        int cardEnd = line.lastIndexOf( ';' );
        if ( cardEnd < 0 ) cardEnd = line.length();
        
        CardType c = cardsMap.get( line.substring( 0, cardEnd ) );
        if( c != null )
        {
          editedCard.name = labelCardName.text = cardName.textIn = c.name;
          cardTime.textIn = ""+ (cardTime.num = cardTime.lastNum = editedCard.timer = c.timer);
          cardCost.textIn = ""+ (cardCost.num = cardCost.lastNum = editedCard.cost = c.cost);
          cardStars.currentIndex = ( editedCard.stars = c.stars ) - 1;
          cardFaction.currentIndex = editedCard.faction = c.faction;
          for( int i = 0; i <= 15; ++ i )
          {
            cardAtk[ i ].textIn = "" + ( cardAtk[ i ].num = cardAtk[ i ].lastNum = editedCard.atk[ i ] = c.atk[ i ] );
            cardHp[ i ].textIn = "" + ( cardHp[ i ].num = cardHp[ i ].lastNum = editedCard.hp[ i ] = c.hp[ i ] );
            
          }
          String images[] = { 
            "frame_forest.png", "frame_swamp.png", "frame_tundra.png", "frame_mountain.png", "frame_demon.png", "frame_special.png"
          };
          for( int i = 0; i < 5; ++ i )
          {
            editedCard.abilities[ i ] = c.abilities[ i ];
            editedCard.abilityL[ i ] = c.abilityL[ i ];
          }
          for ( int i = 0; i < 5; ++ i )
          {
            picStars[ i ].img = ( ( i + 1 <= c.stars ) ? loadImage( "star.png" ) : null );
          }
          pic.img = loadImage(images[editedCard.faction]);
          labelCardName.text = editedCard.name;
          if ( cardName.textIn.length() > 16 )
            labelCardName.text = cardName.textIn.substring(0, 16) + "...";
          labelCardName.font = 25 - (min(cardName.textIn.length(),16)/1.8);
          labelCardName.y = 96 + 32 + (min(cardName.textIn.length(),16)/4);
          showAbilities();
        }
        break;
        
      case BUTTON_CARD_FILL:
        int baseline1 = (int)textAutofill1.lastNum;
        int baseline2 = (int)textAutofill2.lastNum;
        if( baseline1 == baseline2 ) return;
        int baseAtk1 = (int)cardAtk[ baseline1 ].lastNum;
        int baseAtk2 = (int)cardAtk[ baseline2 ].lastNum;
        int baseHp1 = (int)cardHp[ baseline1 ].lastNum;
        int baseHp2 = (int)cardHp[ baseline2 ].lastNum;
        int attackRate = abs( baseAtk1 - baseAtk2 ) / abs( baseline1 - baseline2 );
        int healthRate = abs( baseHp1  - baseHp2 )  / abs( baseline1 - baseline2 );
        int attackStart = baseAtk1 - attackRate * baseline1;
        int healthStart = baseHp1 -  healthRate * baseline1;
        //println(baseAtk1 + " " + baseAtk2 + " " + (abs( baseAtk1 - baseAtk2 )) + " " + abs( baseline1 - baseline2 ) + " " + attackStart + " " + attackRate);
        for( int i = 0; i <= 15; ++ i )
        {
          cardAtk[ i ].num = cardAtk[ i ].lastNum = min(attackStart + i * attackRate,999);
          cardAtk[ i ].textIn = cardAtk[ i ].lastNum +"";
          editedCard.atk[ i ] = (int)cardAtk[ i ].lastNum;
          
          cardHp[ i ].num = cardHp[ i ].lastNum = min(healthStart + i * healthRate,9999999);
          cardHp[ i ].textIn = cardHp[ i ].lastNum + "";
          editedCard.hp[ i ] = (int)cardHp[ i ].lastNum;
        }
        break;
        
      case BUTTON_ABILITY_CLEAR:
        for( int i = 0; i < 5; ++ i )
        {
          editedCard.abilities[ i ] = AType.A_NONE;
        }
        showAbilities();
        break;
      };
    }
    super.handleMouseReleased();
  }
}

void showAbilities()
{
  cardAbility[ 0 ].text = "Ability 1 (0): " + abilityName.get( editedCard.abilities[ 0 ] ) + (editedCard.abilities[ 0 ] == AType.A_NONE ? "" : " " + editedCard.abilityL[ 0 ]);
  cardAbility[ 1 ].text = "Ability 2 (5): " + abilityName.get( editedCard.abilities[ 1 ] ) + (editedCard.abilities[ 1 ] == AType.A_NONE ? "" : " " + editedCard.abilityL[ 1 ]);
  cardAbility[ 2 ].text = "Ability 3 (10): " + abilityName.get( editedCard.abilities[ 2 ] ) + (editedCard.abilities[ 2 ] == AType.A_NONE ? "" : " " + editedCard.abilityL[ 2 ]);
  cardAbility[ 3 ].text = "Ability 4 (10+): " + abilityName.get( editedCard.abilities[ 3 ] ) + (editedCard.abilities[ 3 ] == AType.A_NONE ? "" : " " + editedCard.abilityL[ 3 ]);
  cardAbility[ 4 ].text = "Ability 5 (10+): " + abilityName.get( editedCard.abilities[ 4 ] ) + (editedCard.abilities[ 4 ] == AType.A_NONE ? "" : " " + editedCard.abilityL[ 4 ]);
}

void showDeckCost( int p, boolean clear )
{
  Deck d = deckFromUI( p, clear );
  if( d == null )
  {
    labelh[p].text = "Health: ";
    labelc[ p ].text = "Deck/Init cost: ? (?)/?";
  }
  else
  {
    deckCost = 0;
    demonCost = 0;
    int initativeCost = hpPerLevel[ (int)textLevel[ p ].lastNum ]; // figure out how to get player hps
    for ( int i = 0; i < d.numCards; ++ i )
    {
      demonCost += d.cards[ i ].type.cost;
      deckCost += d.cards[ i ].cost;
      initativeCost += d.cards[i].type.hp[d.cards[i].lvl];
      initativeCost += d.cards[i].type.atk[d.cards[i].lvl];
    }
    if ((int)textLevel[ p ].lastNum == 0) initativeCost = 999999;
    labelc[ p ].text = "Deck (Demon) Cost: " + deckCost + " (" + demonCost + ")\n" + "Initative Cost: " + initativeCost;
    labelh[p].text = "Health: " + hpPerLevel[ (int)textLevel[ p ].lastNum ];
  }
}

class Checkbox extends Control
{
  boolean checked = false;

  Checkbox( String t, int xx, int yy, int ww, int hh, int i )
  {
    super(t, xx, yy, ww, hh, i);
  }

  void draw(PGraphics pg)
  {
    int s = 20;
    int sp = 4;
    pg.stroke(0);
    pg.strokeWeight( 3 );
    pg.fill( clicked ? 192 : 255 );
    pg.rect( x + 0, y + 0, s, s );
    /*if( checked )
     {
     pg.strokeWeight(2);
     pg.line( x+sp, y+sp, x+s-sp, y+s-sp );
     pg.line( x+s-sp, y+sp, x+sp, y+s-sp );
     }*/
    tint(350);
    pg.image( imgCheckbox[ 1 ], x, y, s, s );
    if ( checked )
      pg.image( imgCheckbox[ 0 ], x, y, s, s );
    noTint();
    pg.textSize(font);
    pg.fill(col);
    pg.text(text, x+s*1.75, y+h-font/2 );
  }

  void handleMouseMove()
  {
    super.handleMouseMove();
  }

  void handleMousePressed()
  {
    super.handleMousePressed();
  }

  void handleMouseReleased()
  {
    super.handleMouseReleased();
    checked = mouseIsOn() ? !checked : checked;
    if ( mouseIsOn() && this != checkEvo)
    {
      filterCards(false);
    }
    else if (mouseIsOn()) filterEvos(false);
  }
}

class RadioButton extends Control
{
  RadioButton setStart = null;
  RadioButton setNext = null;
  boolean checked = false;

  RadioButton( String t, int xx, int yy, int ww, int hh, int i )
  {
    super(t, xx, yy, ww, hh, i);
  }

  void draw(PGraphics pg)
  {
    int s = 20;
    int sp = 12;
    /*pg.stroke(0);
     pg.strokeWeight( mouseOn ? 3 : 1 );
     pg.fill( clicked ? 192 : 255 );
     pg.ellipse( x + s/2, y + s/2, s, s );
     if( checked )
     {
     pg.fill(0);
     pg.ellipse( x + s/2, y + s/2, s-sp, s-sp );
     }
     pg.textSize(font);
     pg.fill(col);*/
    pg.image( imgRadio[ checked ? 0 : 1 ], x, y, s, s );
    pg.text(text, x+s*1.75, y+font );
  }

  void handleMouseMove()
  {
    super.handleMouseMove();
  }

  void handleMousePressed()
  {
    super.handleMousePressed();
  }

  void handleMouseReleased()
  {
    if ( mouseIsOn() )
    {
      RadioButton it = setStart;
      while ( it != null )
      {
        it.checked = false;
        it = it.setNext;
      }
      checked = mouseIsOn() && clicked || checked ? true : false;
      super.handleMouseReleased();
    }
  }
}

class TextField extends Control
{
  boolean selected = false;
  boolean isNumeric = false;
  long min = 1;
  long max = 120;
  long num = min;
  long lastNum = min;
  long maxText = 15;
  String textIn = "";

  TextField( String t, int xx, int yy, int ww, int hh, int i )
  {
    super(t, xx, yy, ww, hh, i);
    textIn = t;
  }

  void draw(PGraphics pg)
  {
    text = textIn;
    if ( millis() % 1000 < 500 && selected ) text = text + "|";
    /*if( selected )
     pg.fill( 225 );
     else
     pg.noFill();
     pg.strokeWeight(mouseIsOn()?3:1);
     pg.stroke(0);
     pg.rect(x,y,w,h);*/
    int i = 0;
    if ( w < 75 )
      i = 0;
    else if ( w < 95 )
      i = 1;
    else if ( w < 125 )
      i = 2;
    else
      i = 3;

    pg.image( imgTextField[ i ], x, y, w, h );
    super.draw(pg);
  }

  void handleMouseMove()
  {
    super.handleMouseMove();
  }

  void handleMousePressed()
  {
    super.handleMousePressed();
    if ( !mouseIsOn() && selected )
    {
      deselect();
    }
    if ( mouseIsOn() )
    {
      if (  id == SEARCH_TEXT )
      {
        text = textIn = "";
        deselect();
      }
    }
  }

  void handleMouseReleased()
  {
    if ( clicked && mouseIsOn() )
    {
      if ( selectedText != null && selectedText != this && selectedText.selected )
      {
        selectedText.deselect();
      }
      selectedText = this;
      selected = true;
    }
    super.handleMouseReleased();
  }

  void handleKeyboard()
  {
    if( key == '' && selected)
    {
      cp.copyString(textIn);
      return;
    }
    if( key == '' && selected)
    {
      String p = cp.pasteString();
      p.replace( "\n", "" );
      p = p.substring(0,(int)min(p.length(),maxText));
      textIn = p;
      return;
    }
    
    boolean isLetter = ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z'));
    if ( !selected && !(selectedList != deckList[0] && selectedList != deckList[1] && selectedText == null && this == searchf && key != '1' && key != '2' && (isLetter || key == BACKSPACE || key == ' ' || key == ':' || key == '-' || key == '(' || key == ')'))) return;
    boolean isNumber = key >= '0' && key <= '9';
    if ( !isNumeric )
    {
      if ( isLetter || isNumber || key == ' '|| key == '\'' || key == '-' || key == '(' || key == ')' || key == ':' )
      {
        if ( textIn.length() < maxText )
          textIn = textIn + key;
      }
      else if ( key == BACKSPACE )
      {
        textIn = textIn.substring(0, max(0, textIn.length()-1));
      }
      else if ( key == ENTER )
      {
        deselect();
      }
      if ( this == searchf )
      {
        cards.current.clear();
        filterCards( false );
      }
    }
    else if (isNumeric)
    {
      if ( isNumber )
      {
        if ( textIn.length() < maxText )
        {
          textIn = textIn + key;
          try
          {
            num = Integer.parseInt(textIn);
          }
          catch(NumberFormatException nfe)  
          {
            num = lastNum;
          }
          textIn = "" + num;
        }
      }
      else if ( key == BACKSPACE )
      {
        textIn = textIn.substring(0, max(0, textIn.length()-1));
        try
        {
          num = Integer.parseInt(textIn);
        }
        catch(NumberFormatException nfe)  
        {
          num = 0;
          textIn = "" + num;
        }
      }
      else if ( key == ENTER )
      {
        deselect();
      }
    }
  }

  void deselect()
  {
    if ( selectedText == this ) selectedText = null;
    if ( isNumeric )
    {
      lastNum = (long)min( max, max( min, num ) );
      textIn = "" + lastNum;
    }
    selected = false;
    switch( id )
    {
    case SEARCH_TEXT:
      if (searchf.mouseIsOn()) {
        cards.current.clear();
        filterCards( false );
      }
      cards.focus = true;
      break;

    case TEXT_LEVEL_1:
      Deck d = deckFromUI( 0, true );

      if( (int)textLevel[ 0 ].lastNum == 0 )
      {
        labelh[0].text = "Health: Invulnerable";
        labelc[0].text = "Deck (Demon) Cost: " + deckCost + "(" + demonCost + ")\nInitative Cost: 999999";
      }
      else
      {
        int initativeCost = hpPerLevel[ (int)textLevel[ 0 ].lastNum ]; // figure out how to get player hps
        deckCost = 0;
        demonCost = 0;
        for ( int i = 0; i < d.numCards; ++ i )
        {
          deckCost += d.cards[ i ].cost;
          demonCost += d.cards[ i ].type.cost;
          initativeCost += d.cards[i].type.hp[d.cards[i].lvl];
          initativeCost += d.cards[i].type.atk[d.cards[i].lvl];
        }
        labelc[0].text = "Deck (Demon) Cost: " + deckCost + "(" + demonCost + ")\nInitative Cost: " + initativeCost;
        labelh[0].text = "Health: " + hpPerLevel[ (int)textLevel[ 0 ].lastNum ];
      }
      break;

    case TEXT_LEVEL_2:
      d = deckFromUI( 1, true );

      if( (int)textLevel[ 1 ].lastNum == 0 )
      {
        labelh[1].text = "Health: Invulnerable";
        labelc[1].text = "Deck (Demon) Cost: " + deckCost + "(" + demonCost + ")\nInitative Cost: 999999";
      }
      else
      {
        int initativeCost = hpPerLevel[ (int)textLevel[ 1 ].lastNum ]; // figure out how to get player hps
        deckCost = 0;
        demonCost = 0;
        for ( int i = 0; i < d.numCards; ++ i )
        {
          deckCost += d.cards[ i ].cost;
          demonCost += d.cards[ i ].type.cost;
          initativeCost += d.cards[i].type.hp[d.cards[i].lvl];
          initativeCost += d.cards[i].type.atk[d.cards[i].lvl];
        }
        labelc[1].text = "Deck (Demon) Cost: " + deckCost + "(" + demonCost + ")\nInitative Cost: " + initativeCost;
        labelh[1].text = "Health: " + hpPerLevel[ (int)textLevel[ 0 ].lastNum ];
      }
      break;

    case NUMBER_RUNS:
      numMatch = lastNum;
      break;

    case TEXT_TIME:
      //labelCardTime.text = "" + lastNum;
      break;

    case TEXT_COST:
      //labelCardCost.text = "" + lastNum;
      break;

    case TEXT_NAME:
      {
        labelCardName.text = textIn;
        if ( textIn.length() > 16 )
          labelCardName.text = textIn.substring(0, 16) + "...";
        labelCardName.font = 25 - (textIn.length()/2);
        labelCardName.y = 96 + 32 + (textIn.length()/4);
        break;
      }
    };
  }
}

class DropList extends Control
{
  ArrayList< String > listItems = new ArrayList< String >();
  int currentIndex = 0;
  int selectIndex = 0;
  boolean showList = false;
  int offset = 0;
  int maxSize = 20;

  DropList( String t, int xx, int yy, int ww, int hh, int i )
  {
    super(t, xx, yy, ww, hh, i);
  }

  void draw(PGraphics pg)
  {
    if ( currentIndex < listItems.size() )
      text = (w > 170 ? "       " : "     ") + listItems.get(currentIndex);
    /*pg.strokeWeight(mouseIsOn()?3:1);
     pg.noFill();
     pg.stroke(0);
     pg.rect(x,y,w,h);
     int b = 4;
     pg.triangle(x+w-h, y+b,
     x+w-b, y+b,
     x+w-h+(h-b)/2, y+h-b );*/
    pg.image( imgDropList[ w > 170 ? 0 : 1 ], x, y, w, h );

    super.draw(pg);
    if ( showList )
    {
      pg.image( imgDropList[ 2 ], x+20, y + h, w-40, font*1.3*min(listItems.size(),maxSize) + 5);
      pg.fill(0);
       //pg.strokeWeight(1);
       //pg.rect( x, y+h, w-40, font*1.3*listItems.size()+ 5);
       if( selectIndex > -1 )
       {
       pg.strokeWeight(2);
       pg.rect( x+23, 3+y+h+selectIndex*1.3*font, w-48, font*1.3*1);
       pg.strokeWeight(1);
       }
      pg.pushMatrix();
      pg.translate( 20, 5 );
      for ( int i = 0+offset; i < min(listItems.size(),maxSize)+offset; ++ i )
      {
        pg.translate(0, font*1.3*(1));
        text = listItems.get(i);
        super.draw(pg);
      }
      pg.popMatrix();
      if (selectIndex == (maxSize - 1) || selectIndex == 1) handleMouseMove();
    }
  }

  void handleMouseMove()
  {
    int origy = mousey;
    super.handleMouseMove();
    if ( showList && mousex > x && mousex < x+w && mousey > y+h && mousey < y+h+font*1.3*min(listItems.size(),maxSize)+5 )
    {
      selectIndex = floor((mousey - (y+h+3))/(font*1.3));
      if (selectIndex >= maxSize - 1 || selectIndex <= 0) {
        if (selectIndex >= maxSize - 1) {offset  ++;  if (listItems.size() - 1 < selectIndex + offset) offset = listItems.size()-selectIndex -1;}
        if (selectIndex <= 0) {offset --; selectIndex++; if (offset < 0) offset = 0;} 
      }
    }
    else
    {
      selectIndex = -1;
    }
  }

  void handleMousePressed()
  {
    super.handleMousePressed();
    if ( !( mousex > x && mousex < x+w && mousey > y+h && mousey < y+h+font*1.3*min(listItems.size(),maxSize) ) )
    {
      showList = false;
      droppedList = null;
    }
  }

  void handleMouseReleased()
  {
    if ( mouseIsOn() && clicked )
    {
      showList = true;
      droppedList = this;
    }
    else
    {
      if ( showList && mousex > x && mousex < x+w && mousey > y+h && mousey < y+h+font*1.3*min(listItems.size(),maxSize) )
      {
        currentIndex = floor((mousey - (y+h+5))/(font*1.3)) + offset;

        if ( this == cardFaction )
        {
          String images[] = { 
            "frame_forest.png", "frame_swamp.png", "frame_tundra.png", "frame_mountain.png", "frame_demon.png", "frame_special.png"
          };
          pic.img = loadImage(images[currentIndex]);
        }
        else if ( this == cardStars )
        {
          for ( int i = 0; i < 5; ++ i )
            picStars[ i ].img = i <= currentIndex ? loadImage("star.png") : null;
        }
        else
          filterCards(false);
      }
      showList = false;
      droppedList = null;
    }
    super.handleMouseReleased();
  }
}

class ListBox extends Control
{
  ArrayList< String > listItems = new ArrayList< String >();
  ArrayList< Integer > current = new ArrayList< Integer >();
  int selectIndex = -1;
  int scroll = 0;
  int scrollStart = 0;
  int lineSize = 0;
  int dragStartY = -1;
  boolean hasScroll = false;
  boolean multiselect = true;
  boolean selected = false;
  int lastClickTime = millis();
  int mousePressy = -1;

  ListBox( String t, int xx, int yy, int ww, int hh, int i )
  {
    super(t, xx, yy, ww, hh, i);
    lineSize = h/(int)floor(h / (font*1.3));
  }

  void draw(PGraphics pg)
  {
    /*pg.strokeWeight(1);
     pg.noFill();
     pg.stroke(0);
     pg.rect(x,y,w,h);*/
    pg.image( imgFrame[ w > h ? 1 : 0 ], x, y, w, h );

    hasScroll = listItems.size() > h/lineSize;
    int b = 4;
    if ( hasScroll )
    {
      boolean onScroll = mousex > x+w-lineSize && mousex < x+w && mousey > y+scroll && mousey < y+scroll+lineSize;
      /*pg.rect( x+w-lineSize, y, lineSize, h );
       pg.strokeWeight(onScroll?3:1);
       pg.rect( x+w-lineSize, y+scroll, lineSize, lineSize );
       pg.strokeWeight(1);
       if( (clicked&&dragStartY != -1))
       pg.fill(200);
       pg.triangle(x+w-lineSize+b, y+scroll+b,
       x+w-b, y+scroll+b,
       x+w-lineSize+(lineSize)/2, y+scroll+lineSize-b );*/
      pg.image( imgScroll, x+w-27, y+scroll+b-3, 28, 26 );
    }

    pg.pushMatrix();
    
    scroll = min(scroll,h-lineSize);
    int scrollOffset = round(scroll / float(h-lineSize) * (listItems.size()-h/lineSize));
    int TopRow = (this == evoList ? 1 :0);
    if (this == evoList) {
      text = listItems.get(0) + ((selected && current.contains(0) && millis() % 1000 < 500) ? "|" : "");
      if ( current.contains( 0 ) )
      {
        pg.image( imgSelected[ 1 ], x, y, w-(hasScroll?lineSize:0), lineSize);
      }
      if ( 0 == selectIndex )
      {
        pg.image( imgSelected[ 1 ], x, y, w-(hasScroll?lineSize:0), lineSize);
        pg.image( imgSelected[ 0 ], x, y, w-(hasScroll?lineSize:0), lineSize);
      }
      super.draw(pg);
      pg.translate( 0, lineSize );
    }
    for ( int i = TopRow; i + scrollOffset >=0 && i + scrollOffset <= listItems.size() && i < h/lineSize; ++ i )
    {
      if( i + scrollOffset == listItems.size() && !( this == deckList[ 0 ] || this == deckList[ 1 ] ) ) continue;
      if( i + scrollOffset < listItems.size() )
        text = listItems.get( i + scrollOffset ) + ((selected && current.contains(i+ scrollOffset) && millis() % 1000 < 500) ? "|" : "");
      else
        text = "" + ((selected && current.contains(i+ scrollOffset) && millis() % 1000 < 500) ? "|" : "");
      if ( current.contains( i+scrollOffset ) )
      {
        /*pg.strokeWeight(1);
         pg.fill(225);
         pg.stroke(0);
         pg.rect(x,y,w-(hasScroll?lineSize:0),lineSize);*/
        pg.image( imgSelected[ 1 ], x, y, w-(hasScroll?lineSize:0), lineSize);
      }
      if ( i == selectIndex )
      {
        /*pg.strokeWeight(3);
         pg.noFill();
         pg.stroke(0);
         pg.rect(x,y,w-(hasScroll?lineSize:0),lineSize);*/
        pg.image( imgSelected[ 1 ], x, y, w-(hasScroll?lineSize:0), lineSize);
        pg.image( imgSelected[ 0 ], x, y, w-(hasScroll?lineSize:0), lineSize);
      }
      super.draw(pg);
      pg.translate( 0, lineSize );
    }
    pg.popMatrix();
  }


  void handleMouseMove()
  {
    super.handleMouseMove();
    if ( dragStartY != -1 )
    {
      scroll = min( h-lineSize, max( 0, (mousey - (dragStartY-(y+scrollStart))) - y ) );
    }
    if ( mouseIsOn() && (!hasScroll || mousex < x+w-lineSize) )
    {
      selectIndex =  (mousey - y)/lineSize;
      //println(scroll + " " +mousey );
    }
    else
    {
      selectIndex = -1;
    }
  }

  void handleMousePressed()
  {
    super.handleMousePressed();
    dragStartY = -1;
    mousePressy = mousey;
    if ( mouseIsOn() && clicked )
    {
      if ( mousex > x+w-lineSize && mousey > y+scroll && mousey < y+scroll+lineSize )
      {
        scrollStart = scroll;
        dragStartY = mousey;
      }
      else {
        draggedList = this;
        selected = true;
        selectedList = this;
        int scrollOffset = round(scroll / float(h-lineSize) * (listItems.size()-h/lineSize));
        int newCurrentIndex = (mousey - y)/lineSize + (((mousey - y)/lineSize == 0 & this == evoList) ? 0 : scrollOffset);
        // Clicked a list item
        if ( newCurrentIndex >= 0 && newCurrentIndex < listItems.size() )
        {
          int lastSelected = current.size() > 0 ? current.get( current.size() - 1 ) : -1;
          if ( !(multiselect && keyPressed && key == CODED && ( keyCode == CONTROL ) ) ) {
            current.clear();
          }
          if ( keyPressed && keyCode == SHIFT && key == CODED ){
            for ( int i = min( lastSelected, newCurrentIndex ); i <= max( lastSelected, newCurrentIndex ); ++ i ) current.add( i );
          }
          else if ( current.contains( newCurrentIndex ) ) {
            current.remove( (Integer)newCurrentIndex );
          }
          else {
            current.add( newCurrentIndex );
          }
        }
      }
    }
    else if ((this == deckList[1] || this == deckList[0]) && (deckList[1].mouseIsOn() || deckList[0].mouseIsOn())) current.clear();
  }

  void handleMouseReleased()
  {
    dragStartY = -1;
    
//    if( selectedList == this )
//    {
//      selected = false;
//      selectedList = null;
//      current.remove( (Integer) listItems.size() );
//      listItems.remove("");
//      showDeckCost( 0 );
//      showDeckCost( 1 );
//    }
    if ( mouseIsOn() && clicked && (!hasScroll || mousex < x+w-lineSize) && !(keyPressed && key == CODED && ( keyCode == CONTROL ) ) && !( keyPressed && keyCode == SHIFT && key == CODED ))
    {
      if( selectedList != null )
      {
        selectedList.current.remove( (Integer) selectedList.listItems.size() );
        selectedList.selected = false;
        selectedList.listItems.remove("");
        if (this != listresult) {
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
      }
      selected = true;
      selectedList = this;
      int scrollOffset = round(scroll / float(h-lineSize) * (listItems.size()-h/lineSize));
      int newCurrentIndex = (mousey - y)/lineSize + scrollOffset;
      // Clicked a list item
      if ( newCurrentIndex >= 0 && newCurrentIndex < listItems.size() && (this == deckList[0] || this == deckList[1] || this == decks) && this.current.size() > 0 ) {
        if (mousePressy != mousey)
        for ( Integer i : this.current )
        {
          listItems.add( newCurrentIndex,listItems.get( (int)i ) );
          if (newCurrentIndex >= (int) i) listItems.remove( (int) i);
          else listItems.remove( (int) i + 1);
          if (this == decks) {
            savedDecks.add( newCurrentIndex,savedDecks.get( (int)i ) );
            if (newCurrentIndex >= (int) i) savedDecks.remove( (int) i);
            else savedDecks.remove( (int) i + 1);
          }
        }
 //        int lastSelected = current.size() > 0 ? current.get( current.size() - 1 ) : -1;
//        if ( !(multiselect && keyPressed && key == CODED && ( keyCode == CONTROL ) ) )
//          current.clear();
//        if ( keyPressed && keyCode == SHIFT && key == CODED )
//          for ( int i = min( lastSelected, newCurrentIndex ); i <= max( lastSelected, newCurrentIndex ); ++ i ) current.add( i );
//        else if ( current.contains( newCurrentIndex ) )
//          current.remove( (Integer)newCurrentIndex );
//        else
//          current.add( newCurrentIndex );
      }
      // Clicked after list items
      else if( newCurrentIndex >= 0 && ( this == deckList[ 0 ] || this == deckList[ 1 ] ) )
      {
        showDeckCost( 0, true );
        showDeckCost( 1, false );
        current.clear();
        current.add( listItems.size() );
        listItems.add( "" );
      }
      // Double clicked an evolution
      if( millis() - lastClickTime < 500 && this == evoList && evoList.current.size() == 1 )
      {
        for( int d = 0; d < 2; ++ d )
        {
          for( Integer i : deckList[ d ].current )
          {
            if( i == deckList[ d ].listItems.size() ) continue;
            Card c = cardFromString( deckList[ d ].listItems.get( i ) );
            if( c == null )
            {
              listresult.listItems.clear();
              listresult.listItems.add( "Invalid card: " + deckList[ d ].listItems.get( i ) );
              continue;
            }
            if( evoList.current.get( 0 ) == 0 )
            {
              c.evo = AType.A_NONE;
            }
            else
            {
              String el = evoList.listItems.get( (int)evoList.current.get( 0 ) );
              el = el.substring( 0, el.lastIndexOf(' ') );
              c.evo = abilities.get( el );
              c.evoLevel = ( int )textEvo.lastNum;
            }
            deckList[ d ].listItems.set( i, "" + c );
          }
        }
      }
      lastClickTime = millis();
    }
    else if ( mouseIsOn() && !clicked && draggedList != null && draggedList != this && (!hasScroll || mousex < x+w-lineSize) )
    {
      if ( draggedList == cards )
      {
        if ( this == deckList[ 0 ] )
        {
          addCardsToDeck(0);
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
        else if ( this == deckList[ 1 ] )
        {
          addCardsToDeck(1);
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
      }
      if ( draggedList == decks )
      {
        if ( this == deckList[ 0 ] )
        {
          if ( decks.current.size() > 0 )
          {
            deckToUI( decks.current.get(0), 0 );
          }
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
        else if ( this == deckList[ 1 ] )
        {
          if ( decks.current.size() > 0 )
          {
            deckToUI( decks.current.get(0), 1 );
          }
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
      }
      else if ( this == decks )
      {
        if ( draggedList == deckList[ 0 ] )
        {
          if ( decks.listItems.contains( textdeck[ 0 ].textIn ) )
          {
            savedDecks.set(  decks.listItems.indexOf( textdeck[ 0 ].textIn ), deckFromUI( 0, true ) );
          }
          else
          {
            savedDecks.add( deckFromUI( 0, true ) );
            decks.listItems.add( textdeck[ 0 ].textIn );
          }
          saveDecks();
        }
        else if ( draggedList == deckList[ 1 ] )
        {
          if ( decks.listItems.contains( textdeck[ 1 ].textIn ) )
          {
            savedDecks.set(  decks.listItems.indexOf( textdeck[ 1 ].textIn ), deckFromUI( 1, true ) );
          }
          else
          {
            savedDecks.add( deckFromUI( 1,true ) );
            decks.listItems.add( textdeck[ 1 ].textIn );
          }
          saveDecks();
        }
      }
      else if ( this == cards )
      {
        if ( draggedList == deckList[ 0 ] )
        {
          Collections.sort(deckList[0].current, Collections.reverseOrder());
          for ( Integer i : deckList[0].current )
          {
            deckList[0].listItems.remove( (int)i );
          }
          deckList[0].current.clear();
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
        else if ( draggedList == deckList[ 1 ] )
        {
          Collections.sort(deckList[1].current, Collections.reverseOrder());
          for ( Integer i : deckList[1].current )
          {
            deckList[1].listItems.remove( (int)i );
          }
          deckList[1].current.clear();
          showDeckCost( 0, true );
          showDeckCost( 1, false );
        }
      }
      else if ( this == deckList[ 0 ] && draggedList == deckList[ 1 ] )
      {
        Collections.sort(deckList[1].current, Collections.reverseOrder());
        for ( Integer i : deckList[1].current )
        {
          deckList[0].listItems.add( deckList[1].listItems.remove( (int)i ) );
        }
        deckList[1].current.clear();
        showDeckCost( 0,true );
        showDeckCost( 1,false );
      }
      else if ( this == deckList[ 1 ] && draggedList == deckList[ 0 ] )
      {
        Collections.sort(deckList[0].current, Collections.reverseOrder());
        for ( Integer i : deckList[0].current )
        {
          deckList[1].listItems.add( deckList[0].listItems.remove( (int)i ) );
        }
        deckList[0].current.clear();
        showDeckCost( 0,true );
        showDeckCost( 1,false );
      }
    }
    super.handleMouseReleased();
  }

  void handleKeyboard()
  {
    if( selected && selectedList == this && focus)
    {
      if( key == '' )
      {
        //println(current.size());
        String string = "";
        for( int i = 0; i < current.size(); ++ i )
          string += listItems.get( current.get( i ) ) + (i < current.size() - 1 ? "\n" : "");
        cp.copyString(string);
        return;
      }
      if( key == '' && (this == deckList[0] || this == deckList[1] ) )
      {
        String p = cp.pasteString();
        String[] tokens = p.split("\n");
        for (String token : tokens)
        {
            listItems.add( token );
        }
        return;
      }
    
      if( this == cards )
      {
        
      }
      else if( this == evoList )
      {
        
      }
      else if(( this == deckList[ 0 ] || this == deckList[ 1 ] ) && current.size() == 1) //modified code for enter key and colon
      {
        if (key == '\n') {
          showDeckCost( 0, true );
          showDeckCost( 1, false );
          current.clear();
          if (!listItems.get(listItems.size() - 1).equals("")) {
            current.add( listItems.size() );
            listItems.add( "" );
            if (listItems.size() > h/lineSize)  scroll = (h-lineSize)*(50)/(listItems.size()-h/lineSize); 
          }
        }
        else if( ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) || key == BACKSPACE || key == ':' || key == ' ' || key == ';' || key == '\'' || key == '(' || key == ')' || key == '-' || (key >= '0' && key <= '9') )
        {
          for( Integer i : current )
          {
            if( key == BACKSPACE )
            {
              listItems.set( i, listItems.get( i ).substring( 0, max( listItems.get( i ).length() - 1, 0 ) ) );
            }
            else
            {
              if( i == listItems.size() ) listItems.add( "" );
              listItems.set( i, listItems.get( i ) + key );
            }
          }
        }
      }
    }
    
    if ( this != deckList[0] ) return;
    int adjust = 0;
    if ( keyCode == UP && key == CODED )
    {
      adjust = 1;
    }
    else if ( keyCode == DOWN && key == CODED )
    {
      adjust = -1;
    }
    if ( adjust != 0 )
    {
      for ( int i = 0; i < 2; ++ i )
      {
        if (!(deckList[i].current.size() > deckList[i].listItems.size()))
          for ( int j = 0; j < deckList[i].current.size(); ++ j )
          {
            String s = deckList[i].listItems.get( deckList[i].current.get(j) );
            if( s.toLowerCase().substring( 0, min( s.length(), 4 ) ).equals( "rune" ) )
            {
              Rune r = runeFromString( s );
              if( r != null )
              {
                r.level = min( 4, max( 0, r.level + adjust ) );
                deckList[i].listItems.set( deckList[i].current.get(j), ""+r );
              }
            }
            else
            {
              Card c = cardFromString( s );
              if( c != null )
              {
                c.lvl = min( 15, max( 0, c.lvl + adjust ) );
                deckList[i].listItems.set( deckList[i].current.get(j), ""+c );
              }
            }
          }
      }
    }
    if ( keyCode == DELETE )
    {
      for ( int i = 0; i < 2; ++ i )
      {
        for ( int j = deckList[i].current.size() - 1; j >= 0 ; -- j )
        {
          deckList[i].listItems.remove( (int)deckList[i].current.get(j) );
        }
        deckList[i].current.clear();
        if (deckList[i].listItems.size() <= h/lineSize) {scroll = 0;}
      }
      showDeckCost(0,true);
      showDeckCost(1,false);
    }
  }
}

void addCardsToDeck(int p)
{
  deckList[ p ].listItems.remove("");
  for ( Integer i : cards.current )
  {
    String line = cards.listItems.get( i );
    if ( line.substring( 0, Math.min( line.length(), 6 ) ).equals( "Rune: " ) )
    {
      deckList[p].listItems.add( line );
      continue;
    }

    String evo = "";
    if ( evoList.current.size() > 0 && evoList.current.get(0) > 0 )
    {
      String el = evoList.listItems.get( (int)evoList.current.get( 0 ) );
      el = el.substring( 0, el.lastIndexOf(' ') );
      String e = evoNames.get( el );
      evo = evoList.current.size() > 0 ? (e + (int)textEvo.lastNum ) : "";
    }
    String card = cards.listItems.get( i );
    int cardEnd = card.length(); //card.lastIndexOf( ';' );
    if ( cardEnd < 0 ) cardEnd = card.length();
    String card2 = card.substring( 0, cardEnd ) + ";" + evo + card.substring( cardEnd, card.length() );
    Card c = cardFromString( card2 );
    deckList[p].listItems.add( c.toString() );
  }
  showDeckCost( 0, true );
  showDeckCost( 1, false );
}

class Picture extends Control
{
  PImage img;
  int tint = 255;

  Picture( String t, int xx, int yy, int ww, int hh, int i, PImage ig )
  {
    super(t, xx, yy, ww, hh, i);
    img = ig;
  }

  void draw(PGraphics pg)
  {
    if ( img != null )
    {
      pg.tint(255,tint);
      pg.image( img, x, y, w, h );
    }
  }

  void handleMousePressed()
  {
    super.handleMousePressed();
    if ( mouseIsOn() && clicked && FOHDownload) {
      for (int i=0;i<8;i++) {
        if (this == picPlayerAvatar[i]) {
          fohPlayer.text = "Player: " + PlayerNames[i].text;
          Deck deckPlayer = deckFromFOH(1, i/2, i%2, true);
          fohLevel.text = "Level: " + deckPlayer.level;
          fohHealth.text = "Health: " + hpPerLevel[deckPlayer.level];
          int deckCost = 0;
          int initative = hpPerLevel[deckPlayer.level];
          fohDeck.text = "Deck: \n";
          for ( int j = 0; j < min(10,deckPlayer.numCards); ++ j )
          {
            initative += deckPlayer.cards[j].type.hp[deckPlayer.cards[j].lvl];
            initative += deckPlayer.cards[j].type.atk[deckPlayer.cards[j].lvl];
            deckCost += deckPlayer.cards[j].cost;
            fohDeck.text += "   " + deckPlayer.cards[j].toStringNoHp() + "\n";
          }
          for ( int j = 0; j < deckPlayer.numRunes; ++ j )
          {
            fohDeck.text += "   " + deckPlayer.runes[j] + "\n";
          }
          fohDeckCost.text = "Deck Cost: " + deckCost;
          fohInitativeCost.text = "Initative: " + initative;
        }
      }
    }
  }

}

void drawEKnumber( PGraphics pg, int num, int x, int y, boolean whiteFont, float scale )
{
  pg.pushMatrix();
  pg.translate( x + (num < 10 ? 12 : 0), y );
  String numString = "" + num;
  for ( int i = 0; i < numString.length(); ++ i )
  {
    int n = numString.charAt( i ) - '0';
    pg.image( whiteFont ? imgHpAtkNum[ n ] : imgCostNum[ n ], 0, 0, 25*scale, 30*scale );
    pg.translate( (whiteFont?26:25)*scale, 0 );
  }
  pg.popMatrix();
}

void saveResults(File selection) {
  try {
    if (selection != null) {  
      PrintWriter writer = new PrintWriter(selection.getAbsolutePath(), "UTF-8");
      if (uiTab != 4){
        for (int p=0;p<2;p++){
          writer.println("Deck #" + p+1 + " Name:" + textdeck[ p ].textIn);
          writer.println("  Level: " + (int)textLevel[ p ].lastNum);
          writer.println("  Cards:");
          for( int i = 0; i < deckList[p].listItems.size(); ++ i )
            {
              writer.println("    " + deckList[p].listItems.get( i ));
            }
          writer.println("");
        }
      }
      else if (uiTab == 4 && FOHDownload) 
      {  
        if (FOHRound == 1) FOHMatch = 4;
        else if (FOHRound == 2) FOHMatch = 2;
        else FOHMatch = 1;
        for (int m=0;m<FOHMatch;m++)
          for (int p=0;p<2;p++) {
            Deck d = deckFromFOH( FOHRound, m, p, false );
            writer.println("Match: " + (m+1) + " Deck #" + (p+1) + " Name: " + d.name);
            writer.println("  Level: " + d.level);
            writer.println("  Cards:");
            for( int c = 0; c < d.numCards; ++ c )
            {
              writer.println("    " +  d.cards[ c ]);
            }
            for( int r = 0; r < d.numRunes; ++ r )
            {
              writer.println("    " +  d.runes[ r ]);
            }
            writer.println("");
          }
      }
      else {
        listresult.listItems.clear();
        listresult.listItems.add("FOH Tab selected and FOH information not downloaded");
        return;
      }
      writer.println("Results:");
      for( int i = 0; i < listresult.listItems.size(); ++ i )
      {
        writer.println("  " + listresult.listItems.get(i));
      }
      writer.close();
    }
  }  
  catch(Exception e)
  {
    println(e);
  }      
}


