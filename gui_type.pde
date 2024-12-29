class ColorPicker extends Block{
    DrawMode drawMode;
    float x, y, w, h;
    float r, tl, tr, br, bl;
    int colorPalletIndex;
    String pickerMode;
    int colorMax = 255;
    float pickNum = 125;

    ColorPicker(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, int colorPalletIndex, String pickerMode){
        super(splitW, splitH);
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        this.drawMode = drawMode;
        this.pickerMode = pickerMode;
        this.x = layoutData.x_point;
        this.y = layoutData.y_point;
        this.w = layoutData.width_point;
        this.h = layoutData.height_point;
        this.r = layoutData.r_point;
        this.tl = layoutData.tl_point;
        this.tr = layoutData.tr_point;
        this.br = layoutData.br_point;
        this.bl = layoutData.bl_point;
        if(pickerMode.endsWith("HSB_H")){
            pickNum = hue(canvas.colorPallet[colorPalletIndex]);
        }else if(pickerMode.endsWith("HSB_S")){
            pickNum = saturation(canvas.colorPallet[colorPalletIndex]);
        }else if(pickerMode.endsWith("HSB_B")){
            pickNum = brightness(canvas.colorPallet[colorPalletIndex]);
        }else if(pickerMode.endsWith("RGB_R")){
            pickNum = red(canvas.colorPallet[colorPalletIndex]);
        }else if(pickerMode.endsWith("RGB_G")){
            pickNum = green(canvas.colorPallet[colorPalletIndex]);
        }else if(pickerMode.endsWith("RGB_B")){
            pickNum = blue(canvas.colorPallet[colorPalletIndex]);
        }
    }

    void drawColPicker(){
        noStroke();
        drawGradation(colorMax);
        drawPickPoint();
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(mousePressed){
                PVector size = getContainerBlockSize(w, h);
                PVector pos = getObjectPos(x, y, w, h, size);
                pickNum = map(mouseX, pos.x, pos.x + size.x, 0, colorMax + 1);
                canvas.colorPallet[colorPalletIndex] = getPickedColor();
                isMouseLeftClicking = false;
            }
            hasMouseTouched = true;
        }
    }

    color getPickedColor(){
        float colElement1;
        float colElement2;
        float colElement3;
        if(pickerMode.startsWith("HSB")){
            colElement1 = hue(canvas.colorPallet[colorPalletIndex]);
            colElement2 = saturation(canvas.colorPallet[colorPalletIndex]);
            colElement3 = brightness(canvas.colorPallet[colorPalletIndex]);
            colorMode(HSB, 255, 255, 255);
        }else{
            colElement1 = red(canvas.colorPallet[colorPalletIndex]);
            colElement2 = green(canvas.colorPallet[colorPalletIndex]);
            colElement3 = blue(canvas.colorPallet[colorPalletIndex]);
            colorMode(RGB, 255, 255, 255);
        }
        color returnCol = color(0, 0, 0);
        if(pickerMode.endsWith("H") || pickerMode.endsWith("R")){
            returnCol = color(pickNum, colElement2, colElement3);
        }else if(pickerMode.endsWith("S") || pickerMode.endsWith("G")){
            returnCol = color(colElement1, pickNum, colElement3);
        }else if(pickerMode.endsWith("B")){
            returnCol = color(colElement1, colElement2, pickNum);
        }
        colorMode(RGB, 255, 255, 255);
        return returnCol;
    }

    void drawGradation(int max){
        float eachWidth = w / max;
        float colElement1;
        float colElement2;
        float colElement3;
        noStroke();
        if(pickerMode.startsWith("HSB")){
            colElement1 = hue(canvas.colorPallet[colorPalletIndex]);
            colElement2 = saturation(canvas.colorPallet[colorPalletIndex]);
            colElement3 = brightness(canvas.colorPallet[colorPalletIndex]);
            colorMode(HSB, 255, 255, 255);
        }else{
            colElement1 = red(canvas.colorPallet[colorPalletIndex]);
            colElement2 = green(canvas.colorPallet[colorPalletIndex]);
            colElement3 = blue(canvas.colorPallet[colorPalletIndex]);
            colorMode(RGB, 255, 255, 255);
        }
        setBlockAnker("CORNER");
        for(int i = 0; i < max; i++){
            if(pickerMode.endsWith("HSB_H")){
                fill(i, 255, 255);
            }else if(pickerMode.endsWith("HSB_S")){
                fill(colElement1, i, colElement3);
            }else if(pickerMode.endsWith("HSB_B")){
                fill(0, 0, i);
            }else if(pickerMode.endsWith("RGB_R")){
                fill(i, colElement2, colElement3);
            }else if(pickerMode.endsWith("RGB_G")){
                fill(colElement1, i, colElement2);
            }else if(pickerMode.endsWith("RGB_B")){
                fill(colElement1, colElement2, i);
            }
            
            if(drawMode.blockAnker.equals("CORNER")){
                box(x, y, w - eachWidth * i, h);
            }else{
                box(x - w / 2, y - h / 2, w - eachWidth * i, h);
            }
        }
        colorMode(RGB, 255, 255, 255);
        setBlockAnker(drawMode.blockAnker);
    }

    void drawPickPoint(){
        PVector colorPickerSize = getContainerBlockSize(w, h);
        PVector colorPickerPos = getObjectPos(x, y, w, h, colorPickerSize);
        float pointX = map(pickNum, 0, colorMax, colorPickerPos.x, colorPickerPos.x + colorPickerSize.x);
        fill(255);
        stroke(0);
        strokeWeight(1);
        int pointW = 5;
        rect(pointX - pointW / 2, colorPickerPos.y, pointW, pointW);
        rect(pointX - pointW / 2, colorPickerPos.y + colorPickerSize.y - pointW, pointW, pointW);
    }
}

//--------------------------------------------------
class TextBlock extends Base{
    String text;
    String textAlign;
    float textSize;
    color textColor;

    TextBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        
        this.text = textData.text;
        this.textAlign = textData.textAlign;
        this.textSize = textData.textSize;
        this.textColor = textData.textColor;
    }

    void drawTextBlock(){
        drawBase();
        switch (textAlign) {
            case "CENTER" :
                textAlign(CENTER, CENTER);
            break;	
            case "RIGHT" :
                textAlign(RIGHT, CENTER);
            break;	
            default :
                textAlign(LEFT, CENTER);
            break;	
        }
        float textGSize = getContainerBlockSize(textSize, textSize).y;
        textSize(textGSize);
        fill(textColor);
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        text(text, pos.x + size.x / 2, pos.y + size.y / 2);
    }
}

//--------------------------------------------------
class Button extends ButtonTemplate{
    DrawMode drawMode;
    StyleData normal, touched, clicked;
    Runnable onClick;
    int colorIndex = -1;
    int status = 0;
    
    Button(int splitW, int splitH, DrawMode drawMode, StyleData normal, StyleData touched, StyleData clicked, Runnable onClick){
        super(splitW, splitH);
        this.normal = normal;
        this.drawMode = drawMode;
        this.touched = touched;
        this.clicked = clicked;
        this.onClick = onClick;
    }
    
    void checkStatus(float mouseX, float mouseY){
        LayoutData normalLayout = normal.layoutData;
        boolean isTouched = isPointInBox(normalLayout.x_point, normalLayout.y_point, normalLayout.width_point, normalLayout.height_point, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(isMouseLeftClicking){
                status = 2;
                if(onClick != null){
                    onClick.run();
                }else{
                    println(this.onClick);
                }
                isMouseLeftClicking = false;
            }else{
                status = 1;
            }
            hasMouseTouched = true;
        }else{
            status = 0;
        }
    }

    void drawButton(){
        if(status == 2){
            display(clicked);
        }else if(status == 1){
            display(touched);
        }else{
            display(normal);
        }
    }

    void display(StyleData style) {
        String buttonType = style.buttonType;
        color fillCol;
        color[] canvasPallet = canvas.colorPallet;
        if(0 <= colorIndex && colorIndex < canvasPallet.length){
            fillCol = canvasPallet[colorIndex];
        }else{
            fillCol = style.fillCol;
        }
        LayoutData layoutData = style.layoutData;
        StrokeData strokeData = style.strokeData;
        ImageData imageData = style.imageData;
        ShadowData shadowData = style.shadowData;

        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);

        setFillCol(fillCol);
        setShadowCol(shadowData.shadowCol);
        setStrokeCol(strokeData.strokeCol);
        setStrokePoint(strokeData.stroke_point);
        switch (buttonType) {
            case "squareButton" :
                drawSquareButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;
            case "roundedSquareButton" :
                drawRoundedSquareButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    layoutData.r_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
            case "eachRoundedButton" :
                drawEachRoundedButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    layoutData.tl_point, layoutData.tr_point, layoutData.br_point, layoutData.bl_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
            case "horizontallyRoundedButton" :
                drawHorizontallyRoundedButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
            case "verticallyRoundedButton" :
                drawVerticallyRoundedButton(
                    layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                    shadowData.shadowMode, shadowData.shadowDistPoint
                );
            break;	
        }

        if(imageData.svgTgl){
            drawSVG(
                layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                imageData.size, imageData.svg
            );
        }else{
            drawImage(
                layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
                imageData.size, imageData.image
            );
        }
        
    }
}

//--------------------------------------------------
class Base extends Block{
    DrawMode drawMode;
    color fillCol;
    float x, y, w, h;
    float r, tl, tr, br, bl;

    Base(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, StrokeData strokeData, color fillCol){
        super(splitW, splitH);
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        this.drawMode = drawMode;
        this.fillCol = fillCol; 
        this.x = layoutData.x_point;
        this.y = layoutData.y_point;
        this.w = layoutData.width_point;
        this.h = layoutData.height_point;
        this.r = layoutData.r_point;
        this.tl = layoutData.tl_point;
        this.tr = layoutData.tr_point;
        this.br = layoutData.br_point;
        this.bl = layoutData.bl_point;
    }

    void drawBase(){
        if(alpha(fillCol) != 0.0){
            fill(fillCol);
            noStroke();
            float loTl = 0;
            float loTr = 0;
            float loBr = 0;
            float loBl = 0;
            if(r != 0.0){
                loTl = tl != 0.0 ? tl : r;
                loTr = tr != 0.0 ? tr : r;
                loBr = br != 0.0 ? br : r;
                loBl = bl != 0.0 ? bl : r;
            }
            box(x, y, w, h, loTl, loTr, loBr, loBl);
        }
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched && alpha(fillCol) != 0.0){
            hasMouseTouched = true;
        }
    }
}