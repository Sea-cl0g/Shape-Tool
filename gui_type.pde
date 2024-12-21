class ColorPicker extends Block{
    DrawMode drawMode;
    LayoutData layoutData;
    int colorPalletIndex;
    String pickerMode;

    ColorPicker(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, int colorPalletIndex, String pickerMode){
        super(splitW, splitH);
        this.drawMode = drawMode;
        this.layoutData = layoutData;
        this.pickerMode = pickerMode;
    }

    void drawColPicker(){
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);

        noStroke();
        drawGradation(255);
        println(colorPalletIndex, pickerMode, "test");
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            hasMouseTouched = true;
        }
    }

    void drawGradation(int max){
        setBlockAnker("CORNER");
        float w = layoutData.width_point / max;
        if(pickerMode.startsWith("HSB")){
            colorMode(HSB);
        }else{
            colorMode(RGB);
        }
        for(int i = 0; i < max; i++){
            if(pickerMode.endsWith("HSB_H")){
                fill(i, 255, 255);
            }else if(pickerMode.endsWith("HSB_S")){
                fill(hue(canvas.colorPallet[colorPalletIndex]), i, brightness(canvas.colorPallet[colorPalletIndex]));
            }else if(pickerMode.endsWith("HSB_B")){
                fill(0, 0, i);
            }else if(pickerMode.endsWith("RGB_R")){
                fill(red(canvas.colorPallet[colorPalletIndex]), i, blue(canvas.colorPallet[colorPalletIndex]));
            }else if(pickerMode.endsWith("RGB_G")){
                fill(red(canvas.colorPallet[colorPalletIndex]), green(canvas.colorPallet[colorPalletIndex]), i);
            }else if(pickerMode.endsWith("RGB_B")){
                fill(red(canvas.colorPallet[colorPalletIndex]), i, blue(canvas.colorPallet[colorPalletIndex]));
            }
            box(layoutData.x_point - layoutData.width_point / 2 + w * i, layoutData.y_point, layoutData.width_point - w * i, layoutData.height_point);
        }
        setBlockAnker(drawMode.blockAnker);
        colorMode(RGB);
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
        if(0 <= colorIndex && colorIndex < canvas.colorPallet.length){
            fillCol = canvas.colorPallet[colorIndex];
        }else{
            fillCol = style.fillCol;
        }
        LayoutData layoutData = style.layoutData;
        StrokeData strokeData = style.strokeData;
        IconData iconData = style.iconData;
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

        icon(
            layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, 
            iconData.size, iconData.icon
        );
    }
}

//--------------------------------------------------
class Base extends Block{
    DrawMode drawMode;
    color fillCol;
    LayoutData layoutData;

    Base(int splitW, int splitH, DrawMode drawMode, LayoutData layoutData, color fillCol){
        super(splitW, splitH);
        this.drawMode = drawMode;
        this.fillCol = fillCol; 
        this.layoutData = layoutData;
    }

    void drawBase(){
        setContainerAnker(drawMode.containerAnker);
        setBlockMode(drawMode.blockMode);
        setBlockAnker(drawMode.blockAnker);

        fill(fillCol);
        noStroke();
        float tl = 0;
        if(layoutData.r_point != 0.0){
            tl = layoutData.tl_point == 0.0 ? layoutData.r_point : layoutData.tl_point;  
        }
        float tr = 0;
        if(layoutData.r_point != 0.0){
            tr = layoutData.tr_point == 0.0 ? layoutData.r_point : layoutData.tr_point;  
        }
        float br = 0;
        if(layoutData.r_point != 0.0){
            br = layoutData.br_point == 0.0 ? layoutData.r_point : layoutData.br_point;  
        }
        float bl = 0;
        if(layoutData.r_point != 0.0){
            bl = layoutData.bl_point == 0.0 ? layoutData.r_point : layoutData.bl_point;  
        }

        box(layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, tl, tr, br, bl);
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            hasMouseTouched = true;
        }
    }
}