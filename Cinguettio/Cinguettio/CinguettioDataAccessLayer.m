//
//  CinguettioDataAccessLayer.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "CinguettioDataAccessLayer.h"

@implementation CinguettioDataAccessLayer
-(void)addPostDraft:(NSString *)title withContent:(NSString *)content
{
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *moc = [delegate managedObjectContext];
    
    PostDraft *newEntry = (PostDraft*)[NSEntityDescription insertNewObjectForEntityForName:@"PostDraft" inManagedObjectContext:moc];
    
    newEntry.title = title;
    newEntry.content = content;
    newEntry.dateCreated = [NSDate date];
    
    NSError* error;
    [moc save:&error];
}

-(void)addUploadedImage:(NSString *)url withTitle:(NSString *)title
{
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *moc = [delegate managedObjectContext];
    
    UploadedImage *newEntry = (UploadedImage*)[NSEntityDescription insertNewObjectForEntityForName:@"UploadedImage" inManagedObjectContext:moc];
    
    newEntry.imgTitle = title;
    newEntry.imgUrl = url;
    
    NSError* error;
    [moc save:&error];
}
@end
