#
# Be sure to run `pod lib lint MKNanoBeacon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKNanoBeacon'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MKNanoBeacon.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BeaconX-Pro/06-iOS-NanoBeacon-SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lovexiaoxia' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/BeaconX-Pro/06-iOS-NanoBeacon-SDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKNanoBeacon' => ['MKNanoBeacon/Assets/*.png']
  }
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKNanoBeacon/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKNanoBeacon/Classes/Target/**'
    
    ss.dependency 'MKNanoBeacon/Functions'
  end

  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNanoBeacon/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKNanoBeacon/Classes/Functions/ScanPage/Controller/**'
        
        ssss.dependency 'MKNanoBeacon/Functions/ScanPage/Model'
        ssss.dependency 'MKNanoBeacon/Functions/ScanPage/Adopter'
        ssss.dependency 'MKNanoBeacon/Functions/ScanPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKNanoBeacon/Classes/Functions/ScanPage/Model/**'
      end
      sss.subspec 'Adopter' do |ssss|
        ssss.source_files = 'MKNanoBeacon/Classes/Functions/ScanPage/Adopter/**'
        
        ssss.dependency 'MKNanoBeacon/Functions/ScanPage/Model'
        ssss.dependency 'MKNanoBeacon/Functions/ScanPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKNanoBeacon/Classes/Functions/ScanPage/View/**'
        
        ssss.dependency 'MKNanoBeacon/Functions/ScanPage/Model'
      end
    end
    
    ss.dependency 'MKNanoBeacon/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'MKBeaconXCustomUI'
    
  end
  
  
  
  
end
