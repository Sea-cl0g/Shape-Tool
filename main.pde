Block block;
Dialog dialog;
StandardButton button;

boolean isMouseClicking;

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
    isMouseClicking = mousePressed;
    menu();
}

color backgroundCol = color(67, 67, 67);

//--------------------------------------------------
void menu(){
  // side bar
  noStroke();
  fill(backgroundCol);
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
    dialog.setContainerAnker("bottomLeft");
    dialog.setBlockMode("vertical");
    dialog.setBlockAnker("CENTER");
    dialog.drawLayerBox(3.5, 4, 6, 7);
  // other_button
    button.setContainerAnker("bottomRight");
    button.setBlockMode("vertical");
    button.setBlockAnker("CORNER");
    button.test_button(0.5, 6.5, 1.8, 1.8);
    button.test_button(0.5, 4.5, 1.8, 1.8);
    button.test_button(0.5, 2.5, 1.8, 1.8);
    button.test_button(0.5, 0.5, 1.8, 1.8);
}

//checkBlocks(1, 1, "vertical", "CENTER");
void checkBlocks(int wCount, int hCount, String blockMode, String blockAnker){
  Block tmpBlock = new Block(16, 16);
    tmpBlock.setBlockMode(blockMode);
    tmpBlock.setBlockAnker(blockAnker);
    tmpBlock.setContainerAnker("topLeft");
    tmpBlock.debugGrid(wCount, hCount);
    tmpBlock.setContainerAnker("topRight");
    tmpBlock.debugGrid(wCount, hCount);
    tmpBlock.setContainerAnker("bottomLeft");
    tmpBlock.debugGrid(wCount, hCount);
    tmpBlock.setContainerAnker("bottomRight");
    tmpBlock.debugGrid(wCount, hCount);
}