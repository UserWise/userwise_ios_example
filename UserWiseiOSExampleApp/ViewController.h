#import <UIKit/UIKit.h>
#import <UserWiseSDK/UserWiseSDK-Swift.h>

#import "UIView+Toast.h"
#import "ExampleSurveyDelegate.h"
#import "ExampleOfferDelegate.h"
#import "ExampleMessageDelegate.h"

#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif

@interface ViewController : UIViewController
@property UserWise *userWise;
@property (weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *userIdField;
@property (weak, nonatomic) IBOutlet UIButton *changeUserBtn;

- (IBAction)changeUser:(id)sender;

@end

