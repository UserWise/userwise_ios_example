#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if (@available(iOS 14, *)) {
        [self askForIDFAPermissions];
    } else {
        [self initializeUserWiseSDK];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.userWise onStop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)askForIDFAPermissions {
    if (@available(iOS 14, *)) {
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus authStatus) {
            if (authStatus == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSLog(@"You have allowed the example app to retrieve your IDFA.");
            } else {
                NSLog(@"You have denied the example app the right to retrieve your IDFA.");
            }

            [self initializeUserWiseSDK];
        }];
#else
        [self initializeUserWiseSDK];
#endif
    }
}

- (void)initializeUserWiseSDK {
    self.userWise = [UserWise sharedInstance];
    
    if (![self.userWise isInitialized]) {
        [self.userWise setDebugMode:YES];
        [self.userWise setHostOverride:[NSURL URLWithString:@"http://127.0.0.1:3000"]];
        [self.userWise setApiKey:@"2fac619fdeecba9f3fb3c7228406"];
        [self.userWise setUserId:@"userwise-demo-app-user"];
        // or: [self.userWise initializeWithApiKey:(NSString* _Nonnull) userId:(NSString* _Nonnull)];
    }

    [self.userWise onStart];

    // SurveysModule Configuration
    [self.userWise.surveysModule setSurveyDelegate:[ExampleSurveyDelegate initWithController:self andUserWise:self.userWise]];
    // [self.userWise.surveysModule setColorsWithPrimaryColor:UIColor.purpleColor splashScreenBackgroundColor:UIColor.whiteColor];
    // [self.userWise setSplashScreenLogo:[UIImage imageNamed:@"herowars-logo"]];
    
    // OffersModule Configuration
    [self.userWise.offersModule setOfferDelegate:[ExampleOfferDelegate initWithController:self andUserWise:self.userWise]];

    // Finally, you can assign your app user attributes and events directly within the SDK!
    //NSDictionary *attributes = @{@"current_coins": @10000, @"current_diamonds": @20};
    //[self.userWise setAttributes:attributes];
    //[self.userWise assignEvent:@"completed_tutorial" attributes:@{@"was_repeat_play": @NO}];
}

- (IBAction)forceRepolling:(id)sender {
    [self.userWise forcePollRequest];
}

@end
