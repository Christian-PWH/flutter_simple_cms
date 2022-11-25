import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ApiServices {
  // testing database
  final String keyApplicationId = "ju2F1pmGlk488wahDAU1FZsmWcPKs4Z9sUsiRcJW";
  final String keyClientKey = "vTsN7M7ByCRUqZYrS1H51kZX8RVWTrYi87KLRu6i";
  final String keyParseServerUrl = "https://parseapi.back4app.com/";
  // final String contentType = "application/json";

  Future<Parse> initialize() async {
    return Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      debug: true,
      clientKey: keyClientKey,
      coreStore: await CoreStoreSharedPrefsImp.getInstance(),
    );
  }
}
