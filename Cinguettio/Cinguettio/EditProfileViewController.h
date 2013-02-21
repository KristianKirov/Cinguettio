//
//  EditProfileViewController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "EditTextController.h"
#import "EditTextDelegate.h"
#import "ImageSelectorDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EditProfileViewController : UIViewController<ServiceClientDelegate, EditTextDelegate, ImageSelectorDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNameContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailContentLabel;
@property (nonatomic) int userID;
@property (nonatomic, strong) NSString* imageUrl;

- (IBAction)editFirstNameButton:(id)sender;
- (IBAction)editLastNameButton:(id)sender;
- (IBAction)editMailButton:(id)sender;
- (IBAction)editPicture:(id)sender;

@end
