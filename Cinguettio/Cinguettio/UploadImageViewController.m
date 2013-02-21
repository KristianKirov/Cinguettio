//
//  UploadImageViewController.m
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "UploadImageViewController.h"

@interface UploadImageViewController ()

@end

@implementation UploadImageViewController
@synthesize ImageExtentionTextField;
@synthesize selectedImageView;
@synthesize imagePicker;
@synthesize imageNameTextField;

//scroll code
CGFloat animatedDistance;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


//end of scroll code


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)choiceImageClicked:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Gallery", @"Take Picture", nil];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Gallery", nil];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }else {
        [self addPictureWithTypeOfSource:buttonIndex];
    }
}

- (void)addPictureWithTypeOfSource:(int)sourceType{
    imagePicker = [[GKImagePicker alloc] init];
    imagePicker.cropSize = CGSizeMake(150, 150);
    imagePicker.delegate = self;
    
    if(sourceType == 0){
        imagePicker.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(sourceType == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    
    [self presentViewController:imagePicker.imagePickerController animated:YES completion:nil];
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    self.selectedImageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)uploadImageClicked:(id)sender
{
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    [client uploadImage:self.selectedImageView.image withName:self.imageNameTextField.text withExtention:self.ImageExtentionTextField.text];
    
    self.loadingView = [UIUtilities showLoadingMessageWithTitle:@"Please wait while we upload your pucture"];
}

- (void)uploadImageCompleted:(NSString *)url
{
    [self.loadingView dismissWithClickedButtonIndex:0 animated:YES];
    if (url)
    {
        CinguettioDataAccessLayer* dal = [[CinguettioDataAccessLayer alloc] init];
        [dal addUploadedImage:url withTitle:self.imageNameTextField.text];
        
        UIAlertView* succesMessage = [[UIAlertView alloc] initWithTitle:@"Uploaded" message:@"Image was uploaded successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [succesMessage show];
    }
    else
    {
        UIAlertView* errorMessage = [[UIAlertView alloc] initWithTitle:@"Uploaded" message:@"Image was uploaded successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorMessage show];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setSelectedImageView:nil];
    [self setImageNameTextField:nil];
    [self setImageExtentionTextField:nil];
    [super viewDidUnload];
}
@end
