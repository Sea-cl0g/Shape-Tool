Block block;
Popup popup;

//--------------------------------------------------
void setup(){
  size(800, 450);
  surface.setResizable(true);

    block = new Block(16, 16);
    popup = new Popup(16, 16);
}

void draw() {
    background(255);
    menu();
}

//--------------------------------------------------
void menu(){
  // side bar
  noStroke();
  fill(47, 55, 54);
  block.blockAnker("CORNER");
  block.box(0, 0, 8, 16, "topLeft", "vertical");
  block.box(0, 0, 8, 16, "topRight", "vertical");
  // shape_button
  fill(255, 255, 255);
  stroke(0, 0, 0);
  block.blockAnker("CENTER");
  block.box(4, 4, 3, 3, "topLeft", "vertical");

  
  ///*
  noFill();
  block.blockAnker("CORNER");
  for(int i = 0; i < 20; i++){
    for(int q = 0; q < 20; q++){
      stroke(255, 0, 0);
      block.box(q, i, 1, 1, "topLeft", "vertical");
      stroke(0, 0, 255);
      //block.box(q, i, 1, 1, "topLeft", "both");
      stroke(0, 255, 0);
      //block.box(q, i, 1, 1, "topLeft", "horizontal");
   }
  }
  //*/
}
