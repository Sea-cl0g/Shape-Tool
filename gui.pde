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
        if(is_containerAnkerType(containerAnker)){
          this.containerAnker = containerAnker;
        }else if(!(is_containerAnkerType(this.containerAnker))){
          this.containerAnker = "topLeft";
        }
    }
    boolean is_containerAnkerType(String containerAnker){
        return containerAnker == "topLeft" 
        || containerAnker == "topRight"
        || containerAnker == "bottomLeft"
        || containerAnker == "bottomRight"
        || containerAnker == "center";
    }

    //blockMode関係
    void setBlockMode(String blockMode){
        if(is_blockModeType(blockMode)){
          this.blockMode = blockMode;
        }else if(!(is_blockModeType(this.blockMode))){
          this.blockMode = "vertical";
        }
    }
    boolean is_blockModeType(String blockMode){
        return blockMode == "vertical" 
        || blockMode == "horizontal" 
        || blockMode == "both";
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

//--------------------------------------------------
class Dialog extends Block{
    ButtonTemplate bt;

    int LAYER_BOX_BORDER = 10;

    Dialog(int splitW, int splitH) {
        super(splitW, splitH);
        bt = new ButtonTemplate(splitW, splitH);
    }

    //layer_box
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

    //outlineBox
    void outlineBox(float x, float y, float w, float h, color fillCol, float lineWeight, color lineCol){
        if(blockAnker == "CORNER"){
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
        if(blockAnker == "CORNER"){
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
class Button extends ButtonTemplate{
    Runnable normal, touched, clicked;
    Runnable onClick;
    
    Button(int splitW, int splitH, StyleData normal, StyleData touched, StyleData clicked){
        super(splitW, splitH);
    }
    /*
    Button(int splitW, int splitH, StyleData normal, StyleData touched, StyleData clicked, StyleData selected){
        super(splitW, splitH);
        this.normal = buildButton(normal);
        this.touched = touched;
        this.clicked = clicked;
        this.selected = selected;
    }

    Runnable buildButton(StyleData styleData){
        float x = styleData.layoutData.x_point;
        float y = styleData.layoutData.y_point;
        float w = styleData.layoutData.width_point;
        float h = styleData.layoutData.height_point;
        switch (styleData.button_type) {
            case  "squareButton":
                drawSquareButton(x, y, w, h, )
            break;	
        }
    }

    void drawButton() {
        drawRoundedSquareButton(x, y, w, h, 0.2, color(102 * tmp, 102 * tmp, 102 * tmp), true, "BOTTOMRIGHT", 0.1, color(0, 0, 0));
        icon(x, y, w, h, 0.8, add_rectangle);
    }
    */
}

//--------------------------------------------------
class ButtonTemplate extends Block{
    PShape add_rectangle;

    ButtonTemplate(int splitW, int splitH){
        super(splitW, splitH);
        loadShapeFile();
    }
    
    void loadShapeFile(){
        add_rectangle = safeLoad.svgLoad("data/assets/TMP_ICON1.svg");
    }

    // ボタン


    //仮実装
    void test_button(float x, float y, float w, float h){
        float tmp;
        if(isMouseInBox(x, y, w, h)){
            tmp = 0.5;
            if(isMouseClicking){
                isMouseClicking = false;
                tmp = 0.8;
            }
        }else{
            tmp = 1;
        }
        drawRoundedSquareButton(x, y, w, h, 0.2, color(102 * tmp, 102 * tmp, 102 * tmp), true, "BOTTOMRIGHT", 0.1, color(0, 0, 0));
        icon(x, y, w, h, 0.8, add_rectangle);
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
    void drawSquareButton(float x, float y, float w, float h, color mainCol, boolean shadow, String shadowMode, float shadowDist, color shadowCol){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawSquareButton(shadowPos.x, shadowPos.y, w, h, shadowCol);
        }
        drawSquareButton(x, y, w, h, mainCol);
    }
    void drawSquareButton(float x, float y, float w, float h, color mainCol){
        fill(mainCol);
        noStroke();
        box(x, y, w, h);
    }
    
    //すべての角が一定の丸みを持つ四角いボタン
    void drawRoundedSquareButton(float x, float y, float w, float h, float r, color mainCol, boolean shadow, String shadowMode, float shadowDist, color shadowCol){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawRoundedSquareButton(shadowPos.x, shadowPos.y, w, h, r, shadowCol);
        }
        drawRoundedSquareButton(x, y, w, h, r, mainCol);
    }
    void drawRoundedSquareButton(float x, float y, float w, float h, float r, color mainCol){
        fill(mainCol);
        noStroke();
        box(x, y, w, h, r);
    }

    //角ごとに丸みを指定できるボタン
    void drawEachRoundedButton(float x, float y, float w, float h, float tl, float tr, float br, float bl, color mainCol, boolean shadow, String shadowMode, float shadowDist, color shadowCol){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawEachRoundedButton(shadowPos.x, shadowPos.y,  w, h, tl, tr, br, bl, shadowCol);
        }
        drawEachRoundedButton(x, y, w, h, tl, tr, br, bl, mainCol);
    }
    void drawEachRoundedButton(float x, float y, float w, float h, float tl, float tr, float br, float bl, color mainCol){
        fill(mainCol);
        noStroke();
        box(x, y, w, h, tl, tr, br, bl);
    }


    //横が丸いボタン
    void drawHorizontallyRoundedButton(float x, float y, float w, float h, color mainCol, boolean shadow, String shadowMode, float shadowDist, color shadowCol){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawHorizontallyRoundedButton(shadowPos.x, shadowPos.y, w, h, shadowCol);
        }
        drawHorizontallyRoundedButton(x, y, w, h, mainCol);
    }
    void drawHorizontallyRoundedButton(float x, float y, float w, float h, color mainCol){
        fill(mainCol);
        noStroke();
        box(x, y, w, h, y / 2);
    }

    //縦が丸いボタン
    void drawVerticallyRoundedButton(float x, float y, float w, float h, color mainCol, boolean shadow, String shadowMode, float shadowDist, color shadowCol){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawVerticallyRoundedButton(shadowPos.x, shadowPos.y, w, h, shadowCol);
        }
        drawVerticallyRoundedButton(x, y, w, h, mainCol);
    }
    void drawVerticallyRoundedButton(float x, float y, float w, float h, color mainCol){
        fill(mainCol);
        noStroke();
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
        if(blockAnker == "CENTER"){
            return new PVector(x, y);
        }else{
            return new PVector(x - w / 2, y - h / 2);
        }
    }

    //ボタンに触れているか？
    boolean isMouseInBox(float x, float y, float w, float h){
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
        if(is_blockAnkerType(blockAnker)){
          this.blockAnker = blockAnker;
        }else if(!(is_blockAnkerType(this.blockAnker))){
          this.blockAnker = "CORNER";
        }
    }
    boolean is_blockAnkerType(String blockAnker){
        return blockAnker == "CORNER" 
        || blockAnker == "CENTER";
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