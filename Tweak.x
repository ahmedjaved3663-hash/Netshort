#import <UIKit/UIKit.h>

// 1. Hooking the Global Data Parser
// This is a powerful "Wildcard" hook. It checks if any data coming in 
// has a 'lock' status and forces it to 'NO'.
%hook NSObject
- (BOOL)isLocked {
    // If the class name contains "Episode" or "Drama", force unlock
    NSString *className = NSStringFromClass([self class]);
    if ([className containsString:@"Episode"] || [className containsString:@"Drama"] || [className containsString:@"Video"]) {
        return NO;
    }
    return %orig;
}

- (BOOL)is_free {
    NSString *className = NSStringFromClass([self class]);
    if ([className containsString:@"Episode"] || [className containsString:@"Drama"]) {
        return YES;
    }
    return %orig;
}
%end

// 2. Hooking the User/VIP status
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)isPremium { return YES; }
- (NSInteger)vipLevel { return 10; }
%end

// 3. Bypassing the Ad-blocker (often required for some "Free" episodes)
%hook PAGAdSDKManager
+ (BOOL)isReady { return NO; }
%end

// 4. Forcing the Player to start
%hook NSVideoPlayerManager
- (void)checkPlayPermission:(id)arg1 completion:(void (^)(BOOL canPlay))completion {
    if (completion) {
        completion(YES); // Tell the app "Yes, the user can play this" immediately
    }
}
%end
