class Shape extends Block {
    color selectLineCol = color(#5894f5);
    color unselectedLineCol = color(#b348fa);
    color shapeDefaultFillCol = color(#9966FF);
    color shapeDefaultStrokeCol = color(#000000);
    color fillCol, strokeCol;
    float strokeWeight;
    boolean[] status = new boolean[5];
    boolean isAnyStateActive;
    float degree;

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

    PVector getRotatedLocalPos(PVector globalPos, PVector localPos){
        float radian = radians(degree);
        PVector rotatedLocalPos = new PVector();
        rotatedLocalPos.x = cos(radian) * localPos.x - sin(radian) * localPos.y + globalPos.x; 
        rotatedLocalPos.y = sin(radian) * localPos.x + cos(radian) * localPos.y + globalPos.y; 
        return rotatedLocalPos;
    }

    void drawPoint(int stateIndex, float x, float y, float boxW, boolean isEllipse) {
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
            }else if(keyCode == 38){
                tl += 1;
            }
        }
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
        PVector rectCenter = getObjectPos(x, y, w, h, rectSize);
        PVector pointPosFromRectCenter = new PVector(rectSize.x / 2, rectSize.y / 2);
        PVector rotatedLocalPos = getRotatedLocalPos(rectCenter, pointPosFromRectCenter);
        boolean isTouched = isNearTarget(
            rotatedLocalPos.x, 
            rotatedLocalPos.y, 
            mouseX, 
            mouseY, 
            6
        );
        updateState(1, isTouched);
        if (status[1] && mousePressed && mouseButton == LEFT) {
            PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
            w += mouseMove.x;
            h += mouseMove.y;
        }
    }

    //tl -> tr -> br -> bl -> scalemove
    void changeTopLeftTh() {
        PVector rectSize = getContainerBlockSize(w, h);
        PVector rectCenter = getObjectPos(x, y, w, h, rectSize);
        float gTl = getContainerBlockSize(tl, tl).x;
        PVector pointPosFromRectCenter = new PVector(rectSize.x / 2 * -1 + gTl, rectSize.y / 2 * -1);
        PVector rotatedLocalPos = getRotatedLocalPos(rectCenter, pointPosFromRectCenter);
        boolean isTouched = isNearTarget(
            rotatedLocalPos.x, 
            rotatedLocalPos.y, 
            mouseX, 
            mouseY, 
            3
        );
        drawRectOnGlobal(rotatedLocalPos.x, rotatedLocalPos.y, 5, 5, color(0, 0, 255), color(0, 0, 0, 0));
        updateState(2, isTouched);
        if (status[2] && mousePressed && mouseButton == LEFT) {
            PVector mouseMove = getContainerBlockPoint(mouseX - pmouseX, mouseY - pmouseY);
            tl += mouseMove.x;
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
    //moveRectangle逆数
    //cos(radian) * (mouseX - rectPos.x) - sin(radian) * (mouseY - rectPos.y) + rectPos.x, 
    //sin(radian) * (mouseX - rectPos.x) + cos(radian) * (mouseY - rectPos.y) + rectPos.y

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
        changeTopLeftTh();
        arg_tmp();
        moveRectangle();
    }

    void drawRectangle() {
        PVector size = getContainerBlockSize(w, h);
        float gTl = getContainerBlockSize(tl, tl).x;
        fill(fillCol);
        stroke(strokeCol);
        strokeWeight(4);
        rect(0, 0, size.x, size.y, gTl, gTl, gTl, gTl);
    }

    void drawShapeWithGUI() {
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        translate(pos.x, pos.y);
        rotate(radians(degree));

        drawRectangle();
        isAnyStateActive = isAnyStateActive();
        drawSelectLine(x, y, w, h);
        drawPoint(1, w / 2, h / 2, 10, false);
        drawPoint(2, -1 * w / 2 + tl, -1 * h / 2, 10, true);
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
        rotate(radians(degree));
    }
}

//--------------------------------------------------
