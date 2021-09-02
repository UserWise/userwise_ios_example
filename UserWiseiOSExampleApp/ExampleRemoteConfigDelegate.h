#ifndef ExampleRemoteConfigDelegate_h
#define ExampleRemoteConfigDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>

@interface ExampleRemoteConfigDelegate : NSObject <UserWiseRemoteConfigDelegate>

@property UIViewController *controller;
@property UserWise *userWise;

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise;

@end

#endif
