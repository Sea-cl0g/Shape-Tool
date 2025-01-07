class Processing4Code extends Block{
    Processing4Code() {
        super(0, 0, 100, 100, 16, 16);
    }
    
    String[] export_to_processing() {
        ArrayList<String> exportList = new ArrayList<String>();
        exportList.add("void shapeToolExport(float x, float y){");
        for (int i = 0; i < canvas.shapes.size(); i++) {
            exportList.add("    pushMatrix();");
            Object shapeObj = canvas.shapes.get(i);
            if (shapeObj.getClass() == Rectangle.class) {
                Rectangle shapeRect = (Rectangle) shapeObj;
                exportList.add("    fill(" + getSplitedColor(shapeRect.fillCol) + ");");
                
                float x = shapeRect.x;
                float y = shapeRect.y;
                float w = shapeRect.w;
                float h = shapeRect.h;
                float tl = shapeRect.tl;
                float tr = shapeRect.tr;
                float br = shapeRect.br;
                float bl = shapeRect.bl;
                
                exportList.add("    translate(" + x + " + x, " + y + " + y);");
                exportList.add("    rotate(" + shapeRect.radian + ");");
                exportList.add("    rectMode(CENTER);");
                if (tl != 0.0 || tr != 0.0 || br != 0.0 || bl != 0.0) {
                    exportList.add("    rect(0, 0, " + w + ", " + h + ", " + tl + ", " + tr + ", " + br + ", " + bl + ");");
                } else{
                    exportList.add("    rect(0, 0, " + w + ", " + h + ");");
                }
                exportList.add("    rectMode(CORNER);");
            } else if (shapeObj.getClass() == Ellipse.class) {
                Ellipse shapeEllipse = (Ellipse) shapeObj;
                exportList.add("    fill(" + getSplitedColor(shapeEllipse.fillCol) + ");");
                
                float x = shapeEllipse.x;
                float y = shapeEllipse.y;
                float w = shapeEllipse.w;
                float h = shapeEllipse.h;
                
                PVector rectSize = getContainerBlockSize(w, h);
                PVector rectGCenter = getObjectPos(x, y, w, h, rectSize);
                exportList.add("    translate(" + x + " + x, " + y + " + y);");
                exportList.add("    rotate(" + shapeEllipse.radian + ");");
                
                exportList.add("    ellipse(0, 0, " + w + ", " + h + ");");
            }
            exportList.add("    popMatrix();");
            exportList.add("    ");
        }
        exportList.add("}");
        String[] exportCode = new String[exportList.size()];
        for (int i = 0; i < exportCode.length; i++) {
            exportCode[i] = exportList.get(i);
        }
        return exportCode;
    }
    
    String getSplitedColor(color col) {
        int r = int(red(col));
        int g = int(green(col));
        int b = int(blue(col));
        int a = int(alpha(col));
        if (255 <= a) {
            if (r == g && g == b && b == r) {
                return str(r);
            } else{
                return str(r) + ", " + str(g) + ", " + str(b);
            }
        }
        return str(r) + ", " + str(g) + ", " + str(b) + ", " + str(a);
    }
}

//--------------------------------------------------
class ProjectCode{
    JSONArray array_to_code(ArrayList<Shape> array) {
        JSONArray project = new JSONArray();
        for (Shape item : array) {
            //JSONObjectの用意
            JSONObject shapeData = new JSONObject();
            
            //shape
            shapeData.setInt("fillCol", item.fillCol);
            shapeData.setFloat("strokeWeight", item.strokeWeight);
            shapeData.setInt("strokeCol", item.strokeCol);
            shapeData.setFloat("x", item.x);
            shapeData.setFloat("y", item.y);
            shapeData.setFloat("radian", item.radian);
            
            //図形ごとの処理
            if (item.getClass() == Ellipse.class) {
                Ellipse ellipse = (Ellipse) item;
                JSONObject prop = new JSONObject();
                
                prop.setFloat("w", ellipse.w);
                prop.setFloat("h", ellipse.h);
                
                shapeData.setString("label", "ellipse");
                shapeData.setJSONObject("prop", prop);
            } else if (item.getClass() == Rectangle.class) {
                Rectangle rect = (Rectangle) item;
                JSONObject prop = new JSONObject();
                
                prop.setFloat("w", rect.w);
                prop.setFloat("h", rect.h);
                prop.setFloat("tl", rect.tl);
                prop.setFloat("tr", rect.tr);
                prop.setFloat("br", rect.br);
                prop.setFloat("bl", rect.bl);
                
                shapeData.setString("label", "rectangle");
                shapeData.setJSONObject("prop", prop);
            }
            
            //JSONArrayに追加
            project.append(shapeData);
        }
        return project;
    }
    
    
    ArrayList<Shape> code_to_array(String path) {
        ArrayList<Shape> shapeArray = new ArrayList<Shape>();
        JSONArray project = loadJSONArray(path);
        for (int i = 0; i < project.size(); i++) {
            //JSONObjectの用意
            JSONObject shapeData = project.getJSONObject(i);
            
            //shape
            float x = shapeData.getFloat("x");
            float y = shapeData.getFloat("y");
            color fillCol = shapeData.getInt("fillCol");
            color strokeCol = shapeData.getInt("strokeCol");
            float strokeWeight = shapeData.getFloat("strokeWeight");
            float radian = shapeData.getFloat("radian");
            
            //図形ごとの処理
            if (shapeData.getString("label").equals("ellipse")) {
                JSONObject prop = shapeData.getJSONObject("prop");
                float w = prop.getFloat("w");
                float h = prop.getFloat("h");
                Ellipse ellipse = new Ellipse(x, y, w, h, fillCol, strokeCol);
                
                ellipse.strokeWeight = strokeWeight;
                ellipse.radian = radian;
                
                shapeArray.add(ellipse);
            } else if (shapeData.getString("label").equals("rectangle")) {
                JSONObject prop = shapeData.getJSONObject("prop");
                float w = prop.getFloat("w");
                float h = prop.getFloat("h");
                Rectangle rectangle = new Rectangle(x, y, w, h, fillCol, strokeCol);
                
                rectangle.strokeWeight = strokeWeight;
                rectangle.radian = radian;
                
                rectangle.tl = prop.getFloat("tl");
                rectangle.tr = prop.getFloat("tr");
                rectangle.br = prop.getFloat("br");
                rectangle.bl = prop.getFloat("bl");
                
                shapeArray.add(rectangle);
            }
        }
        return shapeArray;
    }
}