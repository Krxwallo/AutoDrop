#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

static NSString * nsDomainString = @"io.github.krxwallo.AutoDrop";
static NSString * nsNotificationString = @"io.github.krxwallo.AutoDrop/preferences.changed";
static BOOL enabled;

/**
 * Log a message to the console with the [AutoDrop] prefix
 * @param format The message to log
 */
static void Log(NSString *format, ...) {
    va_list args;
    va_start(args, format);

    NSString *formattedString = [[NSString alloc] initWithFormat:[@"[AutoDrop] " stringByAppendingString:format] arguments:args];

    va_end(args);

    NSLog(@"%@", formattedString);
}

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;
    Log(@"Enabled is now %d", enabled);
}

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

	// Add any personal initializations

}
/*
static int downFinger_=0;

%hook UIAlertView
-(id)window { Log(@"Window!!!"); return %orig; }
-(void)show {
    Log(@"SHOW!!!"); %orig;
    // dismiss directly
    [self dismissWithClickedButtonIndex:0 animated:NO];
}
-(void)dismiss { Log(@"DISMISS!!!"); %orig; }
-(void)_prepareForDisplay { Log(@"PREPARE FOR DISPLAY!!!"); %orig; }
-(void)_prepareToBeReplaced { Log(@"PREPARE TO BE REPLACED"); %orig; }
%end


%hook SFAirDropPayload
-(void)viewDidLoad { Log(@"AIRDROP INSTRUCTIONS VIEW DID LOAD"); %orig; }
-(id)_airDropText { Log(@"AIR DROP TEXT"); return %orig; }
%end


%hook SFAirDropTransfer

//-(void)setContentsDescription:(NSString *)arg1 { Log(@"SET CONTENTS DESCRIPTION"); %orig; }

-(void)setUpProgressToBroadcast:(BOOL)arg1 { Log(@"SET UP PROGRESS TO BROADCAST"); %orig; }
-(void)setUpProgress {
    Log(@"SET UP PROGRESS"); %orig;

    // Your block of code to be executed after the delay
    void (^delayedBlock)(void) = ^{
        Log(@"Auto-accepting... (WIP)");

        //[self setUserResponse:1];
        //[self setTransferState:1];
    };

    // Usage:
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), delayedBlock);

}
-(void)setTransferState:(unsigned long long)arg1 { Log(@"SET TRANSFER STATE: %d", arg1); %orig; }

-(void)setUserResponse:(unsigned long long)arg1 { Log(@"SET USER RESPONSE: %d", arg1); %orig; }

%end

%hook SFAirDropTransferItem

-(id)init {
    Log(@"INIT TRANSFER ITEM"); return %orig;
}

%end

%hook CRKAirDropItem

-(id)copyToFolder:(id)arg1 error:(id*)arg2 { Log(@"COPY TO FOLDER"); return %orig; }

-(id)moveToFolder:(id)arg1 error:(id*)arg2 { Log(@"MOVE TO FOLDER"); return %orig; }

-(id)initWithFileURL:(id)arg1 { Log(@"INIT WITH FILE URL"); return %orig; }

%end

%hook CRKAirDropTransferInfo

-(void)setFiles:(NSArray *)arg1 { Log(@"SET FILES"); %orig; }

-(void)setPreviewImageData:(NSData *)arg1 { Log(@"SET PREVIEW IMAGE DATA"); %orig; }

-(NSString *)senderName { Log(@"SENDER NAME"); return %orig; }

%end

%hook SBPowerDownController

- (void)orderFront {
    Log(@"Simulating touch!");
    //%orig; // Don't Call the original implementation of this method

    // Your block of code to be executed after the delay
    void (^delayedBlock)(void) = ^{
        //downFinger_=[SimulateTouch simulateTouch:0 atPoint:CGPointMake(50,50) withType:(STTouchUp)];
        Log(@"Delayed action executed");
    };

    // Usage:
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), delayedBlock);

    //downFinger_=[SimulateTouch simulateTouch:0 atPoint:CGPointMake(50,50) withType:(STTouchDown)];

    Log(@"Down finger: %d", downFinger_);

    UIAlertView *credits = [[UIAlertView alloc] initWithTitle:@"Test Title"
                                                      message:@"Test Message"
                                                     delegate:self
                                            cancelButtonTitle:@"Close Test Pop-Up"
                                            otherButtonTitles:@"Test Link", nil];
    [credits show];
}

%end


%hook AMSDialog

-(void)present { Log(@"AMS DIALOG PRESENT"); %orig; }


%end

%hook UITapGestureRecognizer

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    Log(@"Received tap: %@", gestureRecognizer);
}

-(void)touchesBegan:(id)arg1 withEvent:(id)arg2 { Log(@"TOUCHES BEGAN: %@, %@", arg1, arg2); %orig; }

-(void)touchesCancelled:(id)arg1 withEvent:(id)arg2 { Log(@"TOUCHES CANCELLED"); %orig; }

-(void)pressesBegan:(id)arg1 withEvent:(id)arg2 { Log(@"PRESSES BEGAN: %@, %@", arg1, arg2); %orig; }

%end

%hook UIAlertController


-(void)loadView { Log(@"LOAD VIEW"); %orig; }

-(void)viewDidAppear:(BOOL)arg1 {
    %orig;

    Log(@"VIEW DID APPEAR; AUTO-ACCEPTING... (WIP)");

    //[self _dismissWithAction:[self.actions objectAtIndex:0]];
}

-(void)viewDidDisappear:(BOOL)arg1 { Log(@"VIEW DID DISAPPEAR"); %orig; }

-(void)addAction:(id)arg1 {
    Log(@"ADD ACTION: %@", arg1); %orig;
    if ([[arg1 title] isEqual:@"Annehmen"]) {
        // Your block of code to be executed after the delay
        void (^delayedBlock)(void) = ^{
            Log(@"Auto-accepting...");
            [self performSelector:@selector(_dismissWithAction:) withObject:arg1];

            Log(@"Auto-accepted alert!");
        };

        // Usage:
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), delayedBlock);
        Log(@"Scheduled auto-accept...");
    }
}

-(void)setTitle:(NSString *)arg1 { Log(@"SET TITLE: %@", arg1); %orig; }

-(void)_dismissWithAction:(id)arg1 { Log(@"DISMISSED WITH ACTION: %@", arg1); %orig; }

%end
*/

%hook UIAlertController

-(void)addAction:(id)arg1 {
    Log(@"ADD ACTION: %@", arg1); %orig;
    if ([[arg1 title] isEqual:@"Annehmen"]) {
        // Your block of code to be executed after the delay
        void (^delayedBlock)(void) = ^{
            Log(@"Auto-accepting... (WIP)");
            [self performSelector:@selector(_dismissWithAction:) withObject:arg1];

            Log(@"Delayed action executed");
        };

        // Usage:
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), delayedBlock);
        Log(@"Scheduled auto-accept...");
    }
}


%end

/*%hook UIAlertAction

-(void)setTitle:(NSString *)arg1 { Log(@"SET TITLE ACTION: %@", arg1); %orig; }

-(void)setEnabled:(BOOL)arg1 { Log(@"SET ENABLED: %d", arg1); %orig; }

%end*/