class Button extends ButtonTemplate{
    DrawMode drawMode;
    StyleData normal, touched, clicked;
    Runnable onClick;
    int status = 0;
    
    Button(int splitW, int splitH, DrawMode drawMode, StyleData normal, StyleData touched, StyleData clicked, Runnable onClick){
        super(splitW, splitH);
        this.normal = normal;
        this.drawMode = drawMode;
        this.touched = touched;
        this.clicked = clicked;
        this.onClick = onClick;
        println(this.onClick);
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
        color fillCol = style.fillCol;
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
        box(layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point);
    }

    void checkStatus(float mouseX, float mouseY){
        boolean isTouched = isPointInBox(layoutData.x_point, layoutData.y_point, layoutData.width_point, layoutData.height_point, mouseX, mouseY);
        if(!hasMouseTouched && isTouched){
            hasMouseTouched = true;
        }
    }
}