//
//  FPFAppDelegate.h
//  PDF to Word
//
//  Created by James Wei on 4/2/26.
//  Copyright (c) 2026 Flyingbee Software. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * App delegate for the PDF Converter demo.
 * Manages the app lifecycle and main window setup.
 */
@interface FPFAppDelegate : NSObject <UIApplicationDelegate> {
	UINavigationController *navigationController; // Navigation controller for the app
    UIWindow *window; // Main application window
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController* navigationController;



@end

