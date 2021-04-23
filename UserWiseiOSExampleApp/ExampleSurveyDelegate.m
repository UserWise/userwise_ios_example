#import "ExampleSurveyDelegate.h"

@implementation ExampleSurveyDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleSurveyDelegate *delegate = [[ExampleSurveyDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onSurveysLoaded {
    
}

- (void)onSurveyAvailableWithSurvey:(Survey * _Nonnull)survey {
    [self.userWise.surveysModule initializeSurveyInviteWithSurvey:survey];
}

- (void)onSurveyInviteInitializedWithSurvey:(Survey * _Nonnull)survey wasInitialized:(BOOL)wasInitialized responseId:(NSString * _Nullable)responseId inviteId:(NSString * _Nullable)inviteId {
    
    if (!wasInitialized) { return; }

    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        SurveyOfferViewController *vc = [[SurveyOfferViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.responseId = responseId;
        vc.inviteId = inviteId;
        [self.controller presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)onSurveyClosedWithSurvey:(Survey * _Nonnull)survey responseId:(NSString * _Nonnull)responseId {
    [self.controller.view makeToast:@"Survey has been closed!"];
}


- (void)onSurveyCompletedWithSurvey:(Survey * _Nonnull)survey responseId:(NSString * _Nonnull)responseId {
    [self.controller.view makeToast:@"Survey was successfully completed!"];
}


- (void)onSurveyEnterFailedWithSurvey:(Survey * _Nonnull)survey responseId:(NSString * _Nonnull)responseId {
    [self.controller.view makeToast:@"Survey failed to load!"];
}


- (void)onSurveyEnteredWithSurvey:(Survey * _Nonnull)survey responseId:(NSString * _Nonnull)responseId {
    [self.controller.view makeToast:@"Entering survey!"];
}

@end
