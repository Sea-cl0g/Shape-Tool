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
  noFill();
  strokeWeight(1);

  stroke(0, 0, 0);
  block.setContainerAnker("topLeft");
  block.setBlockMode("vertical");
  block.setBlockAnker("CORNER");
  block.debugGrid(10, 10);

  stroke(255, 0, 0);
  block.setBlockMode("vertical");
  block.setBlockAnker("CORNER");
  block.setContainerAnker("topLeft");
  block.box(2, 2, 3, 3);

  stroke(0, 0, 255);
  block.setBlockMode("vertical");
  block.setBlockAnker("CENTER");
  block.setContainerAnker("topLeft");
  block.box(2, 2, 3, 3);
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