Pod::Spec.new do |s|
  s.name                = 'YXTimer'
  s.summary             = 'A timer based on GCD implementation provides pause and recovery functions.'
  s.version             = '1.0.0'
  s.homepage            = 'https://github.com/xinghanjie/YXTimer'
  s.license             = { :type => 'MIT', :file => 'LICENSE' }


  s.author               = { 'Heikki' => 'xinghanjie@gmail.com' }
  s.platform             = :ios, '7.0'
  s.source               = { :git => 'https://github.com/xinghanjie/YXTimer.git', :tag => s.version }
  s.source_files         = 'YXTimer/*.{h,m}'
  s.requires_arc         = true
  s.public_header_files  = 'YXTimer/*.{h}'

end
