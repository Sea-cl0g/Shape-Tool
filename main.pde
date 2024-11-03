Block block;
Popup popup;

//--------------------------------------------------
void setup(){
  size(800, 450);
  surface.setResizable(true);

    block = new Block(10, 10);
    popup = new Popup(10, 10);
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
  block.box(0, 0, 2, 10, "topLeft", "vertical");
  noFill();
  for(int i = 0; i < 10; i++){
    for(int q = 0; q < 10; q++){
      stroke(255, 0, 0);
      block.box(q, i, 1, 1, "topLeft", "vertical");
      stroke(0, 0, 255);
      //block.box(q, i, 1, 1, "topLeft", "both");
      stroke(0, 255, 0);
      //block.box(q, i, 1, 1, "topLeft", "horizontal");
   }
  }
  /*
  // side bar
  noStroke();
  fill(47, 55, 54);
  block.box(0, 0, 5, 10, "topLeft", "vertical");
  block.box(0, 0, 5, 10, "topRight", "vertical");
  // shape_button
  noStroke();
  fill(255, 255, 255);
  stroke(0, 0, 0);
  block.box(3, 2, 1, 1, "topLeft", "vertical");
  */
}
