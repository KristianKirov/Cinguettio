//
//  ProfileController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/25/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "SingleUserMapViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EditProfileViewController.h"
#import "UploadedImagesViewController.h"

@interface ProfileController : UIViewController<ServiceClientDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendMailButton;
@property (nonatomic) int userID;

- (IBAction)showMailAction:(id)sender;
- (IBAction)viewOnMapClicked:(id)sender;

- (IBAction)myPostsButton:(id)sender;
- (void)getUserCompleted:(UserModel *)user;

@end
