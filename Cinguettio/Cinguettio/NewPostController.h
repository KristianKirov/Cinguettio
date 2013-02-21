//
//  SecondViewController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTextDelegate.h"
#import "EditRichTextDelegate.h"
#import "EditTextController.h"
#import "EditRichTextController.h"
#import "CinguettioDataAccessLayer.h"
#import "DraftsListController.h"
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "DraftsListDelegate.h"

@interface NewPostController : UIViewController <EditTextDelegate, EditRichTextDelegate, ServiceClientDelegate, DraftsListDelegate>

-(void)textEditCompleted:(id)sender value:(NSString *)val;
-(void)richTextEditCompleted:(id)sender value:(NSString *)val;
-(IBAction)titleEditClicked:(id)sender;
-(IBAction)contentEditClicked:(id)sender;
-(IBAction)loadDraftClicked:(id)sender;

@property (nonatomic) BOOL isInEditMode;
@property (nonatomic) int postID;
@property (nonatomic, strong) IBOutlet UIButton* loadButton;
@property (nonatomic, strong) IBOutlet UILabel* titleContentLabel;
@property (nonatomic, strong) IBOutlet UITextView* contentTextView;
@end
