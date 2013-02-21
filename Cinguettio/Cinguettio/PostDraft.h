//
//  PostDraft.h
//  Cinguettio
//
//  Created by kkirov on 1/6/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PostDraft : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * title;

@end
