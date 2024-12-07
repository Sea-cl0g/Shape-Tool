PVector move;
float scale;

class Canvas{
    Canvas(){
        move = new PVector(0, 0);
        scale = 1.0;
    }

    void add_rectangle(){
        println("rect_added");
    }

    void add_ellipse(){
        println("ellipse_added");
    }
}

//--------------------------------------------------

class Easel extends Block{
    DrawMode drawMode;
    color fillCol;
    float x, y, w, h;

    Easel(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, color fillCol){
        super(splitW, splitH);
        this.drawMode = drawMode;
        this.fillCol = fillCol; 

        x = layoutData.x_point;
        y = layoutData.y_point;
        w = layoutData.width_point;
        h = layoutData.height_point;
    }

    void drawEasel(){
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        
        fill(fillCol);
        noStroke();
        box(x + move.x, y + move.y, w * scale, h * scale);
    }
}

class CanvasBlock extends Easel{
    boolean dragged;
    PVector buffer;

    CanvasBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, color fillCol){
        super(splitW, splitH, drawMode, layoutData, fillCol);
        this.drawMode = drawMode;
        this.fillCol = fillCol;

        buffer = new PVector(0, 0);
    }

    void checkStatus(float mouseX, float mouseY){
        println(dragged);
        if(dragged){
            dragged = false;
            move.add(getContainerBlockPoint(mouseX - buffer.x, mouseY - buffer.y));
        }
        boolean isTouched = isPointInBox(x + move.x, y + move.y, w * scale, h * scale, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(isMouseCenterClicking){
                dragged = true;
                buffer = new PVector(mouseX, mouseY);
            }
            hasMouseTouched = true;
        }
    }

    void drawItems(){
        println("items");
    }
}
