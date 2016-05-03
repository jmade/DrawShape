//
//  JDMCurveView.h
//  DrawShape
//
//  Created by Justin Madewell on 10/15/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMCurveView : UIView

@property int segments;

@property CGPoint curve_startPoint;
@property CGPoint curve_endPoint;
@property CGPoint curve_controlPoint1;
@property CGPoint curve_controlPoint2;

-(UIBezierPath*)getChamferProfilePath;

@end
