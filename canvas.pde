class Canvas{
    ArrayList<Shape> shapes = new ArrayList<Shape>();
    color[] colorPallet = new color[2];
    boolean dragged;
    PVector move;
    float scale;
    PointString loadPath, savePath, themePath, exportPath;
    PointStringArray exportPreview;
    

    Canvas(){
        move = new PVector(0, 0);
        scale = 1.0;
        colorPallet[0] = color(#9966FF);
        colorPallet[1] = color(50, 50, 50);

        loadPath = new PointString("data/saves/project.json");
        savePath = new PointString("data/saves/new_project.json");
        exportPath = new PointString("data/saves/new_export.txt");
        themePath = new PointString();
        String[] test = {"apple", "banana", "grape"};
        exportPreview = new PointStringArray(test);
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
            if(shape.isAnyStateActive() && shape.getClass() == Ellipse.class){
                Ellipse copy = new Ellipse((Ellipse) shape);
                copy.x -= 1;
                copy.y -= 1;
                shapes.add(copy);
            }else if(shape.isAnyStateActive() && shape.getClass() == Rectangle.class){
                Rectangle copy = new Rectangle((Rectangle) shape);
                copy.x -= 1;
                copy.y -= 1;
                shapes.add(copy);
            }
        }
    }
    void raise_layer(){
        for (int i = shapes.size() - 1; i >= 0; i--){
            Shape item = shapes.get(i);
            if (item.isAnyStateActive() && i < shapes.size() - 1){
                shapes.remove(i);
                shapes.add(i + 1, item);
            }
        }
    }
    void lower_layer(){
        for (int i = 0; i < shapes.size(); i++){
            Shape item = shapes.get(i);
            if (item.isAnyStateActive() && i > 0){
                shapes.remove(i);
                shapes.add(i - 1, item);
            }
        }
    }
    void delete_shape(){
        int i = 0;
        while(i < shapes.size()){
            Shape shape = shapes.get(i);
            if(shape.isAnyStateActive()){
                shapes.remove(i);
            }else{
                i++;
            }
        }
    }
    void bring_to_front(){
        ArrayList<Shape> toFront = new ArrayList<Shape>();
        for(Shape item : shapes){
            if(item.isAnyStateActive()){
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
            if(item.isAnyStateActive()){
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
            if(item.isAnyStateActive()){
                item.y -= 1;
            }
        }
    }
    void move_down_1px(){
        for(Shape item : shapes){
            if(item.isAnyStateActive()){
                item.y += 1;
            }
        }
    }
    void move_right_1px(){
        for(Shape item : shapes){
            if(item.isAnyStateActive()){
                item.x += 1;
            }
        }
    }
    void move_left_1px(){
        for(Shape item : shapes){
            if(item.isAnyStateActive()){
                item.x -= 1;
            }
        }
    }

    //図形の回転
    void rotate_left_90(){
        for(Shape item : shapes){
            if(item.isAnyStateActive()){
                item.radian -= HALF_PI;
            }
        }
    }
    void rotate_right_90(){
        for(Shape item : shapes){
            if(item.isAnyStateActive()){
                item.radian += HALF_PI;
            }
        }
    }

    //図形を反転
    void flip_y_axis(){
        println("flip_y_axis");
    }
    void flip_x_axis(){
        println("flip_x_axis");
    }

    //図形を拡大、縮小
    void double_width(){
        for(Shape item : shapes){
            if(item.isAnyStateActive() && item.getClass() == Ellipse.class){
                Ellipse ellipse = (Ellipse) item;
                ellipse.w *= 2;
            }else if(item.isAnyStateActive() && item.getClass() == Rectangle.class){
                Rectangle rect = (Rectangle) item;
                rect.w *= 2;
            }
        }
    }
    void double_height(){
        for(Shape item : shapes){
            if(item.isAnyStateActive() && item.getClass() == Ellipse.class){
                Ellipse ellipse = (Ellipse) item;
                ellipse.h *= 2;
            }else if(item.isAnyStateActive() && item.getClass() == Rectangle.class){
                Rectangle rect = (Rectangle) item;
                rect.h *= 2;
            }
        }
    }
    void double_ratio(){
        for(Shape item : shapes){
            if(item.isAnyStateActive() && item.getClass() == Ellipse.class){
                Ellipse ellipse = (Ellipse) item;
                ellipse.w *= 2;
                ellipse.h *= 2;
            }else if(item.isAnyStateActive() && item.getClass() == Rectangle.class){
                Rectangle rect = (Rectangle) item;
                rect.w *= 2;
                rect.h *= 2;
            }
        }
    }
    void half_width(){
        for(Shape item : shapes){
            if(item.isAnyStateActive() && item.getClass() == Ellipse.class){
                Ellipse ellipse = (Ellipse) item;
                ellipse.w /= 2;
            }else if(item.isAnyStateActive() && item.getClass() == Rectangle.class){
                Rectangle rect = (Rectangle) item;
                rect.w /= 2;
            }
        }
    }
    void half_height(){
        for(Shape item : shapes){
            if(item.isAnyStateActive() && item.getClass() == Ellipse.class){
                Ellipse ellipse = (Ellipse) item;
                ellipse.h /= 2;
            }else if(item.isAnyStateActive() && item.getClass() == Rectangle.class){
                Rectangle rect = (Rectangle) item;
                rect.h /= 2;
            }
        }
    }
    void half_ratio(){
        for(Shape item : shapes){
            if(item.isAnyStateActive() && item.getClass() == Ellipse.class){
                Ellipse ellipse = (Ellipse) item;
                ellipse.w /= 2;
                ellipse.h /= 2;
            }else if(item.isAnyStateActive() && item.getClass() == Rectangle.class){
                Rectangle rect = (Rectangle) item;
                rect.w /= 2;
                rect.h /= 2;
            }
        }
    }

    //save project
    void save_project(){
        String path = savePath.pool; 
        if(safeLoad.canLoad(path, ".json")){
            ProjectCode coc = new ProjectCode();
            saveJSONArray(coc.array_to_code(shapes), path);
        }
    }

    //load project
    void open_file(){
        String path = loadPath.pool;
        if(safeLoad.canLoad(path, ".json")){
            ProjectCode coc = new ProjectCode();
            shapes = coc.code_to_array(path);
        }
    }

    //図形をprocessing4のコードにコンバート
    void convert_code(){
        Processing4Code coc = new Processing4Code();
        exportPreview.pool = coc.export_to_processing();
    }
    //コンバートしたコードをテキストファイルに保存
    void save_code_as_text_file(){
        saveStrings(exportPath.pool, exportPreview.pool);
    }
    //コンバートしたコードをテキストファイルに保存
    void copy_code_to_clipboard(){
        copyStrings(exportPreview.pool);
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