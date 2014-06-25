Pod::Spec.new do |s|
  s.name             = "DKImageView"
  s.version          = File.read('VERSION')
  s.summary          = "Library to zoom, ratio, crop, and funny features on a UIImageView"
  s.homepage         = "https://github.com/kevindelord/DKImageView"
  s.license          = 'MIT'
  s.author           = { "kevindelord" => "delord.kevin@gmail.com" }
  s.source           = { :git => "https://github.com/kevindelord/DKImageView.git", :tag => s.version.to_s }
  s.platform         = :ios
  s.requires_arc     = true
  s.source_files     = 'DKImageView/*'
end
