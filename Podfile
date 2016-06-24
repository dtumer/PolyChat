# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

#loads all firebase pods
def firebase
    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/AdMob'
    pod 'Firebase/Messaging'
    pod 'Firebase/Database'
    pod 'Firebase/Invites'
    pod 'Firebase/DynamicLinks'
    pod 'Firebase/Crash'
    pod 'Firebase/RemoteConfig'
    pod 'Firebase/Auth'
    pod 'Firebase/AppIndexing'
    pod 'Firebase/Storage'
end

target 'PolyChat' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PolyChat
  
  #load all firebase pods
  firebase
  
  pod 'JSQMessagesViewController'

  target 'PolyChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PolyChatUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end