//
//  UserModel.h
//  VirtualScrolling
//
//  Created by kkirov on 12/26/12.
//  Copyright (c) 2012 kkirov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic, strong) NSNumber* userId;
@property(nonatomic, strong) NSString* firstName;
@property(nonatomic, strong) NSString* lastName;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) NSString* email;
@property(nonatomic, strong) NSNumber* latitude;
@property(nonatomic, strong) NSNumber* longitude;
@property(nonatomic, strong) NSString* imageUrl;

-(id)initFromJson:(NSDictionary*)data;
@end
