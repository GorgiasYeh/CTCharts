Pod::Spec.new do |s|
  s.name             = 'CHCharts'
  s.version          = '0.1.0'
  s.summary          = 'Line Chart & Bar Chart for iOS'
  s.homepage         = 'https://github.com/quickbirdstudios/BloggerBird'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'CT' => 'GorgiasYeh@gmail.com' }
  s.source           = { :git => 'https://github.com/GorgiasYeh/CTCharts.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.6'
  s.source_files = 'Sources/CTCharts/**/*'
end
