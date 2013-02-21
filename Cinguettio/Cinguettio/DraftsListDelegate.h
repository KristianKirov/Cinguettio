//
//  DraftsListDelegate.h
//  Cinguettio
//
//  Created by kkirov on 1/3/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DraftsListDelegate <NSObject>
- (void)draftSelectedWithTitle:(NSString*)title andContent:(NSString*)content;
@end
