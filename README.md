# CliqIt

iOS SDK for **deferred deep linking** — closed-source binary only.

**Version:** `2.0.2` · **iOS 15+** · **Swift 5**

---

## Install (CocoaPods)

```ruby
platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'CliqIt',
      :git => 'https://github.com/mindrootstech/CliqIt.git',
      :tag => '2.0.2'
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
        CliqItSDK.shared.configure(apiKey: "pk_live_…")

        CliqItSDK.shared.onDeferredMatch { outcome in
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
    CliqItSDK.shared.configure(apiKey: "pk_live_…")
    CliqItSDK.shared.onDeepLink { payload in
        print(payload.path, payload.isDeferred)
    }
    CliqItSDK.shared.onDeferredMatch { outcome in
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
