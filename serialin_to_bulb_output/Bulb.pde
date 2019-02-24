class Bulb {
  int xpos;
  int ypos;
  int bulbId;
  String url;
  boolean on;
  int fadeCount=100;
  Bulb(int _x, int _y, int _id, String _url) {
    xpos=_x;
    ypos=_y;
    bulbId=_id;
    url=_url;
  }

  //draw ellipse and load url 
  void draw() {
    ellipseMode(CENTER);
    noStroke();

    if (on) {
      on=false;
      fadeCount=0;
      loadURL();
      //stroke(255);
      //line(lastPos.x, lastPos.y, x, y);
    } else {
      fadeCount+=2;
      if (fadeCount>255)fadeCount=255;
      fill(fadeCount);
    }

    ellipse(xpos, ypos, 10, 10);

    //stroke(0);
    fill(240);
    text(bulbId, xpos+8, ypos-3);
  }



  void plotLineLow(int x0, int y0, int  x1, int y1) {
    int dx = x1 - x0;
    int dy = y1 - y0;
    int yi = 1;
    if (dy < 0) {
      yi = -1;
      dy = -dy;
    }
    int D = 2*dy - dx;
    int  y = y0;

    for (int x = x0; x < x1; x++) {
      plot(x, y);
      if (D > 0) {
        y = y + yi;
        D = D - 2*dx;
      }
      D = D + 2*dy;
    }
  }

  void plotLineHigh(int x0, int y0, int  x1, int y1) {
    int dx = x1 - x0;
    int dy = y1 - y0;
    int xi = 1;
    if (dx < 0) {
      xi = -1;
      dx = -dx;
    }
    int D = 2*dx - dy;
    int x = x0;

    for (int y = y0; y<= y1; y++) {
      plot(x, y);
      if (D > 0) {
        x = x + xi;
        D = D - 2*dy;
      }
      D = D + 2*dx;
    }
  }

  void plot(int x, int y) {
    int n;

    if (y%2==0) n=int(x+y*(gridX-1));
    else n=int((gridX-1)-x+y*(gridX-1));


    bulbs[n].on=true;
  }

  void drawLine() {
    int y0=bulbId/(gridX-1);
    int x0;
    if (y0%2==0)x0=bulbId%(gridX-1);
    else x0=(gridX-1)-bulbId%(gridX-1);


    //println(bulbId+":"+x0+","+y0);

    //int x1=lastbulbId%(gridX-1);
    int y1=lastbulbId/(gridX-1);

    int x1;
    if (y1%2==0)x1=lastbulbId%(gridX-1);
    else x1=(gridX-1)-lastbulbId%(gridX-1);


    if (abs(y1 - y0) < abs(x1 - x0)) {
      if (x0 > x1) {
        plotLineLow(x1, y1, x0, y0);
      } else {
        plotLineLow(x0, y0, x1, y1);
      }
    } else {
      if ( y0 > y1) {
        plotLineHigh(x1, y1, x0, y0);
      } else {
        plotLineHigh(x0, y0, x1, y1);
      }
    }

    lastbulbId=bulbId;
  }



  //load url
  void loadURL() {
    //println(bulbId);
    //img= loadImage(url);
  }

  //allow mousepress to debug and interact with bulb grid
  void update() {
    if (mousePressed) {
      if (mouseX>xpos-scaleX/2 && mouseX<xpos+scaleX/2 && mouseY>ypos-scaleY/2 && mouseY<ypos+scaleY/2) 
        //on=true;
        drawLine();
      //println("drawline");
    }
  }
}
