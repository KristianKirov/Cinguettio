//
//  UploadedImagesViewController.h
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreData/CoreData.h>
#import "UploadedImage.h"
#import "AppDelegate.h"
#import "UploadImageViewController.h"
#import "ImageSelectorDelegate.h"

@interface UploadedImagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* resultsController;
@property (strong, nonatomic) IBOutlet UITableView *imagesTableVIew;
@property (nonatomic, weak) id<ImageSelectorDelegate> delegate;

@end
