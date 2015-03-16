
ArrayList< Result > resultsTracked = new ArrayList< Result >();
ArrayList< Result > resultsBest = new ArrayList< Result >();

/*long totalmeritMax;
long totalmeritMin;
long totalroundsMin;
long totalroundsMax;*/

TextField numBars;
RadioButton barGraph;
RadioButton lineGraph;
Checkbox verticalZero;

class Result
{
  float score;
  int rounds;
  
  Result( float s, int r )
  {
    score = s;
    rounds = r;
  }
}

void drawGraph(PGraphics pg)
{
  long rangeMerit = totalmeritMax - totalmeritMin;
  long rangeRounds = totalroundsMax - totalroundsMin;
  int bars = (int)numBars.lastNum;
  int barWidth = (int)((1280-128-4)/bars);
  
  int meritPerBar = (int)max( (rangeMerit / bars), 1 );
  int roundsPerBar = (int)max( (rangeRounds / min(bars,rangeRounds)), 1 );
  
  int counter = 0;
  
  int barValues1[] = new int[ bars ];
  int barValues2[] = new int[ bars ];
  
  
  if( radkw.checked )
  {
    for( Result res : resultsBest )
    {
      ++ barValues1[ min( (int)((res.score - totalmeritMin) / meritPerBar), bars-1 ) ];
      ++ barValues2[ min( (int)((res.rounds - totalroundsMin) / roundsPerBar), bars-1 ) ];
    }
  }
  else if( raddi.checked )
  {
   // println("counter\tmerit\trounds");
    for( Result res : resultsBest )
    {
      counter++;
     //println(counter + "\t" + res.score + "\t" + res.rounds);
      ++ barValues1[ min( (int)((res.score - totalmeritMin) / meritPerBar), bars-1 ) ];
      ++ barValues2[ min( (int)((res.rounds - totalroundsMin) / roundsPerBar), bars-1 ) ];
    }
  }
  else
  {
    for( Result res : resultsBest )
    {
      //++ barValues1[ min( (int)((res.score - totalmeritMin) / meritPerBar), bars-1 ) ];
      ++ barValues2[ min( (int)((res.rounds - totalroundsMin) / roundsPerBar), bars-1 ) ];
    }
  }
  
  int minBar1 = -1;
  int maxBar1 = -1;
  int minBar2 = -1;
  int maxBar2 = -1;
  for( int i = 0; i < bars; ++ i )
  {
    if( minBar1 == -1 || barValues1[ i ] < minBar1 ) minBar1 = barValues1[ i ];
    if( maxBar1 == -1 || barValues1[ i ] > maxBar1 ) maxBar1 = barValues1[ i ];
    if( minBar2 == -1 || barValues2[ i ] < minBar2 ) minBar2 = barValues2[ i ];
    if( maxBar2 == -1 || barValues2[ i ] > maxBar2 ) maxBar2 = barValues2[ i ];
  }
  
  
  color col = color(240, 205, 175);
  color col2 = color(240/2, 205/2, 175/2);
  
  pg.strokeWeight(2);
  pg.stroke(col);
  pg.line( 64, 96, 64, listresult.y - 128 );
  pg.line( 64, listresult.y - 128, 1280-64, listresult.y - 128 );
  pg.textSize(min(12/(bars/20.0),12));
  
  if( raddi.checked )
  {
    pg.fill(col);
    pg.stroke(col);
    pg.text( "Merit", 4, listresult.y - 128 + 32 );
  }
  else if( radkw.checked )
  {
    pg.fill(col);
    pg.stroke(col);
    pg.text( "Wins", 4, listresult.y - 128 + 32 );
  }
  
  pg.fill(col2);
  pg.stroke(col2);
  pg.text( "Rounds", 4, listresult.y - 128 + 32 + 64 );
  
  int  lastValue1 = -1;
  int lastX1 = -1;
  int  lastValue2 = -1;
  int lastX2 = -1;
  boolean isBar = barGraph.checked;
  for( int i = 0; i < bars; ++ i )
  {
    int val1 = 0;
    int val2 = 0;
    if( verticalZero.checked ) // Start at minimum instead of 0 on vertical axis TODO ADD CHECKBOX FOR THIS
    {
      if( raddi.checked )
      {
        val1 = (int)(-(barValues1[i])/float(maxBar1)*((listresult.y - 128)-(64)));
        //val1 = (int)(-(barValues1[i]-(minBar1-1))/float(maxBar1-minBar1)*((listresult.y - 128)-(64)));
      }
      else if( radkw.checked )
      {
        val1 = (int)(-(barValues1[i])/float(maxBar1)*((listresult.y - 128)-(64)));
        //val1 = (int)(-(barValues1[i]-(minBar1-1))/float(maxBar1-minBar1)*((listresult.y - 128)-(64)));
      }
      val2 = (int)(-(barValues2[i])/float(maxBar2)*((listresult.y - 128)-(64)));
    }
    else
    {
      if( raddi.checked )
      {
        val1 = (int)(-(barValues1[i]-(minBar1-1))/float(maxBar1-minBar1)*((listresult.y - 128)-(64)));
      }
      else if( radkw.checked )
      {
        val1 = (int)(-(barValues1[i]-(minBar1-1))/float(maxBar1-minBar1)*((listresult.y - 128)-(64)));
      }
      if( resultsBest.size() > 0 )
        val2 = (int)(-(barValues2[i]-(minBar2-1))/float(maxBar2-minBar2)*((listresult.y - 128)-(64)));
    }
    
    pg.fill(col);
    pg.strokeWeight(1);
    pg.stroke(col);
    drawBar( 64 + 4 + max((barWidth-4),4)*i, listresult.y - 128, (int)(max(barWidth-4,4)/2*0.85), val1, lastValue1, lastX1, isBar );
    pg.text( ((i*meritPerBar+totalmeritMin)+"-\n"+((i+1)*meritPerBar+totalmeritMin)), 64 + 4 + max((barWidth-4),4)*i, listresult.y - 128 + 32 );
    pg.text(String.format("%.1f",float(100*barValues1[i]) / float(resultsBest.size()))+"%",64 + 4 + max((barWidth-4),4)*i,listresult.y - 128 + val1 - 5);

    pg.fill(col2);
    pg.stroke(col2);
    drawBar( (int)(64 + 4 + max((barWidth-4),4)*(i+0.5)), listresult.y - 128, (int)(max(barWidth-4,4)/2*0.85), val2, lastValue2, lastX2, isBar );
    pg.text( ((i*roundsPerBar+totalroundsMin)+"-\n"+((i+1)*roundsPerBar+totalroundsMin)), 64 + 4 + max((barWidth-4),4)*i, listresult.y - 128 + 32 + 32 + 32 );
    pg.text(String.format("%.1f",float(100*barValues2[i]) / float(resultsBest.size()))+"%",64 + 4 + max((barWidth-4),4)*(i+0.5),listresult.y - 128 + val2 - 5);

    lastValue1 = val1;
    lastX1 = 64 + 4 + max((barWidth-4),4)*i;
    lastValue2 = val2;
    lastX2 = (int)(64 + 4 + max((barWidth-4),4)*(i+0.5));
  }
}

void drawBar( int x, int y, int barWidth, int value, int lastValue, int lastx, boolean bar )
{
  pg.strokeWeight(1);
  if( bar )
  {
    pg.rect( x, y, barWidth, value );
  }
  else
  {
    pg.ellipse( x, y+value, barWidth/2, barWidth/2 );
    if( lastx > -1 )
    {
      pg.strokeWeight(2);
      pg.line( lastx, y+lastValue, x, y+value );
    }
  }
}
