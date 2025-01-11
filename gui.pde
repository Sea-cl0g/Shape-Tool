class Block extends Container{
    String blockAnker;

    Block(int splitW, int splitH){
        super(splitW, splitH);
        setBlockAnker("DEFAULT");
    }
    Block(float anchorX, float anchorY, float sizeW, float sizeH, int splitW, int splitH){
        super(anchorX, anchorY, sizeW, sizeH, splitW, splitH);
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

    PVector getObjectPos(float x, float y, float w, float h, PVector size){
        switch (blockAnker){
            case "CENTER" :
                return getContainerPos(x - w / 2, y - h / 2, size);
            default :
                return getContainerPos(x, y, size);
        }
    }

    //box
    void box(float x, float y, float w, float h){
        drawBox(x, y, w, h, 0, 0, 0, 0);
    }
    void box(float x, float y, float w, float h, float r){
        drawBox(x, y, w, h, r, r, r, r);
    }
    void box(float x, float y, float w, float h, float tl, float tr, float br, float bl){
        drawBox(x, y, w, h, tl, tr, br, bl);
    }

    void drawBox(float x, float y, float w, float h, float tl, float tr, float br, float bl){
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        tl = getContainerBlockSize(tl, tl).x;
        tr = getContainerBlockSize(tr, tr).x;
        br = getContainerBlockSize(br, br).x;
        bl = getContainerBlockSize(bl, bl).x;
        rect(pos.x, pos.y, size.x, size.y, tl, tr, br, bl);
    }

    // 画像の表示
    void drawSVG(float x, float y, float w, float h, float w_scale, float h_scale, float scale, PShape svg){
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);

        float squareSize = min(size.x, size.y);
        PVector imageGSize = new PVector(squareSize * w_scale * scale, squareSize * h_scale * scale);
        PVector imageGPos = new PVector(pos.x + size.x / 2 - imageGSize.x / 2, pos.y + size.y / 2 - imageGSize.y / 2);

        shape(svg, imageGPos.x, imageGPos.y, imageGSize.x, imageGSize.y);
    }

    void drawImage(float x, float y, float w, float h, float w_scale, float h_scale, float scale, PImage image){
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);

        float squareSize = min(size.x, size.y);
        PVector imageGSize = new PVector(squareSize * w_scale * scale, squareSize * h_scale * scale);
        PVector imageGPos = new PVector(pos.x + size.x / 2 - imageGSize.x / 2, pos.y + size.y / 2 - imageGSize.y / 2);

        image(image, imageGPos.x, imageGPos.y, imageGSize.x, imageGSize.y);
    }


    //boxに触れているか？
    boolean isPointInBox(float x, float y, float w, float h, float pointX, float pointY){
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);

        boolean xCheck = pos.x < pointX && pointX < pos.x + size.x;
        boolean yCheck = pos.y < pointY && pointY < pos.y + size.y;
        return xCheck && yCheck;
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

//--------------------------------------------------
class Container{
    String containerAnker;
    String blockMode;

    float anchorX, anchorY, sizeW, sizeH;

    int splitW;
    int splitH;
    
    Container(int splitW, int splitH){
        this(0.0, 0.0, width, height, splitW, splitH);
    }
    Container(float anchorX, float anchorY, float sizeW, float sizeH, int splitW, int splitH){
        this.anchorX = anchorX; //アンカーの設定。
        this.anchorY = anchorY;

        this.sizeW = sizeW;
        this.sizeH = sizeH;

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
    
    PVector getContainerBlockSize(float w, float h){
        switch (blockMode){
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

    PVector getContainerPos(float x, float y, PVector size){
        PVector relative_pos = getContainerBlockSize(x, y);
        PVector global_pos;

        switch (containerAnker){
            case "topLeft":
                global_pos = new PVector(relative_pos.x , relative_pos.y);
                break;
            case "topRight":
                global_pos = new PVector(sizeW  - size.x - relative_pos.x, relative_pos.y);
                break;
            case "bottomLeft":
                global_pos = new PVector(relative_pos.x, sizeH - size.y - relative_pos.y);
                break;
            case "bottomRight":
                global_pos = new PVector(sizeW  - size.x - relative_pos.x, sizeH - size.y - relative_pos.y);
                break;
            case "center":
                global_pos = new PVector(sizeW  / 2 + relative_pos.x, sizeH / 2 + relative_pos.y);
                break;
            default:
                global_pos = new PVector(relative_pos.x, relative_pos.y);
                break;
        }

        global_pos.add(anchorX, anchorY);
        return global_pos;
    }

    float getContainerBlockWidth(float w){
        return sizeW * w / splitW;
    }

    float getContainerBlockHeight(float h){
        return sizeH * h / splitH;
    }

    PVector getContainerBlockPoint(float w, float h){
        switch (blockMode){
            case "vertical":
                return new PVector(getContainerBlockHeightPoint(w), getContainerBlockHeightPoint(h));
            case "horizontal":
                return new PVector(getContainerBlockWidthPoint(w), getContainerBlockWidthPoint(h));
            case "both":
                return new PVector(getContainerBlockWidthPoint(w), getContainerBlockHeightPoint(h));
            default:
                return new PVector(getContainerBlockWidthPoint(w), getContainerBlockHeightPoint(h));
        }
    }
    
    float getContainerBlockWidthPoint(float blockWidth){
        return blockWidth * splitW / sizeW ;
    }

    float getContainerBlockHeightPoint(float blockHeight){
        return blockHeight * splitH / sizeH;
    }
}