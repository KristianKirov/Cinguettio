//
//  UploadImageViewController.h
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKClasses/GKImagePicker.h"
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "CinguettioDataAccessLayer.h"
#import "UIUtilities.h"

@interface UploadImageViewController : UIViewController <GKImagePickerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ServiceClientDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
- (IBAction)choiceImageClicked:(id)sender;
@property (nonatomic, strong)GKImagePicker* imagePicker;
@property (strong, nonatomic) IBOutlet UITextField *imageNameTextField;
- (IBAction)uploadImageClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ImageExtentionTextField;
@property (strong, nonatomic) UIAlertView* loadingView;

@end
