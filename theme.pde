class Theme{
    JSONObject variableJSON = new JSONObject();

    ArrayList<TriggerButton> triggerButtonList = new ArrayList<TriggerButton>();

    void drawMenu(){
        for(TriggerButton triggerButton : triggerButtonList){
            triggerButton.drawButton(mouseX, mouseY);
        }
    }

    void loadTheme(){
        JSONObject assetsPath = config.getJSONObject("assets_path");
        for(Object assetNameObj : assetsPath.keys()){
            String assetName = (String) assetNameObj;
            JSONObject asset = assetsPath.getJSONObject(assetName);
            EasyJSONObject design = new EasyJSONObject(safeLoad.assetLoad(asset.getString("path")));
            readDesign(asset, design);
        }
    }

    void readDesign(JSONObject asset, EasyJSONObject design){
        buildVariableJSON(design.getNormalJSONObject());

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
                    DrawMode drawMode = new DrawMode(design);
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

    void readVariableJSON(){

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

class StyleData{
    String buttonType;
    color fillCol;
    LayoutData layoutData;
    StrokeData strokeData;
    IconData iconData;
    ShadowData shadowData;

    void readData(EasyJSONObject styleEJSON, JSONObject variableJSON){

        buttonType = styleEJSON.safeGetString("button_type");
        println(buttonType);

        fillCol = styleEJSON.safeGetColor("color");
        println(fillCol);
        
        Object layoutObj = styleEJSON.get("layout");
        EasyJSONObject layoutEJSON = new EasyJSONObject();
        if(layoutObj instanceof String){
            String variableName = (String) layoutObj;
            if(variableName.startsWith("$")){
                variableName = variableName.substring(1);
                JSONObject variable = variableJSON.getJSONObject("layouts").getJSONObject(variableName);
                layoutEJSON = new EasyJSONObject(variable);
            }
        }else{
            layoutEJSON = styleEJSON.safeGetEasyJSONObject("layout");
        }
        layoutData = new LayoutData(layoutEJSON);
        println(layoutData.x_point);
        
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

    void getEachData(){

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
        this.icon = safeLoad.iconLoad(iconEJSON.safeGetString("path"));
        //changeIconColor(icon, iconCol); //iconが空でない場合。
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