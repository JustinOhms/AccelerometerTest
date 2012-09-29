//
//  AppDelegate.m
//  AccelerometerTest
//
//  Created by Alex Pawlowski on 9/11/12.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong, nonatomic) NetworkManager *networkManager;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.networkManager = [[NetworkManager alloc] init];
    self.networkManager.targetIPAddress = @"127.0.0.1";
    self.shakeButton.refusesFirstResponder = NO;
}

- (void)applicationWillBecomeActive:(NSNotification *)notification {
    [self.textField resignFirstResponder];
    [self.circleView becomeFirstResponder];
    self.circleView.delegate = self;
}

- (IBAction)shakeAction:(id)sender {
    AccelerationInfo *info = [AccelerationInfo createWithTimestamp:CFAbsoluteTimeGetCurrent() X:0 Y:0 Z:0];
    self.networkManager.accelInfo = info;
    self.networkManager.shake = YES;
}

- (void)updateAccelerationWithX:(UIAccelerationValue)x andY:(UIAccelerationValue)y {
    AccelerationInfo *info = [AccelerationInfo createWithTimestamp:CFAbsoluteTimeGetCurrent() X:x Y:y Z:0];
    self.networkManager.accelInfo = info;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
