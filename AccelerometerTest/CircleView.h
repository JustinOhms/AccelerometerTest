//
//  CircleView.h
//  AccelerometerTest
//
//  Created by Alex Pawlowski on 9/11/12.
//

#import <Cocoa/Cocoa.h>

@interface CircleView : NSView

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) NSPoint circlePoint;
@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, strong) NSColor *circleColor;
@property (nonatomic, strong) NSColor *backgroundColor;

@property (nonatomic, assign) float x, y;
@property (nonatomic, assign) BOOL returnToOrigin;

- (void)moveXPointDelta:(CGFloat)delta;
- (void)moveYPointDelta:(CGFloat)delta;

@end
