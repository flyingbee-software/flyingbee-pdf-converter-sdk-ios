//
//  MainViewController.h
//  PDF to Word
//
//  Created by James Wei on 4/2/26.
//  Copyright (c) 2026 Flyingbee Software. All rights reserved.
//

#import <UIKit/UIKit.h>
// Macro for accessing the Documents folder
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


/*
 * Main view controller for the PDF Converter demo app.
 * Handles PDF preview, conversion, and document interaction.
 */
@interface MainViewController : UIViewController <UIDocumentInteractionControllerDelegate>
{
    IBOutlet UIWebView*         wv_content;              // Web view for PDF preview
    IBOutlet UIBarButtonItem*   bbi_left;                // Left toolbar button (Stop)
    IBOutlet UIBarButtonItem*   bbi_right;               // Right toolbar button (Convert)
    
    IBOutlet UIActivityIndicatorView*   aiv_view;        // Activity indicator for conversion progress
    
    UIDocumentInteractionController* documentInteractionController; // Document preview controller
    
    
}


@end


