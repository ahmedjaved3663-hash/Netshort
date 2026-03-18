#import <UIKit/UIKit.h>

// 1. Hooking the Data Parser
// This intercepts the data as it's being converted from JSON to a Model
%hook NSDramaEpisodeModel
- (void)setIs_locked:(BOOL)arg1 {
    %orig(NO); // Force every episode to be 'unlocked' in the data layer
}

- (void)setPrice:(NSInteger)arg1 {
    %orig(0); // Force price to 0
}

- (BOOL)isLocked { return NO; }
- (BOOL)isUnlocked { return YES; }
%end

// 2. Hooking the User Response
// This tells the app the server said "This user is a VIP"
%hook NSUserModel
- (void)setIs_vip:(BOOL)arg1 {
    %orig(YES);
}
- (BOOL)isVip { return YES; }
- (NSInteger)vipLevel { return 10; }
%end

// 3. The "Infinite Loading" Fix
// This forces the "Permission" check to return a success token immediately 
// without waiting for the server to reply.
%hook NSVideoPlayerManager
- (void)checkPlayPermission:(id)episode completion:(void (^)(BOOL success))completion {
    if (completion) {
        completion(YES); // Force success to kill the loading spinner
    }
}
%end

// 4. Removing the Payment Popup
%hook NSUnlockEpisodePopView
- (void)showInView:(id)view {
    // Emptying this prevents the popup from ever appearing
}
%end
