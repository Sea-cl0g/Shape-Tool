
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

class SafeLoad{
    String ERROR_SVG_PATH, DEFAULT_THEME_PATH;
    String configPath = "data/config.json";

    SafeLoad(){
        config = configLoad();
        ERROR_SVG_PATH = config.getString("ERROR_SVG_PATH");
        DEFAULT_THEME_PATH = config.getString("DEFAULT_THEME_PATH");
    }


    boolean canLoad(String filePath, String fileType){
        //パスのファイルが存在するか？
        if(filePath.startsWith("/")){
            filePath = sketchPath() + filePath;
        }else if(filePath.startsWith("./")){
            filePath = sketchPath() + filePath.substring(1);
        }else{
            filePath = sketchPath() + "/" + filePath;
        }
        Path apath = Paths.get(filePath);
        if(!Files.exists(apath)){
            println("File does not exist: " + filePath);
            return false;
        }
        //ファイルの型が想定通りか？
        if (!filePath.endsWith(fileType)) {
            println("File type mismatch. Expected: " + fileType);
            return false;
        }
        println("File can be loaded.");
        return true;
    }

    PShape svgLoad(String filePath){
        if(canLoad(filePath, ".svg")){
            return loadShape(filePath);
        }else if(canLoad(ERROR_SVG_PATH, ".svg")){
            return loadShape(ERROR_SVG_PATH);
        }
        println("ERROR: " + ERROR_SVG_PATH + " not found");
        return new PShape();
    }
    
    JSONObject assetLoad(String currThemeDir, String assetPath){
        String currThemeAsset = currThemeDir + "/assets/designs/" + assetPath;
        String defaultThemeAsset = DEFAULT_THEME_PATH + "/assets/designs/" + assetPath;
        if(canLoad(currThemeAsset, ".json")){
            return loadJSONObject(currThemeAsset);
        }else if(canLoad(defaultThemeAsset, ".json")){
            return loadJSONObject(defaultThemeAsset);
        }
        println("ERROR: " + defaultThemeAsset + " not found");
        return new JSONObject();
    }

    JSONObject configLoad(){
        if(canLoad(configPath, ".json")){
            return loadJSONObject(configPath);
        }
        println("ERROR: " + configPath + " not found");
        return new JSONObject();
    }

}

//--------------------------------------------------
class DrawMode{
    String containerAnker, blockMode, blockAnker;
    DrawMode(JSONObject drawModeJSON){
        this.containerAnker = drawModeJSON.getString("containerAnker");
        this.blockMode = drawModeJSON.getString("blockMode");
        this.blockAnker = drawModeJSON.getString("blockAnker");
    }
}

class StyleData{
    String button_type;
    LayoutData layoutData;
    StrokeData strokeData;
    IconData iconData;
    ShadowData shadowData;
    //もういっそのことeasyjsonクラスで扱う？？

    StyleData(JSONObject styleJSON){
        button_type = styleJSON.getString("button_type");
        println(button_type);
        layoutData = new LayoutData(styleJSON.getJSONObject("layout"));
        println(layoutData);
        strokeData = new StrokeData(styleJSON.getJSONObject("stroke"));
        println(strokeData);
        iconData = new IconData(styleJSON.getJSONObject("icon"));
        println(iconData);
        shadowData = new ShadowData(styleJSON.getJSONObject("shadow"));
        println(shadowData);
    }
}

class LayoutData{
    float x_point, y_point, width_point, height_point;
    float r_point, tl_point, tr_point, br_point, bl_point;

    LayoutData(JSONObject layoutJSON){
        EasyJSONObject ejson = new EasyJSONObject(layoutJSON);
        this.x_point = ejson.safeGetFloat("x_point");
        this.y_point = ejson.safeGetFloat("y_point");
        this.width_point = ejson.safeGetFloat("width_point");
        this.height_point = ejson.safeGetFloat("height_point");

        this.r_point = ejson.safeGetFloat("r_point");

        this.tl_point = ejson.safeGetFloat("tl_point");
        this.tr_point = ejson.safeGetFloat("tr_point");
        this.br_point = ejson.safeGetFloat("br_point");
        this.bl_point = ejson.safeGetFloat("bl_point");
    }
}

class StrokeData{
    boolean isNeed;
    float strokeWeight;
    color strokeCol;

    StrokeData(JSONObject strokeJSON){
        EasyJSONObject ejson = new EasyJSONObject(strokeJSON);
        this.strokeWeight = ejson.safeGetFloat("strokeWeight");
        println(this.strokeWeight);
        this.strokeWeight = ejson.safeGetColor("color");
    }
}

class IconData{
    float size;
    PShape icon;

    IconData(JSONObject iconJSON){
        this.size = iconJSON.getFloat("size");
        color iconCol = hexToColor(iconJSON.getString("color"));
        PShape shape = safeLoad.svgLoad(iconJSON.getString("path"));
        changeIconColor(shape, iconCol);
    }

    void changeIconColor(PShape shape, color overrideCol){
        if(0 < shape.getChildCount()){
            for(int i = 0; i < shape.getChildCount(); i++){
                changeIconColor(shape.getChild(i), overrideCol);
            }
        }else{
            shape.setFill(overrideCol);
        }
    }
}

class ShadowData{
    String shadowMode;
    float shadowDistPoint;
    color shadowCol;
    
    ShadowData(JSONObject shadowJSON){
        this.shadowMode = shadowJSON.getString("shadowMode");
        this.shadowDistPoint = shadowJSON.getFloat("shadowDistPoint");
        this.shadowCol = hexToColor(shadowJSON.getString("color"));
    }
}