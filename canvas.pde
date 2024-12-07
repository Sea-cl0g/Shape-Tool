PVector move;
float scale;

class Canvas{
    PVector buffer;
    boolean dragged;

    Canvas(){
        move = new PVector(0, 0);
        scale = 1.0;
    }

    void process(){
        if(dragged){
            if(!mousePressed){ //ボタンの確認はしない
                dragged = false;
            }
            move = new PVector(mouseX - buffer.x, mouseY - buffer.y);
        }else if(isMouseCenterClicked && !hasMouseTouched){
            dragged = true;
            buffer = new PVector(mouseX, mouseY);
        }

        if(isMouseCenterClicked){
            isMouseCenterClicked = false;
        }
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
        PVector move_point = getContainerBlockPoint(move.x, move.y);
        box(x + move_point.x, y + move_point.y, w * scale, h * scale);
    }
}

class CanvasBlock extends Easel{
    CanvasBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, color fillCol){
        super(splitW, splitH, drawMode, layoutData, fillCol);
        this.drawMode = drawMode;
        this.fillCol = fillCol;
    }

    void drawItems(){
        println("items");
    }
}
