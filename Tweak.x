#import <UIKit/UIKit.h>

// 1. Hooking the User/Account info
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)isPremium { return YES; }
- (NSInteger)vipLevel { return 10; }
- (long long)coinBalance { return 999999; }
// Adding setters to ensure server data doesn't overwrite our hack
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
%end

// 2. Hooking the Episode Data
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)isUnlocked { return YES; }
- (BOOL)isFree { return YES; }
- (NSInteger)price { return 0; }
// Intercepting the server response setter
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

// 3. Killing the Payment Check (The "Infinite Loading" Fix)
%hook NSPayManager
- (BOOL)checkEpisodeIsBought:(id)arg1 { return YES; }
- (void)payWithProduct:(id)product completion:(void (^)(BOOL success, id error))completion {
    if (completion) {
        completion(YES, nil); // Force immediate success
    }
}
%end

// 4. Force Video Player to Play
%hook NSVideoPlayerManager
- (void)checkPlayPermission:(id)episode completion:(void (^)(BOOL canPlay))completion {
    if (completion) {
        completion(YES); // Tell the UI it's safe to play
    }
}
%end
