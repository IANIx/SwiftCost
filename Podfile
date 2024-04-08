# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'TestSwiftDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TestSwiftDemo
  pod 'SnapKit'        # 跟Masonry一样是用来设置约束的，swift版
  pod 'ObjectMapper'   # 字典转模型
  pod 'SwiftyJSON', '~> 4.0'
  pod 'GRDB.swift', '~> 5.7.4'
  pod 'LookinServer', :configurations => ['Debug']
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
     puts "#{target.name}"
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
          
          config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
          config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
          config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      end
  end
end
