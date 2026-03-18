#import <UIKit/UIKit.h>

// 1. Hooking the User/Account info
// This forces the "VIP" badge and premium status
%hook NSUserModel
- (BOOL)isVip {
    return YES;
}
- (BOOL)isPremium {
    return YES;
}
- (NSInteger)vipLevel {
    return 10;
}
%end

// 2. Hooking the Drama/Video Data
// This tells the app that every episode is already "Purchased" or "Free"
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
- (NSInteger)price {
    return 0;
}
%end

// 3. Hooking the Controller that handles the "Lock" UI
// This hides the coin-payment popup entirely
%hook NSDramaDetailViewController
- (BOOL)isEpisodeLocked:(id)arg1 {
    return NO;
}
%end

// 4. Hooking the Ad SDK to prevent forced ads during playback
%hook PAGAdSDKManager
+ (BOOL)isReady {
    return NO;
}
%end
