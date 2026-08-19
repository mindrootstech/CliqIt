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

```swift
import MRTDeepLinkSDK
import SwiftUI

@main
struct MyApp: App {
    init() {
        MRTDeepLink.shared.configure(apiKey: "pk_live_…")
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

### Typed deferred match

```swift
MRTDeepLink.shared.onDeferredMatch { outcome in
    switch outcome {
    case .matched(let info):
        print(info.destinationPath ?? "")
        print(info[.slug] ?? "")
    case .notMatched:
        break
    case .failed(let error):
        print(error.localizedDescription)
    }
}
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

## License

Proprietary — see `LICENSE`.
