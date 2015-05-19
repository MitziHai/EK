void FOH()
{
  try
  {
    listresult.listItems.clear();
    listresult.listItems.add( "Downloading decks and match info for server " + servers.listItems.get(servers.currentIndex));
    EkClient client = new EkClient();
    String decks = client.getFoHDeckForServer(servers.listItems.get(servers.currentIndex).toLowerCase(), evoNames);
    PrintWriter writer = new PrintWriter("foh_"+ servers.listItems.get(servers.currentIndex)+"_decks.txt", "UTF-8");
    String lines[] = decks.split("\n");
    Boolean NameNext = false;
    int PlayerID = 0; 
    String parts[];
    for (int i = 0; i < lines.length; i++) 
    {
      lines[i] = lines[i].substring(0,lines[i].length()-1);
      if (lines[i].length() < 2) {
        writer.println("");
        NameNext = true;
        continue;
      }
      if (i <= 1 || NameNext) {
        writer.println(lines[i]);
        NameNext = false;
      }
      else if (lines[i].matches("\\d+$")) writer.println(lines[i]);
      else if( lines[i].substring( 0, Math.min( lines[i].length(), 6 ) ).toLowerCase().equals( "rune: " ) )
      {
        writer.println(lines[i]);
      }
      else {
        parts = lines[i].split(";");
        if (parts.length == 4) {
          if (cardsMap.get(parts[0]).cost < Integer.parseInt(parts[3]))
         { 
            parts[3] = str(Integer.parseInt(parts[3]) - cardsMap.get(parts[0]).cost);
            if ((int)((Integer.parseInt(parts[2]) - 9)/2) == Integer.parseInt(parts[3])) parts[3] = "";
         }
          else parts[3] = "";
          lines[i] = parts[0] + ";" + parts[2] + (parts[3].equals("")?"":";" + parts[3]) + ";" + parts[1];
        }
        else {
          if (cardsMap.get(parts[0]).cost < Integer.parseInt(parts[2])) {
            parts[2] = str(Integer.parseInt(parts[2]) - cardsMap.get(parts[0]).cost);
            if ((int)((Integer.parseInt(parts[1]) - 9)/2) == Integer.parseInt(parts[2])) parts[2] = "";
          }
          else parts[2] = "";
          lines[i] = parts[0] + ";" + parts[1] + (parts[2].equals("")?"":";" + parts[2]);
        }
        writer.println(lines[i]);
      }
    }
    writer.close();

    
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

