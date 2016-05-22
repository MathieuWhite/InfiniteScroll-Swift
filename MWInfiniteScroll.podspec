#
# Be sure to run `pod lib lint MHInfiniteScroll.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MWInfiniteScroll"
  s.version          = "0.1.2"
  s.summary          = "An infinite horizontal UIScrollView subclass with paging for Swift."

  s.homepage         = "https://github.com/MathieuWhite/InfiniteScroll-Swift"
  s.screenshots     = "https://raw.githubusercontent.com/MathieuWhite/InfiniteScroll-Swift/master/demo.gif"
  s.license          = 'MIT'
  s.author           = { "Mathieu White" => "mathieuwhite91@gmail.com" }
  s.source           = { :git => "https://github.com/MathieuWhite/InfiniteScroll-Swift.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pod/Classes/InfiniteScrollView.swift'
  
  s.frameworks = 'UIKit'
  
  # s.resource_bundles = {
  #   'MHInfiniteScroll' => ['MHInfiniteScroll/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
