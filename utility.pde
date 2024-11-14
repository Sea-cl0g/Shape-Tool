
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

class SafeLoad{
    static final String ERROR_SVG_PATH = "data/assets/ERROR_ICON.svg";
    static final String DEFAULT_THEME_PATH = "data/themes/default.json";

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
        println(apath);
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
    
    JSONObject jsonLoad(String filePath){
        if(canLoad(filePath, ".json")){
            return loadJSONObject(filePath);
        }else if(canLoad(DEFAULT_THEME_PATH, ".json")){
            return loadJSONObject(DEFAULT_THEME_PATH);
        }
        println("ERROR: " + DEFAULT_THEME_PATH + " not found");
        return new JSONObject();
    }
}