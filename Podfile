# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

#pod definitions
def pods
    firebase
    crashlytics
    
    pod 'JSQMessagesViewController'
    pod 'KTCenterFlowLayout'
    pod 'SwiftKeychainWrapper'
    pod 'CryptoSwift'
    pod 'OneSignal'
    pod 'JGProgressHUD'
end
#loads all firebase pods
def firebase
    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/AdMob'
    pod 'Firebase/Messaging'
    pod 'Firebase/Database'
    #pod 'Firebase/Invites'
    pod 'Firebase/DynamicLinks'
    pod 'Firebase/Crash'
    pod 'Firebase/RemoteConfig'
    pod 'Firebase/Auth'
    pod 'Firebase/AppIndexing'
    pod 'Firebase/Storage'
end

def crashlytics
    pod 'Fabric'
    pod 'Crashlytics'
end

target 'PolyChat' do
    pods
end

target 'PolyChatTests' do
    pods
end

target 'PolyChatUITests' do
   pods
end
