//
//  EditTextController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EditTextDelegate.h"
#import "EditProfileViewController.h"

@interface EditTextController : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong) NSString *PropertyLabel;
@property(nonatomic, strong) NSString *PropertyText;

@property(nonatomic, strong) IBOutlet UILabel *label;
@property(nonatomic, strong) IBOutlet UITextField *textField;

@property(nonatomic, weak) id<EditTextDelegate> delegate;
@end
