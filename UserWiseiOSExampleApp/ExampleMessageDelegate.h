#ifndef ExampleMessageDelegate_h
#define ExampleMessageDelegate_h

#import <Foundation/Foundation.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>
#import "SurveyOfferViewController.h"

@interface ExampleMessageDelegate : NSObject <UserWiseMessageDelegate>

@property UIViewController *controller;
@property UserWise *userWise;

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise;

@end

#endif
