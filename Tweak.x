#import <UIKit/UIKit.h>

// --- Fix for Forward Declaration Errors ---
@interface NSDramaEpisodeModel : NSObject
@property (assign, nonatomic) BOOL isLocked;
@end

@interface NSUserModel : NSObject
@property (assign, nonatomic) BOOL isVip;
@end

@interface NSDramaDetailViewController : UIViewController
@end

// --- The Actual Tweak Logic ---

%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (BOOL)isFree { return YES; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

%hook NSUserModel
- (BOOL)isVip { return YES; }
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
%end

%hook NSPayManager
- (BOOL)checkEpisodeIsBoughtWithDramaId:(id)arg1 episodeId:(id)arg2 {
    return YES;
}
%end

%hook NSDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }

// This hides the 'Watch 2 ads' and 'Unlock All' buttons seen in your screenshot
- (void)setupBottomView {
    // Leave empty to prevent the pay bar from rendering
}

- (void)viewDidLoad {
    %orig;
    // Force the view to think everything is already paid for
    [self setValue:@(NO) forKey:@"isLocked"];
}
%end
