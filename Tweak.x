#import <UIKit/UIKit.h>

// 1. Hooking the Episode Data
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (BOOL)isFree { return YES; }
- (NSInteger)price { return 0; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

// 2. Hooking the User Profile
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (NSInteger)vipLevel { return 10; }
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
%end

// 3. Bypassing Payment Checks
%hook NSPayManager
- (BOOL)checkEpisodeIsBoughtWithDramaId:(id)arg1 episodeId:(id)arg2 {
    return YES;
}
%end

// 4. Removing the "Unlock" Button from the Screen
%hook NSDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    // This tells the app the episode is already owned before the screen draws
    [self setValue:@(NO) forKey:@"isLocked"];
}

- (void)setupBottomView {
    // Keeping this empty prevents the "Unlock/Pay" bar from loading
}
%end
