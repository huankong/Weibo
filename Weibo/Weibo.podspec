Pod::Spec.new do |s|
  s.name         = 'Weibo'
  s.version      = '<#Project Version#>'
  s.license      = '<#License#>'
  s.homepage     = '<#Homepage URL#>'
  s.authors      = '<#Author Name#>': '<#Author Email#>'
  s.summary      = '<#Summary (Up to 140 characters#>'

  s.platform     =  :ios, '<#iOS Platform#>'
  s.source       =  git: '<#Github Repo URL#>', :tag => s.version
  s.source_files = '<#Resources#>'
  s.frameworks   =  '<#Required Frameworks#>'
  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod 'SnapKit', '~> 0.15.0'
  s.dependencies =	pod 'SVProgressHUD'
  s.dependencies =	pod 'AFNetworking', '~> 3.0'
  s.dependencies =	pod 'SDWebImage', '~>3.8'

end