Block block;
Dialog dialog;
StandardButton button;

//--------------------------------------------------
void setup(){
  size(800, 450);
  surface.setResizable(true);

    block = new Block(16, 16);
    dialog = new Dialog(16, 16);
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
  block.setContainerAnker("topLeft");
  block.box(0, 0, 8, 16);
  block.setContainerAnker("topRight");
  block.box(0, 0, 8, 16);
  // shape_button
  button.setBlockAnker("CENTER");
  button.drawRoundedSquareButton(4, 4, 3, 3, 1, color(255, 255, 255), false, "BOTTOMRIGHT", 0.3, color(0, 0, 0));
  button.test_button(4, 4, 3, 3);
  
  noFill();
  stroke(255, 0, 0);
  block.setBlockAnker("CORNER");
  block.setContainerAnker("topLeft");
  block.debugGrid(10, 10);

  stroke(0, 255, 0);
  block.setBlockAnker("CORNER");
  block.setContainerAnker("topRight");
  block.debugGrid(10, 10);
}

