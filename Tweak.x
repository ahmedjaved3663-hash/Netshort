#import <UIKit/UIKit.h>

// 1. Hooking the Network Data Parser
// This is the "Master Key" - it tells the app that every episode it just 
// heard about from the server is actually free.
%hook NSDramaEpisodeModel
- (void)setIs_locked:(BOOL)arg1 {
    %orig(NO); // Force the 'locked' value to NO whenever the server tries to set it
}

- (void)setIs_free:(BOOL)arg1 {
    %orig(YES); // Force the 'free' value to YES
}

- (BOOL)isLocked { return NO; }
- (BOOL)isUnlocked { return YES; }
%end

// 2. The Loading Spinner Fix
// This tells the "Order Manager" that any episode check is already paid for.
%hook NSOrderManager
- (BOOL)checkEpisodeBoughtWithId:(id)arg1 {
    return YES;
}
%end

// 3. User VIP Status
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (NSInteger)vipLevel { return 10; }
%end

// 4. Force Video Player to ignore "Permission" checks
%hook NSVideoPlayerManager
- (void)verifyPlayPermission:(id)episode completion:(void (^)(BOOL silver))completion {
    if (completion) {
        completion(YES); // Tell the player it has permission immediately
    }
}
%end
