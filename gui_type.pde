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
        this.colorPalletIndex = colorPalletIndex;
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
        }else if(pickerMode.endsWith("ALPHA")){
            pickNum = alpha(canvas.colorPallet[colorPalletIndex]);
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
            if(mousePressed && mouseButton == LEFT){
                PVector size = getContainerBlockSize(w, h);
                PVector pos = getObjectPos(x, y, w, h, size);
                pickNum = map(mouseX, pos.x, pos.x + size.x, 0, colorMax + 1);
                canvas.colorPallet[colorPalletIndex] = getPickedColor();
                if(colorPalletIndex == 0){
                    fillColorJustChanged = true;
                }else if(colorPalletIndex == 1){
                    strokeColorJustChanged = true;
                }
                isMouseLeftClicking = false;
            }
            hasMouseTouched = true;
        }
    }

    color getPickedColor(){
        float colElement1;
        float colElement2;
        float colElement3;
        float colElement4;
        if(pickerMode.startsWith("HSB")){
            colElement1 = hue(canvas.colorPallet[colorPalletIndex]);
            colElement2 = saturation(canvas.colorPallet[colorPalletIndex]);
            colElement3 = brightness(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(HSB, 255, 255, 255);
        }else{
            colElement1 = red(canvas.colorPallet[colorPalletIndex]);
            colElement2 = green(canvas.colorPallet[colorPalletIndex]);
            colElement3 = blue(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(RGB, 255, 255, 255);
        }
        color returnCol = color(0, 0, 0);
        if(pickerMode.endsWith("H") || pickerMode.endsWith("R")){
            returnCol = color(pickNum, colElement2, colElement3, colElement4);
        }else if(pickerMode.endsWith("S") || pickerMode.endsWith("G")){
            returnCol = color(colElement1, pickNum, colElement3, colElement4);
        }else if(pickerMode.endsWith("B")){
            returnCol = color(colElement1, colElement2, pickNum, colElement4);
        }else if(pickerMode.endsWith("ALPHA")){
            returnCol = color(colElement1, colElement2, colElement3, pickNum);
        }
        colorMode(RGB, 255, 255, 255);
        return returnCol;
    }

    void drawGradation(int max){
        float eachWidth = w / max;
        float colElement1;
        float colElement2;
        float colElement3;
        float colElement4;
        noStroke();
        if(pickerMode.startsWith("HSB")){
            colElement1 = hue(canvas.colorPallet[colorPalletIndex]);
            colElement2 = saturation(canvas.colorPallet[colorPalletIndex]);
            colElement3 = brightness(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(HSB, 255, 255, 255);
        }else{
            colElement1 = red(canvas.colorPallet[colorPalletIndex]);
            colElement2 = green(canvas.colorPallet[colorPalletIndex]);
            colElement3 = blue(canvas.colorPallet[colorPalletIndex]);
            colElement4 = alpha(canvas.colorPallet[colorPalletIndex]);
            colorMode(RGB, 255, 255, 255);
        }
        setBlockAnker("CORNER");
        for(int i = 0; i < max; i++){
            if(pickerMode.endsWith("HSB_H")){
                fill(i, 255, 255, colElement4);
            }else if(pickerMode.endsWith("HSB_S")){
                fill(colElement1, i, colElement3, colElement4);
            }else if(pickerMode.endsWith("HSB_B")){
                fill(0, 0, i, colElement4);
            }else if(pickerMode.endsWith("RGB_R")){
                fill(i, colElement2, colElement3, colElement4);
            }else if(pickerMode.endsWith("RGB_G")){
                fill(colElement1, i, colElement2, colElement4);
            }else if(pickerMode.endsWith("RGB_B")){
                fill(colElement1, colElement2, i, colElement4);
            }else if(pickerMode.endsWith("ALPHA")){
                fill(colElement1, colElement2, colElement3, i);
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
        float pointW = 0.1;
        float pointGW = getContainerBlockSize(pointW, pointW).x;
        rect(pointX - pointGW / 2, colorPickerPos.y, pointGW, pointGW);
        rect(pointX - pointGW / 2, colorPickerPos.y + colorPickerSize.y - pointGW, pointGW, pointGW);
    }
}

//--------------------------------------------------
class TextBlock extends Base{
    String text;
    String[] textArray;
    boolean isTextArray;
    String textAlign;
    float textSize;
    color textColor;
    PointString importText;
    PointStringArray importTextArray;

    TextBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        textPrepare(textData);
    }

    TextBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol, PointString importText){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        this.importText = importText;
        textPrepare(textData);
    }

    TextBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol, PointStringArray importTextArray){
        super(splitW, splitH, drawMode, layoutData, strokeData, fillCol);
        this.importTextArray = importTextArray;
        textPrepare(textData);
    }

    void textPrepare(TextData textData){
        this.text = textData.text;
        textArray = getSplitedText(text);
        this.textAlign = textData.textAlign;
        this.textSize = textData.textSize;
        this.textColor = textData.textColor;
    }

    String[] getSplitedText(String str){
        return splitTokens(str, "|");
    }

    void drawTextBlock(){
        if(importText != null){
            text = importText.pool;
            textArray = getSplitedText(text);
        }else if(importTextArray != null){
            textArray = importTextArray.pool;
        }

        if(1 < textArray.length){
            drawTextArray();
        }else{
            drawText();
        }
    }

    void drawText(){
        drawBase();
        fill(textColor);
        float textGSize = getContainerBlockSize(textSize, textSize).y;
        textSize(textGSize);
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        switch (textAlign){
            case "CENTER" :
                textAlign(CENTER, CENTER);
                text(text, pos.x + size.x / 2, pos.y + size.y / 2);
            break;	
            case "RIGHT" :
                textAlign(RIGHT, CENTER);
                text(text, pos.x + size.x, pos.y + size.y / 2);
            break;	
            default :
                textAlign(LEFT, CENTER);
                text(text, pos.x, pos.y + size.y / 2);
            break;	
        }
    }

    void drawTextArray(){
        drawBase();
        fill(textColor);
        float textGSize = getContainerBlockSize(textSize, textSize).y;
        textSize(textGSize);
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        for(int i = 0; i < min(floor(size.y / textGSize), textArray.length); i++){
            float yPos = pos.y + textGSize / 2 + textGSize * i;
            String str = textArray[i];
            switch (textAlign){
                case "CENTER" :
                    textAlign(CENTER, CENTER);
                    text(str, pos.x + size.x / 2, yPos);
                break;	
                case "RIGHT" :
                    textAlign(RIGHT, CENTER);
                    text(str, pos.x + size.x, yPos);
                break;	
                default :
                    textAlign(LEFT, CENTER);
                    text(str, pos.x, yPos);
                break;	
            }
        }
    }
}

//--------------------------------------------------
class TextEditor extends TextBlock{
    boolean isSelected = false;
    int cursor;
    int th = 4;
    int brinkMax = 60;
    int brinkTimer = 0;
    int keyRepeatMax = 10;
    int keyRepeat = 0;
    PointString exportText;

    TextEditor(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, TextData textData, StrokeData strokeData, color fillCol,  PointString exportText){
        super(splitW, splitH, drawMode, layoutData, textData, strokeData, fillCol);
        this.exportText = exportText;
        this.text = exportText.pool;
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            if(isMouseLeftClicking){
                isSelected = true;
                isMouseLeftClicking = false;
                cursor = getCursor();
            }
            hasMouseTouched = true;
        }else{
            if(isMouseLeftClicking){
                isSelected = false;
            }
        }
        if(isSelected){
            if(isKeyPressing && keyRepeat <= 0){
                editText();
                exportText.pool = text;
                keyRepeat = keyRepeatMax;
            }
            countUpTimer();
        }
        if(0 < keyRepeat){
            keyRepeat--;
        }
    }

    void editText(){
        char[] charArray = text.toCharArray();
        ArrayList<Character> textSplit = new ArrayList<Character>();
        for(char chr : charArray){
            textSplit.add(chr);
        }
        if (isPrintableKey()){
            textSplit.add(cursor + 1, key);
            cursor++;
        }else if(key == CODED && keyCode == LEFT && 0 <= cursor){
          cursor--;
        }else if(key == CODED && keyCode == UP && 0 < cursor){
          cursor = -1;
        }else if(key == CODED && keyCode == RIGHT && cursor < textSplit.size() - 1){
          cursor++;
        }else if(key == CODED && keyCode == DOWN && cursor <= textSplit.size()){
          cursor = textSplit.size() - 1;
        }else if(key == BACKSPACE && 0 <= cursor){
            textSplit.remove(cursor);
            cursor--;
        }else if(key == DELETE && cursor == textSplit.size() && 0 <= cursor){
            textSplit.remove(cursor + 1);
        }
        StringBuilder sb = new StringBuilder();
        for (Character c : textSplit){
            sb.append(c);
        }
        text = sb.toString();
    }

    boolean isPrintableKey(){
        if(key >= 32 && key <= 126){
            return true;
        }
        if(key >= 160 && key <= 255){
           return true;
        }
        return false;
    }

    void countUpTimer(){
        if(brinkTimer < brinkMax){
            brinkTimer++;
        }else{
            brinkTimer = 0;
        }
    }

    void drawTextBlock(){
        super.drawText();
        
        if(isSelected && brinkTimer < brinkMax / 2){
            stroke(textColor);
            strokeWeight(1);
            PVector size = getContainerBlockSize(w, h);
            float boxCenterGpos = getObjectPos(x, y, w, h, size).y + size.y / 2;
            float textGSize = getContainerBlockSize(textSize, textSize).y;
            float textTh = textGSize / 2.0;
            float cursorX = getCursorX();
            line(cursorX, boxCenterGpos - textTh, cursorX, boxCenterGpos + textTh);
        }
    }

    float getBeginX(){
        float textGSize = getContainerBlockSize(textSize, textSize).y;
        textSize(textGSize);
        float textWidth = textWidth(text);
        PVector size = getContainerBlockSize(w, h);
        PVector pos = getObjectPos(x, y, w, h, size);
        if(textAlign.equals("CENTER")){
            return pos.x + size.x / 2 - textWidth / 2;
        }else if(textAlign.equals("RIGHT")){
            return pos.x + size.x - textWidth;
        }else if(textAlign.equals("LEFT")){
            return pos.x;
        }
        return -1;
    }

    int getCursor(){
        char[] charArray = text.toCharArray();
        float beginX = getBeginX();

        String buildText = "";
        for(int i = 0; i < charArray.length; i++){
            char chr = charArray[i];
            buildText = buildText + chr;
            float textCurrX = beginX + textWidth(buildText);
            if(abs(textCurrX - mouseX) < th){
                return i;
            }
        }
        return -1;
    }

    float getCursorX(){
        char[] charArray = text.toCharArray();
        float beginX = getBeginX();

        String buildText = "";
        for(int i = 0; i <= cursor; i++){
            char chr = charArray[i];
            buildText = buildText + chr;
        }
        return beginX + textWidth(buildText);
    }
}

//--------------------------------------------------
class ImageBlock extends Block{
    DrawMode drawMode;
    float x, y, w, h;
    ImageData imageData;
    ImageBlock(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, ImageData imageData){
        super(splitW, splitH);
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);
        this.x = layoutData.x_point;
        this.y = layoutData.y_point;
        this.w = layoutData.width_point;
        this.h = layoutData.height_point;
        this.imageData = imageData;
    }
    
    void drawImageBlock(){
        if(imageData.svgTgl){
            drawSVG(x, y, w, h, imageData.size, imageData.svg);
        }else{
            drawImage(x, y, w, h, imageData.size, imageData.image);
        }
    }
    
    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            hasMouseTouched = true;
        }
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

    void display(StyleData style){
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
        switch (buttonType){
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
    color fillCol, strokeCol;
    float x, y, w, h;
    float r, tl, tr, br, bl;
    float strokeW;

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
        this.strokeCol = strokeData.strokeCol;
        this.strokeW = strokeData.stroke_point;
        
        if(r != 0.0){
            tl = tl != 0.0 ? tl : r;
            tr = tr != 0.0 ? tr : r;
            br = br != 0.0 ? br : r;
            bl = bl != 0.0 ? bl : r;
        }
    }

    void drawBase(){
        if(alpha(fillCol) == 0.0){
            noFill();
        }else{
            fill(fillCol);
        }
        if(alpha(strokeCol) == 0.0 || strokeW == 0.0){
            noStroke();
        }else{
            stroke(strokeCol);
            float strokeGW = getContainerBlockSize(strokeW, strokeW).y;
            strokeWeight(strokeGW);
        }
        box(x, y, w, h, tl, tr, br, bl);
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(x, y, w, h, mouseX, mouseY);
        if(!hasMouseTouched && isTouched && alpha(fillCol) != 0.0){
            hasMouseTouched = true;
        }
    }
}