#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>

#import "UIView+Toast.h"
#import "ExampleSurveyDelegate.h"
#import "ExampleOfferDelegate.h"

#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif

@interface FileHandler : NSObject <UserWiseMediaInfoDelegate>
- (void)onSuccessWithMediaInfo:(MediaInfo *)mediaInfo;
- (void)onFailure;
@end

@interface ViewController : UIViewController <UserWiseVariablesDelegate>

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

