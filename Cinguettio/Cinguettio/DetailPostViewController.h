//
//  DetailPostViewController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/28/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "PostModel.h"
#import "ProfileController.h"
#import "NewPostController.h"

@interface DetailPostViewController : UIViewController<ServiceClientDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* fullNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTexView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)viewProfileClicked:(id)sender;

@property (nonatomic) int postID;
@property (nonatomic) int userID;

@end
