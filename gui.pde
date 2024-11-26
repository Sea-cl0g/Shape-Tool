class Dialog extends Block{
    ButtonTemplate bt;

    int LAYER_BOX_BORDER = 10;

    Dialog(int splitW, int splitH) {
        super(splitW, splitH);
        bt = new ButtonTemplate(splitW, splitH);
    }

    //layer_box
    /*
    void drawLayerBox(float x, float y, float w, float h){
        //背景
        noStroke();
        outlineBox(x, y, w, h, backgroundCol, 0.1, color(217, 217, 217));

        //ボタン
        bt.setContainerAnker(this.containerAnker);
        bt.setBlockMode(this.blockMode);
        bt.setBlockAnker(this.blockAnker);
        int buttonNum = 6;
        float buttonSize = w / buttonNum;
        for(int i = 0; i < 6; i++){
            bt.test_button(x - w / 2 + i * w / buttonNum + buttonSize / 2, y + h / 2 - 1.5, buttonSize, buttonSize);
        }
        
    }
    */

    //outlineBox
    void outlineBox(float x, float y, float w, float h, color fillCol, float lineWeight, color lineCol){
        if(blockAnker.equals("CORNER")){
            fill(lineCol);
            drawBox(x - lineWeight, y - lineWeight, w + lineWeight * 2, h + lineWeight * 2, 0, 0, 0, 0);
            fill(fillCol);
            drawBox(x, y, w, h, 0, 0, 0, 0);
        }else{
            fill(lineCol);
            drawBox(x, y, w + lineWeight * 2, h + lineWeight * 2, 0, 0, 0, 0);
            fill(fillCol);
            drawBox(x, y, w, h, 0, 0, 0, 0);
        }
    }

    //inlineBox
    void inlineBox(float x, float y, float w, float h, color fillCol, float lineWeight, color lineCol){
        if(blockAnker.equals("CORNER")){
            fill(lineCol);
            drawBox(x, y, w, h, 0, 0, 0, 0);
            fill(fillCol);
            drawBox(x + lineWeight, y + lineWeight, w - lineWeight * 2, h - lineWeight * 2, 0, 0, 0, 0);
        }else{
            fill(lineCol);
            drawBox(x, y, w, h, 0, 0, 0, 0);
            fill(fillCol);
            drawBox(x, y, w - lineWeight * 2, h - lineWeight * 2, 0, 0, 0, 0);
        }
    }
}

//--------------------------------------------------
class TriggerButton extends ButtonTemplate{
    DrawMode drawMode;
    StyleData normal, touched, clicked;
    Runnable onClick;
    
    TriggerButton(int splitW, int splitH, DrawMode drawMode, StyleData normal, StyleData touched, StyleData clicked){
        super(splitW, splitH);
        this.normal = normal;
        this.drawMode = drawMode;
        this.touched = touched;
        this.clicked = clicked;
    }

    void drawButton(float mouseX, float mouseY){
        LayoutData normalLayout = normal.layoutData;
        boolean isTouched = isPointInBox(normalLayout.x_point, normalLayout.y_point, normalLayout.width_point, normalLayout.height_point, mouseX, mouseY);
        if(isTouched && isMouseClicking){
            isMouseClicking = false;
            display(clicked);
        }else if(isTouched){
            display(touched);
        }else{
            display(normal);
        }
    }

    void display(StyleData style) {
        String buttonType = style.buttonType;
        color fillCol = style.fillCol;
        LayoutData layoutData = style.layoutData;
        StrokeData strokeData = style.strokeData;
        IconData iconData = style.iconData;
        ShadowData shadowData = style.shadowData;

        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);

        setFillCol(fillCol);
        setShadowCol(shadowData.shadowCol);
        setStrokeCol(strokeData.strokeCol);
        setStrokeWeight(strokeData.strokeWeight);
        switch (buttonType) {
            case "squareButton" :
                drawSquareButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;
            case "roundedSquareButton" :
                drawRoundedSquareButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    layoutData.r_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
            case "eachRoundedButton" :
                drawEachRoundedButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    layoutData.tl_point, layoutData.tr_point, layoutData.br_point, layoutData.bl_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
            case "horizontallyRoundedButton" :
                drawHorizontallyRoundedButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
            case "verticallyRoundedButton" :
                drawVerticallyRoundedButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
        }

        icon(
            layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
            iconData.size, iconData.icon
        );
    }
}

//--------------------------------------------------
class Base extends Block{
    DrawMode drawMode;
    color fillCol;
    LayoutData layoutData;

    Base(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, color fillCol){
        super(splitW, splitH);
        this.drawMode = drawMode;
        this.layoutData = layoutData;
    }

    void drawBase(){
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);

        fill(fillCol);
        noStroke();
        box(layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point);
    }
}

//--------------------------------------------------
class ButtonTemplate extends Block{
    PShape add_rectangle;
    color fillCol = color(0);
    color shadowCol = color(0);
    color strokeCol = color(0);
    float strokeWeight = 1.0;

    ButtonTemplate(int splitW, int splitH){
        super(splitW, splitH);
    }

    void setFillCol(color col){
        this.fillCol = col;
    }

    void setShadowCol(color col){
        this.shadowCol = col;
    }

    void setStrokeCol(color col){
        this.strokeCol = col;
    }
    void setStrokeWeight(float num){
        this.strokeWeight = num;
    }
    void setNoStroke(){
        this.strokeCol = color(0, 0, 0, 255);
        this.strokeWeight = 1.0;
    }

    // アイコン
    void icon(float x, float y, float w, float h, float scale, PShape icon){
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size, blockAnker);

        PVector iconSize = getContainerBlockSize(w * scale, h * scale);
        PVector speaceSize = getContainerBlockSize((w - w * scale) / 2, (h - h * scale) / 2);
        shape(icon, pos.x + speaceSize.x, pos.y + speaceSize.y, iconSize.x, iconSize.y);
    }

    // ボタンテンプレート
    //四角いボタン
    void drawSquareButton(float x, float y, float w, float h, String shadowMode, float shadowDist){
        if(shadowDist != 0.0) {
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            fill(shadowCol);
            noStroke();
            box(x, y, w, h);
        }
        fill(fillCol);
        if(alpha(strokeCol) == 0.0 || strokeWeight == 0.0){
            noStroke();
        }else{
            strokeWeight(getContainerBlockSize(strokeWeight, strokeWeight).x);
            stroke(strokeCol);
        }
        box(x, y, w, h);
    }
    
    //すべての角が一定の丸みを持つ四角いボタン
    void drawRoundedSquareButton(float x, float y, float w, float h, float r, String shadowMode, float shadowDist){
        if(shadowDist != 0.0) {
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            fill(shadowCol);
            noStroke();
            box(x, y, w, h, r);
        }
        fill(fillCol);
        println(strokeWeight);
        if(alpha(strokeCol) == 0.0 || strokeWeight == 0.0){
            noStroke();
        }else{
            strokeWeight(getContainerBlockSize(strokeWeight, strokeWeight).x);
            stroke(strokeCol);
        }
        box(x, y, w, h, r);
    }

    //角ごとに丸みを指定できるボタン
    void drawEachRoundedButton(float x, float y, float w, float h, float tl, float tr, float br, float bl, String shadowMode, float shadowDist){
        if(shadowDist != 0.0) {
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            fill(shadowCol);
            noStroke();
            box(x, y, w, h, tl, tr, br, bl);
        }
        fill(fillCol);
        if(alpha(strokeCol) == 0.0 || strokeWeight == 0.0){
            noStroke();
        }else{
            strokeWeight(getContainerBlockSize(strokeWeight, strokeWeight).x);
            stroke(strokeCol);
        }
        box(x, y, w, h, tl, tr, br, bl);
    }


    //横が丸いボタン
    void drawHorizontallyRoundedButton(float x, float y, float w, float h, String shadowMode, float shadowDist){
        if(shadowDist != 0.0) {
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            fill(shadowCol);
            noStroke();
            box(x, y, w, h);
        }
        fill(fillCol);
        if(alpha(strokeCol) == 0.0 || strokeWeight == 0.0){
            noStroke();
        }else{
            strokeWeight(getContainerBlockSize(strokeWeight, strokeWeight).x);
            stroke(strokeCol);
        }
        box(x, y, w, h, y / 2);
    }

    //縦が丸いボタン
    void drawVerticallyRoundedButton(float x, float y, float w, float h, String shadowMode, float shadowDist){
        if(shadowDist != 0.0) {
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            fill(shadowCol);
            noStroke();
            box(x, y, w, h);
        }
        fill(fillCol);
        if(alpha(strokeCol) == 0.0 || strokeWeight == 0.0){
            noStroke();
        }else{
            strokeWeight(getContainerBlockSize(strokeWeight, strokeWeight).x);
            stroke(strokeCol);
        }
        box(x, y, w, h, x / 2);
    }

    //影の座標を取得
    PVector getShadowPos(float x, float y, String shadowMode, float shadowDist){
        int calcModeX = 1;
        int calcModeY = 1;
        switch (containerAnker) {
            case "topRight" :
                calcModeX = -1;
            break;	
            case "bottomLeft" :
                calcModeY = -1;
            break;	
            case "bottomRight" :
                calcModeX = -1;
                calcModeY = -1;
            break;	
        }
        switch (shadowMode) {
            case "BOTTOM" :
                return new PVector(x, y + shadowDist * calcModeY);
            case "TOP" :
                return new PVector(x, y - shadowDist);
            case "RIGHT" :
                return new PVector(x + shadowDist * calcModeX, y);
            case "LEFT" :
                return new PVector(x - shadowDist * calcModeX, y);
            case "BOTTOMRIGHT" :
                return new PVector(x + shadowDist * calcModeX, y + shadowDist * calcModeY);
            case "BOTTOMLEFT" :
                return new PVector(x - shadowDist * calcModeX, y + shadowDist * calcModeY);
            case "TOPRIGHT" :
                return new PVector(x + shadowDist * calcModeX, y - shadowDist * calcModeY);
            case "TOPLEFT" :
                return new PVector(x - shadowDist * calcModeX, y - shadowDist * calcModeY);
            default :
                return new PVector(x, y);
        }
    }

    //boxの左上角の座標を取得
    PVector getBoxCorner(float x, float y, float w, float h){
        if(blockAnker.equals("CENTER")){
            return new PVector(x, y);
        }else{
            return new PVector(x - w / 2, y - h / 2);
        }
    }

    //ボタンに触れているか？
    boolean isPointInBox(float x, float y, float w, float h, float pointX, float pointY){
        PVector cornerPos = getBoxCorner(x, y, w, h);
        
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size, blockAnker);
        boolean xCheck = pos.x < mouseX && mouseX < pos.x + size.x;
        boolean yCheck = pos.y < mouseY && mouseY < pos.y + size.y;
        return xCheck && yCheck;
    }
}


//--------------------------------------------------
class Block extends Container{
    String blockAnker;

    Block(int splitW, int splitH) {
        super(splitW, splitH);
        setBlockAnker("DEFAULT");
    }

    //blockAnker関係
    void setBlockAnker(String blockAnker){
        if(this.blockAnker != null || is_blockAnkerType(blockAnker)){
          this.blockAnker = blockAnker;
        }else if(this.blockAnker == null || !(is_blockAnkerType(this.blockAnker))){
          this.blockAnker = "CORNER";
        }
    }
    boolean is_blockAnkerType(String blockAnker){
        return blockAnker.equals("CORNER") 
        || blockAnker.equals("CENTER");
    }

    PVector getObjectPos(float x, float y, float w, float h, PVector size, String blockAnker){
        switch (blockAnker) {
            case "CENTER" :
                return getContainerPos(x - w / 2, y - h / 2, size);
            default :
                return getContainerPos(x, y, size);
        }
    }

    //box
    void box(float x, float y, float w, float h) {
        drawBox(x, y, w, h, 0, 0, 0, 0);
    }
    void box(float x, float y, float w, float h, float r) {
        drawBox(x, y, w, h, r, r, r, r);
    }
    void box(float x, float y, float w, float h, float tl, float tr, float br, float bl) {
        drawBox(x, y, w, h, tl, tr, br, bl);
    }

    void drawBox(float x, float y, float w, float h, float tl, float tr, float br, float bl){
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size, blockAnker);
        tl = getContainerBlockSize(tl, tl).x;
        tr = getContainerBlockSize(tr, tr).x;
        br = getContainerBlockSize(br, br).x;
        bl = getContainerBlockSize(bl, bl).x;
        rect(pos.x, pos.y, size.x, size.y, tl, tr, br, bl);
    }

    // プリセット
    void debugGrid(int wCount, int hCount){
        for(int i = 0; i < hCount; i++){
            for(int q = 0; q < wCount; q++){
                box(q, i, 1, 1);
            }
        }
    }
}

class Container {
    String containerAnker;
    String blockMode;
    int splitW;
    int splitH;

    Container(int splitW, int splitH) {
        this.splitW = splitW;
        this.splitH = splitH;
        setContainerAnker("DEFAULT");
        setBlockMode("DEFAULT");
    }

    //containerAnker関係
    void setContainerAnker(String containerAnker){
        if(this.containerAnker != null || is_containerAnkerType(containerAnker)){
            this.containerAnker = containerAnker;
        }else if(this.containerAnker == null || !(is_containerAnkerType(this.containerAnker))){
          this.containerAnker = "topLeft";
        }
    }
    boolean is_containerAnkerType(String containerAnker){
        return containerAnker.equals("topLeft")
        || containerAnker.equals("topRight")
        || containerAnker.equals("bottomLeft")
        || containerAnker.equals("bottomRight")
        || containerAnker.equals("center");
    }

    //blockMode関係
    void setBlockMode(String blockMode){
        if(this.blockMode != null || is_blockModeType(blockMode)){
          this.blockMode = blockMode;
        }else if(this.blockMode == null || !(is_blockModeType(this.blockMode))){
          this.blockMode = "vertical";
        }
    }
    boolean is_blockModeType(String blockMode){
        return blockMode.equals("vertical") 
        || blockMode.equals("horizontal")
        || blockMode.equals("both");
    }
    
    PVector getContainerBlockSize(float w, float h) {
        switch (blockMode) {
            case "vertical":
                return new PVector(getContainerBlockHeight(w), getContainerBlockHeight(h));
            case "horizontal":
                return new PVector(getContainerBlockWidth(w), getContainerBlockWidth(h));
            case "both":
                return new PVector(getContainerBlockWidth(w), getContainerBlockHeight(h));
            default:
                return new PVector(getContainerBlockWidth(w), getContainerBlockHeight(h));
        }
    }

    PVector getContainerPos(float x, float y, PVector size) {
        PVector g_pos = getContainerBlockSize(x, y);
        switch (containerAnker) {
            case "topLeft":
                return new PVector(g_pos.x, g_pos.y);
            case "topRight":
                return new PVector(width - size.x - g_pos.x, g_pos.y);
            case "bottomLeft":
                return new PVector(g_pos.x, height - size.y - g_pos.y);
            case "bottomRight":
                return new PVector(width - size.x - g_pos.x, height - size.y - g_pos.y);
            case "center":
                return new PVector(width / 2 - size.x / 2 + g_pos.x, height / 2 - size.y / 2 + g_pos.y);
            default:
                return new PVector(g_pos.x, g_pos.y);
        }
    }

    float getContainerBlockWidth(float w) {
        return width * w / splitW;
    }

    float getContainerBlockHeight(float h) {
        return height * h / splitH;
    }
}