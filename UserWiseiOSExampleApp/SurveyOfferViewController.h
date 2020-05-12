//
//  SurveyOfferViewController.h
//  UserWiseDemoAPP
//
//  Created by David Jenkins on 5/12/20.
//  Copyright © 2020 theoremreach. All rights reserved.
//

#import "ViewController.h"
#import "SurveyOfferView.h"
#import "UserWiseSDK/UserWiseSDK-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface SurveyOfferViewController : UIViewController
    @property (weak) IBOutlet UIButton *offerAcceptBtn;
    @property (weak) IBOutlet UIButton *offerCloseBtn;
    @property (weak) IBOutlet UIImageView *offerImageView;
@end

NS_ASSUME_NONNULL_END
