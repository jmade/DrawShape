//
//  JDMSCNVC.m
//  DrawShape
//
//  Created by Justin Madewell on 1/22/15.
//  Copyright (c) 2015 Justin Madewell. All rights reserved.
//

#import "JDMUtility.h"
#import "JDMSCNVC.h"
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>



@interface JDMSCNVC ()
{
    SCNView *mySceneView;
    SCNNode *myShape;
}

@end

@implementation JDMSCNVC



-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGSize sceneSize = CGSizeMake(ScreenWidth(), ScreenWidth());
    CGFloat sceneViewY = (self.view.frame.size.height - sceneSize.height) / 2 ;
    CGRect sceneRect = CGRectMake(0, sceneViewY, sceneSize.width,sceneSize.height);
    mySceneView = [[SCNView alloc]initWithFrame:sceneRect];
    
    // create a new scene
    SCNScene *scene = [SCNScene scene];
    [self lights:scene];
    [self camera:scene];
    [self action:scene];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)mySceneView;
    
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = NO;
    
    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:mySceneView];
    
    
}


-(SCNNode*)compliePathNode
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    for (int x=0; x<=self.sentPoints.count-1; x++) {
        
        CGPoint pathPoint = [[self.sentPoints objectAtIndex:x] CGPointValue];
        
        if (x == 0) {
            [path moveToPoint:pathPoint];
        }
        else
        {
            [path addLineToPoint:pathPoint];
        }
    }
    
    [path closePath];
    
    MirrorPathVertically(path);
    
    path.flatness = 5.0;
    SCNShape *pathShape = [SCNShape shapeWithPath:path extrusionDepth:self.extrusionAmount];
    
    pathShape.chamferRadius = self.chamferRadius;
    
    
    
    // MirrorPathHorizontally(self.chamferPath);
    
    pathShape.chamferProfile = self.chamferPath;
    
    
    SKTexture *noiseTexture = [SKTexture textureNoiseWithSmoothness:0.0001 size:CGSizeMake(1024, 1024) grayscale:NO];
    
    SKTexture *normalTexture = [noiseTexture textureByGeneratingNormalMapWithSmoothness:0.0001 contrast:0.75];
    
    UIColor *shapeColor = [UIColor moneyGreenColor];
    
    pathShape.firstMaterial.diffuse.contents = shapeColor;
    pathShape.firstMaterial.ambient.contents = shapeColor;
    pathShape.firstMaterial.normal.contents = normalTexture;
    pathShape.firstMaterial.doubleSided = YES;
    //pathShape.firstMaterial.lightingModelName = SCNLightingModelConstant;

    SCNNode *pathNode = [SCNNode nodeWithGeometry:pathShape];
    
    pathNode.rotation = SCNVector4Make(0, 0, 0, 2);
    pathNode.position = SCNVector3Zero;
    myShape = pathNode;
    return pathNode;

}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint touchPoint = [mytouch locationInView:self.view];
    
    if (touchPoint.y < mySceneView.frame.origin.y) {
       
        [self performSegueWithIdentifier:@"goBack" sender:self];
    }
    
    if (touchPoint.y > (mySceneView.frame.origin.y + mySceneView.frame.size.height) ) {
        [self performSegueWithIdentifier:@"goBack" sender:self];
        
    }
    
   
}


-(void)action:(SCNScene*)scene
{
    [scene.rootNode addChildNode:[self compliePathNode]];
}

-(void)lights:(SCNScene*)scene
{
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    SCNNode *spotLight = [SCNNode node];
    spotLight.light = [SCNLight light];
    spotLight.light.type = SCNLightTypeSpot;
    spotLight.position = SCNVector3Make(0, -10, 0);
    [scene.rootNode addChildNode:spotLight];
    
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
}

-(void)camera:(SCNScene*)scene
{
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    
    cameraNode.position = SCNVector3Make(0.5, 0.5, 1.75);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


@end
