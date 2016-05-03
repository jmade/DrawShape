//
//  JDMGridView.m
//  DrawShape
//
//  Created by Justin Madewell on 1/20/15.
//  Copyright (c) 2015 Justin Madewell. All rights reserved.
//

#import "JDMGridView.h"
#import "JDMUtility.h"

@interface JDMGridView ()
{
    UIBezierPath *myPath;
    NSMutableArray *xSort;
    NSMutableArray *ySort;
    BOOL areDotsDrawn;
    UIBezierPath *shapePath;
    NSMutableArray *pathPoints;
    CGFloat vOffset;
    CGFloat hOffset;

}
@end

@implementation JDMGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.dots = [[NSMutableArray alloc]init];
        pathPoints = [[NSMutableArray alloc]init];
        self.dotSize = 6.0;
        self.spacing = 44;
        areDotsDrawn = NO;
        shapePath = [UIBezierPath bezierPath];
        shapePath.lineCapStyle = kCGLineCapRound;
        shapePath.lineJoinStyle = kCGLineJoinRound;
        shapePath.lineWidth = self.spacing/5;
        [self findOffsets:frame Spacing:self.spacing];
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
      
    }
    return self;
}


#pragma mark - OutSide Calls

-(NSMutableArray *)points
{
    NSMutableArray *pointsArray = [[NSMutableArray alloc]init];
    
    for (int x=0; x<pathPoints.count-1; x++) {
        CGPoint point = [[pathPoints objectAtIndex:x] CGPointValue];
        [pointsArray insertObject:[NSValue valueWithCGPoint:[self scalePoint:point]] atIndex:x];
    }
    
    return pointsArray;
}

-(CGPoint)scalePoint:(CGPoint)point
{
    return CGPointMake(point.x/self.frame.size.width, point.y/self.frame.size.height);
}

-(UIBezierPath *)drawnPath
{
    return shapePath;
}

-(void)undoLastLine
{
     [self undoLastDrawnLine];
}

-(void)refreshLine
{
    [self eraseLine];
}

-(void)changeSpacing:(CGFloat)newSpacing
{
    self.spacing = newSpacing;
    [self findOffsets:self.frame Spacing:self.spacing];
    [self setNeedsDisplay];
}

-(NSString *)gridStats
{
    NSString *gridStats;
    
    NSString *dotCountString = [NSString stringWithFormat:@"%lu Dots",(unsigned long)self.dots.count];
    NSString *dimesionString = [NSString stringWithFormat:@"%iX%i",(int)sqrt(self.dots.count),(int)sqrt(self.dots.count)];
    
    gridStats = [NSString stringWithFormat:@"%@ - %@",dimesionString,dotCountString];
    
    return gridStats;
}
#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if (self.shouldSnap) {
        [self drawDotsInRect:rect];
        [self drawLine];
        [self fillinTappedDots];
    }
    else
    {
        [self drawLine];

    }
}


-(void)findOffsets:(CGRect)rect Spacing:(CGFloat)spacing
{
    CGFloat maxVertLines = (int)(rect.size.width/spacing);
    CGFloat gridWidth = maxVertLines * spacing ;
    CGFloat leftoverWidth = rect.size.width - gridWidth ;
    CGFloat horizontalLeadIn = leftoverWidth/2;
    hOffset = horizontalLeadIn;
    
    CGFloat maxHorizontalLines = (int)(rect.size.height/self.spacing);
    CGFloat gridHeight = maxHorizontalLines * self.spacing ;
    CGFloat leftoverHeight = rect.size.height - gridHeight ;
    CGFloat verticalLeadIn = leftoverHeight/2 ;
    vOffset = verticalLeadIn;

}

-(void)drawDotsInRect:(CGRect)rect
{
    CGFloat spacing = self.spacing;
    self.dots = [[NSMutableArray alloc]init];
    
    CGFloat Xsegments = (rect.size.width / spacing );
    CGFloat Ysegments = (rect.size.height / spacing );
    
    CGPoint dotPoint = CGPointMake(rect.origin.x, rect.origin.y);
    dotPoint = CGPointMake(rect.origin.x+hOffset, rect.origin.y+vOffset);
    
    for (int x=0; x<Xsegments; x++) {
        for (int y=0; y<Ysegments; y++) {
            
            [self paintDot:dotPoint];
            [self.dots addObject:[NSValue valueWithCGPoint:dotPoint]];
            CGPoint newYPoint = CGPointMake(dotPoint.x, dotPoint.y+spacing);
            dotPoint = newYPoint;
        }
        
        CGPoint newXPoint = CGPointMake(dotPoint.x+spacing, vOffset);
        dotPoint = newXPoint;
    }
    
    areDotsDrawn = YES;
}

-(void)fillinTappedDots
{
    for (NSValue *value in pathPoints) {
        
        CGPoint firstPoint = [value CGPointValue];
        CGFloat fds = self.dotSize*1.75;
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(firstPoint.x-(fds/2), firstPoint.y-(fds/2),fds,fds)];
        [[UIColor fuschiaColor] setFill];
        [dotPath fill];

    }
    
}

-(void)drawShapePath
{
    // Construct Path
    UIColor *pathColor = [UIColor purpleColor];
    CGFloat lineWidth = self.spacing/5;
    
    if (!self.shouldSnap) {
        pathColor = [UIColor blueberryColor];
        lineWidth = self.spacing/8;
    }
    
    UIBezierPath *tempPath = [UIBezierPath bezierPath];
    tempPath.lineCapStyle = kCGLineCapRound;
    tempPath.lineJoinStyle = kCGLineJoinRound;
    tempPath.lineWidth = lineWidth;
    
    NSInteger pathCount = pathPoints.count;
    for (int x=0; x<pathCount; x++) {
        
        CGPoint pathPoint = [[pathPoints objectAtIndex:x] CGPointValue];
        
        if (x==0) {
            
            [tempPath moveToPoint:pathPoint];
        }
        else
        {
            [tempPath addLineToPoint:pathPoint];
        }
    }
    

    [pathColor setStroke];
    [tempPath strokeWithBlendMode:kCGBlendModeMultiply alpha:0.50];

    shapePath = tempPath;
}

-(void)drawLine
{

    if (pathPoints.count == 1) {
        //
        CGFloat fds = self.dotSize*1.50;
        UIColor *fillColor = [UIColor lavenderColor];
        if (!self.shouldSnap) {
            fds = self.dotSize*0.75;
            fillColor = [UIColor pastelPurpleColor];
            
        }
        
        CGPoint firstPoint = [[pathPoints firstObject] CGPointValue];
        
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(firstPoint.x-(fds/2), firstPoint.y-(fds/2),fds,fds)];
        
        [fillColor setFill];
        [dotPath fill];
    }
    
    [self drawShapePath];
}

-(void)addPointToShapePath:(CGPoint)point
{
    [pathPoints addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}

-(BOOL)checkPathPoints:(CGPoint)pointToCheck
{
    BOOL isPointAlreadyInPath = NO;
    
    for (NSValue *value in pathPoints) {
        
        if (CGPointEqualToPoint(pointToCheck,[value CGPointValue])) {
            isPointAlreadyInPath = YES;
            NSLog(@"Point is In Path");
        }
    }
    
    return isPointAlreadyInPath;
}

-(void)eraseLine
{
    pathPoints = [[NSMutableArray alloc]init];
    [self setNeedsDisplay];
}

-(void)undoLastDrawnLine
{
    [pathPoints removeLastObject];
    [self setNeedsDisplay];
}





-(void)paintDot:(CGPoint)dotPoint
{
    UIColor *dotColor = [UIColor paleGreenColor];
    CGFloat dotSize = self.dotSize;
    
    if (!self.shouldSnap) {
        dotColor = [UIColor babyBlueColor];
        dotSize = self.dotSize * 0.75;
    }
    
    // make dot
    CGFloat dotRectX = dotPoint.x-dotSize/2;
    CGFloat dotRectY = dotPoint.y-dotSize/2;
    
    CGRect newDotRect = CGRectMake(dotRectX, dotRectY, dotSize, dotSize);
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:newDotRect];
    [dotColor setFill];
    [dotPath fill];
    //
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    
    if (self.shouldSnap) {
        
        [self findClosetDot:[mytouch locationInView:self]];
    }
    else
    {
        [self addPointToShapePath:[mytouch locationInView:self]];
        //[self setNeedsDisplay];

    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    
    if (self.shouldSnap) {
        
        [self findClosetDot:[mytouch locationInView:self]];
    }
    else
    {
        [self addPointToShapePath:[mytouch locationInView:self]];
    }

}


-(void)findClosetDot:(CGPoint)tappedLocation
{
    CGFloat tappedX = tappedLocation.x - (hOffset/2) ;
    CGFloat tappedY = tappedLocation.y  - (vOffset/2) ;
    
    CGFloat spacing = self.spacing ;
    CGFloat rounding = 0.5;
    
    CGFloat newX = ((tappedX / spacing) + rounding ) ;
    CGFloat newY = ((tappedY / spacing) + rounding) ;
    NSInteger xInt = (int)newX;
    NSInteger yInt = (int)newY;
    
    CGFloat gridX = xInt * spacing ;
    CGFloat gridY = yInt * spacing ;
    
    CGPoint snappedPoint = CGPointMake(gridX+hOffset,gridY+vOffset) ;
    [self addPointToShapePath:snappedPoint];
    [self setNeedsDisplay];
}



@end




