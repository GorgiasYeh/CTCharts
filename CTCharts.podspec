Pod::Spec.new do |spec|
  spec.name          = "CTCharts"
  spec.version       = "0.1.0"
  spec.summary       = "Health-style line and bar charts for UIKit, iOS 11+."
  spec.description   = <<-DESC
    Line and bar charts for UIKit apps, based on the chart components of Apple's CareKit.
    Adds a limit line, long-press selection, and iOS 11 support.
  DESC
  spec.homepage      = "https://github.com/GorgiasYeh/CTCharts"
  spec.documentation_url = "https://gorgiasyeh.github.io/CTCharts/documentation/ctcharts/"
  spec.license       = { :type => "BSD-3-Clause", :file => "LICENSE.md" }
  spec.author        = { "Gorgias Yeh" => "71258457+GorgiasYeh@users.noreply.github.com" }
  spec.source        = { :git => "https://github.com/GorgiasYeh/CTCharts.git", :tag => spec.version.to_s }
  spec.ios.deployment_target = "11.0"
  spec.swift_versions = ["5.6"]
  spec.source_files  = "Sources/CTCharts/**/*.swift"
  spec.frameworks    = "UIKit"
end
