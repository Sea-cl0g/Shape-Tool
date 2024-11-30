//エラーを解析、判断→無理
//厳格名読み込み

class Theme{
    JSONObject variableJSON = new JSONObject();

    ArrayList<Base> baseList = new ArrayList<Base>();
    ArrayList<TriggerButton> triggerButtonList = new ArrayList<TriggerButton>();

    void drawMenu(){
        for(Base base : baseList){
            base.drawBase();
        }
        for(TriggerButton triggerButton : triggerButtonList){
            triggerButton.drawButton(mouseX, mouseY);
        }
    }

    void loadTheme(){
        println("Theme Loading...");
        JSONObject assetsPath = config.getJSONObject("assets_path");
        for(Object assetNameObj : assetsPath.keys()){
            String assetName = (String) assetNameObj;
            JSONObject asset = assetsPath.getJSONObject(assetName);
            EasyJSONObject design = new EasyJSONObject(safeLoad.assetLoad(asset.getString("path")));
            
            println();
            readDesign(asset, design);
        }
    }

    void readDesign(JSONObject asset, EasyJSONObject design){
        buildVariableJSON(design.jsonObj);
        JSONObject elements = asset.getJSONObject("elements");
        DrawMode drawMode = new DrawMode(design);
        for(Object elementObj : elements.keys()){
            String elementID = (String) elementObj;
            EasyJSONObject element = design.safeGetEasyJSONObject(elementID);
            switch (element.safeGetString("type")) {
                case "base" :
                    LayoutData layout = new LayoutData(element.get("layout"), variableJSON);
                    color fillCol = readColor(element.safeGetString("fillCol"), variableJSON);
                    baseList.add(new Base(16, 16, drawMode, layout, fillCol));
                break;
                case "color" :
                
                break;	
                case "triggerButton" :
                    EasyJSONArray styles = element.safeGetEasyJSONArray("style");
                    triggerButtonList.add(buildTriggerButton(styles, drawMode));
                break;
                case "toggleButton" :
                    
                break;	
            }
        }
    }

    TriggerButton buildTriggerButton(EasyJSONArray styleList, DrawMode drawMode){
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
                        normal.readData(style, variableJSON);
                    break;
                    case "touched" :
                        touched.readData(style, variableJSON);
                    break;	
                    case "clicked" :
                        clicked.readData(style, variableJSON);
                    break;
                    case "selected" :
                        selected.readData(style, variableJSON);
                    break;
                }
            }
        }
        return new TriggerButton(16, 16, drawMode, normal, touched, clicked);
    }

    void buildVariableJSON(JSONObject design){
        for(Object keyObj : design.keys()){
                String key = (String) keyObj;
                Object valueObj = design.get(key);
                if(valueObj instanceof JSONObject){
                    JSONObject value = (JSONObject) valueObj;
                    variableJSON.setJSONObject(key, value);
                }
        }
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

//--------------------------------------------------
class StyleData{
    String buttonType;
    color fillCol;
    LayoutData layoutData;
    StrokeData strokeData;
    IconData iconData;
    ShadowData shadowData;

    void readData(EasyJSONObject styleEJSON, JSONObject variableJSON){
        buttonType = readButtonType(styleEJSON.safeGetString("button_type"), variableJSON);

        fillCol = readColor(styleEJSON.safeGetString("fill"), variableJSON);
        layoutData = new LayoutData(styleEJSON.get("layout"), variableJSON);
        strokeData = new StrokeData(styleEJSON.get("stroke"), variableJSON);
        iconData = new IconData(styleEJSON.get("icon"), variableJSON);
        shadowData = new ShadowData(styleEJSON.get("shadow"), variableJSON);
    }
    
    String readButtonType(String buttonTypeData, JSONObject variableJSON){
        if(buttonTypeData.startsWith("$")){
            String variableName = buttonTypeData.substring(1);
            return variableJSON.getJSONObject("button_types").getString(variableName);

        }
        return buttonTypeData;
    }
}

//--------------------------------------------------
class LayoutData{
    float x_point, y_point, width_point, height_point;
    float r_point, tl_point, tr_point, br_point, bl_point;

    LayoutData(Object layoutObj, JSONObject variableJSON){
        if(layoutObj != null){
            EasyJSONObject layoutEJSON = new EasyJSONObject();
            if(layoutObj instanceof String){
                String layoutStr = (String) layoutObj;
                if(layoutStr.startsWith("$")){
                    String variableName = layoutStr.substring(1);
                    layoutEJSON = new EasyJSONObject(variableJSON.getJSONObject("layouts").getJSONObject(variableName));
                }
            }else if(layoutObj instanceof JSONObject){
                JSONObject layoutJSON = (JSONObject) layoutObj;
                layoutEJSON = new EasyJSONObject(layoutJSON);
            }else{
                layoutEJSON = new EasyJSONObject();
            }
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
}

//--------------------------------------------------
class StrokeData{
    float stroke_point;
    color strokeCol;

    StrokeData(Object strokeObj, JSONObject variableJSON){
        if(strokeObj != null){
            EasyJSONObject strokeEJSON = new EasyJSONObject();
            if(strokeObj instanceof String){
                String strokeStr = (String) strokeObj;
                if(strokeStr.startsWith("$")){
                    String variableName = strokeStr.substring(1);
                    strokeEJSON = new EasyJSONObject(variableJSON.getJSONObject("strokes").getJSONObject(variableName));
                }
            }else if(strokeObj instanceof JSONObject){
                JSONObject strokeJSON = (JSONObject) strokeObj;
                strokeEJSON = new EasyJSONObject(strokeJSON);
            }else{
                strokeEJSON = new EasyJSONObject();
            }
            this.stroke_point = strokeEJSON.safeGetFloat("stroke_point");
            this.strokeCol = readColor(strokeEJSON.safeGetString("color"), variableJSON);
        }
    }
}

//--------------------------------------------------
class IconData{
    float size;
    PShape icon;

    IconData(Object iconObj, JSONObject variableJSON){
        if(iconObj != null){
            EasyJSONObject iconEJSON = new EasyJSONObject();
            if(iconObj instanceof String){
                String iconStr = (String) iconObj;
                if(iconStr.startsWith("$")){
                    String variableName = iconStr.substring(1);
                    iconEJSON = new EasyJSONObject(variableJSON.getJSONObject("icons").getJSONObject(variableName));
                }
            }else if(iconObj instanceof JSONObject){
                JSONObject iconJSON = (JSONObject) iconObj;
                iconEJSON = new EasyJSONObject(iconJSON);
            }else{
                iconEJSON = new EasyJSONObject();
            }
            this.size = iconEJSON.safeGetFloat("size");
            //color iconCol = iconEJSON.safeGetColor("color");
            this.icon = safeLoad.iconLoad(iconEJSON.safeGetString("path"));
        //changeIconColor(icon, iconCol); //iconが空でない場合。
        }
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

//--------------------------------------------------
class ShadowData{
    String shadowMode;
    float shadowDistPoint;
    color shadowCol;
    
    ShadowData(Object shadowObj, JSONObject variableJSON){
        if(shadowObj != null){
            EasyJSONObject shadowEJSON = new EasyJSONObject();
            if(shadowObj instanceof String){
                String shadowStr = (String) shadowObj;
                if(shadowStr.startsWith("$")){
                    String variableName = shadowStr.substring(1);
                    shadowEJSON = new EasyJSONObject(variableJSON.getJSONObject("shadows").getJSONObject(variableName));
                }
            }else if(shadowObj instanceof JSONObject){
                JSONObject shadowJSON = (JSONObject) shadowObj;
                shadowEJSON = new EasyJSONObject(shadowJSON);
            }else{
                shadowEJSON = new EasyJSONObject();
            }
            this.shadowMode = shadowEJSON.safeGetString("shadowMode");
            this.shadowDistPoint = shadowEJSON.safeGetFloat("shadowDistPoint");
            this.shadowCol = readColor(shadowEJSON.safeGetString("color"), variableJSON);
        }
    }
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
        println(r, g, b, a);
        return color(r, g, b, a);
}

color readColor(String colorData, JSONObject variableJSON){
    if(colorData.startsWith("$")){
        String variableName = colorData.substring(1);
        return hexToColor(variableJSON.getJSONObject("colors").getString(variableName));
    }
    return hexToColor(colorData);
}