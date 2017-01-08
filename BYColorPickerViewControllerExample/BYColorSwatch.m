//
//  BYColorSwatch.m
//  BYColorPickerViewControllerExample
//
//  Created by Berk Yuksel on 26/12/2016.
//  Copyright © 2016 Berk Yuksel. All rights reserved.
//

#import "BYColorSwatch.h"
#import "BYGfxUtility.h"

@implementation BYColorSwatch
@synthesize color = _color;

#pragma  mark - Public Methods

- (void)setColor:(UIColor *)color{
    
    _color = color;
    [self setNeedsDisplay];
}

#pragma  mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    float strokeSize = 1.0f;    
    
    CGContextAddEllipseInRect(context, CGRectInset(self.bounds, strokeSize, strokeSize));
    if (_color) {
        CGContextSetFillColorWithColor(context, _color.CGColor);
        CGContextFillPath(context);
    }
    
    CGContextSetLineWidth(context, strokeSize);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectInset(self.bounds, strokeSize, strokeSize));
    
    UIColor *shadowColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    CGPathRef innerShadowPath = CGPathCreateWithEllipseInRect(CGRectInset(self.bounds, strokeSize, strokeSize), nil);
    
    [BYGfxUtility drawInnerShadowInContext:context withPath:innerShadowPath shadowColor:shadowColor.CGColor offset:CGSizeMake(0, 2) blurRadius:3];
    CGContextRestoreGState(context);
}

@end
