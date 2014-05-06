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

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }


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

// Converts color code to appropriate card color (red, green, purple)
- (UIColor *) returnSelfColor
{
    if(self.color == 1) return [UIColor colorWithRed:1 green:0 blue:0 alpha:[self returnSelfShading]];
    if(self.color == 2) return [UIColor colorWithRed:0 green:1 blue:0 alpha:[self returnSelfShading]];
    if(self.color == 3) return [UIColor colorWithRed:1 green:0 blue:1 alpha:[self returnSelfShading]];
    return nil;
}

// Converts color code to appropriate stroke color
- (UIColor *) returnSelfStrokeColor
{
    if(self.color == 1) return [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    if(self.color == 2) return [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    if(self.color == 3) return [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
    return nil;
}

// Returns the proper shading for the card.
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

// Draws the shapes onto the card
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

// Draws 10 vertical stripes inside "path", which starts at "origin" and has a size of "size"
- (void)drawStripesWithPath:(UIBezierPath *)path
                   AtOrigin:(CGPoint)origin
                   WithSize:(CGSize)size
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [path addClip];
    CGContextSetLineWidth(context, 0.5);
    [[self returnSelfStrokeColor] set];
    
    for (CGFloat x = origin.x; x < origin.x + size.width; x += size.width/10) {
        CGContextMoveToPoint(context, x, origin.y);
        CGContextAddLineToPoint(context, x, origin.y + size.height);
    }
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

// Draws each object given its appropriate vertical offset
- (UIBezierPath *) getBezierPath:(CGFloat) y{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    if(self.symbol == 1){   //Draws a diamond
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
        
        if (self.shading == 2) {  //Draws stripes in the shape
            CGPoint origin = CGPointMake(width/2-widthRatio, y - heightRatio);
            CGSize size = CGSizeMake(widthRatio*2, heightRatio*2);
            [self drawStripesWithPath:setDiamond AtOrigin:origin WithSize:size];
        }
        
        return setDiamond;
        
    }
    else if(self.symbol == 2){      //Draws an oval
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
        
        if (self.shading == 2) {    //Draws stripes
            CGPoint origin = CGPointMake(width/2-widthRatio-heightRatio, y - heightRatio);
            CGSize size = CGSizeMake((widthRatio+heightRatio)*2, heightRatio*2);
            [self drawStripesWithPath:setOval AtOrigin:origin WithSize:size];
        }
        
        return setOval;
    }
    else if(self.symbol == 3){    //Draws a squiggle
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
        
        if (self.shading == 2) {    //Draws stripes
            CGPoint origin = CGPointMake(width/2-widthRatio-heightRatio, y - heightRatio-widthRatio);
            CGSize size = CGSizeMake((widthRatio+heightRatio)*2, (widthRatio+heightRatio)*2);
            [self drawStripesWithPath:setSquiggle AtOrigin:origin WithSize:size];
        }
        
        return setSquiggle;
        
    }
    return nil;
}


@end

