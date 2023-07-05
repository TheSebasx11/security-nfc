const String _baseUrl =
    //"https://nfc-health-securty-production-31a5.up.railway.app";
    "https://nfc-health-securty-production.up.railway.app";

///Person Routes
String getLoginRoute() => "$_baseUrl/auth/login";
String getRegisterRoute() => "$_baseUrl/auth/register";
String getPersonDataRoute({required String id}) => "$_baseUrl/person/$id";

///NFC Routes
String getRegisterNFCRoute({required String id}) =>
    "$_baseUrl/nfc/register/$id";
String getConsultNFCRoute({required int id}) => "$_baseUrl/nfc/read/$id";
