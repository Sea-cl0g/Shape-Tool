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
    return jsonObj.isNull(key) ? ifNull : jsonObj.getFloat(key);
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

  Object keys(){
    return jsonObj.keys();
  }

  // 
  void override(EasyJSONObject source){
    override(source.jsonObj);
  }
  void override(JSONObject source){
    for(Object key : source.keys()){
      String keyStr = (String) key;
      println("key: ", keyStr);
    }
    exit();
  }
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