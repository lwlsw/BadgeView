#import <libcolorpicker.h>

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.minazuki.badgeview.plist"

@interface SBIconBadgeView : UIView
@end

static BOOL enabled;
static int borderWidth = 1;
static NSString *borderColor = nil;

static void loadPrefs()
{

     NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];

     enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : NO;
     borderWidth = [[prefs objectForKey:@"borderWidth"] intValue];
     borderColor = [prefs objectForKey:@"borderColor"];

}

%hook SBIconBadgeView
- (void)layoutSubviews

{
	if (enabled) {

            %orig;
            self.clipsToBounds = YES;
            self.layer.cornerRadius = self.frame.size.height/2;
            self.layer.borderColor = [(LCPParseColorString(borderColor, @"#ffffff")) CGColor];

            if (borderWidth == 1) {
                %orig;
                self.layer.borderWidth = 1;
                    }
            else if (borderWidth == 2) {
                %orig;
                self.layer.borderWidth = 2;
                    }
            else if (borderWidth == 3) {
                %orig;
                self.layer.borderWidth = 3;
                    }

	} else {
		return %orig;
	} 
}
%end


%ctor 
{
    @autoreleasepool {
        loadPrefs();
        %init;
    }
}