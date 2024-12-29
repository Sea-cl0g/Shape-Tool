import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

class SafeLoad{
    String ERROR_SVG_PATH, DEFAULT_THEME_DIR, currThemeDir;

    SafeLoad(){
        ERROR_SVG_PATH = config.getString("ERROR_SVG_PATH");
        DEFAULT_THEME_DIR = config.getString("DEFAULT_THEME_DIR");
        currThemeDir = config.getString("current_theme");
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
            return false;
        }
        //ファイルの型が想定通りか？
        if (!filePath.endsWith(fileType)) {
            return false;
        }
        return true;
    }

    JSONObject assetLoad(String assetPath){
        String currThemeAsset = currThemeDir + "/assets/designs/" + assetPath;
        String defaultThemeAsset = DEFAULT_THEME_DIR + "/assets/designs/" + assetPath;
        if(canLoad(currThemeAsset, ".json")){
            println("assetLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadJSONObject(currThemeAsset);
        }else if(canLoad(defaultThemeAsset, ".json")){
            println("assetLoad-INSTEAD: " + defaultThemeAsset + " has loaded!!");
            return loadJSONObject(currThemeAsset);
        }
        println("assetLoad-ERROR: " + defaultThemeAsset + " does not exist.");
        return new JSONObject();
    }

    PShape svgLoad(String imagePath){
        String currThemeAsset = currThemeDir + "/assets/images/" + imagePath;
        String defaultThemeAsset = DEFAULT_THEME_DIR + "/assets/images/" + imagePath;
        if(canLoad(currThemeAsset, ".svg")){
            println("svgLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadShape(currThemeAsset);
        }else if(canLoad(ERROR_SVG_PATH, ".svg")){
            println("svgLoad-ERROR: " + ERROR_SVG_PATH + " has loaded!");
            return loadShape(ERROR_SVG_PATH);
        }
        println("svgLoad-ERROR: Could not load any files!");
        return new PShape();
    }

    PShape imageLoad(String imagePath){
        String currThemeAsset = currThemeDir + "/assets/images/" + imagePath;
        String defaultThemeAsset = DEFAULT_THEME_DIR + "/assets/images/" + imagePath;
        if(canLoad(currThemeAsset, ".png")){
            println("svgLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadShape(currThemeAsset);
        }else if(canLoad(ERROR_SVG_PATH, ".svg")){
            println("svgLoad-ERROR: " + ERROR_SVG_PATH + " has loaded!");
            return loadShape(ERROR_SVG_PATH);
        }
        println("svgLoad-ERROR: Could not load any files!");
        return new PShape();
    }
}

//--------------------------------------------------
String[] getReverseSortedStringArrayFromJSONObject(JSONObject json){
    String[] array = new String[json.keys().size()];
    int i = 0;
    for(Object jsonObj : json.keys()){
        array[i] = (String) jsonObj;
        i++;
    }
    return reverse(sort(array));
}