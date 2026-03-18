#import <UIKit/UIKit.h>

%hook NSObject
- (id)init {
    id result = %orig;
    NSString *className = NSStringFromClass([result class]);
    
    // We only care about names that might handle unlocking
    if ([className containsString:@"Drama"] || 
        [className containsString:@"Episode"] || 
        [className containsString:@"User"] || 
        [className containsString:@"Member"]) {
        NSLog(@"[NetShortLog] Found Class: %@", className);
    }
    return result;
}
%end

// A generic "Catch-All" to try one last broad unlock while logging
%hook UIView
- (void)didMoveToWindow {
    %orig;
    if ([NSStringFromClass([self class]) containsString:@"Lock"]) {
        NSLog(@"[NetShortLog] Found a Lock View: %@", NSStringFromClass([self class]));
        self.hidden = YES; // Try to hide any view with "Lock" in the name
    }
}
%end
