class Canvas{
    ArrayList<Shape> shapes = new ArrayList<Shape>();
    color[] colorPallet = new color[2];
    boolean dragged;
    PVector move;
    float scale;
    

    Canvas(){
        move = new PVector(0, 0);
        scale = 1.0;
        colorPallet[0] = color(#9966FF);
        colorPallet[1] = color(50, 50, 50);
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
        Rectangle rect = new Rectangle(0, 0, 10, 10);
        shapes.add(rect);
    }

    void add_ellipse(){
        Ellipse ellipse = new Ellipse(0, 0, 10, 10);
        shapes.add(ellipse);
    }

    void tgl_fillPallet(){
        theme.isFillMode = !theme.isFillMode;
    }

    void tgl_strokePallet(){
        theme.isStrokeMode = !theme.isFillMode;
    }


    //キャンバス関係のボタン
    void zoom_in(){
        if(scale + 0.1 > 4.0){
            scale = 4.0; 
        }else{
            scale += 0.1;
        }
    }
    void zoom_out(){
        if(scale - 0.1 < 0.1){
           scale = 0.1;
        }else{
          scale -= 0.1;
        }
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
        rectMode(CENTER);
        PVector canvasSize = getContainerBlockSize(w * canvas.scale, h * canvas.scale);
        PVector canvasPos = getObjectPos(pos.x, pos.y, w * canvas.scale, h * canvas.scale, canvasSize);
        for(int i = canvas.shapes.size() - 1; 0 <= i; i--){
            pushMatrix();
            Shape shapeObj = canvas.shapes.get(i);
            if(shapeObj instanceof Rectangle){
                Rectangle shape = (Rectangle) shapeObj;
                shape.sizeW = canvasSize.x;
                shape.sizeH = canvasSize.y;
                shape.anchorX = canvasPos.x;
                shape.anchorY = canvasPos.y;
                shape.checkStatus();
            }else if(shapeObj instanceof Ellipse){
                Ellipse shape = (Ellipse) shapeObj;
                shape.sizeW = canvasSize.x;
                shape.sizeH = canvasSize.y;
                shape.anchorX = canvasPos.x;
                shape.anchorY = canvasPos.y;
                shape.checkStatus();
            }
            popMatrix();
        }
        rectMode(CORNER);
    }

    void drawItems(){
        rectMode(CENTER);
        for(Shape shapeObj : canvas.shapes){
            pushMatrix(); 
            if(shapeObj instanceof Rectangle){
                Rectangle shape = (Rectangle) shapeObj;
                shape.drawShapeWithGUI();
            }else if(shapeObj instanceof Ellipse){
                Ellipse shape = (Ellipse) shapeObj;
                shape.drawShapeWithGUI();
            }
            popMatrix();
        }
        rectMode(CORNER);
    }
}