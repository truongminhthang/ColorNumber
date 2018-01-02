//
//  ImageProcessor.h
//  ColorNumber
//
//  Created by Chung Sama on 1/2/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageProcessorDelegate <NSObject>

- (void)imageProcessorFinishedProcessingWithImage:(UIImage*)outputImage;

@end

@interface ImageProcessor : NSObject

@property (weak, nonatomic) id<ImageProcessorDelegate> delegate;

+ (instancetype)sharedProcessor;

- (void)processImage:(UIImage*)inputImage;

@end
