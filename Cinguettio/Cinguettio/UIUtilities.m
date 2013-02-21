//
//  UIUtilities.m
//  Cinguettio
//
//  Created by kkirov on 1/6/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "UIUtilities.h"

@implementation UIUtilities

+ (UIAlertView *)showLoadingMessageWithTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [alert addSubview:progress];
    [progress startAnimating];
    [alert show];
    return alert;
}

@end
