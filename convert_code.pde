class ConvertCode extends Block{
    ConvertCode(){
        super(0, 0, 100, 100, 16, 16);
    }

    void export_to_processing(){
        println("void shapeToolExport(float x, float y){");
        for(int i = 0; i < canvas.shapes.size(); i++){
            println("  pushMatrix();");
            Object shapeObj = canvas.shapes.get(i);
            if(shapeObj.getClass() == Rectangle.class){
                Rectangle shapeRect = (Rectangle) shapeObj;
                println("  fill(" + getSplitedColor(shapeRect.fillCol) + ");");
                
                float x = shapeRect.x;
                float y = shapeRect.y;
                float w = shapeRect.w;
                float h = shapeRect.h;
                float tl = shapeRect.tl;
                float tr = shapeRect.tr;
                float br = shapeRect.br;
                float bl = shapeRect.bl;
                
                println("  translate(" + x + " + x, " + y + " + y);");
                println("  rotate(" + shapeRect.radian + ");");
                println("  rectMode(CENTER);");
                if(tl != 0.0 || tr != 0.0 || br != 0.0 || bl != 0.0){
                    println("  rect(0, 0, " + w + ", " + h + ", " + tl + ", " + tr + ", " + br + ", " + bl + ");");
                }else{
                    println("  rect(0, 0, " + w + ", " + h + ");");
                }
                println("  rectMode(CORNER);");
            }else if (shapeObj.getClass() == Ellipse.class) {
                Ellipse shapeEllipse = (Ellipse) shapeObj;
                println("  fill(" + getSplitedColor(shapeEllipse.fillCol) + ");");
                
                float x = shapeEllipse.x;
                float y = shapeEllipse.y;
                float w = shapeEllipse.w;
                float h = shapeEllipse.h;
                
                PVector rectSize = getContainerBlockSize(w, h);
                PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
                println("  translate(" + x + " + x, " + y + " + y);");
                println("  rotate(" + shapeEllipse.radian + ");");

                println("  ellipse(0, 0, " + w + ", " + h + ");");
            }
            println("  popMatrix();");
            println("  ");
        }
        println("}");
    }

    String getSplitedColor(color col){
        int r = int(red(col));
        int g = int(green(col));
        int b = int(blue(col));
        int a = int(alpha(col));
        if(255 <= a){
            if(r == g && g == b && b == r){
                return str(r);
            }else{
                return str(r) + ", " + str(g) + ", " + str(b);
            }
        }
        return str(r) + ", " + str(g) + ", " + str(b) + ", " + str(a);
    }
}
    