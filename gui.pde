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
    //こっちでボタンを使うときはこっちはこっちでインスタンス化する
    StandardButton sb;

    int LAYER_BOX_BORDER = 10;

    Dialog(int splitW, int splitH) {
        super(splitW, splitH);
        sb = new StandardButton(splitW, splitH);
    }

    //layer_box
    void drawLayerBox(float x, float y, float w, float h){
        //背景
        noFill();
        stroke(217, 217, 217);
        float strokeWeight = LAYER_BOX_BORDER / 100.0;
        strokeWeight(getContainerBlockSize(strokeWeight, strokeWeight).x);
        box(x, y, w, h);

        //ボタン
        sb.setContainerAnker(this.containerAnker);
        sb.setBlockMode(this.blockMode);
        sb.setBlockAnker(this.blockAnker);
        for(int i = 0; i < 6; i++){
            sb.test_button(x + w * i / 6, y + h - w / 6, w / 6, w /6);
        }
        
    }
}

//--------------------------------------------------
class StandardButton extends Block{
    SafeLoad safeLoad;
    
    PShape add_rectangle;

    StandardButton(int splitW, int splitH){
        super(splitW, splitH);
        safeLoad = new SafeLoad();
        loadShapeFile();
    }
    
    void loadShapeFile(){
        add_rectangle = safeLoad.svgLoad("data/assets/TMP_ICON1.svg");
    }

    // ボタンプリセット
    void test_button(float x, float y, float w, float h){
        drawRoundedSquareButton(x, y, w, h, 0.2, color(102, 102, 102), false, "BOTTOMRIGHT", 0.3, color(0, 0, 0));
        if(icon(x, y, w, h, 0.8, add_rectangle)){
            println("a");
        }else{
            
        }
    }

    // アイコン
    /*
    boolean icon(float x, float y, float w, float h, float scale, PShape icon){
        PVector size = getContainerBlockSize(w * scale, h * scale);
        PVector blockPos = getContainerPos(x, y, size);
        PVector pos = getObjectPos(blockPos.x, blockPos.y, size.x, size.y, blockAnker);
        shape(icon, pos.x, pos.y, size.x, size.y);
        return false;
    }
    */
    boolean icon(float x, float y, float w, float h, float scale, PShape icon){
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size, blockAnker);

        PVector iconSize = getContainerBlockSize(w * scale, h * scale);
        PVector speaceSize = getContainerBlockSize((w - w * scale) / 2, (h - h * scale) / 2);
        shape(icon, pos.x + speaceSize.x, pos.y + speaceSize.y, iconSize.x, iconSize.y);
        return false;
    }

    // ボタンテンプレート
    //四角いボタン
    void drawSquareButton(float x, float y, float w, float h, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawSquareButton(shadowPos.x, shadowPos.y, w, h, subColor);
        }
        drawSquareButton(x, y, w, h, mainColor);
    }
    void drawSquareButton(float x, float y, float w, float h, color mainColor){
        fill(mainColor);
        noStroke();
        box(x, y, w, h);
    }
    
    //角が丸い四角いボタン
    void drawRoundedSquareButton(float x, float y, float w, float h, float r, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawRoundedSquareButton(shadowPos.x, shadowPos.y, w, h, r, subColor);
        }
        drawRoundedSquareButton(x, y, w, h, r, mainColor);
    }
    void drawRoundedSquareButton(float x, float y, float w, float h, float r, color mainColor){
        fill(mainColor);
        noStroke();
        box(x, y, w, h, r);
    }
    //横が丸いボタン
    void drawHorizontallyRoundedButton(float x, float y, float w, float h, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawHorizontallyRoundedButton(shadowPos.x, shadowPos.y, w, h, subColor);
        }
        drawHorizontallyRoundedButton(x, y, w, h, mainColor);
    }
    void drawHorizontallyRoundedButton(float x, float y, float w, float h, color mainColor){
        fill(mainColor);
        noStroke();
        box(x, y, w, h, y / 2);
    }
    //縦が丸いボタン
    void drawVerticallyRoundedButton(float x, float y, float w, float h, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawVerticallyRoundedButton(shadowPos.x, shadowPos.y, w, h, subColor);
        }
        drawVerticallyRoundedButton(x, y, w, h, mainColor);
    }
    void drawVerticallyRoundedButton(float x, float y, float w, float h, color mainColor){
        fill(mainColor);
        noStroke();
        box(x, y, w, h, x / 2);
    }
    //影の座標を取得
    PVector getShadowPos(float x, float y, String shadowMode, float shadowDist){
        switch (shadowMode) {
            case "BOTTOM" :
                return new PVector(x, y + shadowDist);
            case "TOP" :
                return new PVector(x, y - shadowDist);
            case "RIGHT" :
                return new PVector(x + shadowDist, y);
            case "LEFT" :
                return new PVector(x - shadowDist, y);
            case "BOTTOMRIGHT" :
                return new PVector(x + shadowDist, y + shadowDist);
            case "BOTTOMLEFT" :
                return new PVector(x - shadowDist, y + shadowDist);
            case "TOPRIGHT" :
                return new PVector(x + shadowDist, y - shadowDist);
            case "TOPLEFT" :
                return new PVector(x - shadowDist, y - shadowDist);
            default :
                return new PVector(x, y);
        }
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
                return getContainerPos(x + w / 2, y + h / 2, size);
            default :
                return getContainerPos(x, y, size);
        }
    }

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