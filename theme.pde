class Theme{
    ArrayList<TriggerButton> triggerButtonList = new ArrayList<TriggerButton>();

    String currThemeDir;
    Theme(){
        this.currThemeDir = config.getString("current_theme");
    }

    void loadTheme(){
        JSONObject assetsPath = config.getJSONObject("assets_path");
        for(Object keyObj : assetsPath.keys()){
            String key = (String) keyObj;
            JSONObject asset = assetsPath.getJSONObject(key);
            EasyJSONObject design = new EasyJSONObject(safeLoad.assetLoad(currThemeDir, asset.getString("path")));
            println();
            readDesign(asset, design);
        }
    }

    void readDesign(JSONObject asset, EasyJSONObject design){
        DrawMode drawMode = new DrawMode(design);
        JSONObject elements = asset.getJSONObject("elements");
        for(Object elementObj : elements.keys()){
            String elementID = (String) elementObj;
            EasyJSONObject element = design.safeGetEasyJSONObject(elementID);
            switch (element.safeGetString("type")) {
                case "base" :
                
                break;	
                case "color" :
                
                break;	
                case "triggerButton" :
                    EasyJSONArray styles = element.safeGetEasyJSONArray("style");
                    triggerButtonList.add(buildTriggerButton(styles));
                break;
                case "toggleButton" :
                    
                break;	
            }
        }
    }

    TriggerButton buildTriggerButton(EasyJSONArray styleList){
        StyleData normal = new StyleData();
        StyleData touched = new StyleData();
        StyleData clicked = new StyleData();
        StyleData selected = new StyleData();
        for(int i = 0; i < styleList.size(); i++){
            EasyJSONObject style = styleList.safeGetEasyJSONObject(i);
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
                        normal.readData(style);
                    break;
                    case "touched" :
                        touched.readData(style);
                    break;	
                    case "clicked" :
                        clicked.readData(style);
                    break;	
                    case "selected" :
                        selected.readData(style);
                    break;	
                }
            }
        }
        return new TriggerButton(16, 16, normal, touched, clicked);
    }
}

//--------------------------------------------------
class DrawMode{
    String containerAnker, blockMode, blockAnker;

    DrawMode(EasyJSONObject drawModeEJSON){
        this.containerAnker = drawModeEJSON.safeGetString("containerAnker", "topLeft");
        this.blockMode = drawModeEJSON.safeGetString("blockMode", "vertical");
        this.blockAnker = drawModeEJSON.safeGetString("blockAnker", "CORNER");
    }
}

class StyleData{
    String buttonType;
    color fillCol;
    LayoutData layoutData;
    StrokeData strokeData;
    IconData iconData;
    ShadowData shadowData;

    void readData(EasyJSONObject styleEJSON){
        buttonType = styleEJSON.safeGetString("button_type");
        println(buttonType);

        fillCol = styleEJSON.safeGetColor("color");
        println(fillCol);
        
        EasyJSONObject layoutEJSON = styleEJSON.safeGetEasyJSONObject("layout");
        layoutData = new LayoutData(layoutEJSON);
        
        EasyJSONObject strokeEJSON = styleEJSON.safeGetEasyJSONObject("stroke");
        strokeData = new StrokeData(strokeEJSON);
        println(strokeData);

        EasyJSONObject iconEJSON = styleEJSON.safeGetEasyJSONObject("icon");
        iconData = new IconData(iconEJSON);
        println(iconData);

        EasyJSONObject shadowEJSON = styleEJSON.safeGetEasyJSONObject("shadow");
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