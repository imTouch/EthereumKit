Pod::Spec.new do |s|
  s.name         = 'EthereumKit'
  s.version      = '0.1.3'
  s.summary      = 'Ethereum Support.'
  s.homepage     = 'https://github.com/imTouch/EthereumKit'
  s.authors      = 'Liu Pengpeng'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'

  s.source       = { git: 'https://github.com/imTouch/EthereumKit.git', tag: "v#{s.version}" }
  s.source_files = 'EthereumKit/**/*.{h,m,swift}'

  s.dependency 'TrezorCrypto'
  s.dependency 'CryptoSwift'
  s.dependency 'RLP-ObjC', '~> 1.0'
end