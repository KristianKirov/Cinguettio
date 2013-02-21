//
//  UploadedImage.h
//  Cinguettio
//
//  Created by kkirov on 1/6/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UploadedImage : NSManagedObject

@property (nonatomic, retain) NSString * imgUrl;
@property (nonatomic, retain) NSString * imgTitle;

@end
