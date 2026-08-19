# CliqIt

iOS SDK for **deferred deep linking** — closed-source binary only.

**Version:** `2.0.0` · **iOS 15+** · **Swift 5**

This repository does **not** include Swift source. It ships a compiled `CliqIt.xcframework`.

- Match API: `POST https://api.theblockyapp.com/api/v1/sdk/app/match`
- Auth header: `x-api-key: <your App SDK API Key>`

> **Breaking rename:** `MRTDeepLinkSDK` → **`CliqIt`** (module, types, CocoaPods pod). Use tag `2.0.0+`.

---

## Install (CocoaPods)

```ruby
platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'CliqIt',
      :git => 'https://github.com/mindrootstech/CliqIt.git',
      :tag => '2.0.0'
end
```

```bash
pod install
```

Open the `.xcworkspace`.

If CocoaPods fails with `rsync: … Operation not permitted` (often on external disks / sandboxed user scripts), set in your app target:

```
ENABLE_USER_SCRIPT_SANDBOXING = NO
```

---

## Quick start

**Required:** call `configure(apiKey:)` at launch **before** `onDeepLink` / `onDeferredMatch`.  
If you skip it, the SDK prints a console warning and `onDeferredMatch` receives `.failed(.notConfigured)`.

### SwiftUI

```swift
import CliqIt
import SwiftUI

@main
struct MyApp: App {
    init() {
        CliqIt.shared.configure(apiKey: "pk_live_…")

        CliqIt.shared.onDeferredMatch { outcome in
            switch outcome {
            case .matched(let info):
                print(info.destinationPath ?? "")
            case .notMatched, .failed:
                break
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .handleCliqItDeepLinks { payload in
                    print(payload.path, payload.isDeferred)
                }
        }
    }
}
```

### UIKit (Swift)

```swift
import UIKit
import CliqIt

func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    CliqIt.shared.configure(apiKey: "pk_live_…")
    CliqIt.shared.onDeepLink { payload in
        print(payload.path, payload.isDeferred)
    }
    CliqIt.shared.onDeferredMatch { outcome in
        switch outcome {
        case .matched(let info): print(info.destinationPath ?? "")
        case .notMatched, .failed: break
        }
    }
    return true
}

// SceneDelegate
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    CliqItSceneSupport.handle(connectionOptions: connectionOptions)
}
func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    _ = CliqItSceneSupport.handle(userActivity: userActivity)
}
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    CliqItSceneSupport.handle(urlContexts: URLContexts)
}
```

---

## Associated Domains

Use the Universal Link domain from your admin panel:

```
applinks:<your-admin-panel-domain>
```

---

## Migration from MRTDeepLinkSDK 1.x

| Before | After |
|--------|-------|
| `import MRTDeepLinkSDK` | `import CliqIt` |
| `MRTDeepLink.shared` | `CliqIt.shared` |
| `.handleMRTDeepLinks` | `.handleCliqItDeepLinks` |
| `pod 'MRTDeepLinkSDK'` | `pod 'CliqIt'` |
