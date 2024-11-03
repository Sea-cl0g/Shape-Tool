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

    PVector getContainerPos(int x, int y, String containerAnker, PVector size) {
        int gx = getContainerBlockWidth(x);
        int gy = getContainerBlockHeight(y);
        switch (containerAnker) {
            case "topLeft":
                return new PVector(gx, gy);
            case "topRight":
                return new PVector(width - size.x - gx, gy);
            case "bottomLeft":
                return new PVector(gx, height - size.y - gy);
            case "bottomRight":
                return new PVector(width - size.x - gx, height - size.y - gy);
            case "center":
                return new PVector(width / 2 - size.x / 2 + gx, height / 2 - size.y / 2 + gy);
            default:
                return new PVector(gx, gy);
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
class Popup extends Container {
    Popup(int splitW, int splitH) {
        super(splitW, splitH);
    }
}

//--------------------------------------------------
class Block extends Container {
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

    void box(int x, int y, int w, int h, String containerAnker, String blockMode) {
        PVector size = getContainerBlockSize(w, h, blockMode);
        PVector pos = getContainerPos(x, y, containerAnker, size);
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
}
