# Security And Hardening Notes

## Rollout Order

1. **Prepare authenticated writers**
   1. Confirm the service/app that writes `Buses/*` authenticates with Firebase Auth.
   2. Ensure writer tokens include one of:
      - `admin: true`
      - `operator: true`
2. **Deploy rules in staged mode**
   1. Deploy `database.rules.json` to a test environment first.
   2. Verify write success with authenticated admin/operator writer.
   3. Promote the same rules to production.
3. **Verify post-deploy behavior**
   1. Public read to `Buses` remains available.
   2. Unauthenticated writes are blocked.
   3. Authenticated writes with required claims still succeed.

## Firebase Rules Deploy Command

```powershell
firebase deploy --only database
```

## Verification Commands

### Read should succeed (public)

```powershell
curl.exe "https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app/Buses.json"
```

### Unauthenticated write should fail with permission denied

```powershell
curl.exe -i -X PUT -H "Content-Type: application/json" -d true "https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app/security_probe.json"
```

### Cleanup probe path (if created)

```powershell
curl.exe -i -X DELETE "https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app/security_probe.json"
```

## Key Configuration

### Android

- Add `MAPS_API_KEY=<your key>` to `android/local.properties`, or set `MAPS_API_KEY` in the environment.

### iOS

- Set `GOOGLE_MAPS_API_KEY` in:
  - `ios/Flutter/Debug.xcconfig`
  - `ios/Flutter/Release.xcconfig`

### Restrictions to enforce in Google Cloud Console

1. Restrict Maps API key by app package/bundle and signing cert SHA-1/SHA-256.
2. Restrict enabled APIs to only required Maps services.
3. Rotate any previously exposed unrestricted keys.
