# @!domain [Pod::Podfile]

# @!parse
#  require 'cocoapods'
require 'set'
require_relative './ruby_script/module_stability_list.rb'
gem 'cocoapods', '1.8.4'

# define common version number for different target
class CommonVersions
  def initialize()
  end

  def self.Rx; "5.1.1"; end
  def self.LarkColor; "0.11.0"; end
  def self.SnapKit; "5.0.1"; end
  def self.LarkNotificationServiceExtensionLib; "3.26.1"; end
  def self.LarkDebug; "3.26.1"; end
  def self.IESGeckoKit; "0.5.3-rc.3.1.binary"; end
  def self.NSObject_Rx; "5.0.0"; end
end

# Class for parse packge environment
# ENV see hooks/appcenter_build.sh
class PackgeEnv
  # modify by hooks/appcenter_build.sh, release should be false
  def self.testable; ENV['RUNTIME_TYPE'] != 'release'; end
  def self.should_strip_lang; ENV['SHOULD_STRIP_LANG'] == "true"; end
  def self.is_oversea; ['international', 'inhouse-oversea'].include? ENV['LARK_BUILD_TYPE']; end

  # ENV: DEPLOY_MODE 是 Nest KA 构建任务新加的参数，标记 KA 类型
  # - hosted (专有)
  # - on-premise (私有)
  # - saas (saas定制的,不会下载init_configs, inti_settings)
  #
  # ENV: FORCE_SAAS_LOGIN 表示是否强制使用 SaaS 登录
  # 参考文档：https://bytedance.feishu.cn/docs/doccnfEIyR0i1tolI2LwYWAxEo0
  def self.is_ka_login_module
    ENV['BUILD_PRODUCT_TYPE'] == 'KA' && ENV['DEPLOY_MODE'] != 'saas' && ENV['FORCE_SAAS_LOGIN'].to_s != 'true'
  end

  def self.is_callkit_enable
    ['international', 'inhouse', 'inhouse-oversea'].include? ENV['LARK_BUILD_TYPE']
  end

  def PackgeEnv.oversea(international, internal = {})
    PackgeEnv.feature(PackgeEnv.is_oversea, international, internal)
  end

  def PackgeEnv.feature(conditions, true_value, false_value = {})
    if conditions; true_value; else; false_value; end
  end
end

# 清理错误的缓存，先保留一段时间
def clean_wrong_cache
  wrong_cdn_dir = Pathname('~/.cocoapods/repos/cocoapods-').expand_path
  wrong_cdn_dir.rmtree if wrong_cdn_dir.exist?
end

def migrate_pod_mirror
  mirror_dir = Pathname('~/.cocoapods/repos/byted-pod_master_fork').expand_path
  return if mirror_dir.exist?

  master_dir = mirror_dir.parent.join('master')
  return unless master_dir.exist?

  system <<~SH
    cd ~/.cocoapods/repos

    echo 'migrate pod master mirror. need about 1 minute'
    mkdir /tmp/byted-pod_master_fork
    # move .git first, then checkout, this way is double faster than cp entire dir. though still need 1 minute
    cp -af master/.git /tmp/byted-pod_master_fork && mv /tmp/byted-pod_master_fork .
    cd byted-pod_master_fork
    git remote set-url origin git@code.byted.org:lark/pod_master_fork.git
    git reset --hard @
    echo 'migrate pod master mirror end. '
  SH
end

clean_wrong_cache
migrate_pod_mirror

# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

plugin 'cocoapods-amicable'
plugin 'EEScaffold'

install! 'cocoapods',
    :incremental_installation => true,
    :generate_multiple_pod_projects => true,
    :warn_for_multiple_pod_sources => false

# make ours main source first
source 'git@code.byted.org:ee/pods_specs.git'

# old bd extension sources
source 'git@code.byted.org:iOS_Library/privatethird_binary_repo.git'
source 'git@code.byted.org:iOS_Library/privatethird_source_repo.git'
source 'git@code.byted.org:iOS_Library/toutiao_source_repo.git'
source 'git@code.byted.org:TTVideo/ttvideo-pods.git'
source 'git@code.byted.org:iOS_Library/publicthird_binary_repo.git'
source 'git@code.byted.org:iOS_Library/publicthird_source_repo.git'
source 'git@code.byted.org:iOS_Library/lark_source_repo.git'

# ours custom sources
source 'git@code.byted.org:lark/pod_master_fork.git'
# source 'https://cdn.cocoapods.org/'

disable_framework_header_search_paths! except: [
  'JSONModel', # need by Timor
  'Timor', # need by EEMicroAppSDK
  'CJComponents',
  'CJPay',
  'SAMKeychain',
  'Lynx'
]
use_short_link!
disable_swiftlint! if respond_to?(:disable_swiftlint!)

patch do
  use_binary_repo 'git@code.byted.org:ee/pods_specs.git'

  %w[
    LarkUIKit
    CryptoSwift
    CalendarFoundation
    AnimatedTabBar
    DocsSDK
    HTTProtocol
    LarkAlertController
  ].each { |v| source v, :unstable }

  [
    'DoubleConversion', # header引入问题，代码使用的double-conversion引入
    'Kingfisher',       # Runtime URLResourceValues调用崩溃
    'LarkFoundation',   # Runtime URLResourceValues调用崩溃
    'Sodium',           # 源码和.a module混编，可能出现.a的module找不到或者重复定义的问题
    'SuiteCodable',     # 动态库，切换binary容易造成project文件的变动
    'JTAppleCalendar',  # 会引起autoresizingMask = [.flexibleWidth, .flexibleHeight] Crash
  ].each { |v| source v }

  unless ENV['CACHE_BINARY'] == '1'
    # 默认使用Debug编译，支持assert, patch只显式指定为binary
    [
      'LarkRustClient',
    ].each { |v| source v }
  end
end

def larkMessengerPods
  messenger_pod_version = '3.27.9'
  pod 'LarkMessenger', messenger_pod_version
  pod 'LarkAttachmentUploader', messenger_pod_version
  pod 'LarkFeed', messenger_pod_version
  pod 'LarkMine', messenger_pod_version
  pod 'LarkUrgent', messenger_pod_version
  pod 'LarkFinance', messenger_pod_version
  pod 'LarkChat', messenger_pod_version
  pod 'LarkChatSetting', messenger_pod_version
  pod 'LarkFile', messenger_pod_version
  pod 'LarkThread', messenger_pod_version
  pod 'LarkContact', messenger_pod_version
  pod 'LarkSearch', messenger_pod_version # messenger_pod_version
  pod 'LarkMessageCore', messenger_pod_version, :testspecs => ['Tests']
  pod 'LarkSearchFilter', messenger_pod_version
  pod 'LarkForward', messenger_pod_version
  pod 'LarkAudio', messenger_pod_version
  pod 'LarkCore', messenger_pod_version
  pod 'LarkQRCode', messenger_pod_version
  pod 'LarkWeb', messenger_pod_version
  pod 'LarkMessengerInterface', messenger_pod_version
  pod 'LarkSDK', messenger_pod_version
  pod 'LarkSDKInterface', messenger_pod_version
end

def businessPods
  larkMessengerPods
  pod 'LarkAvatar', '0.8.1'
  pod 'EEImageService', '0.8.1'
  pod 'MailSDK', '3.27.7'
  pod 'LarkMailInterface', '0.1.0-alpha.3'
  pod 'DocsSDK', '3.27.5'
  pod 'SpaceInterface', '0.2.31'
  pod 'LarkHelpdesk', '1.0.1'
  pod 'LKPush', '0.1.3'
  pod 'ByteView', '3.27.2',
    :subspecs => ['Debug', 'Core'],
    **PackgeEnv.feature(PackgeEnv.is_callkit_enable, {feature: "CallKit"})
  pod 'AudioSessionScenario', '0.6.2'
  pod 'Calendar', '3.27.5'#:path => '../ios-calendar/Bizs/Calendar'
  pod 'CalendarInChat', '3.27.5'#:path => '../ios-calendar/Bizs/CalendarInChat'
  pod 'CalendarFoundation', '3.27.5'#:path => '../ios-calendar/Bizs/CalendarFoundation'
  pod 'JTAppleCalendar', '7.1.7'
  pod 'EEMicroAppSDK', '3.27.1'
  pod 'Timor', '3.27.6', :subspecs => ['Core', 'App', 'Networking', 'Debug', 'Card']
  pod 'LarkOPInterface', '3.26.1'
  pod 'LarkOPWeb', '3.26.1'
  pod 'Lynx',
    :git => 'git@code.byted.org:lynx/template-assembler.git',
    :branch => 'card_engine',
    :subspecs => [
      'Framework',
      'Native',
      'JSRuntime',
      'ReleaseResource',
    ]
  pod 'HTTProtocol', '0.1.6'
  pod 'LarkRustHTTP', '0.12.1'
  pod 'LarkAppCenter', :path => './Bizs/LarkAppCenter', :inhibit_warnings => false
  pod 'LarkTabMicroApp', :path => './Bizs/LarkTabMicroApp', :inhibit_warnings => false
  pod 'LarkVoIP', :path => './Bizs/LarkVoIP', :inhibit_warnings => false
  pod 'LarkCalendar', :path => './Bizs/LarkCalendar', :inhibit_warnings => false
  pod 'LarkMail', :path => './Bizs/LarkMail', :inhibit_warnings => false
  pod 'LarkMicroApp', :path => './Bizs/LarkMicroApp', :inhibit_warnings => false

  pod 'LarkAccount', '3.27.4', :inhibit_warnings => false, **PackgeEnv.oversea({feature: 'AppsFlyerFramework'})
  pod 'LarkAccountInterface', '3.27.3', :inhibit_warnings => false
  pod 'LarkAppConfig', '3.27.6', :inhibit_warnings => false
  pod 'LarkAppLinkSDK', '3.27.2', :inhibit_warnings => false
  pod 'LarkBaseService', '3.27.10', :inhibit_warnings => false, **PackgeEnv.oversea({feature: 'AppsFlyerFramework'})
  pod 'LarkExtensionMessage', '3.19.2'
  pod 'LarkMessageBase', '3.27.1', :inhibit_warnings => false
  pod 'LarkNavigation', '3.27.2'
  pod 'LarkNavigator', '3.21.0', :inhibit_warnings => false
  pod 'LarkNotificationServiceExtensionLib',
    CommonVersions.LarkNotificationServiceExtensionLib,
    :inhibit_warnings => false
  pod 'LarkPerf', '3.27.2', :inhibit_warnings => false
  pod 'NewLarkDynamic', '3.26.2', :inhibit_warnings => false
  pod 'LarkSpaceKit', :path => './Bizs/LarkSpaceKit', :inhibit_warnings => false
  pod 'LarkByteView', :path => './Bizs/LarkByteView', :inhibit_warnings => false
  pod 'SuiteLogin', '3.27.5', **PackgeEnv.feature(PackgeEnv.is_ka_login_module, {feature: "KA"})
  pod 'LarkAppResources', '3.22.1'
  pod 'JsSDK', :path => './Bizs/JsSDK', :feature => 'Lark', :inhibit_warnings => false
  pod 'LarkWebCache', '3.26.0'
  pod 'LarkButton', '0.1.7'
  pod 'LarkLocalizations', '1.2.3'
  pod 'RichLabel', '0.9.1'
  pod 'LarkReleaseConfig', '0.10.1'
  # pod 'MultiTask', '1.2.3'
  pod 'QRCode', '100.0.2'
  pod 'LarkBadge', '0.7.0'
  pod 'LarkAppStateSDK', :path => './Bizs/LarkAppStateSDK', :inhibit_warnings => false
  pod 'LarkLaunchGuide', '3.26.0'
  pod 'LKLaunchGuide', '3.25.2'
  pod 'LarkPrivacyAlert', '3.27.0'
  pod 'LarkTourInterface', '3.26.9', :inhibit_warnings => false
  pod 'LarkTour', '3.26.9', :inhibit_warnings => false
  pod 'LarkOpenPlatform', :path => './Bizs/LarkOpenPlatform', :inhibit_warnings => false
  pod 'LarkCustomerService', '0.9.1'
  pod 'LarkLocationPicker', '0.10.3', **PackgeEnv.oversea({feature: 'OverSeaDependency'}, {feature: 'InternalDependency'})

  pod 'LarkReactionView', '0.6.0'
  pod 'LarkReactionDetailController', '0.6.0'
  pod 'LarkMenuController', '0.8.1'
  pod 'LarkSafety', '0.1.4'
  pod 'LarkCreateTeam', :path => './Bizs/LarkCreateTeam', :inhibit_warnings => false
  pod 'LarkDatePickerView', '0.7.0'
  pod 'OfflineResourceManager', '0.9.1'
  pod 'EEImageMagick', '0.1.0'
  pod 'SecSDK', '1.1.0'
  pod 'LarkDynamic', :path => './Bizs/LarkDynamic', :inhibit_warnings => false
  pod 'LarkSettingsBundle', '3.26.1'
  pod 'Yellowstone', '0.5.4'
  pod 'LarkBanner', '0.2.1'
end

def larkPods
  pod 'oc-opus-codec', '0.2.4'
  pod 'LKCommonsLogging', '0.4.10'
  pod 'LKCommonsTracker', '0.4.4'
  pod 'AnimatedTabBar', '0.10.1'
  pod 'Sodium', '0.8.0'
  pod 'RxAutomaton', '0.4.0'
  pod 'Homeric', '0.2.421'
  pod 'LKMetric', '0.4.2'
  pod 'LKTracing', '0.5.1'
end

def commonPods
  pod 'LarkSwipeCellKit', '0.6.1'
  pod 'Kingfisher', '5.3.1-lark.5'
  pod 'KingfisherWebP', '0.6.0-lark.0'
  pod 'Swinject', '10.1.1'
  pod 'LarkContainer', '1.4.1'
  pod 'LarkInterface', :path => './Libs/LarkInterface', :inhibit_warnings => false
  pod 'LarkGuide', '3.0.6'
  pod 'LarkFoundation', '1.6.5'
  pod 'LarkUIKit', '1.21.6'
  pod 'LarkRustClient', '1.16.2'
  pod 'Logger', '1.4.6'
  pod 'LarkFeatureGating', '3.27.4', :inhibit_warnings => false
  pod 'LarkFeatureSwitch', '3.27.1', :inhibit_warnings => false
  pod 'LarkModel', '3.27.2', :inhibit_warnings => false
  pod 'LarkExtensionCommon', :path => './Libs/LarkExtensionCommon'
  pod 'EENavigator', '0.10.24'
  pod 'RustPB', '3.27.11'
  pod 'SuiteAppConfig', "0.6.1", :inhibit_warnings => false
  pod 'SuiteCodable', '0.1.2'
  pod 'PushKitService', '0.2.12'
  pod 'LarkTag', '0.8.2'
  pod 'AppContainer', '0.10.2'
  pod 'LarkColor', CommonVersions.LarkColor
  pod 'LarkCamera', '0.9.1'
  pod 'LarkAlert', '1.8.1'
  pod 'LarkEmotion', '0.9.2'
  pod 'EENotification', '0.2.2'
  pod 'NotificationUserInfo', '0.9.1'
  pod 'LarkCompatible', '0.1.1'
  pod 'LarkExtensions', '0.9.3'
  pod 'RoundedHUD', '1.5.1'
  pod 'LarkActionSheet', '0.11.1'
  pod 'LarkWebView', '0.9.1'
  pod 'EEFlexiable', '0.1.9' #:path => '../ios-infra/Libs/EEFlexiable/EEFlexiable'
  pod 'AsyncComponent', '0.1.5' #:path => '../../EE/EEFoundation/Libs/AsyncComponent'
  pod 'LarkPageController', '0.1.8' #:path => '../ios-infra/Libs/UI/LarkPageController'
  pod 'EditTextView', '0.9.1'
  pod 'LarkAudioKit', '0.8.0'
  pod 'LarkAudioView', '0.8.2'
  pod 'EETroubleKiller', '1.2.5'
  pod 'EEKeyValue', '0.1.1'
  pod 'RxDataSources', '4.0.1'
  pod 'Action', '4.0.0'
  pod 'NSObject+Rx', CommonVersions.NSObject_Rx
  pod 'LarkAlertController', '0.7.2'
  if PackgeEnv.is_oversea # 国外版
    pod 'AppsFlyerFramework', '5.0.0'
  end
  pod 'EEPodInfoDebugger', '0.0.3'
  pod 'RunloopTools', '0.1.0'
  pod 'LarkKeyboardKit', '0.8.1', :source => 'git@code.byted.org:ee/pods_specs.git'
  pod 'LarkKeyCommandKit', '0.0.2'
  pod 'LarkInteraction', '0.2.4'
  pod 'LarkOrientation', '0.0.1'
  pod 'LarkBGTaskScheduler', '1.2.1'
  pod 'LarkPushTokenUploader', '0.8.1'
  pod 'LarkMonitor', '1.4.3'
  pod 'ThreadSafeDataStructure', '0.5.1'
  pod 'LarkTracker', '3.27.1', :inhibit_warnings => false
  pod 'EEAtomic', '0.1.4'
  pod 'LarkLeanMode', '0.6.1'
  pod 'LarkSnsShare',
     '1.2.2',
     **PackgeEnv.oversea({feature: 'InternationalSnsShareDependency'}, {feature: 'InternalSnsShareDependency'})
  pod 'LarkFileSystem', '1.1.1'
  pod 'LarkShareToken', '0.2.5'
  pod 'LarkConfirmContainer', '0.8.1'
  pod 'LarkActivityIndicatorView', '1.0.3'
  pod 'LarkResource', '0.0.5'
  pod 'LarkUIExtension', '0.0.2'
  pod 'LarkAddressBookSelector', '0.2.2'
end

def thirdPartyPods
  pod_heimdallr
  pod 'Alamofire', '4.7.3', :source => 'git@code.byted.org:lark/pod_master_fork.git'
  pod 'DateToolsSwift', '4.0.0'
  pod 'FMDB', '2.6.2'
  pod 'KeychainAccess', '3.1.2'
  pod 'RxSwift', CommonVersions.Rx
  pod 'RxCocoa', CommonVersions.Rx
  pod 'SnapKit', CommonVersions.SnapKit
  pod 'SSZipArchive', '2.2.2'
  pod 'ReachabilitySwift', '4.3.0'
  pod 'Yoga', '1.9.0'
  pod 'UIImageViewAlignedSwift', '0.6.0'
  pod 'ByteRtcSDK', '3.27.5'
  pod 'SkeletonView', '1.4.1'
  pod 'CryptoSwift', '1.1.3'
  pod 'MarkdownView', '1.6.0-lark-0.1'
  pod 'SwiftyJSON', '4.1.0'
  pod 'HandyJSON', '5.0.0'
  pod 'MBProgressHUD', '1.1.0'
  pod 'ESPullToRefresh', '2.9.2'
  pod 'libPhoneNumber-iOS', '0.9.15'
  pod 'LarkSegmentedView', '5.0.0'
  pod 'React-Core/Default', :git => 'git@code.byted.org:ee/ReactNative.git', :commit => '27ea2b5f3'
  pod 'React-Core/RCTWebSocket', :git => 'git@code.byted.org:ee/ReactNative.git', :commit => '27ea2b5f3'
  pod 'React-Core/DevSupport', :git => 'git@code.byted.org:ee/ReactNative.git', :commit => '27ea2b5f3'

  # Pods for googledrive
  pod 'AppAuth', '1.4.0'
  pod 'GTMAppAuth', '1.0.0'
  pod 'GoogleAPIClientForREST/Drive', '1.3.11'
  pod 'GTMSessionFetcher', '1.4.0'

end

def debugPods
  pod 'LarkDebug', CommonVersions.LarkDebug, :subspecs => ['core']
  pod 'LarkDebugExtensionPoint', '3.17.0-alpha.20', :inhibit_warnings => false
  pod 'MLeaksFinder', '21.0.6', :configurations => ['Debug']
  pod 'FBRetainCycleDetector',
    :git => 'https://github.com/facebook/FBRetainCycleDetector.git',
    :commit => '19fd284',
    :configurations => ['Debug']
  pod 'Reveal-SDK', '26', :configurations => ['Debug']

  if PackgeEnv.testable
    pod 'LarkDebug', CommonVersions.LarkDebug, :subspecs => ['Flex']
    pod 'FLEX', '3.1.2'
    pod 'IESGeckoKit', CommonVersions.IESGeckoKit, :subspecs => ['Debug']
  else
    pod 'IESGeckoKit', CommonVersions.IESGeckoKit, :subspecs => ['Core']
  end
end

def pod_smash
  # AI lib 提供的图像处理的库：扫码、人脸识别
  pod 'smash',
    '2.6.1-alpha.1.1.binary',
    :subspecs => [
      'private_utils',
      'qrcode',
      'action_liveness',
      'utils',
      'package'
    ]
  pod 'mobilecv2', '1.4.1.1-binary'
#smash内部依赖espresso
  pod 'espresso', '2.0.9.1-binary'
end

def pod_video_editor
  # 视频转码、压缩相关
  # Video transcode
  pod 'TTVideoEditor',
    '6.5.0.60-larkModeupdate.1.binary',
    :subspecs => ['LarkMode'],
    :source => 'git@code.byted.org:iOS_Library/privatethird_binary_repo.git'
end

def pod_heimdallr
  pod 'Heimdallr', '0.7.19-rc.4',
    :source => 'git@code.byted.org:iOS_Library/privatethird_source_repo.git',
    :subspecs => [
      'Monitors',
      'TTMonitor',
      'HMDStart',
      'HMDANR',
      'UITracker',
      'HMDWatchDog',
      'CrashDetector',
      'UserException',
      'HMDOOMCrash',
      'HMDOOM',
      'MemoryGraph',
      'UIFrozen',
      'WatchdogProtect',
      PackgeEnv.oversea('HMDOverseas', 'HMDDomestic')
    ]
    pod 'MemoryGraphCapture', '1.2.4'
end

def pod_cjpay
  pod 'CJPay', '5.3.3-rc.1',
  :subspecs => [
    'PayBiz',
    'VerifyModules/SMS',
    'VerifyModules/Biopayment',
    'PayManage',
    'Withdraw'
  ],
  :source => 'git@code.byted.org:iOS_Library/privatethird_source_repo.git'
end

def broadcastPods
  pod 'ByteViewLS', '0.6.0'
  pod 'LLBSDMessaging', '0.4.0'
  pod 'ByteViewBoardcastExtension', '0.16.0'
end

def toutiaoPods
  pod_video_editor
  pod_smash
  pod_cjpay

  pod 'BDDataDecorator', '2.0.1', :subspecs => ['Data']
  pod 'BDDataDecoratorTob', '1.0.0', :subspecs => ['Data'], :source => 'git@code.byted.org:iOS_Library/privatethird_source_repo.git'
  pod 'TTVideoEngine', '1.9.28.3'
  pod 'TTPlayerSDK', '2.8.28.1'
  pod 'TTReachability', '0.10.0'
  pod 'MDLMediaDataLoader', '1.0.5.1'
  pod 'boringssl', '0.0.3'
  pod "byted_cert",  "0.2.8-lark", :subspecs => ['native']
  pod 'TTNetworkManager', '2.2.8.53.1', :source => 'git@code.byted.org:ee/pods_specs.git' #branch: lark_without_cronet
  pod 'TTHelium', '1.0.0-eelark', :source => 'git@code.byted.org:iOS_Library/privatethird_source_repo.git'

  pod 'CJComponents', '0.2.5', :source => 'git@code.byted.org:iOS_Library/privatethird_source_repo.git'
  pod 'SAMKeychain', '1.5.2', :source => 'git@code.byted.org:iOS_Library/publicthird_source_repo.git'

  pod 'tfccsdk', '2.0.4',
    :subspecs => ['tfcc'],
    :source => 'git@code.byted.org:iOS_Library/privatethird_source_repo.git'
  pod 'RangersAppLog', '5.1.4.1-bugfix', :subspecs => ['Core']
  pod 'BDWebImage', '0.2.4',
    :source => 'git@code.byted.org:ee/pods_specs.git',
    :subspecs => ['Core', 'Download','Decoder']
  pod 'libwebp', '0.6.1.1-binary'
  pod 'YYCache', '1.0.4'
  pod 'BDUGLogger', '1.1.5'
  unless PackgeEnv.is_oversea # 国外版
    pod 'BDUGShare', '2.1.2-rc.3', :subspecs => [
      'BDUGShareBasic/BDUGUtil',
      'BDUGShareBasic/BDUGWeChatShare',
      'BDUGShareBasic/BDUGWeiboShare',
      'BDUGShareBasic/BDUGQQShare'
    ]
    pod 'WechatSDK', '0.2.2', :source => 'git@code.byted.org:iOS_Library/privatethird_source_repo.git'
    pod 'WeiboSDK', '3.2.5-rc.1'
    pod 'TencentQQSDK', '1.1.0-rc.0.1.binary'
  end
  pod 'BDABTestSDK', '1.0.2'
  pod 'AFgzipRequestSerializer', '0.0.3'
  pod 'BDJSBridgeAuthManager', '0.1.2.1-binary-debug'
  pod 'IESJSBridgeCore', '1.1.2'
  pod 'TTBridgeUnify', '4.0.1-rc.0', :subspecs => [
    'TTBridge',
    'UnifiedWebView',
    'TTBridgeAuthManager'
  ]
  pod 'Gaia', '3.1.0'
  pod 'BDAssert', '2.0.0'
  pod 'BDMonitorProtocol', '1.1.1'
  pod 'BDWebCore', '2.0.0'
end

target 'Lark' do
  pod 'LarkCrashSanitizer', '3.27.3'
  # Pods for Lark
  businessPods
  larkPods
  commonPods
  thirdPartyPods
  debugPods
  toutiaoPods

  target 'LarkTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'ShareExtension' do
  pod 'LarkShareExtension', :path => './Libs/LarkShareExtension', :inhibit_warnings => false
  pod 'SnapKit', CommonVersions.SnapKit
  pod 'LarkExtensionCommon', :path => './Libs/LarkExtensionCommon'
  pod 'RxSwift', CommonVersions.Rx
  pod 'LarkColor', CommonVersions.LarkColor
end

target 'BroadcastUploadExtension' do
  broadcastPods
  pod 'NSObject+Rx', CommonVersions.NSObject_Rx
  pod 'RxSwift', CommonVersions.Rx
  pod 'RxCocoa', CommonVersions.Rx
end

target 'NotificationServiceExtension' do
  pod 'LarkNotificationServiceExtension',
    :path => './Libs/LarkNotificationServiceExtension',
    :inhibit_warnings => false
  pod 'ExtensionMessenger', '0.8.0'
  pod 'LarkNotificationServiceExtensionLib',
    CommonVersions.LarkNotificationServiceExtensionLib,
    :inhibit_warnings => false
end

def strip_unneeded_languages
  keep_languages = Set['en-US', 'zh-CN', 'ja-JP']
  Dir.chdir __dir__ do
    file_to_delete = Dir.glob('**/auto_resources/*.strings{,dict}').reject do |path|
      name = File.basename(path, '.*')
      keep_languages.include? name
    end
    return if file_to_delete.empty?
    Pod::UI.titled_section "strip unneeded languages:" do
      file_to_delete.each { |p| Pod::UI.message "- #{p}" }
      FileUtils.rm file_to_delete
    end
  end
end

# @param installer [Pod::Installer]
pre_install do |installer|
  testable = PackgeEnv.testable
  # NOTE: 改Sandbox在重新Install时不会重新下载. xcconfig的flag只保证重新生成工程
  if ENV['PSEUDO'] == '1'
    load(File.expand_path('bin/pseudo_i18n.rb', __dir__))
  elsif PackgeEnv.should_strip_lang
    strip_unneeded_languages
    stripped_unneeded_languages = true
  end

  force_use_static_framwork installer, except: []

  # modify build_settings in pre_install, so cache check will be valid

  # switch SWIFT_WHOLE_MODULE_OPTIMIZATION
  use_whold_module = ENV['SWIFT_WHOLE_MODULE_OPTIMIZATION'] == 'YES'

  # fix: add search path for these cross module include headers
  should_fix_include_headers = {
    'TTVideoEditor' => ['KVOController', 'Heimdallr'],
    'TTVideoEngine' => ['TTPlayerSDK', 'TTVideoSetting'],
    'ConfigCenter' => ['FMDB'],
    'AFgzipRequestSerializer' => ['AFNetworking', 'Godzippa'],
    'Heimdallr' => ['BDAlogProtocol', 'TTMacroManager'],
    'Timor' => true,
    'CJPay' => true,
    'CJComponents' => true,
    'SAMKeychain' => true,
    'LarkFinance' => true,
    'EEMicroAppSDK' => true, # 直接头文件和模块混用，需要改代码, 光改搜索路径还不行
    'JsSDK' => true, # 依赖了EEMicroAppSDK
    'LarkMicroApp' => true,
    # indirect dependency
    'TTNetworkManager' => ['AFNetworking', 'Godzippa'],
    'LarkWeb' => true,
    'LarkOpenPlatform' => true,
    'TTBaseLib' => ['OpenUDID'],
    'QRCode' => ['smash'],
    'byted_cert' => true,
    'Lynx' => true,
    'LarkSnsShare' => ['BDUGShare']
  }

  fix_modular_include = Set[
    'TTNetworkManager',
    'EEMicroAppSDK',
    'JsSDK',
    'LarkMicroApp',
    'LarkWeb',
    'Lynx',
    'LarkOpenPlatform',
    'WeiboSDK',
    'WechatSDK',
    'TencentQQSDK',
    'BDUGShare',
    'LarkContact',
    'BDABTestSDK',
    'LarkFinance',
    'CJPay',
    'CJComponents',
    'SAMKeychain',
    'TTVideoEditor',
    'QRCode',
    'byted_cert',
    'LarkSnsShare'
  ]

  tobsdk_flags = Set[
    'TTTracker',
    'LarkTracker'
  ]
  mail_target = Set[
    'MailSDK'
  ]

  # @type [Hash{String => Pod::PodTarget}]
  pod_targets_by_name = installer.pod_targets.group_by(&:pod_name)
  header_search_paths_of_pods = lambda do |pod_target|
    return unless config = should_fix_include_headers[pod_target.name]
    # use true to represent all dependency
    included_targets = case config
                       when true then pod_target.recursive_dependent_targets
                       when Hash then
                         pod_targets_by_name.values_at(*config[:recursive]).compact.flatten(1)
                           .flat_map {|pt| [pt] + pt.recursive_dependent_targets}
                           .uniq
                       when Array then
                         pod_targets_by_name.values_at(*config).compact.flatten(1)
                       else
                         raise "unsupported"
                       end
    return nil if included_targets.empty?

    headers = []
    # @param pt [Pod::PodTarget]
    included_targets.each do |pt|
      if pt.requires_frameworks? && pt.should_build?
        headers.push pt.build_settings.framework_header_search_path
      else
        # the above code use direct include header, not <module/header.h>
        headers.push "${PODS_ROOT}/Headers/Public"
        headers.push "${PODS_ROOT}/Headers/Public/#{pt.pod_name}"
        # append vendored frameworks header
        headers.concat(pt.build_settings.file_accessors.flat_map(&:vendored_frameworks).map { |f|
          File.join '${PODS_ROOT}', f.relative_path_from(pt.sandbox.root), "Headers"
        })
      end
    end
    headers.uniq
  end

  # lint: if generate multiple scoped pod_target, downstream pod don't know choose which
  duplicate_pod_targets = pod_targets_by_name.values.select { |a| a.length > 1 }
  duplicate_pod_targets.each do |a|
    Pod::UI.warn "Duplicate Pod target with different subspecs, defined in:"
    a.each do |pod_target|
      Pod::UI.warn "  - #{pod_target.name}(#{pod_target.specs.map(&:name).join(", ")}) contained in: #{pod_target.target_definitions.map(&:name).join(', ')}"
    end
  end
  raise "Currently Not Support Duplicate Pod Targets" unless duplicate_pod_targets.empty?

  installer.pod_targets.each do |pod_target|
    attributes_hash = pod_target.root_spec.attributes_hash
    pod_target_xcconfig = (attributes_hash['pod_target_xcconfig'] ||= {})

    pod_target_xcconfig['SWIFT_VERSION'] = '5.1'
    pod_target_xcconfig['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    pod_target_xcconfig['WARNING_CFLAGS'] ||= ''
    pod_target_xcconfig['WARNING_CFLAGS'] += ' -Wno-nullability-completeness -Wno-nonnull'
    pod_target_xcconfig['OTHER_SWIFT_FLAGS'] ||= ''
    pod_target_xcconfig['OTHER_SWIFT_FLAGS'] += ' -Xcc -Wno-nullability-completeness'
    pod_target_xcconfig['ASSETCATALOG_COMPILER_OPTIMIZATION'] = 'space'

    pod_target_xcconfig['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'NO'

    # if use_whold_module == true
    pod_target_xcconfig['SWIFT_COMPILATION_MODE'] ||= 'wholemodule'
    # end

    if headers = header_search_paths_of_pods[pod_target]
      pod_target_xcconfig['SYSTEM_HEADER_SEARCH_PATHS'] = headers.join(' ')
    end
    if fix_modular_include.include? pod_target.name
      pod_target_xcconfig['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = "YES"
      # CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES 只对objc生效，swift需要额外参数禁掉error
      pod_target_xcconfig['OTHER_SWIFT_FLAGS'] += ' -Xcc -Wno-error=non-modular-include-in-framework-module'
    end
    if tobsdk_flags.include? pod_target.name
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] ||= ''
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] += ' TOBSDK=1'
    end
    if testable
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] ||= ''
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] += ' ALPHA=1'
      pod_target_xcconfig['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] ||= '$(inherited)'
      pod_target_xcconfig['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] += ' ALPHA'
    end
    if mail_target.include? pod_target.name
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] ||= ''
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] += ' PROJECT_DIR=\""$PROJECT_DIR\/"\"'
    end
    if pod_target.name == 'IESGeckoKit'
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] ||= ''
      pod_target_xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] += ' GURD_DEBUG_ENABLED=1'
    end

    is_lark_release_branch = true
    if is_lark_release_branch == false && ($enable_module_stability_list.include? pod_target.name)
      pod_target_xcconfig['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end

    pod_target_xcconfig['PSEUDO'] = '2' if ENV['PSEUDO'] == '1'
    pod_target_xcconfig['STRIP_LANG'] = '1' if stripped_unneeded_languages

    # if pod_target.name == 'LarkRustClient'
    #   pod_target_xcconfig['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] ||= '$(inherited)'
    #   pod_target_xcconfig['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] += ' DisableAssertMain'
    # end
  end
end

# @param installer [Pod::Installer]
post_install do |installer|
  # the post installer change won't mark cache invalid, and the results is not full(unless use clean install)
  # but it can set config by configurations..
  installer.target_installation_results.pod_target_installation_results.each do |name, result|
    # @type [Xcodeproj::Project::PBXNativeTarget]
    target = result.native_target
    release_settings = target.build_settings('Release')
    release_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Osize'
    release_settings['GCC_OPTIMIZATION_LEVEL'] = 'z'
    if !PackgeEnv.testable
#      lto会影响linkmap符号影响模块体积分析,只在appstore下打开lto
      release_settings['LLVM_LTO'] = 'YES'
    end
  end

  puts <<-EOF
    \033[36m

    自2020年5月13日起，ios-client 的主分支已经支持使用Xcode11.4或以上版本编译，但是仍不建议升级；因为Release/3.24
    及之前的版本仍需维护一段时间，或者你可以选在安装两个版本。
    具体原因请参考：https://bytedance.feishu.cn/wiki/wikcnCNTP9VU7FWS7d77GjdgnSh
    Xcode11.3.1 下载链接：https://developer.apple.com/download/more/

    Since May 13, 2020, the master branch of ios-client has been able to compile using Xcode11.4 or higher,
    but it is not recommended to upgrade as Release/3.24 and previous releases will still need to be maintained
    for some time. Or you can choose to install both versions.
    Reasons：https://bytedance.feishu.cn/wiki/wikcnCNTP9VU7FWS7d77GjdgnSh
    Xcode11.3.1 download link：https://developer.apple.com/download/more/

    \033[0m\n
  EOF
end
