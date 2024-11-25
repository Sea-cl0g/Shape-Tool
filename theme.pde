class Theme{
    JSONObject variableJSON = new JSONObject();

    ArrayList<Base> baseList = new ArrayList<Base>();
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
        DrawMode drawMode = new DrawMode(design);
        for(Object elementObj : elements.keys()){
            String elementID = (String) elementObj;
            EasyJSONObject element = design.safeGetEasyJSONObject(elementID);
            switch (element.safeGetString("type")) {
                case "base" :
                    LayoutData layout = new LayoutData(element.safeGetEasyJSONArray("style"));
                    baseList.add(new Base(16, 16, layout));
                break;	
                case "color" :
                
                break;	
                case "triggerButton" :
                    EasyJSONArray styles = element.safeGetEasyJSONObject("layout");
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

class StyleData{
    String buttonType;
    color fillCol;
    LayoutData layoutData;
    StrokeData strokeData;
    IconData iconData;
    ShadowData shadowData;

    void readData(EasyJSONObject styleEJSON, JSONObject variableJSON){
        String buttonTypeStr = styleEJSON.safeGetString("button_type");
        if(buttonTypeStr.startsWith("$")){
            buttonTypeStr = buttonTypeStr.substring(1);
            String variable = variableJSON.getJSONObject("button_types").getString(buttonTypeStr);
            buttonType = variable;
        }else{
            buttonType = styleEJSON.safeGetString("button_type");
        }

        String fillStr = styleEJSON.safeGetString("fill");
        if(fillStr.startsWith("$")){
            fillStr = fillStr.substring(1);
            String variable = variableJSON.getJSONObject("fills").getString(fillStr);
            fillCol = hexToColor(variable);
        }else{
            fillCol = styleEJSON.safeGetColor("fill");
        }
        
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
        
        Object strokeObj = styleEJSON.get("stroke");
        EasyJSONObject strokeEJSON = new EasyJSONObject();
        if(strokeObj instanceof String){
            String variableName = (String) strokeObj;
            if(variableName.startsWith("$")){
                variableName = variableName.substring(1);
                JSONObject variable = variableJSON.getJSONObject("strokes").getJSONObject(variableName);
                strokeEJSON = new EasyJSONObject(variable);
            }
        }else{
            strokeEJSON = styleEJSON.safeGetEasyJSONObject("stroke");
        }
        strokeData = new StrokeData(strokeEJSON);

        Object iconObj = styleEJSON.get("icon");
        EasyJSONObject iconEJSON = new EasyJSONObject();
        if(iconObj instanceof String){
            String variableName = (String) iconObj;
            if(variableName.startsWith("$")){
                variableName = variableName.substring(1);
                JSONObject variable = variableJSON.getJSONObject("icons").getJSONObject(variableName);
                iconEJSON = new EasyJSONObject(variable);
            }
        }else{
            iconEJSON = styleEJSON.safeGetEasyJSONObject("icon");
        }
        iconData = new IconData(iconEJSON);

        Object shadowObj = styleEJSON.get("shadow");
        EasyJSONObject shadowEJSON = new EasyJSONObject();
        if(shadowObj instanceof String){
            String variableName = (String) shadowObj;
            if(variableName.startsWith("$")){
                variableName = variableName.substring(1);
                JSONObject variable = variableJSON.getJSONObject("shadows").getJSONObject(variableName);
                shadowEJSON = new EasyJSONObject(variable);
            }
        }else{
            shadowEJSON = styleEJSON.safeGetEasyJSONObject("shadow");
        }
        shadowData = new ShadowData(shadowEJSON);
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