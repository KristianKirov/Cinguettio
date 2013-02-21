//
//  UserModel.m
//  VirtualScrolling
//
//  Created by kkirov on 12/26/12.
//  Copyright (c) 2012 kkirov. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize userId;
@synthesize firstName;
@synthesize lastName;
@synthesize userName;
@synthesize email;
@synthesize latitude;
@synthesize longitude;
@synthesize imageUrl;

-(id)initFromJson:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        self.email = [data objectForKey:@"Email"];
        self.firstName = [data objectForKey:@"FirstName"];
        self.lastName = [data objectForKey:@"LastName"];
        self.userName = [data objectForKey:@"UserName"];
        self.userId = [data objectForKey:@"Id"];
        
        id lat = [data objectForKey:@"Latitude"];
        if (lat && [lat isKindOfClass:[NSNumber class]])
        {
            self.latitude = lat;
        }
        else
        {
            self.latitude = nil;
        }
        
        id longi = [data objectForKey:@"Longitude"];
        if (longi && [longi isKindOfClass:[NSNumber class]])
        {
            self.longitude = longi;
        }
        else
        {
            self.longitude = nil;
        }
        
        id img = [data objectForKey:@"ImageUrl"];
        if (img && [img isKindOfClass:[NSString class]])
        {
            self.imageUrl = img;
        }
        else
        {
            self.imageUrl = nil;
        }
    }
    
    return self;
}

@end
