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
    
    String connectThemePathAndDesignFilePath(String themePath, String assetPath){
        //パスの修正機能を追加したい
        return themePath + "/assets/designs/" + assetPath;
    }

    JSONObject assetLoad(String currThemeDir, String assetPath){
        String currThemeAsset = connectThemePathAndDesignFilePath(currThemeDir, assetPath);
        String defaultThemeAsset = DEFAULT_THEME_PATH + "/assets/designs/" + assetPath;
        if(canLoad(currThemeAsset, ".json")){
            println("Log: " + currThemeAsset + " has loaded!!");
            return loadJSONObject(currThemeAsset);
        }else if(canLoad(defaultThemeAsset, ".json")){
            println("ERROR: " + currThemeAsset + " not found");
            println("Log: " + defaultThemeAsset + " has loaded!!");
            return loadJSONObject(currThemeAsset);
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
/*
class Utils{
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
}
*/

//--------------------------------------------------
class DrawMode{
    String containerAnker, blockMode, blockAnker;
    DrawMode(JSONObject drawModeJSON){
        EasyJSONObject drawModeEJSON = new EasyJSONObject(drawModeJSON);
        this.containerAnker = drawModeEJSON.safeGetString("containerAnker", "topLeft");
        this.blockMode = drawModeEJSON.safeGetString("blockMode", "vertical");
        this.blockAnker = drawModeEJSON.safeGetString("blockAnker", "CORNER");
    }
}

class StyleData{
    String button_type;
    LayoutData layoutData;
    StrokeData strokeData;
    IconData iconData;
    ShadowData shadowData;

    StyleData(JSONObject styleJSON){
        EasyJSONObject styleEJSON = new EasyJSONObject(styleJSON);
        button_type = styleEJSON.safeGetString("button_type");
        println(button_type);

    //getEasyJSONObject -> ファイルがなかったら空のjsonを返す。 -> 各要素は存在しなくなるので各クラス内で各要素を確認しても代わりの値が出る。 -> 例えば、strokWeightが0で指定されたときの処理を特別に書く必要がなくなる。なぜならその要素が空だった時に代わりに与えられる値も０にしておけば二つの問題を一度に克服できるから！！！！
        EasyJSONObject layoutEJSON = styleEJSON.getEasyJSONObject("layout");
        layoutData = new LayoutData(layoutEJSON);
        
        EasyJSONObject strokeEJSON = styleEJSON.getEasyJSONObject("stroke");
        strokeData = new StrokeData(strokeEJSON);
        println(strokeData);

        EasyJSONObject iconEJSON = styleEJSON.getEasyJSONObject("icon");
        iconData = new IconData(iconEJSON);
        println(iconData);

        EasyJSONObject shadowEJSON = styleEJSON.getEasyJSONObject("shadow");
        shadowData = new ShadowData(shadowEJSON);
        println(shadowData);
    }
}

class LayoutData{
    float x_point, y_point, width_point, height_point;
    float r_point, tl_point, tr_point, br_point, bl_point;

    LayoutData(EasyJSONObject layoutEJSON){
        this.x_point = layoutEJSON.safeGetFloat("x_point");
        this.y_point = layoutEJSON.safeGetFloat("y_point");
        this.width_point = layoutEJSON.safeGetFloat("width_point");
        this.height_point = layoutEJSON.safeGetFloat("height_point");

        this.r_point = layoutEJSON.safeGetFloat("r_point");

        this.tl_point = layoutEJSON.safeGetFloat("tl_point");
        this.tr_point = layoutEJSON.safeGetFloat("tr_point");
        this.br_point = layoutEJSON.safeGetFloat("br_point");
        this.bl_point = layoutEJSON.safeGetFloat("bl_point");
    }
}

class StrokeData{
    boolean isNeed;
    float strokeWeight;
    color strokeCol;

    StrokeData(EasyJSONObject strokeEJSON){
        this.strokeWeight = strokeEJSON.safeGetFloat("strokeWeight");
        this.strokeCol = strokeEJSON.safeGetColor("color");
    }
}

class IconData{
    float size;
    PShape icon;

    IconData(EasyJSONObject iconEJSON){
        this.size = iconEJSON.safeGetFloat("size");
        color iconCol = iconEJSON.safeGetColor("color");
        PShape shape = safeLoad.svgLoad(iconEJSON.safeGetString("path"));
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
    
    ShadowData(EasyJSONObject shadowEJSON){
        this.shadowMode = shadowEJSON.safeGetString("shadowMode");
        this.shadowDistPoint = shadowEJSON.safeGetFloat("shadowDistPoint");
        this.shadowCol = shadowEJSON.safeGetColor("color");
    }
}