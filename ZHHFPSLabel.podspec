#
# Be sure to run `pod lib lint ZHHFPSLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHHFPSLabel'
  s.version          = '0.0.1'
  s.summary          = 'ZHHFPSLabel是一个监测FPS的小工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  ZHHFPSLabel是一个监测FPS的小工具，通过FPS检测页面卡顿问题。
                       DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHFPSLabel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHFPSLabel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.public_header_files = 'ZHHFPSLabel/Classes/ZHHCommon.h'
  s.source_files = 'ZHHFPSLabel/Classes/ZHHCommon.h'
  s.subspec 'Common' do |common|
    common.public_header_files = 'ZHHFPSLabel/Classes/Common/ZHHLabelHeader.h'
    common.source_files = 'ZHHFPSLabel/Classes/Common/ZHHLabelHeader.h'
    #三级
    common.subspec 'Label' do |label|
      label.source_files = 'ZHHFPSLabel/Classes/Common/Label/*.{h,m}'
    end
  end
  # s.resource_bundles = {
  #   'ZHHFPSLabel' => ['ZHHFPSLabel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
