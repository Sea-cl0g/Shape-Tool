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
        // status[0]がtrueのShapeを格納するリスト
        ArrayList<Shape> toRaise = new ArrayList<Shape>();
        
        // status[0]がtrueの要素をtoRaiseに追加
        for (Shape item : shapes) {
            if (item.status[0]) {
                toRaise.add(item);
            }
        }
        println(toRaise);
        // toRaise内のShapeを順番に前に移動
        for (Shape item : toRaise) {
            int index = shapes.indexOf(item);
            if (index < shapes.size() - 1) {
                // 要素を1つ前に持ち上げる
                shapes.set(index, shapes.get(index + 1));
                shapes.set(index + 1, item);
            }
        }
    }

    void lower_layer(){
        // shapes リストを逆順にループ
        for (int i = shapes.size() - 1; i >= 0; i--) {
            Shape item = shapes.get(i);
            // status[0] が true の場合
            if (item.status[0] == true) {
            // リスト内で一つ前に移動
                if (i > 0) {
                    // i番目の要素と、i-1番目の要素を入れ替える
                    shapes.set(i, shapes.get(i - 1));
                    shapes.set(i - 1, item);
                }
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