//
//  main.m
//  PDF to Word
//
//  Created by James Wei on 4/2/26.
//  Copyright (c) 2026 Flyingbee Software. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Application entry point.
 * Creates an autorelease pool and launches the iOS application.
 */
int main(int argc, char *argv[]) {
    
    // Create autorelease pool for memory management
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    // Run the main application loop
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
