

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
        }else if(isMouseCenterClicking && !hasMouseTouched){
            dragged = true;
        }
        
        if(isMouseCenterClicking){
            isMouseCenterClicking = false;
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
    boolean isShapeSelected;

    Shape(){
        super(0, 0, 1000, 1000, 100, 100); //適当な数で初期化
    }

    void drawSelectLine(float x, float y, float w, float h){
        if(isShapeSelected){
            noFill();
            stroke(0, 0, 255);
            strokeWeight(1);
            box(x, y, w, h);
        }
    }

    void drawPoint(float x, float y, float w, float h, float boxW, boolean isSelected){
        if(isSelected){
            PVector rectSize = getContainerBlockSize(w, h);
            PVector rectPos = getObjectPos(x, y, w, h, rectSize);
            fill(0, 0, 255);
            rect(rectPos.x + rectSize.x - boxW / 2, rectPos.y + rectSize.y - boxW / 2, boxW, boxW);
        }
    }

    boolean isNearTarget(float targetX, float targetY, float pointX, float pointY, float th){
        return dist(targetX, targetY, pointX, pointY) < th;
    }
}

class Rectangle extends Shape{
    float x, y, w, h, tl, tr, br, bl;
    boolean isCornerSelected;

    Rectangle(float x, float y, float w, float h){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        this.tl = 0.0;
        this.tr = 0.0;
        this.br = 0.0;
        this.bl = 0.0;
    }

    void checkStatus(){
        //corner
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectPos = getObjectPos(x, y, w, h, rectSize);
        boolean isCornerTouched = isNearTarget(rectPos.x + rectSize.x, rectPos.y + rectSize.y, mouseX, mouseY, 40);
        if(!hasMouseTouched && isCornerTouched){
            if(isMouseLeftClicking && !isCornerSelected){
                isMouseLeftClicking = false;
                isCornerSelected = true;
            }
            hasMouseTouched = true;
        }else if(!isCornerTouched && isMouseLeftClicking && !hasMouseTouched){
            isCornerSelected = false;
        }
        if(isCornerSelected){
            if(mousePressed && mouseButton == LEFT){
                PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
                w += mouseMove.x;
                h += mouseMove.y;
            }
        }

        //shape
        boolean isShapeTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isShapeTouched){
            if(isMouseLeftClicking && !isShapeSelected){
                isMouseLeftClicking = false;
                isShapeSelected = true;
            }
            hasMouseTouched = true;
        }else if(!isShapeTouched && isMouseLeftClicking && !hasMouseTouched){
            isShapeSelected = false;
        }
        if(isShapeSelected){
            if(mousePressed && mouseButton == LEFT){
                PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
                x += mouseMove.x;
                y += mouseMove.y;
            }
        }
    }


    void drawRectangle(){
        fill(255, 0, 0, 50);
        stroke(200, 200, 200, 50);
        strokeWeight(4);
        box(x, y, w, h);
    }

    void drawShape(){
        drawRectangle();
        drawSelectLine(x, y, w, h);
        drawPoint(x, y, w, h, 10, isCornerSelected);
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

    void checkShapesStatus(){
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
                
                shape.checkStatus();
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
