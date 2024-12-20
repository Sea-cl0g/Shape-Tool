//マジックナンバー16を修正する
SafeLoad safeLoad;
Theme theme;
Canvas canvas;

boolean isMouseLeftClicking, isMouseRightClicking, isMouseCenterClicking;
boolean hasMouseLeftClicked;
boolean hasMouseTouched;
boolean isKeyPressing;

String configPath = "data/config.json";
JSONObject config;

//--------------------------------------------------
void setup(){
  size(800, 450);
  surface.setResizable(true);
  
  softPrepare();
  theme.loadTheme();
}

void draw() {
    hasMouseTouched = false;
    background(255, 255, 255);

    theme.drawGUI();
}

//--------------------------------------------------
void softPrepare(){
  config = loadJSONObject(configPath);
  safeLoad = new SafeLoad();
  theme = new Theme();
  canvas = new Canvas();
}


//--------------------------------------------------
void mousePressed() {
  if(mouseButton == LEFT){
    isMouseLeftClicking = true;
    hasMouseLeftClicked = true;
  }
  if(mouseButton == RIGHT){
    isMouseRightClicking = true;
  }
  if(mouseButton == CENTER){
    isMouseCenterClicking = true;
  }
}

void mouseReleased() {
  if(mouseButton == LEFT){
    isMouseLeftClicking = false;
    hasMouseLeftClicked = false;
  }
  if(mouseButton == RIGHT){
    isMouseRightClicking = false;
  }
  if(mouseButton == CENTER){
    isMouseCenterClicking = false;
  }
}

void mouseWheel(MouseEvent mouseEvent){
  float wheel = mouseEvent.getCount();
  if(wheel < 0){
    canvas.zoom_in();
  }
  else if(wheel > 0){
    canvas.zoom_out();
  }
}

void keyPressed(){
  isKeyPressing = true;
}

void keyReleased(){
  isKeyPressing = false;
}

//--------------------------------------------------


//--------------------------------------------------
void checkBlocks(int wCount, int hCount, String blockMode, String blockAnker){
  Block tmpBlock = new Block(16, 16);
  tmpBlock.setBlockMode(blockMode);
  tmpBlock.setBlockAnker(blockAnker);
  
  noFill();
  stroke(255, 0, 0);
  tmpBlock.setContainerAnker("topLeft");
  tmpBlock.debugGrid(wCount, hCount);
  stroke(0, 255, 0);
  tmpBlock.setContainerAnker("topRight");
  tmpBlock.debugGrid(wCount, hCount);
  stroke(0, 0, 255);
  tmpBlock.setContainerAnker("bottomLeft");
  tmpBlock.debugGrid(wCount, hCount);
  stroke(255, 0, 255);
  tmpBlock.setContainerAnker("bottomRight");
  tmpBlock.debugGrid(wCount, hCount);
}