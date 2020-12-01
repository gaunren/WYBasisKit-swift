Pod::Spec.new do |spec|

  spec.name         = "WYBasisKit"
  spec.version      = "0.0.4"
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
  spec.dependency "Kingfisher"
  spec.dependency "IQKeyboardManagerSwift"

  Pod::Spec.new do |sp|

     sp.name = 'WYBasisKit'

     sp.subspec 'Config' do |ssp|
        ssp.source_files = "WYBasisKit/Config"
        ssp.frameworks = "Foundation", "UIKit"
     end

     sp.subspec 'Extension' do |ssp|
        ssp.source_files = "WYBasisKit/Extension"
        ssp.frameworks = "Foundation", "UIKit"
        ssp.dependency "WYBasisKit/Config"
        ssp.dependency "MJRefresh"
        ssp.dependency "libPhoneNumber-iOS"
        ssp.dependency "MBProgressHUD"
     end

     sp.subspec 'Practical' do |ssp|
        ssp.source_files = "WYBasisKit/Practical"
        ssp.frameworks = "Foundation", "UIKit", "LocalAuthentication", "Photos", "CoreFoundation"
        ssp.dependency "WYBasisKit/Config"
        ssp.dependency "WYBasisKit/Extension"
     end

     sp.subspec 'Layout' do |ssp|
        ssp.source_files = "WYBasisKit/Layout"
        ssp.frameworks = "Foundation", "UIKit"
        ssp.dependency "WYBasisKit/Config"
        ssp.dependency "SnapKit"
     end

     sp.subspec 'Networking' do |ssp|
        ssp.source_files = "WYBasisKit/Networking"
        ssp.frameworks = "Foundation", "UIKit"
        ssp.dependency "WYBasisKit/Config"
        ssp.dependency "WYBasisKit/Extension"
        ssp.dependency "Moya"
        ssp.dependency "HandyJSON"
     end

  end


  #spec.subspec "WYBasisKit" do |ss|

       #ss.subspec "Config" do |sss|
          #sss.source_files = "WYBasisKit/Config/**/*"
          #sss.frameworks = "Foundation", "UIKit"
       #end

       #ss.subspec "Extension" do |sss|
          #sss.source_files  = "WYBasisKit/Extension/**/*"
          #sss.frameworks = "Foundation", "UIKit"
          #sss.dependency "WYBasisKit/Config"
          #sss.dependency "MJRefresh"
          #sss.dependency "libPhoneNumber-iOS"
          #sss.dependency "MBProgressHUD"
       #end

       #ss.subspec "Practical" do |sss|
          #sss.source_files  = "WYBasisKit/Practical/**/*"
          #sss.frameworks = "Foundation", "UIKit", "LocalAuthentication", "Photos", "CoreFoundation"
          #sss.dependency "WYBasisKit/Config"
          #sss.dependency "WYBasisKit/Extension"
       #end

       #ss.subspec "Layout" do |sss|
          #sss.source_files  = "WYBasisKit/Layout/**/*"
          #sss.frameworks = "Foundation", "UIKit"
          #sss.dependency "WYBasisKit/Config"
          #sss.dependency "SnapKit"
       #end

       #ss.subspec "Networking" do |sss|
          #sss.source_files  = "WYBasisKit/Networking/**/*"
          #sss.frameworks = "Foundation", "UIKit"
          #sss.dependency "WYBasisKit/Config"
          #sss.dependency "WYBasisKit/Extension"
          #sss.dependency "Moya"
          #sss.dependency "HandyJSON"
       #end
  #end
end
