//
//  NSObject+ImagePixel.h
//  ColorNumber
//
//  Created by Chung on 1/3/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePixel : NSObject {
    
}

-(id)initWithName:(int*)x withY:(int*)y andWithColor:(UInt32*)color;

@property (nonatomic) int *x;
@property(nonatomic) int *y;
@property (nonatomic) UInt32 *color;

@end
