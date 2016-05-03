//
//  JDMCurveView.m
//  DrawShape
//
//  Created by Justin Madewell on 10/15/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import "JDMCurveView.h"
#import "JDMUtility.h"

@interface JDMCurveView ()
{
    UILabel *control1Label;
    UILabel *control2Label;
}

@end

@implementation JDMCurveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor clearColor];
        self.segments = 5;
        self.curve_startPoint = CGPointZero;
        self.curve_endPoint = CGPointMake(self.frame.size.width, self.frame.size.height);
        self.curve_controlPoint1 = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        self.curve_controlPoint2 = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        
        
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setupLabel];
    //-1-Draw Grid background, lines, grid spacing, color, thickness
    [self drawBackGroundGridAtSizing:self.segments];
    //-2-Draw Curve
    [self drawCurve];
}


-(void)setupLabel
{
    static int checker;
    
    if (checker == 0) {
        control1Label = [self makeControlLabel];
        control2Label = [self makeControlLabel];
    }
    
    checker++;
    
}


-(UILabel*)makeControlLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    label.text = @"";//@"0.500,0.500";
    
    [self addSubview:label];
    
    return label;
    
    
}



#pragma mark - CURVE

-(void)drawCurve
{
    // drawing the actual path
    [self drawCurvePath];
    // drawing the controls aroud the controlPoints
    
    
    // drawing lines connecting the control points to thier values
    [self drawLineToControlPoint1];
    [self drawLineToControlPoint2];
    
    // drawing around the start and end points?
    
    [self paintDot:self.curve_startPoint color:[UIColor redColor]];
    [self paintDot:self.curve_endPoint color:[UIColor redColor]];
    
    [self paintDot:self.curve_controlPoint1 color:[UIColor greenColor]];
    [self paintDot:self.curve_controlPoint2 color:[UIColor greenColor]];
}

-(void)drawLineToControlPoint1
{
    UIBezierPath *controlLine1 = [UIBezierPath bezierPath];
    
    [controlLine1 moveToPoint:self.curve_startPoint];
    [controlLine1 addLineToPoint:self.curve_controlPoint1];
    
    CGFloat dashPattern[] = {6,2};
    [controlLine1 setLineDash:dashPattern count:2 phase:0];
    
    controlLine1.lineWidth = 4.0;

    
    UIColor *curveColor = [UIColor orangeColor];
    
    [curveColor setStroke];
    [controlLine1 stroke];
}

-(void)drawLineToControlPoint2
{
    UIBezierPath *controlLine1 = [UIBezierPath bezierPath];
    
    [controlLine1 moveToPoint:self.curve_endPoint];
    [controlLine1 addLineToPoint:self.curve_controlPoint2];
    
    controlLine1.lineWidth = 4.0;

    
    CGFloat dashPattern[] = {6,2};
    [controlLine1 setLineDash:dashPattern count:2 phase:0];
    
    UIColor *curveColor = [UIColor orangeColor];
    
    [curveColor setStroke];
    [controlLine1 stroke];
}




-(CGPoint)conversionForControlPoint1
{
    CGFloat newX = 1 - ValueInRemappedRangeDefinedByOldMinAndMaxToNewMinAndMax(self.curve_controlPoint1.x, self.frame.size.width, 0, 0, 1.0);
    CGFloat newY = 1 - ValueInRemappedRangeDefinedByOldMinAndMaxToNewMinAndMax(self.curve_controlPoint1.y, 0, self.frame.size.height, 0, 1.0);
    
   return CGPointMake(newX, newY);
}


-(CGPoint)conversionForControlPoint2
{
    CGFloat newX = 1 - ValueInRemappedRangeDefinedByOldMinAndMaxToNewMinAndMax(self.curve_controlPoint2.x, self.frame.size.width, 0, 0, 1.0);
    CGFloat newY = 1 - ValueInRemappedRangeDefinedByOldMinAndMaxToNewMinAndMax(self.curve_controlPoint2.y, 0, self.frame.size.height, 0, 1.0);
    
    
    
    return CGPointMake(newX, newY);
}


-(NSString*)readoutForControlPoint1
{
    CGFloat x = [self conversionForControlPoint1].x;
    CGFloat y = [self conversionForControlPoint1].y;
    
    NSString *string = [NSString stringWithFormat:@"%@,%@",floatString(x),floatString(y)];

    return string;
}

-(NSString*)readoutForControlPoint2
{
    CGFloat x = [self conversionForControlPoint2].x;
    CGFloat y = [self conversionForControlPoint2].y;
    
    NSString *string = [NSString stringWithFormat:@"%@,%@",floatString(x),floatString(y)];
    
    return string;
}






-(void)drawCurvePath
{
    
    UIBezierPath *curvePath = [self makeCurve];
    UIColor *curveColor = [UIColor blueColor];
    
    [curveColor setStroke];
    [curvePath stroke];
}



-(UIBezierPath*)makeCurve
{
    UIBezierPath *curvePath = [UIBezierPath bezierPath];
    
    curvePath.lineWidth = ((self.frame.size.width*0.5) / self.segments) * 0.35;
    
    [curvePath moveToPoint:self.curve_startPoint];
    [curvePath addCurveToPoint:self.curve_endPoint controlPoint1:self.curve_controlPoint1 controlPoint2:self.curve_controlPoint2];
    
    return curvePath;
}


-(UIBezierPath*)getChamferProfilePath
{
    UIBezierPath *chamferProfilePath = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(1, 0);
    CGPoint endPoint = CGPointMake(0, 1);
    
    CGPoint control1 = [self conversionForControlPoint1];
    CGPoint control2 = [self conversionForControlPoint2];
    
    CGPoint fixedC1 = CGPointMake(fabs(control1.x), fabs(control1.y));
    CGPoint fixedC2 = CGPointMake(fabs(control2.x), fabs(control2.y));
    
    [chamferProfilePath moveToPoint:endPoint];
    [chamferProfilePath addCurveToPoint:startPoint controlPoint1:fixedC2 controlPoint2:fixedC1];
    
    return chamferProfilePath;
}




#pragma mark - Touches

-(void)updateTouchedLocation:(CGPoint)touchPoint
{
   
    CGFloat c1= PointDistanceFromPoint(touchPoint, self.curve_controlPoint1);
    CGFloat c2 = PointDistanceFromPoint(touchPoint, self.curve_controlPoint2);
    
    if (c1<c2) {
        self.curve_controlPoint1 = touchPoint;
        control1Label.text = [self readoutForControlPoint1];
        control1Label.center = CGPointMake(self.curve_controlPoint1.x,  self.curve_controlPoint1.y - 28);
    }
    else
    {
        self.curve_controlPoint2 = touchPoint;
        control2Label.text = [self readoutForControlPoint2];
        control2Label.center = CGPointMake(self.curve_controlPoint2.x,  self.curve_controlPoint2.y - 28);
    }
    
    
    

    [self setNeedsDisplay];
}





-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint touchLocatoion = [mytouch locationInView:self];
    
    [self updateTouchedLocation:touchLocatoion];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint touchLocatoion = [mytouch locationInView:self];
    
    [self updateTouchedLocation:touchLocatoion];

}







#pragma mark - BACKGROUND GRID


-(void)drawBackGroundGridAtSizing:(int)segments
{
    UIBezierPath *backgroundGridPath = [self makePathForBackgroundGridAtSizing:segments];
    
    UIColor *gridColor = [UIColor black25PercentColor];
    
    
    [gridColor setStroke];
    [backgroundGridPath stroke];
    
}

-(UIBezierPath*)makePathForBackgroundGridAtSizing:(int)segments
{
    CGFloat lineInterval = (self.frame.size.width*0.5) / segments;
    
    UIBezierPath *verticalLines = [UIBezierPath bezierPath];
    
    // startiing at 0,0 going left to right on x we would add lineInterval to the X coord and then draw a straight line down from top to bottom x coor plus height
    
    CGPoint startPoint;
    CGPoint endPoint;
    
    for (int i=0; i<= segments*2; i++) {
        // make a line
        CGFloat x = lineInterval * i;
        
        startPoint = CGPointMake(x, 0);
        endPoint = CGPointMake(x, self.frame.size.height);
        
        UIBezierPath *lineSegmentPath = [UIBezierPath bezierPath];
        [lineSegmentPath moveToPoint:startPoint];
        [lineSegmentPath addLineToPoint:endPoint];
        
        [verticalLines appendPath:lineSegmentPath];
    }
    
    UIBezierPath *horzontalLines = PathByApplyingTransform(verticalLines, CGAffineTransformMakeRotation(RadiansFromDegrees(90)));
    
    [verticalLines appendPath:horzontalLines];
    
    return verticalLines;
    
}

-(void)paintDot:(CGPoint)dotPoint color:(UIColor*)dotColor
{
    CGFloat dotSize = (((self.frame.size.width*0.5) / self.segments) * 0.35) * 2;
    
    // make dot
    CGFloat dotRectX = dotPoint.x-dotSize/2;
    CGFloat dotRectY = dotPoint.y-dotSize/2;
    
    CGRect newDotRect = CGRectMake(dotRectX, dotRectY, dotSize, dotSize);
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:newDotRect];
    
    [[UIColor blackColor] setStroke];
    [dotPath stroke];
    
    [dotColor setFill];
    [dotPath fill];
    
    
    
    //
}




@end
