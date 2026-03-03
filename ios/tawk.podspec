#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tawk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tawk'
  s.version          = '0.1.0'
  s.summary          = 'Flutter plugin that embeds the tawk.to chat widget (web + WebView).'
  s.description      = <<-DESC
A small Flutter plugin that embeds the tawk.to chat widget. Works on web (DOM injection) and on mobile/desktop using a WebView.
                       DESC
  s.homepage         = 'https://github.com/csertant/tawk'
  s.license          = { :type => 'GPL-3.0', :file => '../LICENSE' }
  s.author           = { 'Tamas Csertan' => 'tamas@binarybush.dev', 'Mark Sarvari' => 'mark@binarybush.dev' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'tawk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
