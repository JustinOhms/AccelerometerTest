//
//  AppDelegate.h
//  AccelerometerTest
//
//  Created by Alex Pawlowski on 9/11/12.
//

#import <Cocoa/Cocoa.h>
#import "NetworkManager.h"
#import "AccelerationInfo.h"
#import "CircleView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic, readonly) NetworkManager *networkManager;
@property (assign, nonatomic) IBOutlet NSWindow *window;
@property (weak, nonatomic) IBOutlet NSTextField *textField;
@property (weak, nonatomic) IBOutlet NSButton *shakeButton;
@property (weak, nonatomic) IBOutlet CircleView *circleView;

- (IBAction)shakeAction:(id)sender;
- (void)updateAccelerationWithX:(UIAccelerationValue)x andY:(UIAccelerationValue)y;

@end
