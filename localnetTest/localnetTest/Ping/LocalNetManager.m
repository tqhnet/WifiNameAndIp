//
//  LocalNetManager.m
//  localnetTest
//
//  Created by xj_mac on 2021/4/7.
//

#import "LocalNetManager.h"
#import "SimplePing.h"
#import "LDSRouterInfo.h"

@interface LocalNetManager ()<SimplePingDelegate>
{
    dispatch_source_t _timer;
}
@property (nonatomic, strong) SimplePing *pinger;
@end

@implementation LocalNetManager


+ (instancetype)shareManager {
    static LocalNetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocalNetManager alloc]init];
    });
    return  manager;
}

- (void)stop{
    if (_pinger) {
        [_pinger stop];
    }

    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)checkLocalNetStatus{
    NSDictionary *router = [LDSRouterInfo getRouterInfo];
    _pinger = [[SimplePing alloc] initWithHostName:router[@"ip"]];
    _pinger.delegate = self;
    [_pinger start];
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
    if (_timer) {
        return;
    }
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [pinger sendPingWithData:nil];
    });
    dispatch_resume(_timer);
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    NSLog(@"**可以使用局域网**");
    if(self.finishBlock){
        self.finishBlock();
    }
    [self stop];
}

-  (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
    if (error.code == 65) {
        [self stop];
        NSLog(@"**不可以使用局域网**");
        if(self.errorBlock){
            self.errorBlock();
        }
    }
}

@end
