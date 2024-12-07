PVector move;
float scale;

class Canvas{
    boolean dragged;

    Canvas(){
        move = new PVector(0, 0);
        scale = 1.0;
    }

    void process(){
        move = new PVector(0, 0);
        if(dragged){
            if(!mousePressed){ //ボタンの確認はしない
                dragged = false;
            }
            move = new PVector(mouseX - pmouseX, mouseY - pmouseY);
        }else if(isMouseCenterClicked && !hasMouseTouched){
            dragged = true;
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
    PVector pos = new PVector(); 
    float w, h;

    Easel(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, color fillCol){
        super(splitW, splitH);
        this.drawMode = drawMode;
        this.fillCol = fillCol; 

        pos.x = layoutData.x_point;
        pos.y = layoutData.y_point;
        w = layoutData.width_point;
        h = layoutData.height_point;
    }

    void drawEasel(){
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        
        fill(fillCol);
        noStroke();
        pos.add(getContainerBlockPoint(move.x, move.y));
        box(pos.x, pos.y, w * scale, h * scale, true);
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
