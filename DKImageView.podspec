Pod::Spec.new do |s|
  s.name             = "DKImageView"
  s.version          = File.read('VERSION')
  s.deprecated       = true
  s.summary          = "[Deprecated] Library to apply zoom, ratios, crop, and funny features on a UIImageView. Still working under iOS 8 but will not be maintained anymore."
  s.homepage         = "https://github.com/kevindelord/DKImageView"
  s.license          = 'MIT'
  s.author           = { "kevindelord" => "delord.kevin@gmail.com" }
  s.source           = { :git => "https://github.com/kevindelord/DKImageView.git", :tag => s.version.to_s }
  s.platform         = :ios
  s.requires_arc     = true
  s.framework        = 'CoreGraphics'
  s.source_files     = 'DKImageView/*'
  s.dependency         'DKHelper'
  s.prefix_header_contents = <<-EOS
#import "DKHelper.h"
EOS
end
