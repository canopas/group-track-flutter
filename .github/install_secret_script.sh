env:
  FIREBASE_OPTIONS_BASE64: ${{ secrets.FIREBASE_OPTIONS_BASE64 }}
  GOOGLE_SERVICES_JSON_BASE64: ${{ secrets.GOOGLE_SERVICES_JSON_BASE64 }}

echo $FIREBASE_OPTIONS_BASE64 | base64 -di > lib/firebase_options.dart
echo $GOOGLE_SERVICES_JSON_BASE64 | base64 -di > android/app/google-services.json