Pod::Spec.new do |s|
  s.name             = 'MRTDeepLinkSDK'
  s.version          = '1.0.0'
  s.summary          = 'Deferred deep linking SDK for iOS (binary).'
  s.description      = <<-DESC
    Closed-source XCFramework for SmartLink deferred deep linking.
    Match API: POST https://api.theblockyapp.com/api/v1/sdk/app/match
    Auth: x-api-key header.
  DESC
  s.homepage         = 'https://github.com/mindrootstech/MRTSmartLink'
  s.license          = { :type => 'Copyright', :file => 'LICENSE' }
  s.author           = { 'MindRoots' => 'info@mindroots.com' }
  s.source           = { :git => 'https://github.com/mindrootstech/MRTSmartLink.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'
  s.vendored_frameworks = 'Frameworks/MRTDeepLinkSDK.xcframework'
end
