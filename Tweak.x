#import <UIKit/UIKit.h>

// 1. Force the Model to report Unlocked (Redundant but necessary)
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (BOOL)isFree { return YES; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

// 2. Target the Specific UI View Controllers
// This hides the actual "Unlock" button at the bottom of the screen
%hook NSDramaDetailViewController
- (void)viewDidLoad {
    %orig;
    // Look for subviews and hide the payment ones
    for (UIView *subview in self.view.subviews) {
        NSString *viewName = NSStringFromClass([subview class]);
        if ([viewName containsString:@"Pay"] || [viewName containsString:@"Unlock"] || [viewName containsString:@"Coin"]) {
            subview.hidden = YES;
        }
    }
}

// Bypassing the check that decides to show the bottom "Unlock" bar
- (BOOL)shouldShowPayPopup { return NO; }
- (BOOL)isEpisodeLocked:(id)arg1 { return NO; }
%end

// 3. Prevent the Payment Pop-up from even loading
%hook NSPayManager
- (BOOL)checkEpisodeIsBoughtWithDramaId:(id)arg1 episodeId:(id)arg2 {
    return YES;
}
%end

// 4. Global UI "Eraser"
// If any view is created with these names, we kill it immediately.
%hook UIView
- (void)didMoveToWindow {
    %orig;
    NSString *className = NSStringFromClass([self class]);
    if ([className containsString:@"NSUnlockEpisodePopView"] || 
        [className containsString:@"NSDramaUnlockView"] || 
        [className containsString:@"NSPaymentView"]) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }
}
%end
