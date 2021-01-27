#import <Foundation/Foundation.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>
#import "ViewController.h"

#ifndef FileHandler_h
#define FileHandler_h

@interface FileHandler : NSObject <UserWiseMediaInfoDelegate, UserWiseMediaRawDataHandler>
@property UserWise *userWise;

- (void)onSuccessWithMediaInfo:(MediaInfo *)mediaInfo;
- (void)onFailure;
@end

#endif /* FileHandler_h */
