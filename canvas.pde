

class Canvas{
    ArrayList<Shape> shapes = new ArrayList<Shape>();
    boolean dragged;

    PVector move;
    float scale;

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
        Rectangle rect = new Rectangle(0, 0, 10, 10);
        shapes.add(rect);
    }

    void add_ellipse(){
        println("ellipse_added");
    }
}

//--------------------------------------------------
class Shape extends Block{
    boolean selected;

    Shape(){
        super(0, 0, 1000, 1000, 100, 100); //適当な数で初期化
    }

    void selectLine(float x, float y, float w, float h){
        if(selected){
            noFill();
            stroke(0, 0, 255);
            strokeWeight(1);
            box(x, y, w, h);
        }
    }
}

class Rectangle extends Shape{
    float x, y, w, h;

    Rectangle(float x, float y, float w, float h){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(isMouseLeftClicked){
                isMouseLeftClicked = false;
                selected = true;
            }
            hasMouseTouched = true;
        }else if(!isTouched && isMouseLeftClicked){
                isMouseLeftClicked = false;
                selected = false;
        }
    }

    void drawRectangle(){
        fill(255, 0, 0);
        stroke(200, 200, 200);
        strokeWeight(4);
        box(x, y, w, h);
    }

    void drawShape(){
        drawRectangle();
        selectLine(x, y, w, h);
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
        pos.add(getContainerBlockPoint(canvas.move.x, canvas.move.y));
        box(pos.x, pos.y, w * canvas.scale, h * canvas.scale);
    }
}

//--------------------------------------------------
class CanvasBlock extends Easel{
    CanvasBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, color fillCol){
        super(splitW, splitH, drawMode, layoutData, fillCol);
        this.drawMode = drawMode;
        this.fillCol = fillCol;
    }

    void checkShapesStatus(float pointX, float pointY){
        PVector canvasSize = getContainerBlockSize(w * canvas.scale, h * canvas.scale);
        PVector canvasPos = getObjectPos(pos.x, pos.y, w * canvas.scale, h * canvas.scale, canvasSize);
        for(int i = canvas.shapes.size() - 1; 0 <= i; i--){
            Shape shapeObj = canvas.shapes.get(i);
            if(shapeObj instanceof Rectangle){
                Rectangle shape = (Rectangle) shapeObj;
                shape.sizeW = canvasSize.x;
                shape.sizeH = canvasSize.y;
                shape.anchorX = canvasPos.x;
                shape.anchorY = canvasPos.y;
                shape.checkStatus(pointX, pointY);
            }
        }
    }

    void drawItems(){
        for(Shape shapeObj : canvas.shapes){
            if(shapeObj instanceof Rectangle){
                Rectangle shape = (Rectangle) shapeObj;
                shape.drawShape();
            }
        }
    }
}
