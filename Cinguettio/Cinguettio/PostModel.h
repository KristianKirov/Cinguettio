//
//  PostModel.h
//  VirtualScrolling
//
//  Created by kkirov on 12/26/12.
//  Copyright (c) 2012 kkirov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface PostModel : NSObject
@property(nonatomic, strong) NSNumber* postId;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSDate* dateCreated;
@property(nonatomic, strong) UserModel* user;
-(id)initFromJson:(NSDictionary*)data;
@end
