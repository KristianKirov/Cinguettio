//
//  DetailUserViewController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/28/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
- (IBAction)sendMailButton:(id)sender;

@end
