
Pod::Spec.new do |s|

  s.name         = 'ScaleTransition'
  s.version      = '1.0.0'
  s.summary      = 'Custom modal transition animation.''
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/dev-aleksey/ScaleTransition'

  s.author       = { 'Alex' => 'dev.aleksey@yandex.ru' }
  s.platform     = :ios
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/dev-aleksey/ScaleTransition.git', :tag => s.version.to_s }

  s.source_files  = 'scaletransitiondemo/ScaleTransition/*.swift'
  s.requires_arc = true

  s.dependency 'pop'

end
