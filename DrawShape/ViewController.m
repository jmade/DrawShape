//
//  ViewController.m
//  DrawShape
//
//  Created by Justin Madewell on 1/20/15.
//  Copyright (c) 2015 Justin Madewell. All rights reserved.
//

#import "ViewController.h"
#import "JDMGridView.h"
#import "JDMUtility.h"
//#import "Tools.h"
#import "JDMSCNVC.h"
#import "CustomSegue.h"
#import "CustomUnwindSegue.h"
#import "JDMCurveView.h"


@interface ViewController ()
{
    JDMGridView *gridView;
    UIView *controlsView;
    NSString *sliderValueString;
    UILabel *sliderLabel;
    UILabel *exSliderLabel;
    UILabel *chamSliderLabel;
    JDMSCNVC *scnVC;
    UISlider *gridSlider;
    CGFloat  chamferRadius;
    CGFloat extrusionAmount;
    UISwitch *snapSwitch;
    UISwitch *chamferSwitch;
    JDMCurveView *curveView;
    CGPoint centerPoint;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGSize gridSize = CGSizeMake(ScreenWidth(), ScreenWidth());
    CGFloat gridRectY = (ScreenHeight()-ScreenWidth())/2;
    
    CGRect gridFrame = CGRectMake(0, gridRectY, gridSize.width, gridSize.height);
    
    
    gridView = [[JDMGridView alloc]initWithFrame:CGRectMake(0, gridRectY, gridSize.width, gridSize.height)];
    gridView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:gridView];
    
    
    
    
    //
    
    
    [self loadControlsView];
    [self makeGridSlider];
    [self makeExtrusionSlider];
    [self makeChamSlider];
    [self makeSnapSwitch];
    [self makeCurveSwitch];
    
    
    // NEW CURVE Grid--
    curveView = [[JDMCurveView alloc]initWithFrame:gridFrame];
    [self.view addSubview:curveView];
    
    
    CGPoint center = RectGetCenter(curveView.frame);
    centerPoint = center;
    
    // move to out of frame
    curveView.center = CGPointMake(center.x + ScreenWidth(), center.y);

    
    
    [snapSwitch setOn:YES animated:YES];
    [self snapSwitchAction:snapSwitch];
}



-(void)animateCurveViewIn
{
   
    CGPoint newGridCenter = CGPointMake(centerPoint.x - ScreenWidth(), centerPoint.y);
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.78 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        //
        
        curveView.center = centerPoint;
        gridView.center = newGridCenter;
        
        
    } completion:^(BOOL finished) {
        //
    }];
    
    
    
    
}

-(void)animateCurveViewOut
{
       CGPoint newCurveCenter = CGPointMake(centerPoint.x + ScreenWidth(), centerPoint.y);
   
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.78 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        curveView.center = newCurveCenter;
        gridView.center = centerPoint;
//
        
        
    } completion:^(BOOL finished) {
        //
    }];
    

    

}

-(void)loadControlsView
{
    CGFloat segmentWidth = gridView.frame.size.width/3;
    CGFloat controlHeight = gridView.frame.size.height/5;
    
    
    CGFloat controlViewY = self.view.frame.size.height - controlHeight;
    CGRect controlFrame = CGRectMake(0, controlViewY, gridView.frame.size.width, controlHeight);
    UIView *controlView = [[UIView alloc]initWithFrame:controlFrame];
    // firstButton
    CGRect firstFrame = CGRectMake(0, 0, segmentWidth, controlHeight);
    UIView *firstButton = [[UIView alloc]initWithFrame:firstFrame];
    firstButton.backgroundColor = [UIColor plumColor];
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:firstButton.frame];
    firstLabel.textAlignment = NSTextAlignmentCenter ;
    firstLabel.text = @"UNDO" ;
    firstLabel.textColor = [UIColor whiteColor];
    [firstButton addSubview:firstLabel];
    [controlView addSubview:firstButton];
    
    //second
    
    CGRect secondFrame = CGRectMake(segmentWidth, 0, segmentWidth, controlHeight);
    UIView *secondButton = [[UIView alloc]initWithFrame:secondFrame];
    secondButton.backgroundColor = [UIColor moneyGreenColor];
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, secondButton.frame.size.width, secondButton.frame.size.height)];
    secondLabel.textAlignment = NSTextAlignmentCenter ;
    secondLabel.text = @"CLEAR" ;
    secondLabel.textColor = [UIColor whiteColor];
    [secondButton addSubview:secondLabel];
    [controlView addSubview:secondButton];
    
    //third
    
    CGRect thirdFrame = CGRectMake((segmentWidth*2), 0, segmentWidth, controlHeight);
    UIView *thirdButton = [[UIView alloc]initWithFrame:thirdFrame];
    thirdButton.backgroundColor = [UIColor palePurpleColor];
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, thirdButton.frame.size.width, thirdButton.frame.size.height)];
    thirdLabel.textAlignment = NSTextAlignmentCenter ;
    thirdLabel.text = @"3D" ;
    thirdLabel.textColor = [UIColor whiteColor];
    [thirdButton addSubview:thirdLabel];
    [controlView addSubview:thirdButton];
    
    [self.view addSubview:controlView];
    
    controlsView = controlView;
    
    
}

-(void)makeGridSlider
{

    CGFloat sliderHeight = 30;
    CGSize sliderSize = CGSizeMake(ScreenWidth()/2, sliderHeight);
    CGFloat sliderIndent = ScreenWidth() - sliderSize.width ;
    CGFloat gridSliderY = controlsView.frame.origin.y - 35;
    
    CGRect sliderFrame = CGRectMake(sliderIndent/2, gridSliderY,sliderSize.width,sliderSize.height);
    
    gridSlider = [[UISlider alloc]initWithFrame:sliderFrame];
    gridSlider.minimumValue = 5.0 ;
    gridSlider.maximumValue = 150.0 ;
    gridSlider.continuous = YES;
    gridSlider.value = 44.0;
    gridSlider.minimumTrackTintColor = [UIColor moneyGreenColor];
    
    [gridSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:gridSlider];
    
    
    
    
    
    CGFloat labelY = sliderFrame.origin.y - 30;
    sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, labelY, ScreenWidth(), 20) ];
    sliderLabel.textAlignment = NSTextAlignmentCenter;
    sliderLabel.textColor = [UIColor blackColor];
    sliderLabel.text =  @"44 - 9X9 - 81 Dots";
    [self.view addSubview:sliderLabel];
    [gridSlider setValue:44.0 animated:YES];
    
    if (!snapSwitch.isOn) {
        gridSlider.hidden = YES;
        sliderLabel.hidden = YES;
    }
    
    
    
    
    
}
-(void)makeChamSlider
{
    CGFloat chamSliderHeight = 30;
    CGSize chamSliderSize = CGSizeMake(ScreenWidth()/2, chamSliderHeight);
    CGFloat chamSliderIndent = ScreenWidth() - chamSliderSize.width ;
    CGFloat chamSliderY = exSliderLabel.frame.origin.y-30;
    
    CGRect chamSliderFrame = CGRectMake(chamSliderIndent/2, chamSliderY,chamSliderSize.width,chamSliderSize.height);
    
    UISlider *chamSlider = [[UISlider alloc]initWithFrame:chamSliderFrame];
    chamSlider.minimumValue = 0.00 ;
    chamSlider.maximumValue = 1.01 ;
    chamSlider.continuous = YES;
    chamSlider.value = 0.00;
    chamferRadius =  chamSlider.value;
    chamSlider.minimumTrackTintColor = [UIColor pastelPurpleColor];
    
    [chamSlider addTarget:self action:@selector(chamSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:chamSlider];
    
    CGFloat labelY = chamSliderFrame.origin.y - 25;
    chamSliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, labelY, ScreenWidth(), 20) ];
    chamSliderLabel.textAlignment = NSTextAlignmentCenter;
    chamSliderLabel.textColor = [UIColor blackColor];
    chamSliderLabel.text =  @"Chamfer OFF";
    [self.view addSubview:chamSliderLabel];
}

-(void)makeExtrusionSlider
{
    CGFloat exSliderHeight = 30;
    CGSize exSliderSize = CGSizeMake(ScreenWidth()/2, exSliderHeight);
    CGFloat exSliderIndent = ScreenWidth() - exSliderSize.width ;
    CGFloat exSliderY = gridView.frame.origin.y - 35;
    
    CGRect exSliderFrame = CGRectMake(exSliderIndent/2, exSliderY,exSliderSize.width,exSliderSize.height);
    
    UISlider *exSlider = [[UISlider alloc]initWithFrame:exSliderFrame];
    exSlider.minimumValue = 0.00 ;
    exSlider.maximumValue = 1.01 ;
    exSlider.continuous = YES;
    exSlider.value = 0.15;
    extrusionAmount = exSlider.value;
    exSlider.minimumTrackTintColor = [UIColor fuschiaColor];
    
    [exSlider addTarget:self action:@selector(exSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:exSlider];
    
    CGFloat labelY = exSliderFrame.origin.y - 25;
    exSliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, labelY, ScreenWidth(), 20) ];
    exSliderLabel.textAlignment = NSTextAlignmentCenter;
    exSliderLabel.textColor = [UIColor blackColor];
    exSliderLabel.text =  @"Extrusion: 0.15";
    [self.view addSubview:exSliderLabel];
}

-(void)makeSnapSwitch
{
    
    CGFloat y = (gridView.frame.origin.y - 95)/2;
    CGRect switchFrame = CGRectMake(10, 60, 20, 20);
    snapSwitch = [[UISwitch alloc]initWithFrame:switchFrame];
    [snapSwitch addTarget:self action:@selector(snapSwitchAction:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:snapSwitch];
    
    CGFloat labelY = switchFrame.origin.y - 25;
    UILabel *switchLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, labelY, 75, 20) ];
    switchLabel.textAlignment = NSTextAlignmentLeft;
    switchLabel.textColor = [UIColor blackColor];
    switchLabel.text =  @"SNAP";
    [self.view addSubview:switchLabel];
    
}

-(void)makeCurveSwitch
{
    
    // CGFloat y = (gridView.frame.origin.y - 95)/2;
    CGRect chamferFrame = CGRectMake(self.view.frame.size.width - 60, 60, 20, 20);
    chamferSwitch = [[UISwitch alloc]initWithFrame:chamferFrame];
    [chamferSwitch addTarget:self action:@selector(chamferSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:chamferSwitch];
    
    CGFloat labelY = chamferFrame.origin.y - 25;
    UILabel *switchLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, labelY, 75, 20) ];
    switchLabel.textAlignment = NSTextAlignmentLeft;
    switchLabel.textColor = [UIColor blackColor];
    switchLabel.text =  @"Chamfer";
    [self.view addSubview:switchLabel];

    
    
}

-(void)chamferSwitchAction:(id)sender
{
    UISwitch *theSwitch = (UISwitch*)sender;
    if (theSwitch.isOn) {
      NSLog(@"Chamfer Mode ON");
        [self animateCurveViewIn];
    }
    else
    {
        NSLog(@"Chamfer Mode OFF");
        [self animateCurveViewOut];
    }

}



-(void)snapSwitchAction:(id)sender
{
    UISwitch *theSwitch = (UISwitch*)sender;
    if (theSwitch.isOn) {
        gridView.shouldSnap = YES;
        //sliderLabel.text = [self gridSliderString];
        gridSlider.hidden = NO;
        sliderLabel.hidden = NO;
    }
    else
    {
        gridView.shouldSnap = NO;
        //sliderLabel.text = @"";
        gridSlider.hidden = YES;
        sliderLabel.hidden = YES;
    }
    [gridView setNeedsDisplay];
}

-(void)chamSliderAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    chamferRadius = slider.value;
    chamSliderLabel.text = [NSString stringWithFormat:@"Chamfer: %@",floatString(slider.value)];
}

-(void)exSliderAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    extrusionAmount = slider.value;
    exSliderLabel.text = [NSString stringWithFormat:@"Extrusion: %@",floatString(slider.value)];
}


-(NSString*)gridSliderString
{
    
    NSString *spacingString = [NSString stringWithFormat:@"%i",(int)gridSlider.value];
    NSString *gridString = [NSString stringWithFormat:@"%@ - %@",spacingString,[gridView gridStats]];
    return gridString;
}


-(void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    
    NSString *spacingString = [NSString stringWithFormat:@"%i",(int)slider.value];
    NSString *labelString = [NSString stringWithFormat:@"%@ - %@",spacingString,[gridView gridStats]];
    sliderLabel.text = labelString ;
    [gridView changeSpacing:slider.value];
    //-- Do further actions
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint touchPoint = [mytouch locationInView:self.view];
    
    if (touchPoint.y > controlsView.frame.origin.y && touchPoint.y < controlsView.frame.origin.y + controlsView.frame.size.height) {
        
        [self handleControlTouch:touchPoint];
        
    }
    
    
    
    
}

-(void)handleControlTouch:(CGPoint)touchPoint
{
    // NSLog(@"Touch is Inside of Control");
    
    NSInteger count = controlsView.subviews.count;
    NSLog(@"count: %lu",(unsigned long)count);
    
    CGFloat buttonSize = controlsView.frame.size.width/3;
    
    if (touchPoint.x < buttonSize) {
        // first Button
        [gridView undoLastLine];
        
    }
    if (touchPoint.x > buttonSize && touchPoint.x < (buttonSize*2)) {
        // Second Button
        [gridView refreshLine];
        
    }
    if (touchPoint.x > (buttonSize*2)) {
        // third button
        [self performSegueWithIdentifier:@"CustomSegue" sender:self];
    }
}

-(UIBezierPath*)gridPath
{
    UIBezierPath *path = [gridView drawnPath];
    [path closePath];
    
    return path;
    
}

// Prepare for the segue going forward
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue isKindOfClass:[CustomSegue class]]) {
        // Set the start point for the animation to center of the button for the animation
        ((CustomSegue *)segue).originatingPoint = self.view.center;
        [[segue destinationViewController] setSentPath:[self gridPath]];
        [[segue destinationViewController] setSentPoints:[gridView points]];
        [[segue destinationViewController] setExtrusionAmount:extrusionAmount];
        [[segue destinationViewController] setChamferRadius:chamferRadius];
        UIBezierPath *chamfPath = [curveView getChamferProfilePath];
        [[segue destinationViewController] setChamferPath:chamfPath];

        
    }
}

// We need to over-ride this method from UIViewController to provide a custom segue for unwinding
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    // Instantiate a new CustomUnwindSegue
    CustomUnwindSegue *segue = [[CustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    // Set the target point for the animation to the center of the button in this VC
    segue.targetPoint = self.view.center;
    return segue;
}

- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
