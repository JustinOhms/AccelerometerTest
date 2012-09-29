//
//  CircleView.m
//  AccelerometerTest
//
//  Created by Alex Pawlowski on 9/11/12.
//

#import "CircleView.h"

#import <objc/message.h>

void CGContextAddCircle(CGContextRef ctx, float ox, float oy, float radius)
{
    double len = 2 * M_PI * radius;
    double step = 1.8 / len; // over the top :)
    
    // translating/scaling would more efficient, etc..
    //
    float x = ox + radius;
    float y = oy;
    
    // stupid hack - should just do a quadrant and mirror twice.
    //
    CGContextMoveToPoint(ctx,x,y);
    for (double a = step; a < 2.0 * M_PI -step; a += step) {
        x = ox + radius * cos(a);
        y = oy + radius * sin(a);
        CGContextAddLineToPoint(ctx, x, y);
    };
    
    CGContextClosePath(ctx);
};

@interface NSColor (CGColor)
@property (nonatomic, readonly) CGColorRef CGColor;
@end

@implementation NSColor (CGColor)

- (CGColorRef)CGColor
{
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat *)&components];
    
    return CGColorCreate(colorSpace, components);
}

@end

@interface CircleView ()

@end

@implementation CircleView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.returnToOrigin = YES;
        _circleColor = [NSColor lightGrayColor];
        _backgroundColor = [NSColor clearColor];
        _circleRadius = 10;
        _circlePoint = NSMakePoint(floor(frameRect.size.width/2), floor(frameRect.size.height/2));
    }
    return self;
}

- (void)awakeFromNib {
    [self addObserver:self forKeyPath:@"self.circlePoint" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"self.circlePoint"]) {
        [self setNeedsDisplay:YES];
        
        NSPoint center = NSMakePoint(floor(self.frame.size.width/2), floor(self.frame.size.height/2));
        float xDiff = self.circlePoint.x - center.x;
        float yDiff = self.circlePoint.y - center.y;
        
        self.x = 3 * (xDiff / center.x);
        self.y = 3 * (yDiff / center.y);
        
        if ([self.delegate respondsToSelector:@selector(updateAccelerationWithX: andY:)]) {
            objc_msgSend(self.delegate, @selector(updateAccelerationWithX: andY:), self.x, self.y);
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext currentContext];
    CGContextRef zCgContextRef = (CGContextRef)[nsGraphicsContext graphicsPort];
    
    CGContextSetFillColorWithColor(zCgContextRef, [_backgroundColor CGColor]);
    CGContextFillRect(zCgContextRef, NSRectToCGRect(dirtyRect));
    
    CGContextSetStrokeColorWithColor(zCgContextRef, [_circleColor CGColor]);
    CGContextSetFillColorWithColor(zCgContextRef, [_circleColor CGColor]);
    CGContextBeginPath(zCgContextRef);
    CGContextAddCircle(zCgContextRef, _circlePoint.x, _circlePoint.y, _circleRadius);
    CGContextDrawPath(zCgContextRef, kCGPathFillStroke);
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    switch ([theEvent keyCode]) {
        case 126: { // up arrow
            [self moveYPointDelta:5];
        }
            break;
        case 125: { // down arrow
            [self moveYPointDelta:-5];
        }
            break;
        case 124: { // right arrow
            [self moveXPointDelta:5];
        }
            break;
        case 123: { // left arrow
            [self moveXPointDelta:-5];
        }
            break;
        case 48: {
            [self.window makeFirstResponder:self.nextKeyView];
        }
            break;
        default:
            break;
    }
}

- (BOOL)becomeFirstResponder {
    BOOL become = [super becomeFirstResponder];
    if (become) {
        self.circleColor = [NSColor darkGrayColor];
        [self setNeedsDisplay:YES];
    }
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    if (resign) {
        self.circleColor = [NSColor lightGrayColor];
        [self setNeedsDisplay:YES];
    }
    return resign;
}

- (void)keyUp:(NSEvent *)theEvent {
    switch ([theEvent keyCode]) {
        case 126:
        case 125:
        case 124:
        case 123: {
            if (self.returnToOrigin) {
                CGPoint a = self.circlePoint;
                CGPoint b = NSMakePoint(floor(self.frame.size.width/2), floor(self.frame.size.height/2));
                
                float deltaX = b.x - a.x;
                float deltaY = b.y - a.y;
                
                CGPoint p;
                
                for (float i = 0; i <= 1; i += 0.2) {
                    p.x = a.x + i * deltaX;
                    p.y = a.y + i * deltaY;
                    
                    self.circlePoint = p;
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)moveXPointDelta:(CGFloat)delta {
    if (_circlePoint.x + delta > self.frame.origin.x && _circlePoint.x + delta < self.frame.size.width) {
        self.circlePoint = NSMakePoint(_circlePoint.x + delta, _circlePoint.y);
    }
}

- (void)moveYPointDelta:(CGFloat)delta {
    if (_circlePoint.y + delta > self.frame.origin.y && _circlePoint.y + delta < self.frame.size.height) {
        self.circlePoint = NSMakePoint(_circlePoint.x, _circlePoint.y + delta);
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.circlePoint"];
    self.circleColor = nil;
}

@end
