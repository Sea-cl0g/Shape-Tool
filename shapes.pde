class Shape extends Block {
    color selectLineCol = color(#5894f5);
    color unselectedLineCol = color(#b348fa);
    color shapeDefaultFillCol = color(#9966FF);
    color shapeDefaultStrokeCol = color(#000000);
    color fillCol, strokeCol;
    float strokeWeight;
    boolean[] status;
    boolean isAnyStateActive;
    float radian;

    Shape() {
        super(0, 0, 1000, 1000, 100, 100); // 適当な値で初期化
        this.radian = 0;
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

    PVector getRotatedGPos(PVector centerGPos, PVector pointPosFromCenter){
        PVector rotatedGPos = new PVector();
        rotatedGPos.x = cos(radian) * pointPosFromCenter.x - sin(radian) * pointPosFromCenter.y + centerGPos.x; 
        rotatedGPos.y = sin(radian) * pointPosFromCenter.x + cos(radian) * pointPosFromCenter.y + centerGPos.y; 
        return rotatedGPos;
    }
    
    void drawSelectLine(float x1, float y1, float x2, float y2) {
        PVector gPos1 = getContainerBlockSize(x1, y1);
        PVector gPos2 = getContainerBlockSize(x2, y2);
        if(isAnyStateActive){
            noFill();
            strokeWeight(1);
            if (status[0]) {
                stroke(selectLineCol);
            }else{
                stroke(unselectedLineCol);
            }
            line(gPos1.x, gPos1.y, gPos2.x, gPos2.y);
        }
    }
    void drawSelectPoint(int stateIndex, float x, float y, float boxW, boolean isEllipse) {
        PVector size = getContainerBlockSize(x, y);
        if(isAnyStateActive){
            stroke(255);
            strokeWeight(1);
            if (status[stateIndex]) {
                fill(selectLineCol);
            }else{
                fill(unselectedLineCol);
            }
            if(isEllipse){
                ellipse(size.x, size.y, boxW, boxW);
            }else{
                rect(size.x, size.y, boxW, boxW);
            }
        }
    }

    boolean isNearTarget(float targetX, float targetY, float pointX, float pointY, float th) {
        return dist(targetX, targetY, pointX, pointY) < th;
    }

    PVector movePoint(int index, PVector gPos, int pointTh){
        boolean isTouched = isNearTarget(
            gPos.x, 
            gPos.y, 
            mouseX, 
            mouseY, 
            pointTh
        );
        updateState(index, isTouched);
        if (status[index] && mousePressed && mouseButton == LEFT) {
            return getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
        }
        return new PVector(0, 0);
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

    
}

//--------------------------------------------------
class Rectangle extends Shape {
    float x, y, w, h, tl, tr, br, bl;
    
    Rectangle(float x, float y, float w, float h) {
        resetRectangle(x, y, w, h, shapeDefaultFillCol, shapeDefaultStrokeCol);
    }
    Rectangle(float x, float y, float w, float h, color fillCol, color strokeCol) {
        resetRectangle(x, y, w, h, fillCol, strokeCol);
    }

    void resetRectangle(float x, float y, float w, float h, color fillCol, color strokeCol){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.tl = 0.0;
        this.tr = 0.0;
        this.br = 0.0;
        this.bl = 0.0;
        this.fillCol = fillCol;
        this.strokeCol = strokeCol;
        status = new boolean[7];
    }

    void changeScale() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        PVector pointGPosFromRectCenter = new PVector(rectSize.x / 2, rectSize.y / 2);
        PVector rotatedGPos = getRotatedGPos(rectGCenter, pointGPosFromRectCenter);
        
        PVector moveVector = movePoint(1, rotatedGPos, 10);
        if(moveVector.x != 0 || moveVector.y != 0){
            w += moveVector.x;
            h += moveVector.y;
        }
    }
    
    void changeTopLeftTh() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        float gTl = getContainerBlockSize(tl, tl).x;
        PVector pointGPosFromRectCenter = new PVector(rectSize.x / 2 * -1 + gTl, rectSize.y / 2 * -1);
        PVector rotatedGPos = getRotatedGPos(rectGCenter, pointGPosFromRectCenter);
        //頂点の移動
        PVector moveVector = movePoint(2, rotatedGPos, 6);
        if(moveVector.x != 0){
            tl += moveVector.x;
        }
        //制限
        if(tl < 0){
            tl = 0;
        }else if(min(w / 2, h / 2) < tl){
            tl = min(w / 2, h / 2);
        }
    }
    void changeTopRightTh() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        float gTr = getContainerBlockSize(tr, tr).x;
        PVector pointGPosFromRectCenter = new PVector(rectSize.x / 2 - gTr, rectSize.y / 2 * -1);
        PVector rotatedGPos = getRotatedGPos(rectGCenter, pointGPosFromRectCenter);
        //頂点の移動
        PVector moveVector = movePoint(3, rotatedGPos, 6);
        if(moveVector.x != 0){
            tr -= moveVector.x;
        }
        //制限
        if(tr < 0){
            tr = 0;
        }else if(min(w / 2, h / 2) < tr){
            tr = min(w / 2, h / 2);
        }
    }
    void changeBottomRightTh() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        float gBr = getContainerBlockSize(br, br).x;
        PVector pointGPosFromRectCenter = new PVector(rectSize.x / 2 - gBr, rectSize.y / 2);
        PVector rotatedGPos = getRotatedGPos(rectGCenter, pointGPosFromRectCenter);
        //頂点の移動
        PVector moveVector = movePoint(4, rotatedGPos, 6);
        if(moveVector.x != 0){
            br -= moveVector.x;
        }
        //制限
        if(br < 0){
            br = 0;
        }else if(min(w / 2, h / 2) < br){
            br = min(w / 2, h / 2);
        }
    }
    void changeBottomLeftTh() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        float gBl = getContainerBlockSize(bl, bl).x;
        PVector pointGPosFromRectCenter = new PVector(rectSize.x / 2 * -1 + gBl, rectSize.y / 2);
        PVector rotatedGPos = getRotatedGPos(rectGCenter, pointGPosFromRectCenter);
        //頂点の移動
        PVector moveVector = movePoint(5, rotatedGPos, 6);
        if(moveVector.x != 0){
            bl += moveVector.x;
        }
        //制限
        if(bl < 0){
            bl = 0;
        }else if(min(w / 2, h / 2) < bl){
            bl = min(w / 2, h / 2);
        }
    }

    void rotateRectangle() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        float tmp = getContainerBlockSize(4, 4).x;
        PVector pointGPosFromRectCenter = new PVector(0, -1 * rectSize.y / 2 - tmp);
        PVector rotatedGPos = getRotatedGPos(rectGCenter, pointGPosFromRectCenter);
        //頂点の移動
        PVector moveVector = movePoint(6, rotatedGPos, 6);
        if(moveVector.x != 0 || moveVector.y != 0){
            PVector mouseGPosFromRectCenter = new PVector(mouseX, mouseY).sub(rectGCenter);
            PVector pmouseGPisFromRectCenter = new PVector(pmouseX, pmouseY).sub(rectGCenter);
            float cross = mouseGPosFromRectCenter.x * pmouseGPisFromRectCenter.y - mouseGPosFromRectCenter.y * pmouseGPisFromRectCenter.x;
            if (cross > 0) {
                radian -= PVector.angleBetween(mouseGPosFromRectCenter,pmouseGPisFromRectCenter);
            } else if (cross < 0) {
                radian += PVector.angleBetween(mouseGPosFromRectCenter,pmouseGPisFromRectCenter);
            }
        }
    }
    
    boolean isPointInRecrangle(float x, float y, float w, float h, float pointX, float pointY){
        PVector size = getContainerBlockSize(this.w, this.h);
        PVector pos = getObjectPos(this.x, this.y, this.w, this.h, size);

        boolean xCheck = x < pointX && pointX < x + w;
        boolean yCheck = y < pointY && pointY < y + h;
        return xCheck && yCheck;
    }
    
    void moveRectangle() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectPos = getObjectPos(x, y, w, h, rectSize);
        PVector cornerPos = new PVector(rectSize.x / 2, rectSize.y / 2);
        boolean isTouched = isPointInRecrangle(
            rectPos.x - rectSize.x / 2, 
            rectPos.y - rectSize.y / 2, 
            rectSize.x, 
            rectSize.y, 
            sin(radian) * (mouseY - rectPos.y) + cos(radian) * (mouseX - rectPos.x) + rectPos.x,
            cos(radian) * (mouseY - rectPos.y) - sin(radian) * (mouseX - rectPos.x) + rectPos.y
        );//programmed by rin
        updateState(0, isTouched);
        if (status[0] && mousePressed && mouseButton == LEFT) {
            PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
            x += mouseMove.x;
            y += mouseMove.y;
        }
    }

    void drawSelectRect(float w, float h) {
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

    //tl -> tr -> br -> bl -> scalemove
    void checkStatus() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        translate(rectGCenter.x, rectGCenter.y);
        rotate(radian);

        changeTopLeftTh();
        changeTopRightTh();
        changeBottomRightTh();
        changeBottomLeftTh();
        changeScale();
        rotateRectangle();
        moveRectangle();
    }

    void drawShapeWithGUI() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
        translate(rectGCenter.x, rectGCenter.y);
        rotate(radian);
        isAnyStateActive = isAnyStateActive();

        drawSelectLine(0, 0, 0, -1 * h / 2 - 4);
        drawRectangle();
        drawSelectRect(w, h);
        drawSelectPoint(6, 0, -1 * h / 2 - 4, 10, true); //rotate
        drawSelectPoint(1, w / 2, h / 2, 10, false); //scale
        drawSelectPoint(2, -1 * w / 2 + tl, -1 * h / 2, 10, true); //tl
        drawSelectPoint(3, w / 2 - tr, -1 * h / 2, 10, true); //tr
        drawSelectPoint(4, w / 2 - br, h / 2, 10, true); //br
        drawSelectPoint(5, -1 * w / 2 + bl, h / 2, 10, true); //bl
    }

    void drawRectangle() {
        PVector size = getContainerBlockSize(w, h);
        float gTl = getContainerBlockSize(tl, tl).x;
        float gTr = getContainerBlockSize(tr, tr).x;
        float gBr = getContainerBlockSize(br, br).x;
        float gBl = getContainerBlockSize(bl, bl).x;
        fill(fillCol);
        stroke(strokeCol);
        strokeWeight(4);
        rect(0, 0, size.x, size.y, gTl, gTr, gBr, gBl);
    }

    //debug
    void drawRectOnGlobal(float x, float y, float w, float h, color f, color s){
        popMatrix();
        fill(f);
        if(alpha(f) == 0){
            noFill();
        }else{
            fill(f);
        }
        if(alpha(s) == 0){
            noStroke();
        }else{
            stroke(s);
        }
        rect(x, y, w, h);
        pushMatrix();
        PVector pos = getObjectPos(this.x, this.y, this.w, this.h, getContainerBlockSize(this.w, this.h));
        translate(pos.x, pos.y);
    }
}

//--------------------------------------------------