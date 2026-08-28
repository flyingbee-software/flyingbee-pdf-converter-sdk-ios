# FPPDFFramework SDK iOS Integration Guide

Welcome to the official integration guide for the **FPPDFFramework SDK iOS**. This comprehensive documentation provides developers with accurate, SEO-optimized instructions for implementing high-performance PDF conversion on iOS. Learn how to seamlessly convert PDFs to Word, Excel, HTML, Images, and more using our robust Objective-C API.

## Quick Start & SDK Integration

To begin using the FPPDFFramework, import the necessary headers into your Objective-C implementation file. The SDK provides dedicated wrappers for conversion and configuration.

```objectivec
#import <FPPDFFramework/FPPDFFramework.h>
#import <FPPDFFramework/FPPDF2AllConverterWrapper.h>
#import <FPPDFFramework/FPPDFOptions.h>
```

### License Verification

Before initiating any conversion tasks, verify that your SDK license is active. Use the static method provided by the core converter:

```objectivec
if (FPPDF2AllConverter::isSDKLicenseAuth_ExpiredDate()) {
    NSLog(@"Warning: SDK License has expired. Please renew your license.");
}
```

## Comprehensive FPPDFOptions Configuration

The `FPPDFOptions` class allows granular control over the conversion process. Below is a detailed breakdown of all available configuration parameters.

### General & Threading Options

- **`isParserAnnots`**: Boolean. Set to `YES` to parse and retain PDF annotations during conversion.
- **`threadMax`**: Integer. Controls multi-threading. Set to `0` for auto-detection. Maximum allowed is `20`, but `5` is highly recommended for optimal performance.
- **`isEnableOCR`**: Boolean. Enable Optical Character Recognition for scanned documents.

### Word (DOCX) Options (`wordOptions`)

- **`isMergeParagraphs`**: Merge adjacent paragraphs for cleaner text flow.
- **`isTrimmingBlankSpaceCharacters`**: Automatically trim trailing whitespace.
- **`enableShapeToImage`**: Convert complex vector shapes into raster images for better compatibility.
- **`enableMergeIntersectImages`**: Merge overlapping images to prevent rendering artifacts.
- **`htmlLayoutMode`**: Set to `FPWordOption_HTML_LayoutMode_ExactPage` for precise layout matching.
- **`htmlMergeResource`**: Set to `FPWordOption_HTML_Merge_Resource_None` to keep resources separate.
- **`htmlTextFlowParagraph`**: Set to `FPWordOption_HTML_TextFlow_Paragraph_LineBreak`.
- **`htmlNavigationBar`**: Set to `FPWordOption_HTML_NavigationBar_PDFViewer` to include a navigation bar.
- **`htmlPackage`**: Set to `FPWordOption_HTML_Package_None`.

### Excel (XLSX/CSV) Options (`excelOptions`)

- **`excelFormatOption`**: Set to `FPPDFToExcelFormatOptions_RetainDataStructure` to preserve table layouts.
- **`thousandSeparator`**: Set to `FPPDFToExcelThousandSeparator_Auto` for automatic number formatting.
- **`allInOneSheet`**: Boolean. If `NO`, each PDF page is converted to a separate Excel sheet.
- **`allInOneSheetAddToRow`**: Boolean. Append content to existing rows if applicable.
- **`overlapText`**: Set to `FPPDFToExcelOverlapText_Auto` to handle overlapping text gracefully.
- **`recognizeNumber`**: Boolean. Enable intelligent number recognition.
- **`isCSVPackageZip`**: Boolean. Package CSV outputs into a ZIP archive.

### Image & Element Options

- **`imageQuality`**: Float. Range from `0.3` to `1.0`. Controls output fidelity.
- **`imageDPI`**: Integer. Supported values: `36`, `72`, `144`, `300`, `600`, `1202`.
- **`isPackageZip`**: Boolean. Package image/element outputs into a ZIP file.
- **`isAntiAlias`**: Boolean. Enable anti-aliasing for smoother image rendering.

### OCR Configuration (`ocrOptions`)

- **`language`**: String. Specify languages (e.g., `"eng"`, `"chi_sim+eng"`, `"jpn"`).
- **`engineMode`**: Set to `FPPDFOCREngineMode_LSTM_ONLY` for modern neural network recognition.
- **`pageSegmentationMode`**: Set to `FPPDFOCRPageSegmentationMode_Auto`.
- **`resizeDPI`**: Integer. Recommended `300` for optimal OCR accuracy.
- **`minConfidence`**: Float. Minimum confidence threshold (e.g., `30.0`).
- **`isEnableImageScan`**: Boolean. Force image scan mode for heavily graphical PDFs.

## Supported Output Formats & Directory Management

### Format Categories

The SDK supports a wide array of output formats, categorized by their output structure:

| Category | Supported Formats | Output Type |
| :--- | :--- | :--- |
| **File-based** | docx, xlsx, pptx, rtf, html, txt | Single File |
| **Folder-based** | csv, htm, element, elements, image, images, jpg, jpeg, png, bmp, gif, tif, tiff, tga, jp2 | Folder |
| **Image-specific** | jpeg, png, bmp, gif, tiff, tga, jp2 | Folder / ZIP |

### File Naming Conventions

- **File-based formats**: Use a dot extension (e.g., `filename.docx`).
- **Folder-based formats**: Use an underscore separator (e.g., `filename_docx`).

### Output Directory Setup

Always direct outputs to the user's Documents directory to ensure proper sandboxing:

```objectivec
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths firstObject];
NSString *outputPath = [documentsDirectory stringByAppendingPathComponent:@"ConvertedPDF"];
```

## Complete Conversion Workflow

Follow this lifecycle to ensure robust PDF conversion, including page indexing, callback handling, and preview capabilities.

### Objective-C Implementation Example

```objectivec
// 1. Load PDF and determine page count
NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"pdf"];
CGPDFDocumentRef pdfDoc = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:pdfPath]);
size_t pageCount = CGPDFDocumentGetNumberOfPages(pdfDoc);

// 2. Build 1-based page indexes
NSMutableArray *pageIndexes = [NSMutableArray array];
for (size_t i = 1; i <= pageCount; i++) {
    [pageIndexes addObject:@(i)];
}

// 3. Configure FPPDFOptions
FPPDFOptions *options = [[FPPDFOptions alloc] init];
options.threadMax = 5;
options.isParserAnnots = YES;
options.isEnableOCR = YES;
options.ocrOptions.language = @"eng";
options.wordOptions.isMergeParagraphs = YES;

// 4. Execute Conversion with Callbacks
NSDate *startDate = [NSDate date];

[FPPDF2AllConverterWrapper convertPDFAtPath:pdfPath 
                              outputPath:outputPath 
                               pageIndexes:pageIndexes 
                                  options:options 
                              onSuccess:^{
    NSTimeInterval duration = -[startDate timeIntervalSinceNow];
    NSLog(@"Conversion completed in %.2f seconds", duration);
    
    // Handle Success UI
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" 
                                                                   message:@"PDF converted successfully." 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
} onFailure:^(NSError *error) {
    // Handle Failure UI
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" 
                                                                   message:error.localizedDescription 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
}];

// 5. Preview Output (Optional)
UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:outputPath]];
[interactionController presentPreviewAnimated:YES];
```

### Canceling a Conversion

If the user navigates away or requests a stop, gracefully cancel the operation:

```objectivec
[FPPDF2AllConverterWrapper cancelConversion];
```

## Frequently Asked Questions (FAQ)

**Q: What is the recommended thread count for conversion?**

A: While the SDK supports up to 20 threads, we strongly recommend setting `threadMax` to `5`. This provides the best balance between conversion speed and device thermal/memory management. Set it to `0` to let the SDK auto-detect based on the device's CPU cores.

**Q: Why is my OCR conversion slow?**

A: [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) performance depends heavily on the `resizeDPI` and `engineMode`. Ensure `resizeDPI` is set to `300` and use `FPPDFOCREngineMode_LSTM_ONLY` for the best accuracy-to-speed ratio. Also, verify that your license is active using `isSDKLicenseAuth_ExpiredDate()`.

**Q: How do I handle overlapping images in Word output?**

A: Enable `enableMergeIntersectImages` and `enableShapeToImage` within the `wordOptions` configuration. This prevents layout breakage when converting complex vector graphics or overlapping raster images.

**Q: Can I convert specific pages instead of the whole document?**

A: Yes. The `pageIndexes` array is 1-based. Simply pass an array containing only the specific page numbers you wish to convert (e.g., `@[@1, @3, @5]`).
