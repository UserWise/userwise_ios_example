#ifndef SurveyOfferViewController_h
#define SurveyOfferViewController_h

#import "ViewController.h"
#import "SurveyOfferView.h"
#import "UserWiseSDK/UserWiseSDK-Swift.h"

@interface SurveyOfferViewController : UIViewController

@property NSString *responseId;
@property NSString *inviteId;
@property Survey *survey;
@property UserWise *userWise;

@property (weak) IBOutlet UIButton *offerAcceptBtn;
@property (weak) IBOutlet UIButton *offerCloseBtn;

- (void)dismissSurveyOfferView;

@end

#endif
