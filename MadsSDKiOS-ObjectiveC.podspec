#
# Be sure to run `pod lib lint MadsSDKiOS-ObjectiveC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "MadsSDKiOS-ObjectiveC"
s.version          = "4.5.6.1"
s.summary          = "Mads SDK iOS."

s.description      = <<-DESC
Mads SDK iOS. Objective C version of MADS Mobile SDK for mobile advertising
DESC

s.homepage         = "https://github.com/MADSNL/MadsSDKiOS-ObjectiveC"
s.license          = 'MADS'
s.author           = { "MADS" => "yevhen.herasymenko@mads.com" }
s.source           = { :git => "https://github.com/MADSNL/MadsSDKiOS-ObjectiveC.git", :tag => s.version.to_s }

s.platform     = :ios, '8.0'
s.requires_arc = true

s.vendored_frameworks = 'MadsSDK.framework'

end
