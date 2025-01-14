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

  EasyJSONObject safeGetEasyJSONObject(String key){
    JSONObject childJsonObj = jsonObj.getJSONObject(key);
    return childJsonObj == null ? new EasyJSONObject() : new EasyJSONObject(childJsonObj);
  }

  EasyJSONArray safeGetEasyJSONArray(String key){
    JSONArray childJsonArray = jsonObj.getJSONArray(key);
    return childJsonArray == null ? new EasyJSONArray() : new EasyJSONArray(childJsonArray);
  }

  // オーバーライド
  Object get(String key){
    return jsonObj.get(key);
  }

  JSONObject getJSONObject(String key){
    return jsonObj.getJSONObject(key);
  }

  JSONArray getJSONArray(String key){
    return jsonObj.getJSONArray(key);
  }

  boolean isNull(String key){
    return jsonObj.isNull(key);
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

  // オーバーライド
  int size(){
    return jsonArray.size();
  }
}