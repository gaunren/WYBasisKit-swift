Pod::Spec.new do |spec|

  spec.name         = "WYBasisKit"
  spec.version      = "1.0.0"
  spec.summary      = "一个大幅提高开发效率的工具库"
  spec.description  = <<-DESC 
                          WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的方法，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。
                   DESC

  spec.homepage     = "https://github.com/Jacke-xu/WYBasisKit-swift"
  spec.license      = { :type => "MIT", :file => "License.md" }
  spec.author             = { "Jacke-xu" => "mobileAppDvlp@icloud.com" }
  spec.ios.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/Jacke-xu/WYBasisKit-swift.git", :tag => "#{spec.version}" }
  spec.swift_versions = "5.0"
  spec.requires_arc = true

  

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #spec.source_files  = "WYBasisKit/**/*"
  #spec.frameworks = "Foundation", "AVFoundation", "UIKit", "Photos", "CoreFoundation"
  spec.dependency "Kingfisher"
  spec.dependency "IQKeyboardManagerSwift"
  #spec.dependency "SnapKit"
  #sspec.dependency "MJRefresh"
  #spec.dependency "HandyJSON"
  #spec.dependency "Moya"
  #spec.dependency "MBProgressHUD"

  spec.subspec "WYBasisKit" do |ss|

       ss.subspec "Config" do |sss|
          sss.frameworks = "Foundation", "UIKit"
          sss.source_files = "WYBasisKit/Config/**/*"
       end

       ss.subspec "Extension" do |sss|
          sss.frameworks = "Foundation", "UIKit"
          sss.dependency "MJRefresh"
          sss.dependency "libPhoneNumber-iOS"
          sss.dependency "MBProgressHUD"
          sss.source_files  = "WYBasisKit/Extension/**/*"
       end

       ss.subspec "Practical" do |sss|
          sss.frameworks = "Foundation", "UIKit", "LocalAuthentication", "Photos", "CoreFoundation"
          sss.source_files  = "WYBasisKit/Practical/**/*"
       end

       ss.subspec "Layout" do |sss|
          sss.frameworks = "Foundation", "UIKit"
          sss.dependency "SnapKit"
          sss.source_files  = "WYBasisKit/Layout/**/*"
       end

       ss.subspec "Networking" do |sss|
          sss.frameworks = "Foundation", "UIKit"
          sss.dependency "WYBasisKit/Config"
          sss.dependency "Moya"
          sss.dependency "HandyJSON"
          sss.source_files  = "WYBasisKit/Networking/**/*"
       end
  end
end
