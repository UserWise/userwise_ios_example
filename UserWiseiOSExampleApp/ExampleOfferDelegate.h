#ifndef ExampleOfferDelegate_h
#define ExampleOfferDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>

@interface ExampleOfferDelegate : NSObject <UserWiseOfferDelegate>

@property UIViewController *controller;
@property UserWise *userWise;

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise;

@end

#endif
