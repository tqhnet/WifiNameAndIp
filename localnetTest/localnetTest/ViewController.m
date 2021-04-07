//
//  ViewController.m
//  localnetTest
//
//  Created by xj_mac on 2021/4/7.
//

#import "ViewController.h"
#import "LocalNetManager.h"
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>


#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) CLLocationManager *locManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取ip地址和获取wifi名称
    NSLog(@"完成检测");
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getLocation];
//    [[LocalNetManager shareManager] checkLocalNetStatus];
//    __weak typeof(self) myself = self;
//    [[LocalNetManager shareManager] setErrorBlock:^{
//        myself.IPLabel.text = @"不可以使用局域网";
//    }];
//
//    [[LocalNetManager shareManager]setFinishBlock:^{
//        myself.IPLabel.text = @"可以使用本地局域网";
//    }];
}

// 需要证书配置wifi
- (NSString *)wifiName {
//    if (@available(iOS 15.0, *)) {
//        __block NSString *wifi = @"Not Found";
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(NEHotspotNetwork * _Nullable currentNetwork) {
//            NSLog(@"%@",currentNetwork.SSID);
//            NSLog(@"%@",currentNetwork.BSSID);
//            wifi = currentNetwork.SSID;
//            dispatch_semaphore_signal(semaphore);  //获取block结果后唤醒
//            }];
//        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_MSEC));
//        //加锁，不让方法结束
//        return wifi;
//    }else {
        NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
        id info = nil;
        for (NSString *interfaceName in interfaces) {
            info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)interfaceName);
            if (info) {
                break;
            }
        }
        NSDictionary *infoDic = (NSDictionary *)info;
        NSString *ssid = [infoDic objectForKey:@"SSID"]; // WiFi的名称
        NSString *bssid = [infoDic objectForKey:@"BSSID"]; // WiFi的mac地址
        NSLog(@"WiFi SSID = %@, MAC = %@", ssid, bssid);
        return ssid;
//    }
}

- (void)getSSID {
    [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(NEHotspotNetwork * _Nullable currentNetwork) {
        NSLog(@"%@",currentNetwork.SSID);
    }];
}

#pragma mark - 定位授权代理方法

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        self.titleLabel.text = [self wifiName];
//        [[LocalNetManager shareManager] checkLocalNetStatus];
//        __weak typeof(self) myself = self;
//        [[LocalNetManager shareManager] setErrorBlock:^{
//            myself.IPLabel.text = @"不可以使用局域网";
//        }];
//
//        [[LocalNetManager shareManager]setFinishBlock:^{
//            myself.IPLabel.text = @"可以使用本地局域网";
//        }];
    }else {
        self.titleLabel.text = @"请打开定位权限";
    }
}

- (void)getLocation
{
    if (!self.locManager) {
        self.locManager = [[CLLocationManager alloc] init];
        
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //这句代码会在app的设置中开启位置授权的选项，只有用户选择了允许一次，下次用户调用这个方法才会弹出询问框，选择不允许或是使用期间允许，下次调用这个方法都不会弹出询问框
        [self.locManager requestAlwaysAuthorization];
        
    }
    
    self.locManager.delegate = self;
    //如果用户第一次拒绝了，弹出提示框，跳到设置界面，要用户打开位置权限
    //如果用户跳到设置界面选择了下次询问，再回到app,[CLLocationManager authorizationStatus]的值会是nil,所以要||后面的判断
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || ![CLLocationManager authorizationStatus]) {
        [self alertMy];
    }
}

- (void)alertMy{
       //1.创建UIAlertControler
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"app需要获取您的位置权限，以获取wifi信息，给机器人配网" preferredStyle:UIAlertControllerStyleAlert];
     
       UIAlertAction *conform = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           //使用下面接口可以打开当前应用的设置页面
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
           NSLog(@"点击了确认按钮");
       }];
       //2.2 取消按钮
       UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           NSLog(@"点击了取消按钮");
       }];
    
       //3.将动作按钮 添加到控制器中
       [alert addAction:conform];
       [alert addAction:cancel];
       
       //4.显示弹框
       [self presentViewController:alert animated:YES completion:nil];
}

@end
