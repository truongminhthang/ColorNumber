//
//  UIImage+LogPixelsOfImage.m
//  ColorNumber
//
//  Created by Chung Sama on 1/2/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

#import "UIImage+LogPixelsOfImage.h"

@implementation UIImage (LogPixelsOfImage)
- (void)logPixelsOfImage {
    // 1. Get pixels of image
    CGImageRef inputCGImage = [self CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
    
    // 2. Iterate and log!
    NSLog(@"Brightness of image:");
    UInt32 * currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
            printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
            currentPixel++;
        }
        printf("\n");
    }
    
    free(pixels);
    
#undef R
#undef G
#undef B
    
}
@end
