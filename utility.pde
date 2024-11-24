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

    JSONObject assetLoad(String assetPath){
        String currThemeAsset = currThemeDir + "/assets/designs/" + assetPath;
        String defaultThemeAsset = DEFAULT_THEME_DIR + "/assets/designs/" + assetPath;
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

    PShape iconLoad(String iconPath){
        String currThemeAsset = currThemeDir + "/assets/images/" + iconPath;
        String defaultThemeAsset = DEFAULT_THEME_DIR + "/assets/images/" + iconPath;
        if(canLoad(currThemeAsset, ".svg")){
            println("Log: " + currThemeAsset + " has loaded!!");
            return loadShape(currThemeAsset);
        }else if(canLoad(defaultThemeAsset, ".svg")){
            println("ERROR: " + currThemeAsset + " not found");
            println("Log: " + defaultThemeAsset + " has loaded!!");
            return loadShape(currThemeAsset);
        }else if(canLoad(ERROR_SVG_PATH, ".svg")){
            println("atffawf");
            println("ERROR: " + ERROR_SVG_PATH + " not found");
            println("ERROR: " + defaultThemeAsset + " not found");
            println("Log: " + ERROR_SVG_PATH + " has loaded!!");
            return loadShape(ERROR_SVG_PATH);
        }
        println("ERROR: " + defaultThemeAsset + " not found");
        return new PShape();
    }
}