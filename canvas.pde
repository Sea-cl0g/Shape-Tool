

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
class Shape extends Block {
    boolean[] status = new boolean[5];
    boolean isAnyStateActive;
    float degree;

    color selectLineCol = color(#5894f5);
    color unselectedLineCol = color(#b348fa);

    Shape() {
        super(0, 0, 1000, 1000, 100, 100); // 適当な値で初期化
        this.degree = 0;
    }

    void drawSelectLine(float x, float y, float w, float h) {
        PVector size = getContainerBlockSize(w, h);
        if(isAnyStateActive){
            noFill();
            strokeWeight(1);
            if (status[0]) {
                stroke(selectLineCol);
            }else{
                stroke(unselectedLineCol);
            }
            rect(0, 0, size.x, size.y);
        }
    }

    void drawPoint(int stateIndex, float x, float y, float w, float h, float boxW) {
        PVector size = getContainerBlockSize(w, h);
        if(isAnyStateActive){
            stroke(255);
            strokeWeight(1);
            if (status[1]) {
                fill(selectLineCol);
            }else{
                fill(unselectedLineCol);
            }
            rect(size.x / 2, size.y / 2, boxW, boxW);
        }
    }

    boolean isNearTarget(float targetX, float targetY, float pointX, float pointY, float th) {
        return dist(targetX, targetY, pointX, pointY) < th;
    }

    void resetStatesExcept(int activeStateIndex) {
        for (int i = 0; i < status.length; i++) {
            if (i != activeStateIndex) {
                status[i] = false;
            }
        }
    }

    boolean isAnyStateActive() {
        for (boolean state : status) {
            if (state) return true;
        }
        return false;
    }

    void arg_tmp(){
        if(isKeyPressing && status[0]){
            println(keyCode);
            if(keyCode == 37){
                if(degree - 1 < 0){
                    degree = 360;
                }else{
                    degree -= 1;
                }
            }else if(keyCode == 39){
                if(degree + 1 < 0){
                    degree = 0;
                }else{
                    degree += 1;
                }
            }
        }
    }
}

//--------------------------------------------------
class Rectangle extends Shape {
    float x, y, w, h, tl, tr, br, bl;

    Rectangle(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.tl = 0.0;
        this.tr = 0.0;
        this.br = 0.0;
        this.bl = 0.0;
    }

    void updateState(int stateIndex, boolean isTouched) {
        if (!hasMouseTouched && isTouched) {
            if (isMouseLeftClicking && !status[stateIndex]) {
                isMouseLeftClicking = false;
                status[stateIndex] = true; // 該当状態を選択
                resetStatesExcept(stateIndex); // 他の状態をリセット
            }
            hasMouseTouched = true;
        } else if (!isTouched && isMouseLeftClicking && !hasMouseTouched) {
            status[stateIndex] = false;
        }
    }
    
    void changeScale() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectPos = getObjectPos(x, y, w, h, rectSize);
        PVector cornerPos = new PVector(rectSize.x / 2, rectSize.y / 2);
        float radian = radians(degree);
        boolean isTouched = isNearTarget(
            cos(radian) * cornerPos.x - sin(radian) * cornerPos.y + rectPos.x, 
            sin(radian) * cornerPos.x + cos(radian) * cornerPos.y + rectPos.y, 
            mouseX, 
            mouseY, 
            5
        );
        updateState(1, isTouched);
        if (status[1] && mousePressed && mouseButton == LEFT) {
            PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
            w += mouseMove.x;
            h += mouseMove.y;
        }
    } 

    void moveRectangle() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectPos = getObjectPos(x, y, w, h, rectSize);
        PVector cornerPos = new PVector(rectSize.x / 2, rectSize.y / 2);
        float radian = radians(degree);
        boolean isTouched = isPointInRecrangle(
            rectPos.x - rectSize.x / 2, 
            rectPos.y - rectSize.y / 2, 
            rectSize.x, 
            rectSize.y, 
            cos(radian) * (mouseX - rectPos.x) - sin(radian) * (mouseY - rectPos.y) + rectPos.x, 
            sin(radian) * (mouseX - rectPos.x) + cos(radian) * (mouseY - rectPos.y) + rectPos.y
        );//逆数を求める！
        updateState(0, isTouched);
        if (status[0] && mousePressed && mouseButton == LEFT) {
            PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
            x += mouseMove.x;
            y += mouseMove.y;
        }
    }

    void rotateRectangle(float x, float y, float dist) {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectPos = getObjectPos(x, y, w, h, rectSize);
        PVector cornerPos = new PVector(rectSize.x / 2, rectSize.y / 2);
        float radian = radians(degree);
        boolean isTouched = isPointInRecrangle(
            rectPos.x - rectSize.x / 2, 
            rectPos.y - rectSize.y / 2, 
            rectSize.x, 
            rectSize.y, 
            cos(radian) * (mouseX - rectPos.x) - sin(radian) * (mouseY - rectPos.y) + rectPos.x, 
            sin(radian) * (mouseX - rectPos.x) + cos(radian) * (mouseY - rectPos.y) + rectPos.y
        );
        updateState(0, isTouched);
        if (status[0] && mousePressed && mouseButton == LEFT) {
            PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
            x += mouseMove.x;
            y += mouseMove.y;
        }
    }

    boolean isPointInRecrangle(float x, float y, float w, float h, float pointX, float pointY){
        PVector size = getContainerBlockSize(this.w, this.h);
        PVector pos = getObjectPos(this.x, this.y, this.w, this.h, size);
        popMatrix();
        fill(0, 255, 0);
        noStroke();
        ellipse(pointX, pointY, 10, 10);
        noFill();
        stroke(0);
        rect(pos.x, pos.y, size.x, size.y);
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(radians(degree));

        boolean xCheck = x < pointX && pointX < x + w;
        boolean yCheck = y < pointY && pointY < y + h;
        return xCheck && yCheck;
    }

    void checkStatus() {
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        translate(pos.x, pos.y);
        rotate(radians(degree));

        changeScale();
        arg_tmp();
        moveRectangle();
    }

    void drawRectangle() {
        PVector size = getContainerBlockSize(w, h);
        fill(255, 0, 0);
        stroke(200, 200, 200);
        strokeWeight(4);
        rect(0, 0, size.x, size.y);
    }

    void drawShapeWithGUI() {
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        translate(pos.x, pos.y);
        rotate(radians(degree));

        drawRectangle();
        isAnyStateActive = isAnyStateActive();
        drawSelectLine(x, y, w, h);
        drawPoint(1, x + w / 2, y + h / 2, w, h, 10);
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
            }
            popMatrix();
        }
        rectMode(CORNER);
    }
}

//--------------------------------------------------