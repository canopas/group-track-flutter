env:
  CONFIG_DART_BASE64: ${{ secrets.CONFIG_DART_BASE64 }}
  FIREBASE_OPTIONS_BASE64: ${{ secrets.FIREBASE_OPTIONS_BASE64 }}
  GOOGLE_SERVICES_JSON_BASE64: ${{ secrets.GOOGLE_SERVICES_JSON_BASE64 }}

cd ../data
echo $CONFIG_DART_BASE64 | base64 -di > lib/config.dart
cd ../app
echo $FIREBASE_OPTIONS_BASE64 | base64 -di > lib/firebase_options.dart
echo $GOOGLE_SERVICES_JSON_BASE64 | base64 -di > android/app/google-services.json
