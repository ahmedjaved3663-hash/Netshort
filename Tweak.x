#import <UIKit/UIKit.h>

// 1. Hooking the User/VIP status based on ZF prefix
%hook ZFUserModel
- (BOOL)isVip { return YES; }
- (BOOL)isPremium { return YES; }
- (NSInteger)vipLevel { return 10; }
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
%end

// 2. Hooking the Episode Unlock logic
%hook ZFDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_free { return YES; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
- (void)setPrice:(NSInteger)arg1 { %orig(0); }
%end

// 3. Bypassing the Payment check that causes the loading wheel
%hook ZFPaymentManager
- (BOOL)checkEpisodeIsBought:(id)arg1 {
    return YES;
}
- (void)buyEpisode:(id)arg1 completion:(void (^)(BOOL success))completion {
    if (completion) {
        completion(YES); // Force a "Success" signal to stop the loading spinner
    }
}
%end

// 4. Force the Player to ignore local "Lock" states
%hook ZFDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }
- (void)presentPayView { 
    // Do nothing - prevents the coin popup from appearing
}
%end
