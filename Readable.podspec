Pod::Spec.new do |s|
  s.name         = "Readable"
  s.version      = "0.0.1"
  s.summary      = "The web mobilizer for iOS. Courtesy of amazing Diffbot."
  s.description  = <<-DESC
  The tool of choice for extracting articles from web pages.
                   DESC
  s.homepage     = "https://github.com/quickread/Readable"
  s.license      = 'MIT (example)'
  s.author             = { "Wojtek Czekalski" => "me@wczekalski.com" }
  s.social_media_url = "http://twitter.com/wczekalski"
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/wczekalski/Readable.git", :tag => "0.0.1" }
  s.source_files  = 'QRContentMobilizer/QRContentMobilizer.{h,m}'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~>2.2.1'
end
