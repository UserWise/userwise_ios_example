#import "ViewController.h"

@implementation FileHandler
- (void)onSuccessWithMediaInfo:(MediaInfo *)mediaInfo{
    NSLog(@"Header Image Loaded: %@", mediaInfo.url);
}

- (void)onFailure {
    NSLog(@"Header image failed to load");
}
@end

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
        [self.userWise setHostOverride:[NSURL URLWithString:@"http://192.168.1.163:3000"]];
        [self.userWise setApiKey:@"f1535363ad9ab340ebc9786337b0"];
        [self.userWise setUserId:@"userwise-demo-ios-user"];
        
        // or: [self.userWise initializeWithApiKey:(NSString* _Nonnull) userId:(NSString* _Nonnull)];
    }
    
    // VariablesModule Configuration *must* be configured prior to calling onStart
    self.maxLevelVar = [[IntegerVariable alloc] initWithName:@"maxLevel" defaultValue:0];
    self.enableThingAVar = [[BooleanVariable alloc] initWithName:@"enableThingA" defaultValue:false];
    self.startThisThingAtVar = [[DatetimeVariable alloc] initWithName:@"startThisThingAt" defaultValue:nil];
    self.titleVar = [[StringVariable alloc] initWithName:@"title" defaultValue:@"title"];
    self.descriptionVar = [[StringVariable alloc] initWithName:@"description" defaultValue:@"My default description"];
    self.exchangeRateVar = [[FloatVariable alloc] initWithName:@"exchangeRate" defaultValue:0.0f];
    self.headerImageVar = [[FileVariable alloc] initWithName:@"headerImage"];

    [self.userWise.variablesModule defineWithVariables:@[self.maxLevelVar, self.enableThingAVar, self.startThisThingAtVar, self.titleVar, self.descriptionVar, self.exchangeRateVar, self.headerImageVar] error:nil];
    
    self.userWise.variablesModule.variablesDelegate = self;
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

- (void)onVariablesInitialized {
    NSLog(@"Variables loaded!");
    
    NSLog(@"Variables Defined:");
    NSLog(@"maxLevel: %ld", [self.maxLevelVar getValue]);
    NSLog(@"enableThingA: %s", [self.enableThingAVar getValue] == YES ? "true" : "false");
    NSLog(@"startThisThingAt: %@", [self.startThisThingAtVar getValue]);
    NSLog(@"title: %@", [self.titleVar getValue]);
    NSLog(@"exchangeRate: %f", [self.exchangeRateVar getValue]);
    NSLog(@"headerImage: %@", [self.headerImageVar getValue]);
    
    [self.userWise getMediaWithMediaId:[self.headerImageVar getValue] handler:[[FileHandler alloc] init]];
}

- (IBAction)forceRepolling:(id)sender {
    [self.userWise forcePollRequest];
}

@end
