//
//  FPFAppDelegate.mm
//  PDF to Word
//
//  Created by James Wei on 4/2/26.
//  Copyright (c) 2026 Flyingbee Software. All rights reserved.
//

#import "FPFAppDelegate.h"
#import "MainViewController.h"

#import <UIKit/UIKit.h>
#import <sys/utsname.h>


@implementation FPFAppDelegate
@synthesize window;
@synthesize navigationController;



/*
 * Called when the app finishes launching.
 * Sets up the main window and navigation controller with the main view.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    // Create the main view controller
    MainViewController* viewController = [[MainViewController alloc] init];
    // Initialize navigation controller with the main view controller as root
    navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [viewController autorelease];
    // Override point for customization after application launch
    window.rootViewController = navigationController;
	//[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


/*
 * Deallocates the app delegate and releases the window.
 */
- (void)dealloc {
    [window release];
    [super dealloc];
}


@end


