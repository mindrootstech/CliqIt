# MRTSmartLink (MRTDeepLinkSDK)

iOS SDK for **deferred deep linking** — closed-source binary only.

**Version:** `1.0.0` · **iOS 15+** · **Swift 5**

This repository does **not** include Swift source. It ships a compiled `MRTDeepLinkSDK.xcframework`.

- Match API: `POST https://api.theblockyapp.com/api/v1/sdk/app/match`
- Auth header: `x-api-key: <your App SDK API Key>`

---

## Install (CocoaPods)

```ruby
platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'MRTDeepLinkSDK',
      :git => 'https://github.com/mindrootstech/MRTSmartLink.git',
      :tag => '1.0.0'
end
```

```bash
pod install
```

Open the `.xcworkspace`.

---

## Quick start

Works with **SwiftUI** and **UIKit (Swift)**. Always call `configure(apiKey:)` at launch.

### SwiftUI

```swift
import MRTDeepLinkSDK
import SwiftUI

@main
struct MyApp: App {
    init() {
        MRTDeepLink.shared.configure(apiKey: "pk_live_…")

        MRTDeepLink.shared.onDeferredMatch { outcome in
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
                .handleMRTDeepLinks { payload in
                    print(payload.path, payload.isDeferred)
                }
        }
    }
}
```

### UIKit (Swift) — AppDelegate + SceneDelegate

```swift
import UIKit
import MRTDeepLinkSDK

// AppDelegate
func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    MRTDeepLink.shared.configure(apiKey: "pk_live_…")

    MRTDeepLink.shared.onDeepLink { payload in
        print(payload.path, payload.isDeferred)
    }

    MRTDeepLink.shared.onDeferredMatch { outcome in
        switch outcome {
        case .matched(let info):
            print(info.destinationPath ?? "")
        case .notMatched, .failed:
            break
        }
    }
    return true
}

// SceneDelegate
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    MRTDeepLinkSceneSupport.handle(connectionOptions: connectionOptions)
}

func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    _ = MRTDeepLinkSceneSupport.handle(userActivity: userActivity)
}

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    MRTDeepLinkSceneSupport.handle(urlContexts: URLContexts)
}
```

### UIKit — manual handlers

```swift
_ = MRTDeepLink.shared.handle(url: url)
_ = MRTDeepLink.shared.handle(userActivity: userActivity)
```

### Associated Domains

Universal Link domain comes from **your SmartLink admin panel** (each app/tenant can have its own host). Add that exact host in Xcode:

```
applinks:<your-admin-panel-domain>
```

Example:

```
applinks:customer.theblockyapp.com
```

AASA is served on that same domain by the admin/platform — not configured inside this SDK.


---

## Troubleshooting

### `Sandbox: rsync deny` / `Operation not permitted` after `pod install`

This is **not** an SDK bug. Newer Xcode enables **User Script Sandboxing**, which can block CocoaPods from embedding the XCFramework — especially when the project or DerivedData lives on an **external disk**.

**Fix in Xcode**

1. Target → Build Settings → search `User Script Sandboxing`
2. Set **Enable User Script Sandboxing** = **No**
3. Product → Clean Build Folder → Build

**Or add this to your Podfile** (recommended):

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end

  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.native_targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end
    end
    aggregate_target.user_project.save
  end
end
```

Then:

```bash
pod install
```

---

## License

Proprietary — see `LICENSE`.
