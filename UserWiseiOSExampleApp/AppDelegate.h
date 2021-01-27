#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>

#import "ExampleSurveyDelegate.h"
#import "ExampleOfferDelegate.h"
#import "FileHandler.h"

#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate, UserWiseVariablesDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UserWise *userWise;

@property (strong, nonatomic) IntegerVariable *maxLevelVar;
@property (strong, nonatomic) BooleanVariable *enableThingAVar;
@property (strong, nonatomic) DatetimeVariable *startThisThingAtVar;
@property (strong, nonatomic) StringVariable *titleVar;
@property (strong, nonatomic) StringVariable *descriptionVar;
@property (strong, nonatomic) FloatVariable *exchangeRateVar;
@property (strong, nonatomic) FileVariable *headerImageVar;

- (void)askForIDFAPermissions;
- (void)initializeUserWiseSDK;
- (void)onVariablesInitialized;
@end

