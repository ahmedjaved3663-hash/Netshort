#import <UIKit/UIKit.h>

// 1. Hooking the Core Data Model
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)isUnlocked { return YES; }
- (BOOL)isFree { return YES; }
- (NSInteger)price { return 0; }

// Use setters to force the value the moment it's loaded from the server
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
- (void)setPrice:(NSInteger)arg1 { %orig(0); }
%end

// 2. Hooking the User Profile
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)isPremium { return YES; }
- (NSInteger)vipLevel { return 10; }
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
%end

// 3. Bypassing the Payment Logic (The Spinner Fix)
%hook NSPayManager
- (BOOL)checkEpisodeIsBought:(id)arg1 {
    return YES;
}
- (void)payWithProduct:(id)product completion:(void (^)(BOOL success, id error))completion {
    if (completion) {
        completion(YES, nil); // Force an immediate "Success" signal
    }
}
%end

// 4. Force the Player to ignore "Locked" UI states
%hook NSDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }
- (void)setupBottomView {
    %orig;
    // This often removes the "Unlock" button from the bottom of the screen
}
%end
