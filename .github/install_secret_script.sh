env:
  FIREBASE_OPTIONS_BASE64: ${{ secrets.FIREBASE_OPTIONS_BASE64 }}
  GOOGLE_SERVICES_JSON_BASE64: ${{ secrets.GOOGLE_SERVICES_JSON_BASE64 }}
  INFO_PLIST_BASE64: ${{ secrets.INFO_PLIST_BASE64 }}

echo $FIREBASE_OPTIONS_BASE64 | base64 -di > lib/firebase_options.dart
echo $GOOGLE_SERVICES_JSON_BASE64 | base64 -di > android/app/google-services.json
echo $INFO_PLIST_BASE64 | base64 -di > ios/Runner/Info.plist