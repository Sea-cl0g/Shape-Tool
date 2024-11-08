class Container {
    int splitW;
    int splitH;

    Container(int splitW, int splitH) {
        this.splitW = splitW;
        this.splitH = splitH;
    }

    PVector getContainerBlockSize(int w, int h, String blockMode) {
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

    PVector getContainerPos(int x, int y, String containerAnker, String blockMode, PVector size) {
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

    int getContainerBlockWidth(int w) {
        return width * w / splitW;
    }

    int getContainerBlockHeight(int h) {
        return height * h / splitH;
    }
}

//--------------------------------------------------
class Dialog extends Container{
    Dialog(int splitW, int splitH) {
        super(splitW, splitH);
    }
}

//--------------------------------------------------
class StandardButton extends Container{
    SafeLoad safeLoad;
    static final int shadowDist = 10;
    
    PShape add_rectangle;

    StandardButton(int splitW, int splitH){
        super(splitW, splitH);
        safeLoad = new SafeLoad();
        loadShapes();
    }
    
    void loadShapes(){
        add_rectangle = safeLoad.svgLoad("data/assets/TMP_ICON1.svg");
    }

    //四角いボタン
    void drawSquareButton(int x, int y, int w, int h, color mainColor, boolean shadow, String shadowMode, color subColor, String containerAnker, String blockMode){
        if (shadow){
            fill(subColor);
            switch (shadowMode) {
                case "BOTTOM" :
                    drawSquareButton(x, y + shadowDist, w, h, subColor, containerAnker, blockMode);
                break;	
                case "TOP" :
                    drawSquareButton(x, y - shadowDist, w, h, subColor, containerAnker, blockMode);
                break;	
                case "RIGHT" :
                    drawSquareButton(x + shadowDist, y, w, h, subColor, containerAnker, blockMode);
                break;	
                case "LEFT" :
                    drawSquareButton(x - shadowDist, y, w, h, subColor, containerAnker, blockMode);
                break;	
                case "BOTTOMRIGHT" :
                    drawSquareButton(x + shadowDist, y + shadowDist, w, h, subColor, containerAnker, blockMode);
                break;	
                case "BOTTOMLEFT" :
                    drawSquareButton(x - shadowDist, y + shadowDist, w, h, subColor, containerAnker, blockMode);
                break;	
                case "TOPRIGHT" :
                    drawSquareButton(x + shadowDist, y - shadowDist, w, h, subColor, containerAnker, blockMode);
                break;	
                case "TOPLEFT" :
                    drawSquareButton(x - shadowDist, y - shadowDist, w, h, subColor, containerAnker, blockMode);
                break;	
                default :
                    //pass
                break;	
            }
        }
        drawSquareButton(x, y, w, h, mainColor, containerAnker, blockMode);
    }
    void drawSquareButton(int x, int y, int w, int h, color mainColor, String containerAnker, String blockMode){
        fill(mainColor);
        block.box(x, y, w, h, containerAnker, blockMode);
    }

    //角が丸い四角いボタン
    void drawRoundedSquareButton(int x, int y, int w, int h, int r, color mainColor, boolean shadow, String shadowMode, color subColor, String containerAnker, String blockMode){
        if (shadow){
            fill(subColor);
            noStroke();
            switch (shadowMode) {
                case "BOTTOM" :
                    drawRoundedSquareButton(x, y + shadowDist, w, h, r, subColor, containerAnker, blockMode);
                break;	
                case "TOP" :
                    drawRoundedSquareButton(x, y - shadowDist, w, h, r, subColor, containerAnker, blockMode);
                break;	
                case "RIGHT" :
                    drawRoundedSquareButton(x + shadowDist, y, w, h, r, subColor, containerAnker, blockMode);
                break;	
                case "LEFT" :
                    drawRoundedSquareButton(x - shadowDist, y, w, h, r, subColor, containerAnker, blockMode);
                break;	
                case "BOTTOMRIGHT" :
                    drawRoundedSquareButton(x + shadowDist, y + shadowDist, w, h, r, subColor, containerAnker, blockMode);
                break;	
                case "BOTTOMLEFT" :
                    drawRoundedSquareButton(x - shadowDist, y + shadowDist, w, h, r, subColor, containerAnker, blockMode);
                break;	
                case "TOPRIGHT" :
                    drawRoundedSquareButton(x + shadowDist, y - shadowDist, w, h, r, subColor, containerAnker, blockMode);
                break;	
                case "TOPLEFT" :
                    drawRoundedSquareButton(x - shadowDist, y - shadowDist, w, h, r, subColor, containerAnker, blockMode);
                break;	
                default :
                    //pass
                break;	
            }
        }
        drawRoundedSquareButton(x, y, w, h, r, mainColor, containerAnker, blockMode);
    }
    void drawRoundedSquareButton(int x, int y, int w, int h, int r, color mainColor, String containerAnker, String blockMode){
        fill(mainColor);
        noStroke();
        block.box(x, y, w, h, r, containerAnker, blockMode);
    }
}

//--------------------------------------------------
class Block extends Container{
    String blockAnker;

    Block(int splitW, int splitH) {
        super(splitW, splitH);
        blockAnker("DEFAULT");
    }

    void blockAnker(String blockAnker){
        if(is_blockAnkerType(blockAnker)){
          this.blockAnker = blockAnker;
        }else if(!(is_blockAnkerType(this.blockAnker))){
          this.blockAnker = "CORNER";
        }
    }

    boolean is_blockAnkerType(String blockAnker){
        return blockAnker == "CORNER" || blockAnker == "CENTER";
    }

    //box関数（オーバーロード）
    void box(int x, int y, int w, int h, String containerAnker, String blockMode) {
        drawBox(x, y, w, h, 0, 0, 0, 0, containerAnker, blockMode);
    }
    void box(int x, int y, int w, int h, float r, String containerAnker, String blockMode) {
        drawBox(x, y, w, h, r, r, r, r, containerAnker, blockMode);
    }
    void box(int x, int y, int w, int h, float tl, float tr, float br, float bl, String containerAnker, String blockMode) {
        drawBox(x, y, w, h, tl, tr, br, bl, containerAnker, blockMode);
    }

    void drawBox(int x, int y, int w, int h, float tl, float tr, float br, float bl, String containerAnker, String blockMode){
        PVector size = getContainerBlockSize(w, h, blockMode);
        PVector pos = getContainerPos(x, y, containerAnker, blockMode, size);
        tl = getContainerBlockSize(int(tl), int(tl), blockMode).x;
        tr = getContainerBlockSize(int(tr), int(tr), blockMode).x;
        br = getContainerBlockSize(int(br), int(br), blockMode).x;
        bl = getContainerBlockSize(int(bl), int(bl), blockMode).x;
        switch (blockAnker) {
            case "CENTER" :
                rect(pos.x - size.x / 2, pos.y - size.y / 2, size.x, size.y, tl, tr, br, bl);
            break;
            default :
                rect(pos.x, pos.y, size.x, size.y, tl, tr, br, bl);
            break;	
        }
    }

    void debugGrid(String containerAnker, String blockMode){
        for(int i = 0; i < 20; i++){
            for(int q = 0; q < 20; q++){
                block.box(q, i, 1, 1, containerAnker, blockMode);
            }
        }
    }
}
