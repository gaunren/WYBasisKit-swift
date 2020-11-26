Pod::Spec.new do |spec|

  spec.name         = "WYBasisKit"
  spec.version      = "0.0.1"
  spec.summary      = "WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的方法，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。"
  spec.description  = <<-DESC 
                          WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的方法，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。
                   DESC

  spec.homepage     = "https://github.com/Jacke-xu/WYBasisKit-swift"
  spec.license      = { :type => "MIT", :file => "License.md" }
  spec.author             = { "Jacke-xu" => "mobileAppDvlp@icloud.com" }
  spec.ios.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/Jacke-xu/WYBasisKit-swift.git", :tag => "#{spec.version}" }
  spec.swift_versions = "5.0"

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "WYBasisKit/**/*"

  spec.dependency "Kingfisher"
  spec.dependency "IQKeyboardManagerSwift"
  spec.dependency "SnapKit"
  spec.dependency "libPhoneNumber-iOS"
  spec.dependency "MJRefresh"
  spec.dependency "HandyJSON"
  spec.dependency "Moya"
  spec.dependency "MBProgressHUD"


 #spec.subspec "UITableView" do |ss|
    #ss.source_files = "WYBasisKit/Extension/UITableView/*.swift"
    #ss.dependency "MJRefresh"
  #end

  #spec.subspec "String" do |ss|
    #ss.source_files = "WYBasisKit/Extension/String/*.swift"
    #ss.dependency "libPhoneNumber-iOS"
  #end

  #spec.subspec "UIViewController" do |ss|
    #ss.source_files = "WYBasisKit/Extension/UIViewController/*.swift"
    #ss.dependency "MBProgressHUD"
  #end

  #spec.subspec "ScrollText" do |ss|
    #ss.source_files = "WYBasisKit/Layout/ScrollText/*.swift"
    #ss.dependency "SnapKit"
  #end

  #spec.subspec "Networking" do |ss|
    #ss.source_files = "WYBasisKit/Networking/*.swift"
    #ss.dependency "Moya"
    #ss.dependency "Alamofire"
   # ss.dependency "HandyJSON"
  #end

end