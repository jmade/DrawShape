//
//  JDMSCNVC.h
//  DrawShape
//
//  Created by Justin Madewell on 1/22/15.
//  Copyright (c) 2015 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMSCNVC : UIViewController

@property (nonatomic, strong) UIBezierPath *sentPath;
@property (nonatomic, strong) NSMutableArray *sentPoints;

@property (nonatomic, strong) UIBezierPath *chamferPath;

@property CGFloat chamferRadius;
@property CGFloat extrusionAmount;

@end
