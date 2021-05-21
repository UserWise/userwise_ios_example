#ifndef ExampleGameEventDelegate_h
#define ExampleGameEventDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>

@interface ExampleGameEventDelegate : NSObject <UserWiseEventDelegate>

@property UIViewController *controller;
@property UserWise *userWise;

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise;

@end

#endif
