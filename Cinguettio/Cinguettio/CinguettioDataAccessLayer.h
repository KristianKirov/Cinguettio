//
//  CinguettioDataAccessLayer.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostDraft.h"
#import "UploadedImage.h"
#import "AppDelegate.h"

@interface CinguettioDataAccessLayer : NSObject
-(void)addPostDraft:(NSString*)title withContent:(NSString*)content;
-(void)addUploadedImage:(NSString*)url withTitle:(NSString*)title;
@end
