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
  /*
  // side bar
  noStroke();
  fill(67, 67, 67);
  block.setContainerAnker("topLeft");
  block.box(0, 0, 7, 16);
  block.setContainerAnker("topRight");
  block.box(0, 0, 7, 16);
  // shape_button
    button.setContainerAnker("topLeft");
    button.setBlockMode("vertical");
    button.setBlockAnker("CENTER");
    //add_rectangle
    button.test_button(3.5, 3, 2.5, 2.5);
    //add_ellipse
    button.test_button(3.5, 6, 2.5, 2.5);
  
  // layer_box
    dialog.setContainerAnker("topRight");
    dialog.setBlockMode("vertical");
    dialog.setBlockAnker("CENTER");
    //dialog.drawLayerBox(3.5, 0, 6, 6);
  */
    dialog.setBlockMode("vertical");
    dialog.setBlockAnker("CORNER");
    dialog.setContainerAnker("topLeft");
    dialog.box(0, 0, 1, 1);
    dialog.setContainerAnker("topRight");
    dialog.box(0, 0, 1, 1);
    dialog.setContainerAnker("bottomLeft");
    dialog.box(0, 0, 1, 1);
    dialog.setContainerAnker("bottomRight");
    dialog.box(0, 0, 1, 1);
  /*
  // other_button
    button.setContainerAnker("bottomRight");
    button.setBlockMode("vertical");
    button.setBlockAnker("CORNER");
    button.test_button(0.5, 6.5, 1.8, 1.8);
    button.test_button(0.5, 4.5, 1.8, 1.8);
    button.test_button(0.5, 2.5, 1.8, 1.8);
    button.test_button(0.5, 0.5, 1.8, 1.8);


  //
  noFill();
  strokeWeight(1);

  stroke(0, 255, 0);
  block.setBlockAnker("CORNER");
  block.setContainerAnker("bottomLeft");
  block.debugGrid(10, 10);
  */
}

