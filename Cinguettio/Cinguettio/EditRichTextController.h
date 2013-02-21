//
//  EditRichTextController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EditRichTextDelegate.h"

@interface EditRichTextController : UIViewController<UITableViewDelegate>

@property(nonatomic, strong) NSString *PropertyText;

@property(nonatomic, strong) IBOutlet UITextView *textView;

@property(nonatomic, weak) id<EditRichTextDelegate> delegate;
@end


