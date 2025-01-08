import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.awt.Toolkit;
import java.awt.datatransfer.StringSelection;

class SafeLoad{
    String ERROR_SVG_PATH, ERROR_IMAGE_PATH;
    
    SafeLoad() {
        ERROR_SVG_PATH = config.getString("ERROR_SVG_PATH");
        ERROR_IMAGE_PATH = config.getString("ERROR_IMAGE_PATH");
    }
    
    boolean canLoad(String filePath, String fileType) {
        //パスのファイルが存在するか？
        if (filePath.startsWith("/")) {
            filePath = sketchPath() + filePath;
        } else if (filePath.startsWith("./")) {
            filePath = sketchPath() + filePath.substring(1);
        } else{
            filePath = sketchPath() + "/" + filePath;
        }
        Path apath = Paths.get(filePath);
        if (!Files.exists(apath)) {
            return false;
        }
        //ファイルの型が想定通りか？
        if (!filePath.endsWith(fileType)) {
            return false;
        }
        return true;
    }

    boolean canLoad(String path) {
        //パスのファイルが存在するか？
        if (path.startsWith("/")) {
            path = sketchPath() + path;
        } else if (path.startsWith("./")) {
            path = sketchPath() + path.substring(1);
        } else{
            path = sketchPath() + "/" + path;
        }
        Path apath = Paths.get(path);
        if (!Files.exists(apath)) {
            return false;
        }
        return true;
    }
    
    JSONObject assetLoad(String assetPath) {
        String currThemeAsset = config.getString("current_theme") + "/assets/designs/" + assetPath;
        if (canLoad(currThemeAsset, ".json")) {
            println("assetLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadJSONObject(currThemeAsset);
        }
        println("assetLoad-ERROR: " + currThemeAsset + " does not exist.");
        return new JSONObject();
    }
    
    PShape svgLoad(String imagePath) {
        String currThemeAsset = config.getString("current_theme") + "/assets/images/" + imagePath;
        if (canLoad(currThemeAsset, ".svg")) {
            println("svgLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadShape(currThemeAsset);
        } else if (canLoad(ERROR_SVG_PATH, ".svg")) {
            println("svgLoad-ERROR: " + ERROR_SVG_PATH + " has loaded!");
            return loadShape(ERROR_SVG_PATH);
        }
        println("svgLoad-ERROR: Could not load any files!");
        return new PShape();
    }
    
    PImage imageLoad(String imagePath) {
        String currThemeAsset = config.getString("current_theme") + "/assets/images/" + imagePath;
        if (canLoad(currThemeAsset, ".png")) {
            println("imageLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadImage(currThemeAsset);
        } else if (canLoad(currThemeAsset, ".gif")) {
            println("imageLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadImage(currThemeAsset);
        } else if (canLoad(currThemeAsset, ".jpeg") || canLoad(currThemeAsset, ".jpg")) {
            println("imageLoad-Log: " + currThemeAsset + " has loaded!!");
            return loadImage(currThemeAsset);
        } else if (canLoad(ERROR_IMAGE_PATH, ".png")) {
            println("imageLoad-ERROR: " + ERROR_IMAGE_PATH + " has loaded!");
            return loadImage(ERROR_IMAGE_PATH);
        }
        println("imageLoad-ERROR: Could not load any files!");
        return new PImage();
    }
}

//--------------------------------------------------
class PointString{
    String pool;
    PointString() {
        pool = "";
    }
    PointString(String text) {
        pool = text;
    }
}

//--------------------------------------------------
class PointStringArray{
    String[] pool;
    PointStringArray() {
        pool = new String[0];
    }
    PointStringArray(String[] textArray) {
        pool = textArray;
    }
}

//--------------------------------------------------
String[] getReverseSortedStringArrayFromJSONObject(JSONObject json) {
    String[] array = new String[json.keys().size()];
    int i = 0;
    for (Object jsonObj : json.keys()) {
        array[i] = (String) jsonObj;
        i++;
    }
    return reverse(sort(array));
}

void copyStrings(String[] lines) {
    String combinedText = String.join("\n", lines);
    StringSelection stringSelection = new StringSelection(combinedText);
    Toolkit.getDefaultToolkit().getSystemClipboard().setContents(stringSelection, null);
}