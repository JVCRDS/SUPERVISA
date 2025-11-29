class Config {
  static String get googleApiKey {
    
    const String fromEnvironment = String.fromEnvironment('GOOGLE_API_KEY');
    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment;
    }
    
    
    try {
   
      final dotenv = _getDotEnv();
      final key = dotenv?['GOOGLE_API_KEY'];
      if (key != null && key.isNotEmpty) {
        return key;
      }
    } catch (e) {
      print('Config: Dotenv não disponível - $e');
    }
 
    return "";
  }
  
  static dynamic _getDotEnv() {
   
    try {
      return null; 
    } catch (e) {
      return null;
    }
  }
}