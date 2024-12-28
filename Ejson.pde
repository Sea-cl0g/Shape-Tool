class EasyJSONObject{
  JSONObject jsonObj;

  EasyJSONObject(){
    this.jsonObj = new JSONObject();
  }
  EasyJSONObject(JSONObject jsonObj){
    this.jsonObj = jsonObj;
  }

  String safeGetString(String key){
    return safeGetString(key, "ERR");
  }
  String safeGetString(String key, String ifNull){
    return jsonObj.isNull(key) ? ifNull : jsonObj.getString(key);
  }

  float safeGetFloat(String key){
    return safeGetFloat(key, 0.0);
  }
  float safeGetFloat(String key, float ifNull){
    if(jsonObj.isNull(key)){
      return ifNull;
    }else{
      Object obj = jsonObj.get(key);
      if(obj instanceof String){
        String str = (String) obj;
        try{
          return calculateExpression(str);
        }catch(Exception e){
          println(key + "': " + e.getMessage());
          return ifNull;
        }
      }
      return jsonObj.getFloat(key);
    }
  }

  EasyJSONObject safeGetEasyJSONObject(String key){
    JSONObject childJsonObj = jsonObj.getJSONObject(key);
    return childJsonObj == null ? new EasyJSONObject() : new EasyJSONObject(childJsonObj);
  }

  EasyJSONArray safeGetEasyJSONArray(String key){
    JSONArray childJsonArray = jsonObj.getJSONArray(key);
    return childJsonArray == null ? new EasyJSONArray() : new EasyJSONArray(childJsonArray);
  }

  // JSONObjectクラス関数のオーバーライド
  Object get(String key){
    return jsonObj.get(key);
  }

  JSONObject getJSONObject(String key){
    return jsonObj.getJSONObject(key);
  }

  JSONArray getJSONArray(String key){
    return jsonObj.getJSONArray(key);
  }
}

float calculateExpression(String expression){
  String[] tokens = expression.split(" ");
  float result = Float.parseFloat(tokens[0]);

  for(int i = 1; i < tokens.length; i += 2){
    String operator = tokens[i];
    float operand = Float.parseFloat(tokens[i + 1]);

    switch (operator){
      case "+":
        result += operand;
        break;
      case "-":
        result -= operand;
        break;
      case "*":
        result *= operand;
        break;
      case "/":
        result /= operand;
        break;
      default:
        throw new IllegalArgumentException("Unsupported operator: " + operator);
    }
  }

  return result;
}

//--------------------------------------------------

class EasyJSONArray extends JSONArray{
  JSONArray jsonArray;

  EasyJSONArray(JSONArray jsonArray){
    this.jsonArray = jsonArray;
  }
  EasyJSONArray(){
    this.jsonArray = new JSONArray();
  }

  float safeGetFloat(int index){
    return !jsonArray.isNull(index) ? 0.0 : jsonArray.getFloat(index);
  }

  EasyJSONObject safeGetEasyJSONObject(int index){
    JSONObject childJsonObj = jsonArray.getJSONObject(index);
    return childJsonObj == null ? new EasyJSONObject() : new EasyJSONObject(childJsonObj);
  }

  EasyJSONArray safeGetEasyJSONArray(int index){
    JSONArray childJsonArray = jsonArray.getJSONArray(index);
    return childJsonArray == null ? new EasyJSONArray() : new EasyJSONArray(childJsonArray);
  }

  // JSONObjectクラス関数のオーバーライド
  int size(){
    return jsonArray.size();
  }
}