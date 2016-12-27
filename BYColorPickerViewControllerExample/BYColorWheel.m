//
//  BYColorWheel.m
//  BYColorPickerViewControllerExample
//
//  Created by Berk Yuksel on 26/12/2016.
//  Copyright © 2016 Berk Yuksel. All rights reserved.
//

#import "BYColorWheel.h"

#pragma mark - Global Constants

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

#pragma mark - Private Interface

@interface BYColorWheel (){
    UIImageView *_wheelImgView;
    UIImageView *_crossHairImgView;
    float _indicatorAngle;
    BOOL _touching;
}

@end

@implementation BYColorWheel
@synthesize delegate;

#pragma mark - Initialization Methods

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    _touching = false;
    
    _wheelImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _wheelImgView.image = [self colorWheelImage];
    [self addSubview:_wheelImgView];
    
    UIImage *crossHairImg = [self crossHairImage];
    _crossHairImgView = [[UIImageView alloc] initWithImage:crossHairImg];
    [self addSubview:_crossHairImgView];
    
    _indicatorAngle = 0;
    [self placeCrosshair];
}

#pragma mark - Public Methods

- (void)prepare{
    
    _wheelImgView.frame = self.bounds;
    _crossHairImgView.frame = [self getCrossHairFrameFromCurrentRadius];
    [self placeCrosshair];
}

- (void)placeCrosshairByHue:(float)hue{
    
    _indicatorAngle = hue*360.0f;
    [self placeCrosshair];
}

#pragma  mark - Touch Event Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    float distance = sqrtf(powf(touchLocation.x-center.x, 2) + powf(touchLocation.y-center.y, 2));
    CGSize radius = [self getRadiusSizeFromCurrentBounds];
    
    if (distance >= radius.width && distance <= radius.height) {
        [self touchedWheelAt:touchLocation];
        _touching = true;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (!_touching) {
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self touchedWheelAt:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _touching = false;
}

- (void)touchedWheelAt:(CGPoint)touchLocation{
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat f = [self pointPairToBearingDegrees:center secondPoint:touchLocation];
    if ([self.delegate respondsToSelector:@selector(setHueFromColorWheel:)]) {
        [self.delegate setHueFromColorWheel:f/360.0f];
    }
    _indicatorAngle = f;
    [self placeCrosshair];
}

#pragma mark - Private Methods

- (void)placeCrosshair{
    
    float radians = DEGREES_TO_RADIANS(_indicatorAngle);
    CGSize radius = [self getRadiusSizeFromCurrentBounds];
    float distance = radius.width + (radius.height-radius.width)/2;
    CGPoint target = CGPointMake(distance*cosf(radians), distance*sinf(radians));
    CGPoint wheelCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _crossHairImgView.center = CGPointMake(wheelCenter.x+target.x, wheelCenter.y+target.y);
}

#pragma  mark - Mathematical Helpers

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (CGSize) getRadiusSizeFromCurrentBounds{
    
    CGSize size = self.bounds.size;
    float bigRadius = MIN(size.width, size.height)/2;
    return CGSizeMake(bigRadius/1.5f, bigRadius-1);
}

- (CGRect) getCrossHairFrameFromCurrentRadius{
    
    CGSize radius = [self getRadiusSizeFromCurrentBounds];
    float crossHairWH = (radius.height-radius.width)/3.0f;
    return CGRectMake(0, 0, crossHairWH, crossHairWH);
}

#pragma  mark - Visual Object Generation methods

- (UIImage*)crossHairImage{
    
    CGFloat lineWidth = 3.0f;
    
    CGRect crossHairFrame = [self getCrossHairFrameFromCurrentRadius];
    UIGraphicsBeginImageContextWithOptions(crossHairFrame.size, NO, 0.0);
    
    UIBezierPath *outerCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(crossHairFrame, 1+lineWidth, 1+lineWidth)];
    UIBezierPath *innerCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(crossHairFrame, 2*lineWidth, 2*lineWidth)];
    
    [outerCircle setLineWidth:lineWidth];
    [[UIColor blackColor] setStroke];
    [outerCircle stroke];
    
    [innerCircle setLineWidth:lineWidth];
    [[UIColor colorWithWhite:0.9 alpha:0.6] setStroke];
    [innerCircle stroke];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage*)colorWheelImage{
    
    CGSize size = self.bounds.size;
    CGSize radius = [self getRadiusSizeFromCurrentBounds];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
    
    
    int sectors = 180;
    float angle = 2 * M_PI/sectors;
    
    UIBezierPath *bezierPath;
    
    for (int i=0; i<sectors; i++) {
        
        CGPoint center = CGPointMake(size.width/2, size.height/2);
        bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius.height startAngle:i * angle endAngle:(i + 1) * angle clockwise:YES];
        [bezierPath addArcWithCenter:center radius:radius.width startAngle:(i+1)*angle endAngle:i*angle clockwise:NO];
        [bezierPath closePath];
        UIColor *color = [UIColor colorWithHue:((float)i)/sectors saturation:1. brightness:1. alpha:1];
        [color setFill];
        [color setStroke];
        [bezierPath fill];
        [bezierPath stroke];
    }
    
    UIColor *shadowColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    
    float circleInset = radius.height-radius.width;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 4), 6, shadowColor.CGColor);
    CGContextAddRect(context, self.bounds);
    CGContextAddEllipseInRect(context, CGRectInset(self.bounds, circleInset+3, circleInset+3));
    CGContextEOClip(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.0 alpha:0.6f].CGColor);
    CGContextFillEllipseInRect(context, CGRectInset(self.bounds, circleInset, circleInset));
    CGContextRestoreGState(context);
    
    CGPathRef innerShadowPath = CGPathCreateWithEllipseInRect(self.bounds, nil);
    [self drawInnerShadowInContext:context withPath:innerShadowPath shadowColor:shadowColor.CGColor offset:CGSizeMake(0, 4) blurRadius:6];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)drawInnerShadowInContext:(CGContextRef)context
                        withPath:(CGPathRef)path
                     shadowColor:(CGColorRef)shadowColor
                          offset:(CGSize)offset
                      blurRadius:(CGFloat)blurRadius {
    CGContextSaveGState(context);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    CGColorRef opaqueShadowColor = CGColorCreateCopyWithAlpha(shadowColor, 1.0);
    
    CGContextSetAlpha(context, CGColorGetAlpha(shadowColor));
    CGContextBeginTransparencyLayer(context, NULL);
    CGContextSetShadowWithColor(context, offset, blurRadius, opaqueShadowColor);
    CGContextSetBlendMode(context, kCGBlendModeSourceOut);
    CGContextSetFillColorWithColor(context, opaqueShadowColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextEndTransparencyLayer(context);
    
    CGContextRestoreGState(context);
    
    CGColorRelease(opaqueShadowColor);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
