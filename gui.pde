class Container {
    int splitW;
    int splitH;

    Container(int splitW, int splitH) {
        this.splitW = splitW;
        this.splitH = splitH;
    }

    PVector getContainerBlockSize(float w, float h, String blockMode) {
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

    PVector getContainerPos(float x, float y, String containerAnker, String blockMode, PVector size) {
        PVector g_pos = getContainerBlockSize(x, y, blockMode);
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
class Dialog extends Container{
        //親をブロックにする
    Dialog(int splitW, int splitH) {
        super(splitW, splitH);
    }
}

//--------------------------------------------------
class StandardButton extends Container{
        //親をブロックにする
    SafeLoad safeLoad;
    
    PShape add_rectangle;

    StandardButton(int splitW, int splitH){
        super(splitW, splitH);
        safeLoad = new SafeLoad();
        loadShapes();
    }
    
    void loadShapes(){
        add_rectangle = safeLoad.svgLoad("data/assets/TMP_ICON1.svg");
    }
    // ボタンプリセット
    boolean icon(float x, float y, float w, float h, PVector icon){
        return false;
    }

    // ボタンテンプレート
    //四角いボタン
    void drawSquareButton(float x, float y, float w, float h, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor, String containerAnker, String blockMode){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawSquareButton(shadowPos.x, shadowPos.y, w, h, subColor, containerAnker, blockMode);
        }
        drawSquareButton(x, y, w, h, mainColor, containerAnker, blockMode);
    }
    void drawSquareButton(float x, float y, float w, float h, color mainColor, String containerAnker, String blockMode){
        fill(mainColor);
        noStroke();
        block.box(x, y, w, h, containerAnker, blockMode);
    }
    //角が丸い四角いボタン
    void drawRoundedSquareButton(float x, float y, float w, float h, float r, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor, String containerAnker, String blockMode){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawRoundedSquareButton(shadowPos.x, shadowPos.y, w, h, r, subColor, containerAnker, blockMode);
        }
        drawRoundedSquareButton(x, y, w, h, r, mainColor, containerAnker, blockMode);
    }
    void drawRoundedSquareButton(float x, float y, float w, float h, float r, color mainColor, String containerAnker, String blockMode){
        fill(mainColor);
        noStroke();
        block.box(x, y, w, h, r, containerAnker, blockMode);
    }
    //横が丸いボタン
    void drawHorizontallyRoundedButton(float x, float y, float w, float h, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor, String containerAnker, String blockMode){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawHorizontallyRoundedButton(shadowPos.x, shadowPos.y, w, h, subColor, containerAnker, blockMode);
        }
        drawHorizontallyRoundedButton(x, y, w, h, mainColor, containerAnker, blockMode);
    }
    void drawHorizontallyRoundedButton(float x, float y, float w, float h, color mainColor, String containerAnker, String blockMode){
        fill(mainColor);
        noStroke();
        block.box(x, y, w, h, y / 2, containerAnker, blockMode);
    }
    //縦が丸いボタン
    void drawVerticallyRoundedButton(float x, float y, float w, float h, color mainColor, boolean shadow, String shadowMode, float shadowDist, color subColor, String containerAnker, String blockMode){
        if (shadow){
            PVector shadowPos = getShadowPos(x, y, shadowMode, shadowDist);
            drawVerticallyRoundedButton(shadowPos.x, shadowPos.y, w, h, subColor, containerAnker, blockMode);
        }
        drawVerticallyRoundedButton(x, y, w, h, mainColor, containerAnker, blockMode);
    }
    void drawVerticallyRoundedButton(float x, float y, float w, float h, color mainColor, String containerAnker, String blockMode){
        fill(mainColor);
        noStroke();
        block.box(x, y, w, h, x / 2, containerAnker, blockMode);
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
        return blockAnker == "CORNER" || blockAnker == "CENTER";
    }

    PVector getObjectPos(float x, float y, float w, float h, String blockAnker){
        switch (blockAnker) {
            case "CENTER" :
                return new PVector(x - w / 2, y - h / 2);
            default :
                return new PVector(x, y);
        }
    }

    void box(float x, float y, float w, float h, String containerAnker, String blockMode) {
        drawBox(x, y, w, h, 0, 0, 0, 0, containerAnker, blockMode);
    }
    void box(float x, float y, float w, float h, float r, String containerAnker, String blockMode) {
        drawBox(x, y, w, h, r, r, r, r, containerAnker, blockMode);
    }
    void box(float x, float y, float w, float h, float tl, float tr, float br, float bl, String containerAnker, String blockMode) {
        drawBox(x, y, w, h, tl, tr, br, bl, containerAnker, blockMode);
    }

    void drawBox(float x, float y, float w, float h, float tl, float tr, float br, float bl, String containerAnker, String blockMode){
        PVector size = getContainerBlockSize(w, h, blockMode);
        PVector blockPos = getContainerPos(x, y, containerAnker, blockMode, size);
        PVector pos = getObjectPos(blockPos.x, blockPos.y, size.x, size.y, blockAnker);
        tl = getContainerBlockSize(tl, tl, blockMode).x;
        tr = getContainerBlockSize(tr, tr, blockMode).x;
        br = getContainerBlockSize(br, br, blockMode).x;
        bl = getContainerBlockSize(bl, bl, blockMode).x;
        rect(pos.x, pos.y, size.x, size.y, tl, tr, br, bl);
    }

    // プリセット
    void debugGrid(String containerAnker, String blockMode){
        for(int i = 0; i < 20; i++){
            for(int q = 0; q < 20; q++){
                block.box(q, i, 1, 1, containerAnker, blockMode);
            }
        }
    }
}