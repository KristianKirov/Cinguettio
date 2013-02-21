//
//  EditProfileViewController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
@synthesize firstNameLabel;
@synthesize firstNameContentLabel;
@synthesize lastNameLabel;
@synthesize lastNameContentLabel;
@synthesize mailLabel;
@synthesize mailContentLabel;
@synthesize userID;
@synthesize photoImageView;
@synthesize imageUrl;


-(BOOL)validateLabels
{
    if( [self.firstNameContentLabel.text length] == 0 || [self.lastNameContentLabel.text length] == 0 || [self.mailContentLabel.text length] == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Incomplete edit profile! "];
        [alert setMessage:@"Missing information! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        
        if([self.firstNameContentLabel.text length] == 0 )
        {
            self.firstNameContentLabel.layer.borderWidth = 2.0f;
            self.firstNameContentLabel.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.firstNameContentLabel.text length] > 0 )
        {
            self.firstNameContentLabel.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        
        if([self.lastNameContentLabel.text length] == 0 )
        {
            self.lastNameContentLabel.layer.borderWidth = 2.0f;
            self.lastNameContentLabel.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.lastNameContentLabel.text length] > 0 )
        {
            self.lastNameContentLabel.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        
        if([self.mailContentLabel.text length] == 0 )
        {
            self.mailContentLabel.layer.borderWidth = 2.0f;
            self.mailContentLabel.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.mailContentLabel.text length] > 0)
        {
            self.mailContentLabel.layer.borderColor = [[UIColor clearColor] CGColor];
        }

        return FALSE;
    }
    return TRUE;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Edit Profile", @"Edit Profile");
        self.tabBarItem.image = [UIImage imageNamed:@"tabImage"];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePressed)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    self.userID = delegate.userID;
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    [client getUser:self.userID];
    
    [firstNameContentLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizerFN = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editFirstNameButton:)];
    [tapGestureRecognizerFN setNumberOfTapsRequired:1];
    [firstNameContentLabel addGestureRecognizer:tapGestureRecognizerFN];
    
    [lastNameContentLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizerLN = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editLastNameButton:)];
    [tapGestureRecognizerLN setNumberOfTapsRequired:1];
    [lastNameContentLabel addGestureRecognizer:tapGestureRecognizerLN];
    
    [mailContentLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizerM = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editMailButton:)];
    [tapGestureRecognizerM setNumberOfTapsRequired:1];
    [mailContentLabel addGestureRecognizer:tapGestureRecognizerM];
    
    [photoImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizerP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPicture:)];
    [tapGestureRecognizerP setNumberOfTapsRequired:1];
    [photoImageView addGestureRecognizer:tapGestureRecognizerP];
    

    
    // Do any additional setup after loading the view from its nib.
}


- (void) savePressed
{
    if( [self validateLabels] )
    {
        ServiceClient* client = [[ServiceClient alloc] init];
        client.delegate = self;
        [client updateProfile:self.userID withFirstName:self.firstNameContentLabel.text withLastName:self.lastNameContentLabel.text withEmail:self.mailContentLabel.text withImageUrl:self.imageUrl];
    }
}

- (void)updateProfileCompleted
{
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Your update has been successfully completed! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserCompleted:(UserModel *)user
{
    self.firstNameContentLabel.text = user.firstName;
    self.lastNameContentLabel.text = user.lastName;
    self.mailContentLabel.text = user.email;
    self.imageUrl = user.imageUrl;
    
    if (user.imageUrl)
    {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        if(delegate.loadImages)
        {
            [self.photoImageView setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@"userDefault.png"]];
        }
    }
}


- (void)viewDidUnload {
    
    [self setFirstNameLabel:nil];
    [self setFirstNameContentLabel:nil];
    [self setLastNameLabel:nil];
    [self setLastNameContentLabel:nil];
    [self setMailLabel:nil];
    [self setMailContentLabel:nil];
    [self setPhotoImageView:nil];
    [super viewDidUnload];
}


- (IBAction)editFirstNameButton:(id)sender {
    
    EditTextController* editFirstNameController = [[EditTextController alloc] init];
    editFirstNameController.delegate = self;
    editFirstNameController.PropertyLabel = @"First Name";
    editFirstNameController.PropertyText = self.firstNameContentLabel.text;
    [self.navigationController pushViewController:editFirstNameController animated:YES];
}


- (IBAction)editLastNameButton:(id)sender {
    
    EditTextController* editLastNameController = [[EditTextController alloc] init];
    editLastNameController.delegate = self;
    editLastNameController.PropertyLabel = @"Last Name";
    editLastNameController.PropertyText = self.lastNameContentLabel.text;
    [self.navigationController pushViewController:editLastNameController animated:YES];

}


- (IBAction)editMailButton:(id)sender {
    
    EditTextController* editMailNameController = [[EditTextController alloc] init];
    editMailNameController.delegate = self;
    editMailNameController.PropertyLabel = @"Mail";
    editMailNameController.PropertyText = self.mailContentLabel.text;
    [self.navigationController pushViewController:editMailNameController animated:YES];

}

- (IBAction)editPicture:(id)sender {
    UploadedImagesViewController* uploadedImagesVC = [[UploadedImagesViewController alloc] init];
    uploadedImagesVC.delegate = self;
    uploadedImagesVC.title = @"Images";
    [self.navigationController pushViewController:uploadedImagesVC animated:YES];

}

- (void)imageSelectedWithUrl:(NSString *)url
{
    self.imageUrl = url;
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    if(delegate.loadImages)
    {
        [self.photoImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"userDefault.png"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textEditCompleted:(id)sender value:(NSString *)val
{
    [self.navigationController popToViewController:self animated:YES];
    NSString* str = ((EditTextController*)sender).PropertyLabel;
    if( [str isEqualToString:@"First Name"] ){
    self.firstNameContentLabel.text = val;
    }
    else if( [str isEqualToString:@"Last Name"] ){
      self.lastNameContentLabel.text = val;
    }
    else if( [str isEqualToString:@"Mail"] ){
     self.mailContentLabel.text = val;
    }
}
@end
