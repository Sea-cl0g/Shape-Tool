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
  println("Theme Loading...");
  config = safeLoad.configLoad();
  String currThemeDir = config.getString("current_theme");

  JSONObject assetsPath = config.getJSONObject("assets_path");
  //config.json内のassets_pathを回す
  for(Object keyObj : assetsPath.keys()){
    println();
    String key = (String) keyObj;
    JSONObject asset = assetsPath.getJSONObject(key);
    String assetPaht = asset.getString("path");
    if(safeLoad.canLoad(safeLoad.connectThemePathAndDesignFilePath(currThemeDir, assetPaht), ".json")){
      JSONObject design = safeLoad.assetLoad(currThemeDir, assetPaht);
      readDesign(asset, design);
    }
  }
}

void readDesign(JSONObject asset, JSONObject design){
  DrawMode drawMode = new DrawMode(design);
  if(drawMode.containerAnker != null){
    JSONObject elements = asset.getJSONObject("elements");
    for(Object elementObj : elements.keys()){
      String elementID = (String) elementObj;
      JSONObject element = design.getJSONObject(elementID);
      //println(design);//easyjsonにしてnullを回避すべき
      switch (element.getString("type")) {
        case "base" :
          
        break;	
        case "color" :
          
        break;	
        case "button" :
          JSONArray styleList = element.getJSONArray("style");
          StyleData normal;
          StyleData touched;
          StyleData clicked;
          StyleData selected;
          for(int i = 0; i < styleList.size(); i++){
            JSONObject style = styleList.getJSONObject(i);
            //predicateに応じて関数を初期化
            Object predicateObj = style.get("predicate");
            JSONArray query = new JSONArray();
            if(predicateObj instanceof String){
              String predicate_tmp = (String) predicateObj;
              query.append(predicate_tmp);
            }else{
              query = (JSONArray) predicateObj;
            }
            for(int q = 0; q < query.size(); q++){
              switch (query.getString(q)) {
                case "normal" :
                  normal = new StyleData(style);
                break;
                case "touched" :
                  touched = new StyleData(style);
                break;	
                case "clicked" :
                  clicked = new StyleData(style);
                break;	
                case "selected" :
                  selected = new StyleData(style);
                break;	
              }
            }
          }
        break;	
      }
    }
  }
}



class EasyJSONObject{

  JSONObject jsonObj;
  EasyJSONObject(){
    this.jsonObj = new JSONObject();
  }
  EasyJSONObject(JSONObject jsonObj){
    this.jsonObj = jsonObj;
  }


  String safeGetString(String key){
    return safeGetString(key, "ERR");
  }
  String safeGetString(String key, String ifNull){
    return jsonObj.isNull(key) ? ifNull : jsonObj.getString(key);
  }

  float safeGetFloat(String key){
    return safeGetFloat(key, 0.0);
  }
  float safeGetFloat(String key, float ifNull){
    return jsonObj.isNull(key) ? ifNull : jsonObj.getFloat(key);
  }

  color safeGetColor(String key){
    return safeGetColor(key, color(255, 0, 255));
  }
  color safeGetColor(String key, color ifNull){
    Object colorObj = jsonObj.get(key);
    if(colorObj instanceof String){
      String colorHex = (String) colorObj;
      return hexToColor(colorHex);
    }else if(colorObj instanceof JSONArray){
      JSONArray colorArrayTmp = (JSONArray) colorObj;
      EasyJSONArray colorArray = new EasyJSONArray(colorArrayTmp);
      if(colorArray.size() == 3){
        return color(colorArray.safeGetFloat(0), colorArray.safeGetFloat(1), colorArray.safeGetFloat(2));
      }else if(colorArray.size() == 4){
        return color(colorArray.safeGetFloat(0), colorArray.safeGetFloat(1), colorArray.safeGetFloat(2), colorArray.safeGetFloat(3));
      }
    }
    return ifNull;
  }
  
  JSONObject getNormalJSONObject(){
    return jsonObj;
  }

  // JSONObjectクラス関数のラップ
  EasyJSONObject getEasyJSONObject(String key){
    JSONObject childJsonObj = jsonObj.getJSONObject(key);
    return childJsonObj == null ? new EasyJSONObject() : new EasyJSONObject(childJsonObj);
  }

  EasyJSONArray getEasyJSONArray(String key){
    JSONArray childJsonArray = jsonObj.getJSONArray(key);
    return childJsonArray == null ? new EasyJSONArray() : new EasyJSONArray(childJsonArray);
  }

  boolean isNull(String key){
    return jsonObj.isNull(key);
  }
}


class EasyJSONArray extends JSONArray{
  JSONArray jsonArray;
  EasyJSONArray(JSONArray jsonArray){
    this.jsonArray = jsonArray;
  }
  EasyJSONArray(){
    this.jsonArray = new JSONArray();
  }

  float safeGetFloat(int index){
    return !jsonArray.isNull(index) ? 0.0 : jsonArray.getFloat(index);
  }

  // JSONObjectクラス関数のオーバーライド
  boolean isNull(int index){
    return jsonArray.isNull(index);
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