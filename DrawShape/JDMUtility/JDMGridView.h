//
//  JDMGridView.h
//  DrawShape
//
//  Created by Justin Madewell on 1/20/15.
//  Copyright (c) 2015 Justin Madewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMGridView : UIView

@property (nonatomic, strong) NSMutableArray *dots;
@property CGFloat spacing;
@property CGFloat dotSize;
@property BOOL shouldSnap;

-(void)undoLastLine;

-(void)refreshLine;

-(void)changeSpacing:(CGFloat)newSpacing;

-(NSString*)gridStats;

-(UIBezierPath*)drawnPath;

-(NSMutableArray*)points;

@end
