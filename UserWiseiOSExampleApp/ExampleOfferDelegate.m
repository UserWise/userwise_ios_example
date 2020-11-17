#import "ExampleOfferDelegate.h"

@implementation ExampleOfferDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleOfferDelegate *delegate = [[ExampleOfferDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onOfferAvailableWithOfferId:(NSString *)offerId {
    NSLog(@"Offer available. offer_id=%@", offerId);
    [self.userWise.offersModule initializeOfferImpressionWithOfferId:offerId];
}

- (void)onOfferUnavailable { NSLog(@"No offers available"); }

- (void)onOfferImpressionInitializationFailedWithOfferId:(NSString *)offerId {
    NSLog(@"Offer impression initialized failed. offer_id=%@", offerId);
}

- (void)onOfferImpressionInitialized:(OfferImpression *)offerImpression {
    NSLog(@"Offer impression successfully initialized. offer_impression_id=%@", offerImpression.id);
    [self.userWise.offersModule showOfferWithOfferImpression:offerImpression];
}

- (void)onOfferViewAttemptFailedWithOfferImpression:(OfferImpression *)offerImpression
                                             reason:(enum OfferViewAttemptFailedReason)reason {
    NSLog(@"Offer failed to load properly. offer_impression_id=%@ reason=%@", offerImpression.id, reason);
    // Above, we tell the UserWise SDK to show the offer, as it was built in our dashboard.
    // However, if you find yourself wanting a data-only approach, you can hook into-and out of-
    // the UserWise OffersModule event flow, at any point.

    // Offer impressions contain information about their `offer`, including bundle information
    // (e.g. pricing, contents, etc.).

    // Offer impressions can have their state updated by calling  offerImpression.updateState();
}

- (void)onOfferViewedWithOfferImpression:(OfferImpression *)offerImpression {
    NSLog(@"Offer has loaded and is actively visible! offer_impression_id=%@", offerImpression.id);
}

- (void)onOfferDismissedWithOfferImpression:(OfferImpression *)offerImpression {
    NSLog(@"Offer was dismissed! offer_impression_id=%@", offerImpression.id);
}

- (void)onOfferAcceptedWithOfferImpression:(OfferImpression *)offerImpression {
    NSLog(@"Offer was accepted! offer_impression_id=%@", offerImpression.id);
    
    NSString *productId = offerImpression.offer.iOSProductId;
    double cost = offerImpression.offer.cost;
    NSDictionary<NSString *, NSNumber *> *bundleContent = offerImpression.offer.currencies;
    
    NSLog(@"Offer Product ID: %@", productId);
    NSLog(@"Offer Cost: %.02f", cost);
    NSLog(@"Bundle Contains: \n %@", bundleContent);

    // Once an offer has been accepted the itself impression will stay in a state of "accepted"
    // on the UserWise servers.  There are currently two possible states beyond "accepted":
    //   - PURCHASED
    //   - PURCHASE_FAILED
    //
    // You can update to these states through the OfferImpression#updateState() method.
    //
    // Examples:

    // 1. You display the buy screen. User purchases. You call:
    [offerImpression updateState:OfferImpressionStatePurchased];
    
    // 2. The purchase process fails in any form. You'd call:
    //[offerImpression updateState:OfferImpressionStatePurchaseFailed];
}

@end
