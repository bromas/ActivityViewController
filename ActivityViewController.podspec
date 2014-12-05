Pod::Spec.new do |spec|
  spec.name = 'ActivityViewController'
  spec.version = '1.0'
  spec.summary = 'Managing Storyboard and controller containment in Swift.'
  spec.homepage = 'https://github.com/bromas/ActivityViewController'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = {
    'Brian Thomas' => 'bromas@mail.com',
  }
  spec.social_media_url = 'http://twitter.com/atomos86'
  spec.source = { :git => 'https://github.com/bromas/ActivityViewController.git', :tag => "v#{spec.version}" }
  spec.source_files = 'ActivityViewController/*.{h,swift}'
  spec.requires_arc = true
  spec.ios.deployment_target = '8.3'
end
