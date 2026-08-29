# PDF to Word, Excel & PowerPoint Conversion SDK for iOS & iPadOS | Flyingbee PDF Conversion SDK

Flyingbee PDF Conversion SDK for iOS & iPadOS is a high-performance, developer-friendly library designed to seamlessly convert PDF to Word, Excel, and PowerPoint files on iPhone and iPad while preserving original layouts, text, and images. Whether you need a robust iOS PDF conversion SDK or a comprehensive mobile PDF library to convert PDF to editable Word documents in your iOS app, this SDK delivers enterprise-grade accuracy and formatting fidelity.

## 🕹️ Try the Free Online Web Demo

Experience the full power of our iOS PDF conversion SDK before integrating it into your project. Our web demo is always powered by the latest version of the Flyingbee SDK, allowing you to test PDF to MS Office (.docx, .xlsx, .pptx) conversion and OCR capabilities instantly.

[🚀 Launch the Free Web Demo](https://www.flyingbee.com/pdf-converter/?utm_source=github_readme_conversion_sdk_ios&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_ios)

## Key Features of the iOS PDF Conversion Library

Flyingbee provides a versatile API that unlocks the content and context within PDF documents, empowering your iOS and iPadOS applications with precise data extraction and conversion.

- **PDF to Word (.docx):** Convert PDF to editable Word documents with high layout fidelity on iPhone and iPad.
- **PDF to Excel (.xlsx):** Accurately extract tables and data into structured spreadsheets on iOS.
- **PDF to PowerPoint (.pptx):** Transform PDF presentations into fully editable PPTX files on iPad.
- **PDF to HTML (.html):** Generate clean, web-ready HTML from PDF sources in your iOS app.
- **PDF to CSV (.csv):** Extract tabular data into universally compatible CSV formats on iPhone.
- **PDF to Image:** Render PDF pages to PNG, JPEG, JPEG2000, BMP, TIFF, or GIF on iOS/iPadOS.
- **PDF to Plain Text (.txt):** Extract raw text content for indexing or analysis on mobile devices.
- **Built-in OCR for iOS:** Advanced Optical Character Recognition to convert scanned PDFs into searchable, editable text on iPhone and iPad.
- **Images to PDF:** Merge multiple images into a single PDF with customizable page size, margins, and orientation.
- **Text to Word:** Convert plain text files to formatted Word documents with configurable font, size, and column layout.
- **Background Conversion:** Run PDF conversions asynchronously in the background without blocking the UI thread.
- **Progress Tracking:** Monitor conversion progress page-by-page with real-time callbacks.
- **Password Protection:** Open and convert password-protected PDF files.
- **Page Selection:** Convert only specific pages instead of the entire document.

## Table of Contents

- [Why Choose Flyingbee PDF Conversion SDK for iOS & iPadOS](#why-choose-flyingbee-pdf-conversion-sdk-for-ios--ipados)
- [System Requirements for iOS Integration](#system-requirements-for-ios-integration)
- [How to Run the iOS Conversion Demo](#how-to-run-the-ios-conversion-demo)
- [Integrate Flyingbee SDK into an iOS App (Swift & Objective-C)](#integrate-flyingbee-sdk-into-an-ios-app-swift--objective-c)
- [API Reference](#api-reference)
  - [PDF Conversion](#pdf-conversion)
  - [Images to PDF](#images-to-pdf)
  - [Text to Word](#text-to-word)
  - [Cancel Conversion](#cancel-conversion)
- [License Options and Free Trial](#license-options-and-free-trial)
- [Technical Support](#technical-support)
- [Frequently Asked Questions (FAQ)](#frequently-asked-questions-faq)

## Why Choose Flyingbee PDF Conversion SDK for iOS & iPadOS

Flyingbee PDF Conversion SDK is engineered for iOS developers who demand precision and performance. Unlike basic converters, our iOS PDF library accurately preserves original text, images, layouts, hyperlinks, tables, and Bezier graphics during the conversion process. The API provides deep access to PDF content, making it the ideal choice for building custom document processing workflows, automated reporting systems, or document management platforms on iPhone and iPad.

## System Requirements for iOS Integration

Ensure your development environment meets the following specifications for optimal performance:

| Platform | System Requirements | Development Environment | Notes |
| :--- | :--- | :--- | :--- |
| **iOS** | iOS 13.0 or later | Xcode 13.0 or later | Supports iPhone, iPad, and iPad mini |
| **iPadOS** | iPadOS 13.0 or later | Xcode 13.0 or later | Optimized for iPad multitasking and split view |

## How to Run the iOS Conversion Demo

Flyingbee PDF Conversion SDK for iOS includes a ready-to-run demo located in the **"samples"** folder. Follow these simple steps to test the conversion capabilities on your iPhone or iPad:

1. Open the `FPPDFFrameworkDemoiOS.xcodeproj` file in Xcode.
2. Navigate to **Project Settings** and update the target signing to your own Apple Developer certificate.
3. Select a physical iOS device or simulator from the device scheme dropdown.
4. Click the **"Run"** button to launch the application.

A converter window will appear, allowing you to import PDF files from Files, Photos, or iCloud Drive, adjust conversion parameters, and export to various output formats interactively.

## Integrate Flyingbee SDK into an iOS App (Swift & Objective-C)

### Create a New iOS Project

1. Launch Xcode and select **File** -> **New** -> **Project...**.
2. Choose **iOS** -> **App** and configure your project options (Swift or Objective-C).
3. Click **Next**, select your desired save location, and click **Create**.

### Add the Flyingbee PDF Conversion SDK Package

Once your project is created, integrate the `FPPDFFramework.framework` using the following steps:

1. In the **Project Navigator**, click on your project name at the top of the left sidebar.
2. Select the target you wish to integrate the SDK into.
3. Click the **General** tab in the main editor area.
4. Scroll down to the **Frameworks, Libraries, and Embedded Content** section.
5. Click the **+** button to add a new framework:
   - Locate and select `FPPDFFramework.framework`, then click **Add**.
   - Ensure the **Embed & Sign** option is set for the framework.
6. Under **Signing & Capabilities**, verify that the **Signing Certificate** is set to your **Development** certificate.

### Add Required Permissions

For iOS apps that need to access PDF files from the Files app or photo library, add the following keys to your `Info.plist`:

- **NSDocumentsFolderUsageDescription** — Describe why your app needs access to documents.
- **NSPhotoLibraryUsageDescription** — Describe why your app needs access to photos (if scanning PDFs from camera).

### Quick Integration Example (Swift)

```swift
import FPPDFFramework

// Initialize the PDF converter
let converter = FPPDF2AllConverterWrapper()

// Convert PDF to Word with progress tracking
converter.convertPDFAtPath("path/to/input.pdf",
                           password: nil,
                           pageIndexes: nil,
                           outputFormat: "docx",
                           destPath: "path/to/output.docx",
                           moreOptions: nil,
                           isInBackground: false,
                           didStartHandler: { success, errorInfo in
    if success {
        print("Conversion started!")
    } else {
        print("Failed to start: \(errorInfo ?? "unknown error")")
    }
},
progressHandler: { currentPage, totalPages, success, errorInfo in
    let progress = Double(currentPage) / Double(totalPages) * 100
    print("Progress: \(progress)% (Page \(currentPage)/\(totalPages))")
},
willSaveHandler: {
    print("Document is about to be saved...")
},
completionHandler: { success, errorInfo in
    if success {
        print("Conversion successful! Output: \(converter.destPath ?? "")")
    } else {
        print("Conversion failed: \(errorInfo ?? "unknown error")")
    }
})
```

### Quick Integration Example (Objective-C)

```objectivec
@import FPPDFFramework;

FPPDF2AllConverterWrapper *converter = [[FPPDF2AllConverterWrapper alloc] init];

[converter convertPDFAtPath:@"path/to/input.pdf"
                   password:nil
                pageIndexes:nil
               outputFormat:@"docx"
                  destPath:@"path/to/output.docx"
                 moreOptions:nil
              isInBackground:NO
           didStartHandler:^(BOOL success, NSString * _Nullable errorInfo) {
    if (success) {
        NSLog(@"Conversion started!");
    } else {
        NSLog(@"Failed to start: %@", errorInfo);
    }
}]
         progressHandler:^(NSInteger currentPageIndex, NSInteger totalPages, BOOL success, NSString * _Nullable errorInfo) {
    NSLog(@"Progress: Page %ld/%ld", (long)currentPageIndex, (long)totalPages);
}]
        willSaveHandler:^{
    NSLog(@"Document is about to be saved...");
}]
      completionHandler:^(BOOL success, NSString * _Nullable errorInfo) {
    if (success) {
        NSLog(@"Conversion successful! Output: %@", converter.destPath);
    } else {
        NSLog(@"Conversion failed: %@", errorInfo);
    }
}];
```

Your iOS application is now configured to utilize the Flyingbee PDF Conversion SDK.

## API Reference

### PDF Conversion

Convert PDF files to various output formats using the `convertPDFAtPath` method:

```swift
converter.convertPDFAtPath(pdfPath: String,
                           password: String?,
                           pageIndexes: [NSNumber]?,
                           outputFormat: String,
                           destPath: String,
                           moreOptions: FPPDFOptions?,
                           isInBackground: Bool,
                           didStartHandler: FPPDFConversionDidStartHandler?,
                           progressHandler: FPPDFConversionPageProgressHandler?,
                           willSaveHandler: FPPDFConversionWillSaveHandler?,
                           completionHandler: FPPDFConversionCompletionHandler)
```

**Parameters:**

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `pdfPath` | `String` | Path to the source PDF file (sandbox path) |
| `password` | `String?` | Password for encrypted PDF files (nil if no password) |
| `pageIndexes` | `[NSNumber]?` | Array of zero-based page indices to convert. nil converts all pages |
| `outputFormat` | `String` | Target format: "docx", "xlsx", "pptx", "html", "csv", "png", "jpeg", "bmp", "tiff", "gif", "txt" |
| `destPath` | `String` | Output file path |
| `moreOptions` | `FPPDFOptions?` | Additional conversion options (OCR settings, image quality, etc.) |
| `isInBackground` | `Bool` | Run conversion in background thread |
| `didStartHandler` | `FPPDFConversionDidStartHandler?` | Callback when conversion starts |
| `progressHandler` | `FPPDFConversionPageProgressHandler?` | Callback for page-by-page progress updates |
| `willSaveHandler` | `FPPDFConversionWillSaveHandler?` | Callback before saving the output file |
| `completionHandler` | `FPPDFConversionCompletionHandler` | Final callback with success/failure result |

**Properties:**

| Property | Type | Description |
| :--- | :--- | :--- |
| `isConverting` | `Bool` (read-only) | Whether a conversion is currently in progress |
| `destPath` | `String` (read-only) | The destination path of the last conversion |

### Images to PDF

Merge multiple images into a single PDF with customizable page layout:

```swift
converter.convertImagesToPDF(["path/to/img1.png", "path/to/img2.png"],
                             outputPath: "path/to/output.pdf",
                             paperSizeAuto: true,
                             pageWidth: 0,
                             pageHeight: 0,
                             pageMargins: 0,
                             orientationLandscape: false,
                             scaleMethod: 0,
                             cropWidth: false,
                             cropHeight: false,
                             title: "My Document",
                             author: nil,
                             keywords: nil,
                             subject: nil,
                             creator: nil,
                             isInBackground: false,
                             completionHandler: { success, errorInfo in
    print(success ? "PDF created!" : "Failed: \(errorInfo ?? "")")
})
```

### Text to Word

Convert plain text files to formatted Word documents:

```swift
converter.convertTextToWordAtPath("path/to/input.txt",
                                  outputPath: "path/to/output.docx",
                                  paperSizeAuto: true,
                                  pageWidth: 0,
                                  pageHeight: 0,
                                  pageMargins: 0,
                                  orientationLandscape: false,
                                  fontName: "Helvetica",
                                  fontSize: 12.0,
                                  columnCount: 1,
                                  isInBackground: false,
                                  completionHandler: { success, errorInfo in
    print(success ? "Word document created!" : "Failed: \(errorInfo ?? "")")
})
```

### Cancel Conversion

Cancel an ongoing conversion at any time:

```swift
let cancelled = converter.cancelConversion()
print("Cancelled: \(cancelled)")
```

## License Options and Free Trial

### Get a Free Trial License

Ready to evaluate the SDK? [Contact our sales team](https://www.flyingbee.com/contact-us?utm_source=github_readme_conversion_sdk_ios&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_ios) to receive a 30-day free trial license for the Flyingbee PDF Conversion SDK for iOS & iPadOS.

### Get a Commercial License

Flyingbee PDF Conversion SDK is a commercial product requiring a valid license for application release. Redistribution of documents, sample code, or source code from the released package to third parties is strictly prohibited.

To obtain a commercial license, please [contact our sales team](https://www.flyingbee.com/contact-us?utm_source=github_readme_conversion_sdk_ios&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_ios). **Note:** For the iOS Conversion SDK, commercial licenses must be bound to your specific iOS app bundle IDs.

## Technical Support

Thank you for choosing Flyingbee PDF Conversion SDK. If you encounter technical questions, integration issues, or bugs, please submit a detailed problem report to [Flyinbee Support](mailto:support@flyingbee.com).

To help us resolve your issue quickly, please include:

- The Flyingbee PDF Conversion SDK product name and version.
- Your iOS/iPadOS version and Xcode IDE version.
- A detailed description of the problem or unexpected behavior.
- Relevant error messages, logs, or screenshots.

**Helpful Links:**

- **Home:** [https://www.flyingbee.com](https://www.flyingbee.com/?utm_source=github_readme_conversion_sdk_ios&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_ios)
- **Support Center:** [https://www.flyingbee.com/support](https://www.flyingbee.com/support?utm_source=github_readme_conversion_sdk_ios&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_ios)
- **Email:** [support@flyingbee.com](mailto:support@flyingbee.com)

## Frequently Asked Questions (FAQ)

### Can I convert scanned PDFs to editable Word documents on iPhone or iPad?

Yes. Flyingbee PDF Conversion SDK for iOS includes a built-in OCR module that accurately recognizes text in scanned documents and converts them into fully editable Word (.docx) files while preserving the original layout, all running natively on your iPhone or iPad.

### Does this iOS PDF SDK support the latest iPhone and iPad models?

Absolutely. The Flyingbee PDF Conversion SDK is optimized for all modern iOS and iPadOS devices, including the latest iPhone 15/16 series, iPad Pro, iPad Air, and iPad mini. It leverages Apple's Metal framework for GPU-accelerated rendering and Core ML for enhanced OCR performance.

### What iOS versions are supported?

The SDK supports iOS 11.0 and later, as well as iPadOS 13.0 and later. This ensures compatibility with a wide range of iPhone and iPad devices, from older models to the latest hardware.

### Can I use the SDK with Swift Package Manager (SPM)?

Currently, the SDK is distributed as a `.framework` bundle. You can integrate it manually via Xcode's framework linker or use a local SPM package wrapper. Swift and Objective-C projects are both fully supported.

### What output formats are supported on iOS?

In addition to PDF to DOCX, the iOS SDK supports PDF to Excel (.xlsx), PDF to PowerPoint (.pptx), PDF to HTML, PDF to CSV, PDF to Plain Text, and PDF to Image formats including PNG, JPEG, TIFF, and BMP — all optimized for mobile performance.

### Can I convert only specific pages of a PDF?

Yes. Use the `pageIndexes` parameter in `convertPDFAtPath` to specify which pages to convert. Pass an array of zero-based page indices (e.g., `[0, 2, 4]` for pages 1, 3, and 5). Pass `nil` to convert all pages.

### Can I run conversions in the background?

Yes. Set `isInBackground` to `true` to run the conversion on a background thread, keeping your UI responsive. Use the `progressHandler` callback to update a progress bar in real time.

### Is there a free trial available for the iOS PDF conversion SDK?

Yes, we offer a 30-day free trial license. Simply [contact our sales team](https://www.flyingbee.com/contact-us?utm_source=github_readme_conversion_sdk_ios&utm_medium=referral&utm_campaign=github_readme_conversion_sdk_ios) to request your evaluation license and begin integrating the SDK into your iOS or iPadOS application.
