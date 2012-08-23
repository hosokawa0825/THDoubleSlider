Pod::Spec.new do |s|
  s.name     = 'THDoubleSlider'
  s.version  = '1.0.0'
  s.summary  = 'THDoubleSlider is a slider which has two handles. '
  s.homepage = 'https://github.com/hosokawa0825/THDoubleSlider'
  s.author   = { 'hosokawa0825' => 'globesessions.sub@gmail.com' }
  s.license  = 'MIT'
  s.source   = { :git => 'https://github.com/hosokawa0825/THDoubleSlider.git', :tag => 'v1.0.0' }
  s.ios.dependency 'JRSwizzle', '~> 1.0'
  s.ios.source_files = '*.{h,m}'
#  s.ios.source_files = 'THDoubleSlider/classes'
  s.ios.frameworks   = 'Foundation', 'QuartzCore', 'CoreGraphics', 'UIKit'
end