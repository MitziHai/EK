void FOH()
{
  try
  {
    EkClient client = new EkClient();
    listresult.listItems.clear();
    listresult.listItems.add( "Downloading decks and match info for server " + servers.listItems.get(servers.currentIndex));
    String decks = client.getFoHDeckForServer(servers.listItems.get(servers.currentIndex).toLowerCase(), evoNames);
    PrintWriter writer = new PrintWriter("foh_"+ servers.listItems.get(servers.currentIndex)+"_decks.txt", "UTF-8");
    writer.println(decks);
    writer.close();
    String lines[] = decks.split("\n");
    Boolean NameNext = false;
    int PlayerID = 0; 
//    for (int i = 0; i < lines.length && PlayerID < 8; i++) {
//      println(lines[i]);
//      if (lines[i].equals(lines[2]))
//      {
//        println("NAME NEXT");
//        NameNext = true;
//      }
//      else if (NameNext == true)
//      {
//        PlayerNames[PlayerID].text = lines[i];
//        PlayerNames[PlayerID].draw(pg);
//        picPlayerAvatar[ PlayerID ].img = loadImage( "PhotoCards\\img_photoCard_D.PNG" ) ;
//        PlayerID++;
//        NameNext = false;
//      }
//    }

    
    listresult.listItems.add( "Success. File foh_"+ servers.listItems.get(servers.currentIndex)+"_decks.txt created please load and sim.");
  }
  catch(Exception e)
  {
    listresult.listItems.add( "Unsuccesful donwload please see log.txt for details");
    println(e);
  }      
}


void FOH_RUN()
{
//        if (PlayerID%2 == 1)  picPlayerAvatar[ PlayerID ].tint = 63;
//        else  picPlayerAvatar[ PlayerID ].tint = 255;



}

