//
//  PostModel.m
//  VirtualScrolling
//
//  Created by kkirov on 12/26/12.
//  Copyright (c) 2012 kkirov. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel
@synthesize postId;
@synthesize title;
@synthesize content;
@synthesize dateCreated;
@synthesize user;

-(id)initFromJson:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        self.title = [data objectForKey:@"Title"];
        self.content = [data objectForKey:@"Content"];
        NSString* dateCreatedAsString = [data objectForKey:@"DateCreated"];
        self.dateCreated = [self deserializeJsonDateString:dateCreatedAsString];
        self.postId = [data objectForKey:@"Id"];
    }
    
    return self;
}

- (NSDate *)deserializeJsonDateString: (NSString *)jsonDateString
{
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    
    NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1;
    NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)]doubleValue] / 1000;
    
    NSDate* date = [[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
    
    return date;
}
@end
