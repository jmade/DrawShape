//
//  JDMUtility.h
//
//  Created by Justin Madewell on 8/2/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import "BaseGeometry.h"
#import "BezierUtilities.h"

#import "SceneKit Additions.h"
#import "Colours.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ResizeMagick.h"




//#import "JDMNetworkObject.h"
//#import "JDMHUEBridgeFinder.h"



// To Use TWEAKS

/*

#import "FBTweakInline.h"
#import "FBTweak.h"
#import "FBTweakInlineInternal.h"
#import "FBTweakCollection.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakViewController.h"
 
#import "AGGeometryKit.h"
#import "POP.h"

*/

/*
 do 2 things to get tweaks to work:
 
 in appdelegate, 
 
 
 #import "FBTweakShakeWindow.h"
 
 and add this method:
 
 
 
 -(UIWindow *)window
 {
    if (!_window) {
    _window = [[FBTweakShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
 }

 
 
 in viewController add this:
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweaksDismissed) name:@"FBTweakShakeViewControllerDidDismissNotification" object:nil];
 
 -(void)tweaksDismissed
 {
 
    // usuall call setNeedsDisplay, like a refresh.
 
 }
 
 
 
 */







