#import <UIKit/UIKit.h>

// --- Headers to stop Build Errors ---
@interface NSDramaEpisodeModel : NSObject
@property (assign, nonatomic) BOOL isLocked;
@end

@interface NSUserModel : NSObject
@property (assign, nonatomic) BOOL isVip;
@end

// --- New Target: The Play Manager ---
@interface NSPlayDetailManager : NSObject
@end

// --- Logic ---

%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (BOOL)isFree { return YES; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

%hook NSUserModel
- (BOOL)isVip { return YES; }
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
- (NSInteger)vipLevel { return 10; }
%end

// This targets the specific "Watch Ads" logic seen in your screenshot
%hook NSPlayDetailManager
- (BOOL)checkEpisodeIsLockedWithModel:(id)arg1 {
    return NO; 
}

- (void)checkEpisodePlayAuthorityWithDramaId:(id)arg1 
                                   episodeId:(id)arg2 
                                  completion:(void (^)(BOOL hasAuthority, id error))completion {
    if (completion) {
        // Force 'hasAuthority' to YES so the video starts immediately
        completion(YES, nil);
    }
}
%end

// Hiding the specific "Ad" and "Unlock" buttons from the UI layer
%hook UIView
- (void)layoutSubviews {
    %orig;
    NSString *className = NSStringFromClass([self class]);
    if ([className containsString:@"NSUnlockEpisodePopView"] || 
        [className containsString:@"NSDramaUnlockView"] || 
        [className containsString:@"NSPay"]) {
        [self setHidden:YES];
        [self setAlpha:0.0];
    }
}
%end
