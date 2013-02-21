//
//  ImageSelectorDelegate.h
//  Cinguettio
//
//  Created by kkirov on 1/6/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageSelectorDelegate <NSObject>

- (void)imageSelectedWithUrl:(NSString*)url;

@end
