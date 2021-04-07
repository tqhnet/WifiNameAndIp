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
