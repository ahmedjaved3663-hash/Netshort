#import <UIKit/UIKit.h>

// 1. Intercepting the User Data Model
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)is_vip { return YES; }
- (NSInteger)vip_level { return 10; }
- (id)vip_expire_time { return @"2099-12-31 23:59:59"; }
// If the app checks for "Coins" instead of VIP
- (NSInteger)total_coin { return 999999; }
- (NSInteger)remained_coin { return 999999; }
%end

// 2. Intercepting the Episode Data Model
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (BOOL)is_free { return YES; }
- (id)price { return @0; }
- (id)coin_price { return @0; }
%end

// 3. The "Master Switch" - Bypassing the Play Authority
// This stops the "Watch 2 Ads" or "Pay" popup from even triggering
%hook NSPlayDetailManager
- (void)checkEpisodePlayAuthorityWithDramaId:(id)arg1 
                                   episodeId:(id)arg2 
                                  completion:(void (^)(BOOL hasAuthority, id error))completion {
    if (completion) {
        // We call the completion block manually with 'YES'
        completion(YES, nil);
    }
}
%end

// 4. Hiding the Paywall UI
%hook NSDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }
- (void)setupBottomView { 
    // This removes the "Unlock All" button bar at the bottom
    %orig;
    UIView *view = [self valueForKey:@"bottomView"];
    if (view) [view setHidden:YES];
}
%end
