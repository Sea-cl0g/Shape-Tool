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
    StandardButton(int splitW, int splitH) {
        super(splitW, splitH);
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

    //関数のオーバーロード
    void box(int x, int y, int w, int h, String containerAnker, String blockMode) {
        drawBox(x, y, w, h, -1, -1, -1, -1, containerAnker, blockMode);
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
        switch (blockAnker) {
            case "CORNER" :
                rect(pos.x, pos.y, size.x, size.y);
            break;
            case "CENTER" :
                rect(pos.x - size.x / 2, pos.y - size.y / 2, size.x, size.y);
            break;
            default :
                rect(pos.x, pos.y, size.x, size.y);
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
