//
//  LocalNetManager.h
//  localnetTest
//
//  Created by xj_mac on 2021/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNetManager : NSObject

@property (nonatomic,copy) dispatch_block_t errorBlock;
@property (nonatomic,copy) dispatch_block_t finishBlock;
+ (instancetype)shareManager;
- (void)checkLocalNetStatus;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
