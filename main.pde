Block block;
Dialog dialog;
StandardButton button;

//--------------------------------------------------
void setup(){
  size(800, 450);
  surface.setResizable(true);

    block = new Block(16, 16);
    dialog = new Dialog(16, 16);0000
    button = new StandardButton(16, 16);
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
  button.normalButton();

  noFill();
  stroke(255, 0, 0);
  block.blockAnker("CORNER");
  block.debugGrid("topLeft", "vertical");
}
