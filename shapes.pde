class Shape extends Block{
    ArrayList<Shape> moveStack;
    color fillCol, strokeCol;
    float strokeWeight;
    
    float radian;
    
    //コンストラクタ
    Shape(){
        super(0, 0, 1000, 1000, 100, 100);
        this.radian = 0;
        moveStack = canvas.moveStack;
    }

    //回転
    rotateItem(PVector center, PVector handle){

    }

    //移動
    void movePoint(PVector from, PVector to){

    }

    //当たり判定
    boolean isPointInCircle(PVector circle, float radius, PVector point){
        return dist(circle.x, target.y, point.x, point.y) < radius;
    }

    //GUI関係
    void drawSelectLine(PVector tr, PVector bl, boolean isSelected){
        noFill();
        strokeWeight(1);
        if (isSelected){
            stroke(selectLineCol);
        }else{
            stroke(unselectedLineCol);
        }
        box(tr.x, tr.y, bl.x, bl.y);
    }

    void drawPoint(PVector point, boolean isSquareMode boolean isSelected){
        stroke(255);
        strokeWeight(1);
        if (isSelected){
            fill(selectLineCol);
        }else{
            fill(unselectedLineCol);
        }

        if(isSquareMode){
            rect(point.x, point.y, 10, 10);
        }else{
            ellipse(point.x, point.y, 10, 10);
        }
    }

    //色の変更
    void setFillCol(){
        if(status[0] && fillColorJustChanged){
            fillCol = canvas.colorPallet[0];
        }
    }

    void setStrokeCol(){
        if(status[0] && strokeColorJustChanged){
            strokeCol = canvas.colorPallet[1];
        }
    }
}

class Ellipse(){
    PVector pos;
    PVector size;

    //コンストラクタ
    Ellipse(float x, float y, float w, float h){
        super();
        this.pos = new PVector(x, y);
        this.size = new PVector(w, h);
        this.fillCol = shapeDefaultFillCol;
        this.strokeCol = shapeDefaultStrokeCol;
    }
    //コピー用コンストラクタ
    Ellipse(Ellipse item){
        super(item.x, item.y);

        this.fillCol = item.fillCol;
        this.strokeCol = item.strokeCol;
        this.strokeWeight = item.strokeWeight;
        this.status = item.statusCopy();
        item.status = new boolean[item.status.length];
        this.isAnyStateActive = item.isAnyStateActive;
        this.radian = item.radian;

        this.pos = new PVector(item.pos.x, item.pos.y);
        this.size = new PVector(item.size.x, item.size.y);
    }

    //当たり判定
    boolean isPointInEllipse(PVector ellipseGPos, PVector ellipseGSize, PVector point){
        float th = pow(point.x - ellipseGPos.x, 2) / pow(ellipseGSize.x / 2, 2) + pow(point.y - ellipseGPos.y, 2) / pow(ellipseGSize.y / 2, 2) - 1;
        return th < 0;
    }

void select() {
    PVector cursor = new PVector(mouseX, mouseY);
    PVector ellipseGSize = getContainerBlockSize(size.x, size.y);
    PVector ellipseGPos = getObjectPos(pos.x, pos.y, size.x, size.y, ellipseGSize);
    boolean cmdKeyPressed = keyPressed && (keyCode == CONTROL || keyCode == COMMAND);

    handleRotationSelection(cursor, ellipseGPos, ellipseGSize, cmdKeyPressed);
    handleVertexSelection(cursor, ellipseGPos, ellipseGSize, cmdKeyPressed, -1, -1); // tl
    handleVertexSelection(cursor, ellipseGPos, ellipseGSize, cmdKeyPressed, 1, -1);  // tr
    handleShapeSelection(cursor, ellipseGPos, ellipseGSize, cmdKeyPressed);
}

void handleRotationSelection(PVector cursor, PVector ellipseGPos, PVector ellipseGSize, boolean cmdKeyPressed) {
    PVector handleGpos = new PVector(ellipseGPos.x, ellipseGPos.y + ellipseGSize.y);
    if (isPointInCircle(handleGpos, 10, cursor) && isSafeClick()) {
        if (cmdKeyPressed) {
            rotateStack.add(handleGpos);
        } else {
            rotateStack.clear();
            rotateStack.add(handleGpos);
        }
        moveStack.clear();
        hasShapeTouched = true;
    }
}

void handleVertexSelection(PVector cursor, PVector ellipseGPos, PVector ellipseGSize, boolean cmdKeyPressed, int xFactor, int yFactor) {
    PVector handleGpos = new PVector(
        ellipseGPos.x + xFactor * ellipseGSize.y / 2,
        ellipseGPos.y + yFactor * ellipseGSize.y / 2
    );
    if (isPointInCircle(handleGpos, 10, cursor) && isSafeClick()) {
        if (cmdKeyPressed) {
            moveStack.add(handleGpos);
        } else {
            moveStack.clear();
            moveStack.add(handleGpos);
        }
        rotateStack.clear();
        hasShapeTouched = true;
    }
}

void handleShapeSelection(PVector cursor, PVector ellipseGPos, PVector ellipseGSize, boolean cmdKeyPressed) {
    if (isPointInRect(ellipseGPos, ellipseGSize, cursor) && isSafeClick()) {
        if (cmdKeyPressed) {
            moveStack.add(cursor);
        } else {
            moveStack.clear();
            moveStack.add(cursor);
        }
        rotateStack.clear();
        hasShapeTouched = true;
    }
}

boolean isSafeClick() {
    return mousePressed && mouseButton == LEFT && !hasShapeTouched && !hasMouseTouched;
}
