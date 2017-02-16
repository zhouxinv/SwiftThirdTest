# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

target 'SwiftTest' do
  # 指定xcodeproj 进行pods
  xcodeproj ‘SwiftTest.xcodeproj'
  # platform :ios, ‘8.0’
  # Comment the next line if you're not using Swift and don't want to use dynamic 
  pod 'Alamofire'  # 网络工具类 ，相当于AFN
  pod 'SwiftyJSON' # Json解析，取值方便
  pod 'Charts'  # 图表类，折线图，柱形图
  pod 'SnapKit', '~> 3.0.2' #自动布局
  pod 'Kingfisher' #图片异步加载frameworks
  use_frameworks!

  # Pods for SwiftTest

  target 'SwiftTestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SwiftTestUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
