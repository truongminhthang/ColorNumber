//
//  NSObject+ImagePixel.m
//  ColorNumber
//
//  Created by Chung on 1/3/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

#import "ImagePixel.h"

@implementation ImagePixel

-(id)initWithName:(int*)x withY:(int*)y andWithColor:(UInt32*)color {
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.color = color;
    }
    return self;
}

@end
