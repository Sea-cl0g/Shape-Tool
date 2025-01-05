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

    //図形の追加
    void add_rectangle(){
        Rectangle rect = new Rectangle(0, 0, 10, 10);
        shapes.add(rect);
    }
    void add_ellipse(){
        Ellipse ellipse = new Ellipse(0, 0, 10, 10);
        shapes.add(ellipse);
    }

    //図形の編集
    void duplicate_layer(){
        int sizeBuffer = shapes.size();
        for(int i = 0; i < sizeBuffer; i++){
            Shape shape = shapes.get(i);
            if(shape.status[0] && shape.getClass() == Ellipse.class){
                Ellipse ellipse = (Ellipse) shape;
                shapes.add(new Ellipse(ellipse));
            }else if(shape.status[0] && shape.getClass() == Rectangle.class){
                Rectangle rect = (Rectangle) shape;
                shapes.add(new Rectangle(rect));
            }
        }
    }
    void raise_layer(){
        for (int i = shapes.size() - 1; i >= 0; i--){
            Shape item = shapes.get(i);
            if (item.status[0] && i < shapes.size() - 1){
                shapes.remove(i);
                shapes.add(i + 1, item);
            }
        }
    }
    void lower_layer(){
        for (int i = 0; i < shapes.size(); i++){
            Shape item = shapes.get(i);
            if (item.status[0] && i > 0){
                shapes.remove(i);
                shapes.add(i - 1, item);
            }
        }
    }
    void delete_shape(){
        int i = 0;
        while(i < shapes.size()){
            Shape shape = shapes.get(i);
            if(shape.status[0]){
                shapes.remove(i);
            }else{
                i++;
            }
        }
    }
    void bring_to_front(){
        ArrayList<Shape> toFront = new ArrayList<Shape>();
        for(Shape item : shapes){
            if(item.status[0]){
                toFront.add(item);
            }
        }
        for(Shape item : toFront){
            int index = shapes.indexOf(item);
            if(index < shapes.size() - 1){
                shapes.remove(index);
                shapes.add(item);
            }
        }
    }
    void send_to_back(){
        ArrayList<Shape> toBack = new ArrayList<Shape>();
        for(Shape item : shapes){
            if(item.status[0]){
                toBack.add(item);
            }
        }
        int arraySize = toBack.size();
        for(int i = arraySize - 1; 0 <= i; i--){
            Shape item = toBack.get(i);
            int index = shapes.indexOf(item);
            if(0 <= index){
                shapes.remove(index);
                shapes.add(0, item);
            }
        }
    }

    //図形の移動
    void move_up_1px(){
        for(Shape item : shapes){
            if(item.status[0]){
                item.y -= 1;
            }
        }
    }
    void move_down_1px(){
        for(Shape item : shapes){
            if(item.status[0]){
                item.y += 1;
            }
        }
    }
    void move_right_1px(){
        for(Shape item : shapes){
            if(item.status[0]){
                item.x += 1;
            }
        }
    }
    void move_left_1px(){
        for(Shape item : shapes){
            if(item.status[0]){
                item.x -= 1;
            }
        }
    }

    //図形の回転
    void rotate_left_90(){
        for(Shape item : shapes){
            if(item.status[0]){
                item.radian -= HALF_PI;
            }
        }
    }
    void rotate_right_90(){
        for(Shape item : shapes){
            if(item.status[0]){
                item.radian += HALF_PI;
            }
        }
    }

    //processing4のコードで出力
    void convert_code(){
        ConvertCode coc = new ConvertCode();
        coc.export_to_processing();
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
    void zoom_reset(){
        println(scale);
        scale = 1.0;
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
            if(shapeObj.getClass() == Rectangle.class){
                Rectangle shape = (Rectangle) shapeObj;
                shape.sizeW = canvasSize.x;
                shape.sizeH = canvasSize.y;
                shape.anchorX = canvasPos.x;
                shape.anchorY = canvasPos.y;
                shape.checkStatus();
            }else if(shapeObj.getClass() == Ellipse.class){
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
            if(shapeObj.getClass() == Rectangle.class){
                Rectangle shape = (Rectangle) shapeObj;
                shape.drawShapeWithGUI();
            }else if(shapeObj.getClass() == Ellipse.class){
                Ellipse shape = (Ellipse) shapeObj;
                shape.drawShapeWithGUI();
            }
            popMatrix();
        }
        rectMode(CORNER);
    }
}