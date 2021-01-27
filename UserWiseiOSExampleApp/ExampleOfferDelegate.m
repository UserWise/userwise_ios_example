#import "ExampleOfferDelegate.h"

@implementation ExampleOfferDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleOfferDelegate *delegate = [[ExampleOfferDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onOffersLoaded {
    NSLog(@"Offer have been loaded from the server");
}

- (void)onOfferAvailableWithOffer:(Offer *)offer {
    NSLog(@"Offer available. offer_id=%@", offer.id);
    [self.userWise.offersModule initializeOfferImpressionWithOffer:offer];
}

- (void)onOfferUnavailable { NSLog(@"No offers available"); }

- (void)onOfferImpressionInitializationFailedWithOffer:(Offer *)offer {
    NSLog(@"Offer impression initialized failed. offer_id=%@", offer.id);
}

- (void)onOfferImpressionInitialized:(OfferImpression *)offerImpression {
    NSLog(@"Offer impression successfully initialized. offer_impression_id=%@", offerImpression.id);
    
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
    [self.userWise.offersModule updateOfferImpressionStateWithOfferImpression:offerImpression newState:OfferImpressionStatePurchased];
    
    // 2. The purchase process fails in any form. You'd call:
    //    [self.userWise.offersModule updateOfferImpressionStateWithOfferImpression:offerImpression newState:OfferImpressionStateFailed];
}


// These signatures should be ignored, for now.
- (void)onOfferViewAttemptFailedWithOfferImpression:(OfferImpression *)offerImpression
                                             reason:(enum OfferViewAttemptFailedReason)reason {}
- (void)onOfferViewedWithOfferImpression:(OfferImpression *)offerImpression {}
- (void)onOfferDismissedWithOfferImpression:(OfferImpression *)offerImpression {}
- (void)onOfferAcceptedWithOfferImpression:(OfferImpression *)offerImpression {}

@end
