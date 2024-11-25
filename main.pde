SafeLoad safeLoad;
Theme theme;

boolean isMouseClicking;
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
    //background(255, 255, 255);
    //checkBlocks(5, 5, "vertical", "CORNER");
    theme.drawMenu();
}

//--------------------------------------------------
void softPrepare(){
  config = loadJSONObject(configPath);
  safeLoad = new SafeLoad();
  theme = new Theme();
}

//--------------------------------------------------
color hexToColor(String hex){
        if (hex.startsWith("#")) {
            hex = hex.substring(1);
        }
        
        int r = unhex(hex.substring(0, 2));
        int g = unhex(hex.substring(2, 4));
        int b = unhex(hex.substring(4, 6));
        int a = hex.length() == 8 ? unhex(hex.substring(6, 8)) : 255;
        
        return color(r, g, b, a);
}

//--------------------------------------------------
void mousePressed() {
  isMouseClicking = true;
}

void mouseReleased() {
  isMouseClicking = false;
}

void keyPressed(){
  isKeyPressing = true;
}

void keyReleased(){
  isKeyPressing = false;
}

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