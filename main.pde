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
    background(255, 255, 255);
    menu();
}

//--------------------------------------------------
void menu(){
  // side bar
  noStroke();
  fill(67, 67, 67);
  block.setContainerAnker("topLeft");
  block.box(0, 0, 8, 16);
  block.setContainerAnker("topRight");
  block.box(0, 0, 8, 16);
  // shape_button
    button.setContainerAnker("topLeft");
    button.setBlockMode("vertical");
    button.setBlockAnker("CENTER");
    //add_rectangle
    button.test_button(4, 3, 2.5, 2.5);
    //add_ellipse
    button.test_button(4, 6, 2.5, 2.5);
  
  // layer_box
    button.setContainerAnker("bottomLeft");
    button.setBlockMode("vertical");
    button.setBlockAnker("CORNER");
    block.box(0.5, 0.5, 7, 5);
    
  
  // other_button
    button.setContainerAnker("bottomRight");
    button.setBlockMode("vertical");
    button.setBlockAnker("CENTER");
    //save_prj
    button.test_button(-0.5, 6, 1.8, 1.8);
    button.test_button(-0.5, 4, 1.8, 1.8);
    button.test_button(-0.5, 2, 1.8, 1.8);
    button.test_button(-0.5, 0, 1.8, 1.8);


  /*
  noFill();
  stroke(255, 0, 0);
  block.setBlockAnker("CORNER");
  block.setContainerAnker("topLeft");
  block.debugGrid(10, 10);

  stroke(0, 255, 0);
  block.setBlockAnker("CORNER");
  block.setContainerAnker("bottomRight");
  block.debugGrid(10, 10);
  */
}

