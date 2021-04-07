# WifiNameAndIp
iOS14获取wifi名称和ip地址检测
```
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
```
wifi相关
https://blog.csdn.net/qq_30513483/article/details/61214081
https://www.jianshu.com/p/14da35d0b74b
https://juejin.cn/post/6844903529618866183
https://github.com/xnxy/nehotspotnetwork
https://www.jianshu.com/p/79b986af536e
https://www.jianshu.com/p/093222b2bf33
https://blog.csdn.net/iOS1501101533/article/details/109306856
https://blog.csdn.net/u011348583/article/details/109059231
