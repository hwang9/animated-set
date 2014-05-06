//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Jed Tan on 5/5/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation SetCardView

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
//#define CORNER_LINE_SPACING_REDUCTION 0.25

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
//- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0;}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    if (self.chosen)
        [[UIColor yellowColor] setFill];
    else
        [[UIColor whiteColor] setFill];
    
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawShapes];
}

/*- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}*/

- (UIColor *) returnSelfColor
{
    if(self.color == 1) return [UIColor colorWithRed:1 green:0 blue:0 alpha:[self returnSelfShading]];
    if(self.color == 2) return [UIColor colorWithRed:0 green:1 blue:0 alpha:[self returnSelfShading]];
    if(self.color == 3) return [UIColor colorWithRed:1 green:0 blue:1 alpha:[self returnSelfShading]];
    return nil;
}

- (UIColor *) returnSelfStrokeColor
{
    if(self.color == 1) return [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    if(self.color == 2) return [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    if(self.color == 3) return [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
    return nil;
}

- (CGFloat) returnSelfShading
{
    if (self.shading == 1) return 0.0;
    if (self.shading == 2) return 0.0;
    if (self.shading == 3) return 1.0;
    return -1.0;
}


#pragma mark - Pips

#define DIAMOND_HEIGHT_RATIO 0.200
#define TRIANGLE_HEIGHT_RATIO 0.200
#define RECTANGLE_WIDTH_RATIO 0.250
#define RECTANGLE_HEIGHT_RATIO 0.150
#define CONTROL_POINT_RATIO 2

- (void)drawShapes
{
    
    CGFloat height = self.bounds.size.height;
    
    NSMutableArray * paths = [[NSMutableArray alloc]init];
    
    for(int i = 1; i <= self.number; i++){
        CGFloat y = (height / (self.number + 1)) * i;
        UIBezierPath *setPip = [self getBezierPath:y];
        if(setPip != nil) [paths addObject: setPip];
    }
    for(UIBezierPath* pip in paths){
        [[self returnSelfColor] setFill];
        [pip fill];
        
        [[self returnSelfStrokeColor] setStroke];
        [pip stroke];
    }
    
    
    
}

- (UIBezierPath *) getBezierPath:(CGFloat) y{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if(self.symbol == 1){
        UIBezierPath *setDiamond = [UIBezierPath bezierPath];
        
        CGFloat widthRatio = DIAMOND_HEIGHT_RATIO * width * 1.5;
        CGFloat heightRatio = DIAMOND_HEIGHT_RATIO * height / 2;
        
        CGPoint firstPoint = CGPointMake(width/2, y + heightRatio);
        CGPoint secondPoint = CGPointMake(width/2 - widthRatio, y);
        CGPoint thirdPoint = CGPointMake(width/2, y - heightRatio);
        CGPoint fourthPoint = CGPointMake(width/2 + widthRatio, y);
        
        [setDiamond moveToPoint:firstPoint];
        [setDiamond addLineToPoint:secondPoint];
        [setDiamond addLineToPoint:thirdPoint];
        [setDiamond addLineToPoint:fourthPoint];
        [setDiamond closePath];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        [setDiamond addClip];
        
        if (self.shading == 2) {
            CGContextSetLineWidth(context, 0.5);
            [[self returnSelfStrokeColor] set];
            for (CGFloat x = width/2 - widthRatio; x < width/2 + widthRatio; x += widthRatio/5) {
                CGContextMoveToPoint(context, x, y - heightRatio);
                CGContextAddLineToPoint(context, x, y + heightRatio);
            }
        }
        
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        return setDiamond;
        
    }
    else if(self.symbol == 2){
        UIBezierPath *setOval = [UIBezierPath bezierPath];
        setOval.lineJoinStyle = kCGLineJoinRound;
        
        CGFloat widthRatio = RECTANGLE_WIDTH_RATIO * height / 2;
        CGFloat heightRatio = RECTANGLE_HEIGHT_RATIO * height / 2;
        
        CGPoint firstPoint = CGPointMake(width/2 - widthRatio, y + heightRatio);
        CGPoint firstCenter = CGPointMake(width/2 - widthRatio, y);
        CGPoint secondCenter = CGPointMake(width/2 + widthRatio, y);
        [setOval moveToPoint:firstPoint];
        [setOval addArcWithCenter:firstCenter radius:heightRatio startAngle: M_PI/2 endAngle: 3 * M_PI/2 clockwise:true];
        [setOval addArcWithCenter:secondCenter radius:heightRatio startAngle: 3 * M_PI/2 endAngle: M_PI/2 clockwise:true];
        [setOval closePath];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        [setOval addClip];
        
        if (self.shading == 2) {
            CGContextSetLineWidth(context, 0.5);
            [[self returnSelfStrokeColor] set];
            for (CGFloat x = width/2 - widthRatio - heightRatio; x < width/2 + widthRatio + heightRatio; x += widthRatio/3) {
                CGContextMoveToPoint(context, x, y - heightRatio);
                CGContextAddLineToPoint(context, x, y + heightRatio);
            }
        }
        
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        return setOval;
    }
    else if(self.symbol == 3){
        UIBezierPath *setSquiggle = [UIBezierPath bezierPath];
        
        CGFloat widthRatio = RECTANGLE_WIDTH_RATIO * height / 2;
        CGFloat heightRatio = RECTANGLE_HEIGHT_RATIO * height / 2;
        
        CGPoint firstCenter = CGPointMake(width/2 - widthRatio, y);
        CGPoint secondCenter = CGPointMake(width/2 + widthRatio, y);
        
        CGPoint secondPoint = CGPointMake(width/2 + widthRatio, y - heightRatio);
        CGPoint thirdPoint = CGPointMake(width/2 - widthRatio, y + heightRatio);
        
        CGPoint firstControl = CGPointMake(width/2 - widthRatio, y - heightRatio + widthRatio);
        CGPoint secondControl = CGPointMake(width/2 + widthRatio, y - heightRatio - widthRatio);
        
        CGPoint thirdControl = CGPointMake(width/2 - widthRatio, y + heightRatio + widthRatio);
        CGPoint fourthControl = CGPointMake(width/2 + widthRatio, y + heightRatio - widthRatio);
        
        [setSquiggle addArcWithCenter:firstCenter radius:heightRatio startAngle: M_PI/2 endAngle: 3 * M_PI/2 clockwise:true];
        [setSquiggle addCurveToPoint:secondPoint controlPoint1:firstControl controlPoint2:secondControl];
        [setSquiggle addArcWithCenter:secondCenter radius:heightRatio startAngle: 3 * M_PI/2 endAngle: M_PI/2 clockwise:true];
        [setSquiggle addCurveToPoint:thirdPoint controlPoint1:fourthControl controlPoint2:thirdControl];
        [setSquiggle closePath];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        [setSquiggle addClip];
        
        if (self.shading == 2) {
            CGContextSetLineWidth(context, 0.5);
            [[self returnSelfStrokeColor] set];
            for (CGFloat x = width/2 - widthRatio - heightRatio; x < width/2 + widthRatio + heightRatio; x += widthRatio/3) {
                CGContextMoveToPoint(context, x, y - heightRatio - widthRatio);
                CGContextAddLineToPoint(context, x, y + heightRatio + widthRatio);
            }
        }
        
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        /*if (self.shading == 2) {
            CGPoint start = CGPointMake(width/2 + widthRatio + heightRatio/2, y + heightRatio*0.707);
            CGPoint end = CGPointMake(width/2 + widthRatio + heightRatio/2, y - heightRatio*0.707);
            [setOval moveToPoint:start];
            [setOval addLineToPoint:end];
        }*/
        
        return setSquiggle;
        
    }
    return nil;
    
    
}








@end

