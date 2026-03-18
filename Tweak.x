#import <UIKit/UIKit.h>

// 1. Force the Episode to be "Unlocked" locally
%hook NSDramaEpisodeModel
- (BOOL)isLocked {
    return NO;
}
- (BOOL)isUnlocked {
    return YES;
}
- (BOOL)isFree {
    return YES;
}
%end

// 2. Trick the Pay Manager into thinking every request is a success
// This stops the "infinite loading" by telling the app the transaction is done
%hook NSPayManager
- (void)payWithProduct:(id)product completion:(void (^)(BOOL success, id error))completion {
    if (completion) {
        completion(YES, nil); // Force a "Success" result immediately
    }
}
%end

// 3. Set User to VIP Tier 10
%hook NSUserModel
- (BOOL)isVip {
    return YES;
}
- (NSInteger)vipLevel {
    return 10;
}
- (long long)coinBalance {
    return 999999;
}
%end

// 4. Hide the "Unlock Popup" Controller
%hook NSUnlockEpisodePopView
- (void)show {
    // Doing nothing here prevents the popup from appearing
}
%end
