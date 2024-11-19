SafeLoad safeLoad;

Block block;
Dialog dialog;
ButtonTemplate buttonTemp;

boolean isMouseClicking;
boolean isKeyPressing;

JSONObject config;

//--------------------------------------------------
void setup(){
  size(800, 450);
  surface.setResizable(true);

  safeLoad = new SafeLoad();
  block = new Block(16, 16);
  dialog = new Dialog(16, 16);
  buttonTemp = new ButtonTemplate(16, 16);

  loadTheme();
}

void draw() {
    background(255, 255, 255);
    menu();
    //checkBlocks(5, 5, "vertical", "CORNER");
}

//--------------------------------------------------
ArrayList<Button> buttons = new ArrayList<Button>();
void loadTheme(){
  config = safeLoad.configLoad();
  String currThemeDir = config.getString("current_theme");

  JSONObject assetsPath = config.getJSONObject("assets_path");
  //config.json内のassets_pathを回す
  for(Object keyObj : assetsPath.keys()){
    println();
    String key = (String) keyObj;
    JSONObject asset = assetsPath.getJSONObject(key);
    //themeファイルの読み込み
    JSONObject design = safeLoad.assetLoad(currThemeDir, asset.getString("path"));
    DrawMode drawMode = new DrawMode(design);
    if(drawMode.containerAnker != null){
      JSONObject elements = asset.getJSONObject("elements");
      for(Object elementObj : elements.keys()){
        String elementID = (String) elementObj;
        JSONObject element = design.getJSONObject(elementID);
        switch (element.getString("type")) {
          case "base" :
            
          break;	
          case "color" :
            
          break;	
          case "button" :
            println("pika-!!!");
          break;	
        }
      }
    }
  }
}

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

// ↓消す
color backgroundCol = color(67, 67, 67);
void menu(){
  // side bar
  noStroke();
  fill(backgroundCol);
  block.setContainerAnker("topLeft");
  block.box(0, 0, 7, 16);
  block.setContainerAnker("topRight");
  block.box(0, 0, 7, 16);
  // shape_button
    buttonTemp.setContainerAnker("topLeft");
    buttonTemp.setBlockMode("vertical");
    buttonTemp.setBlockAnker("CENTER");
    //add_rectangle
    buttonTemp.test_button(3.5, 3, 2.5, 2.5);
    //add_ellipse
    buttonTemp.test_button(3.5, 6, 2.5, 2.5);
  
  // layer_box
    dialog.setContainerAnker("bottomLeft");
    dialog.setBlockMode("vertical");
    dialog.setBlockAnker("CENTER");
    dialog.drawLayerBox(3.5, 4, 6, 7);
  // other_button
    buttonTemp.setContainerAnker("bottomRight");
    buttonTemp.setBlockMode("vertical");
    buttonTemp.setBlockAnker("CORNER");
    buttonTemp.test_button(0.5, 6.5, 1.8, 1.8);
    buttonTemp.test_button(0.5, 4.5, 1.8, 1.8);
    buttonTemp.test_button(0.5, 2.5, 1.8, 1.8);
    buttonTemp.test_button(0.5, 0.5, 1.8, 1.8);
}

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