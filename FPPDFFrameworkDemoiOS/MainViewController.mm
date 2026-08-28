//
//  MainViewController.mm
//  PDF to Word
//
//  Created by James Wei on 4/2/26.
//  Copyright (c) 2026 Flyingbee Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"


#import <FPPDFFramework/FPPDFFramework.h>
#import <FPPDFFramework/FPPDF2AllConverterWrapper.h>
#import <FPPDFFramework/FPPDFOptions.h>


@implementation MainViewController{
    FPPDF2AllConverterWrapper* pdfConverterMutliThread; // Multi-threaded PDF converter instance
    
}

// Sample PDF file path used for preview and conversion
#define kMySamplePDF @"TestPDFFiles.bundle/Colorful Kites.pdf"
//#define kMySamplePDF @"TestPDFFiles.bundle/Excel/Flyingbee-Scan Test.pdf"



/*
 * Deallocates the view controller and releases associated resources.
 */
- (void)dealloc
{
    // Release the multi-threaded PDF converter if allocated
    if (pdfConverterMutliThread) {
        [pdfConverterMutliThread release];
        pdfConverterMutliThread = nil;
    }
    [super dealloc];
}

/*
 * Called after the view is loaded into memory.
 * Sets up the UI: web view for PDF preview, toolbar, navigation bar, and converter instance.
 */
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the navigation title
    self.title = @"FPPDFFrameworkDemoiOS";
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    
    // ==== Load the sample PDF into the web view for preview ===
    NSString* pdfPath = [[NSBundle mainBundle] pathForResource:kMySamplePDF ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:pdfPath];
    //NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSLog(@"%@",[request description]);
    [wv_content setScalesPageToFit:YES];
    [wv_content loadRequest:request];
    wv_content.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    
    // Initialize the multi-threaded PDF converter wrapper
    pdfConverterMutliThread = [[FPPDF2AllConverterWrapper alloc] init];
    
    // Append SDK linkage type to the title (Dynamic or Static)
#ifdef FP_SDK_VERSION_Dylib
    self.title = [self.title stringByAppendingString:@"[Dynamic]"];
#else
    self.title = [self.title stringByAppendingString:@"[Static]"];
#endif
    
    
    // Append build configuration to the title (Release or Debug)
#ifdef __OPTIMIZE__
    self.title = [self.title stringByAppendingString:@", Release"];
#else
    self.title = [self.title stringByAppendingString:@", Debug"];
#endif
    
    // Check and display license expiration status
    if (FPPDF2AllConverter::isSDKLicenseAuth_ExpiredDate()) {
        if (@available(iOS 26.0, *)) {
            self.navigationItem.subtitle = @"❌ License Expired";
        }else {
            self.title = [self.title stringByAppendingString:@", ❌ License Expired"];
        }
    }
    
    // ---- Configure navigation bar ----
    
    self.extendedLayoutIncludesOpaqueBars = true;
    
    // ---- Navigation bar style ----
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    
    // ---- Toolbar items: Stop button, flexible space, Refresh button ----
    UIBarButtonItem *menuItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftButtonPress:)] autorelease];
    UIBarButtonItem *menuItem2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightButtonPress:)] autorelease];
    UIBarButtonItem *menuItem3 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(rightButtonPress:)] autorelease];
    self.toolbarItems = [NSArray arrayWithObjects:menuItem1, menuItem3, menuItem2, nil];
    self.navigationController.toolbar.opaque = YES;
    self.navigationController.toolbar.translucent = NO;
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    // ---- Toolbar appearance configuration ----
    if (@available(iOS 13.0, *)) {
        UIToolbarAppearance *appearance2 = [[[UIToolbarAppearance alloc] init] autorelease];
        [appearance2 configureWithOpaqueBackground];
        //
        //appearance2.backgroundColor = [UIColor systemBackgroundColor];
        self.navigationController.toolbar.standardAppearance = appearance2;
        self.navigationController.toolbar.compactAppearance = appearance2;
        if (@available(iOS 15.0, *)) {
            self.navigationController.toolbar.scrollEdgeAppearance = appearance2;
            self.navigationController.toolbar.compactScrollEdgeAppearance = appearance2;
        }
    }
    self.navigationController.toolbar.barStyle = UIBarStyleDefault;
    self.navigationController.toolbar.translucent = NO;
    
    //[self.navigationController setToolbarHidden:YES animated:NO];
    
}



/*
 * Called just before the view is added to a window.
 */
- (void)viewWillAppear:(BOOL)animation
{
    [super viewWillAppear:animation];
}

/*
 * Called after the view has been fully presented on screen.
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/*
 * Handles the Convert (right toolbar) button tap.
 * Loads the sample PDF, configures conversion options, and starts the conversion process.
 */
- (IBAction)rightButtonPress:(id)sender;
{
    // Prevent starting a new conversion while one is already in progress
    if(aiv_view.isAnimating){
        NSLog(@"❌ Converting in progress...");
        return;
    }
    
    // ==== Load the target PDF file ===
    NSString* pdfPath = [[NSBundle mainBundle] pathForResource:kMySamplePDF ofType:nil];
    //NSString*   pdfPassword     = nil;
    
    // Open the PDF document and retrieve page count
    NSURL* url = [NSURL fileURLWithPath:pdfPath];
    CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL((CFURLRef)url);
    NSInteger numberOfPages = CGPDFDocumentGetNumberOfPages(documentRef);
    CGPDFDocumentRelease(documentRef);
    // pdfPageIndexs: 1,2,3,4...  range: 1 ~ n
    NSMutableArray* pdfPageIndexs = nil;
    // Option: Convert all pages (disabled by default)
    if(1){
        pdfPageIndexs = [NSMutableArray array];
        for (int i = 1; i<=numberOfPages; i++) {
            [pdfPageIndexs addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
    // Option: Convert specific pages only
    }else{
        pdfPageIndexs  = [NSMutableArray arrayWithObjects:
                          [NSNumber numberWithUnsignedInteger:1],
                          //[NSNumber numberWithUnsignedInteger:26],
                          //[NSNumber numberWithUnsignedInteger:48],
                          //[NSNumber numberWithUnsignedInteger:9],
                          //[NSNumber numberWithUnsignedInteger:10],
                          //[NSNumber numberWithUnsignedInteger:11],
                          //[NSNumber numberWithUnsignedInteger:12],
                          //[NSNumber numberWithUnsignedInteger:13],
                          //[NSNumber numberWithUnsignedInteger:14],
                          //[NSNumber numberWithUnsignedInteger:15],
                          nil];
    }
    
    
    
    // Supported output formats: xlsx, csv, pptx, docx, rtf, html, txt, image, elements
    NSString*   destDocType = nil;
    static NSArray* g_outputFormats = [NSArray arrayWithObjects:@"docx", @"xlsx", @"csv", @"pptx", @"rtf", @"html", @"txt", @"image", @"elements", nil].retain;
    // Output formats that produce a folder instead of a single file
    static NSArray* g_outputFormats_folder = [NSArray arrayWithObjects:@"csv", @"htm", @"html", @"element", @"elements", @"image", @"images", @"jpg", @"jpeg", @"png", @"bmp", @"gif", @"tif", @"tiff", @"tga", @"jp2", nil].retain;
    // Supported image output formats
    static NSArray* g_outputFormats_images = [NSArray arrayWithObjects:@"jpeg", @"png", @"bmp", @"gif", @"tiff", @"tga", @"jp2", nil].retain;
    // Select the output format here (index 0 = docx for document, index 0 = jpeg for image)
    if(1){
        destDocType   = [g_outputFormats objectAtIndex:0]; // 0: docx, 3: pptx
    }else{// Switch to image output category
        destDocType   = [g_outputFormats_images objectAtIndex:0]; // 0, 1, 2
    }
    
    // ---- Determine the output directory (Documents folder) ----
    NSURL *outputDirURL = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count > 0) {
        outputDirURL = [NSURL fileURLWithPath:paths[0]];
    } else {
        NSLog(@"❌ Unable to obtain default output directory");
        [aiv_view stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // === pop-up prompt ===
        NSString* message = [NSString stringWithFormat:@"❌ Conversion progress: Conversion has ended! Unable to obtain default output directory"];
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"Alert"
            message:message
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
            actionWithTitle:@"Okay"
            style:UIAlertActionStyleCancel
            handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        // === pop-up prompt-End ===
        
        return;
    }
    
    // Build the target file name based on the original PDF name and output format
    NSString *baseName = [[pdfPath lastPathComponent] stringByDeletingPathExtension];
    NSString *filename = nil;
    // Folder-based formats use underscore separator; file-based formats use dot extension
    if([g_outputFormats_folder containsObject:destDocType]){
        filename = [NSString stringWithFormat:@"%@_%@", baseName, destDocType];
    }else {
        filename = [NSString stringWithFormat:@"%@.%@", baseName, destDocType];
    }
    NSURL *destURL = [outputDirURL URLByAppendingPathComponent:filename];
    
    NSLog(@"destDocPath: %@", [destURL path]);
    
    // Remove any existing file at the destination to avoid conflicts
    [[NSFileManager defaultManager] removeItemAtURL:destURL error:nil];
    
    // Available DPI and quality presets for image output
    int imageDPI[] = {36, 72, 144, 300, 600, 1200};
    CGFloat imageQuality[] = {0.3f, 0.6f, 0.83f, 0.92f, 1.0f};
    // Thread count presets (0 = auto)
    int multiThreads[] = {0, 2, 5, 10, 20}; // Recommended 5 threads
    int multiThread = multiThreads[2];
    
    // Clamp thread count to valid range [0, 20]
    multiThread = MIN(multiThread, 20);
    multiThread = MAX(multiThread, 0);
    
    // Create and configure the conversion options
    FPPDFOptions *moreOptions = new FPPDFOptions();
    moreOptions->isParserAnnots = 1;  // Parse annotations
    moreOptions->threadMax = multiThread;
    moreOptions->imageQuality = imageQuality[2];
    moreOptions->imageDPI     = imageDPI[3];
    
    // ---- 1. Word conversion options ----
    moreOptions->wordOptions->isMergeParagraphs                  = 1; // Merge adjacent paragraphs
    moreOptions->wordOptions->isTrimmingBlankSpaceCharacters     = 1; // Trim trailing whitespace
    //moreOptions->wordOptions->outlineType                        = 1;
    moreOptions->wordOptions->enableShapeToImage                  = 1; // Convert shapes to images
    moreOptions->wordOptions->enableMergeIntersectImages         = 1; // Merge overlapping images
    
    
    int word_imageDPI[] = {72, 144, 300, 600};
    moreOptions->imageDPI     = word_imageDPI[1];
    
    // ---- 2. Excel conversion options ----
    moreOptions->excelOptions->excelFormatOption       = FPPDFToExcelFormatOptions_RetainDataStructure; // Preserve table structure
    moreOptions->excelOptions->thousandSeparator       = FPPDFToExcelThousandSeparator_Auto;
    moreOptions->excelOptions->allInOneSheet           = false;  // Each page to a separate sheet
    moreOptions->excelOptions->allInOneSheetAddToRow            = true;
    moreOptions->excelOptions->overlapText             = FPPDFToExcelOverlapText_Auto;
    
    moreOptions->excelOptions->recognizeNumber     = true; // Enable number recognition
    //moreOptions->excelOptions->collectCGPaths = YES;
    //moreOptions->excelOptions->collectFills = YES;
    moreOptions->excelOptions->isCSVPackageZip = 1; // Package CSV output as ZIP
    
    // ---- 3. Image conversion options ----
    moreOptions->imageOptions->imageQuality     = imageQuality[2];
    moreOptions->imageOptions->imageDPI     = imageDPI[3];
    //moreOptions->imageOptions->prefixName = @"Customize//\ \ image? File Name";
    moreOptions->imageOptions->isPackageZip = 1;  // Package images as ZIP
    moreOptions->imageOptions->isAntiAlias = true; // Enable anti-aliasing
    
    // ---- 4. Elements conversion options ----
    moreOptions->elementOptions->imageQuality     = imageQuality[2];
    //moreOptions->elementOptions->prefixName = @"Customize//\ \ image? File Name";
    moreOptions->elementOptions->isPackageZip = 1; // Package elements as ZIP
    
    
    // ---- 5. HTML conversion options ----
    moreOptions->wordOptions->htmlLayoutMode        = FPWordOption_HTML_LayoutMode_ExactPage; // Exact page layout
    moreOptions->wordOptions->htmlMergeResource     = FPWordOption_HTML_Merge_Resource_None;  // No resource merging
    moreOptions->wordOptions->htmlTextFlowParagraph = FPWordOption_HTML_TextFlow_Paragraph_LineBreak; // Line break paragraph flow
    moreOptions->wordOptions->htmlNavigationBar     = FPWordOption_HTML_NavigationBar_PDFViewer; // PDF viewer navigation
    moreOptions->wordOptions->htmlPackage           = FPWordOption_HTML_Package_None;
    
    // ---- 6. OCR options ----
    moreOptions->isEnableOCR = false; // Set to true to enable OCR
    // OCR language: eng (English), chi_sim+eng (Simplified Chinese + English), jpn (Japanese), etc.
    NSString* ocr_language = @"eng";
    //NSString* ocr_language = @"chi_sim+eng";
    snprintf(moreOptions->ocrOptions->language, sizeof(moreOptions->ocrOptions->language), "%s", ocr_language.UTF8String);
    //snprintf(moreOptions->ocrOptions->language, sizeof(moreOptions->ocrOptions->language), "chi_sim+eng"); // osd, eng, chi_sim, jpn, chi_sim+eng, script/HanS+eng
    // Configure OCR engine parameters
    moreOptions->ocrOptions->engineMode = FPPDFOCREngineMode_LSTM_ONLY; // LSTM or Tesseract
    moreOptions->ocrOptions->pageSegmentationMode = FPPDFOCRPageSegmentationMode_Auto; // Auto page segmentation
    moreOptions->ocrOptions->resizeDPI = 300;       // DPI for OCR input resizing
    moreOptions->ocrOptions->minConfidence = 30.0;  // Minimum confidence threshold
    moreOptions->ocrOptions->isEnableImageScan = false; // Disable image scan mode
    
    NSLog(@"pdfConverterMutliThread:%@", pdfConverterMutliThread);
    
    // ==== Start the conversion ====
    NSDate* conversionStartDate = [NSDate dateWithTimeIntervalSinceNow:0]; // Record start time
    [pdfConverterMutliThread convertPDFAtPath:pdfPath
                                     password:nil
                                  pageIndexes:pdfPageIndexs
                                 outputFormat:destDocType
                                     destPath:[destURL path]
                                  moreOptions:moreOptions
                               isInBackground:YES
                              didStartHandler:^(BOOL success, NSString *error) {
        NSLog(@"Started: %d, errorInfo: %@", success, error);
        
        self.title = [NSString stringWithFormat:@"Start turning to %@, page 1", destDocType];
        //tf_progress.textColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        
        [aiv_view startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
                              progressHandler:^(NSInteger currentPage, NSInteger total, BOOL success, NSString *error) {
        NSLog(@"Progress: %ld/%ld", (long)currentPage, (long)total);
        self.title = [NSString stringWithFormat:@"Convert to %@, %lu/%zd", destDocType, currentPage, total];
        
    }
                              willSaveHandler:^{
        NSLog(@"Will save doc...");
        self.title = [NSString stringWithFormat:@"📥 Saving as %@", destDocType];
        
    }
                            completionHandler:^(BOOL success, NSString *error) {
        if (success) {
            NSLog(@"✅ Conversion done! Output: %@", [destURL path]);
        } else {
            NSLog(@"❌ Failed: %@", error ?: @"Unknown error");
        }
        if (success)
        {
            // Record start time
            NSTimeInterval conversionSpendTime = 0;
            if(conversionStartDate){
                conversionSpendTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceDate:conversionStartDate];
            }
            // Do you want to open the file
            // /Users/James/Library/Containers/com.flyingbee.FPPDFConverterDemo/Data/Documents/
            NSString* message = [NSString stringWithFormat:@"✅ Conversion successful, took %0.0f seconds", conversionSpendTime];
            NSLog(@"%@", message);
            self.title = message;
            // === pop-up prompt ===
            UIAlertController *alert = [UIAlertController
                alertControllerWithTitle:@"Success"
                message:message
                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                actionWithTitle:@"Okay"
                style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction * _Nonnull action) {
                [self showDocumentInteractionController:destURL];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            // === pop-up prompt-End ===
        }else{
            NSLog(@"Error:%@", [error description]);
            NSString* message = [NSString stringWithFormat:@"❌ Conversion failed: %@", error ?: @"Unknown error"];
            NSLog(@"%@", message);
            // === pop-up prompt ===
            UIAlertController *alert = [UIAlertController
                alertControllerWithTitle:@"Failed"
                message:message
                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                actionWithTitle:@"Okay"
                style:UIAlertActionStyleCancel
                handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            // === pop-up prompt-End ===
        }
        
        [aiv_view stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
        
    // Release the conversion options object
    if(moreOptions){
        delete moreOptions;
        moreOptions = nullptr;
    }
    
}



/*
 * Handles the Stop (left toolbar) button tap.
 * Cancels the current PDF conversion operation.
 */
- (IBAction)leftButtonPress:(id)sender;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Cancel the ongoing conversion
    [pdfConverterMutliThread cancelConversion];
    
}




/*
 * Presents a document preview using UIDocumentInteractionController.
 * Validates the file URL and displays the preview on the main thread.
 */
- (void)showDocumentInteractionController:(NSURL*)fileURL {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Validate the input URL
    if (!fileURL || ![fileURL isKindOfClass:[NSURL class]]) {
        return;
    }

    // Check if the file actually exists on disk
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[fileURL path]]) {
        NSLog(@"❌ Open failed, file does not exist!");
        
        [aiv_view stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // === pop-up prompt ===
        NSString* message = [NSString stringWithFormat:@"Open failed, file does not exist!"];
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"Alert"
            message:message
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
            actionWithTitle:@"Okay"
            style:UIAlertActionStyleCancel
            handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        // === pop-up prompt-End ===
        
        return;
    }
    
    // Initialize the document interaction controller
    [documentInteractionController release];
    documentInteractionController = nil;

    documentInteractionController = [[UIDocumentInteractionController interactionControllerWithURL:fileURL] retain];
    documentInteractionController.delegate = self;

    // Ensure the preview is presented on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL presented = [documentInteractionController presentPreviewAnimated:YES];
        //BOOL presented = [documentInteractionController presentOpenInMenuFromBarButtonItem:bbi_right animated:YES];
        if (!presented) {
            // Handle cases where preview is unavailable (e.g., unsupported file type)
            // Works on iOS simulators and real devices, but may not display on Mac
            [documentInteractionController release];
            documentInteractionController = nil;
        }
    });
}

#pragma mark - UIDocumentInteractionController Delegate Methods

/*
 * Called when the document has been sent to another application.
 */
- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [controller dismissMenuAnimated:YES];
    //[controller autorelease];
}

/*
 * Returns the view controller that should be used as the parent for the preview.
 */
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return self;
}

/*
 * Returns the rect in which the preview content should be displayed.
 */
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return CGRectZero; // Use default rect
}

/*
 * Called just before the document preview begins.
 */
- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/*
 * Called after the document preview has ended.
 */
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [controller dismissMenuAnimated:YES];
    //[controller autorelease];
}


/*
 * Returns the supported interface orientations for this view controller.
 */
- (NSUInteger)supportedInterfaceOrientations {
    
    // Support all interface orientations
    return UIInterfaceOrientationMaskAll;
}

/*
 * Called when the app receives a memory warning.
 * Releases any cached data or images that are not currently in use.
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



@end

