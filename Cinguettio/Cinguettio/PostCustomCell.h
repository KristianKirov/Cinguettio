//
//  PostCustomCell.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/29/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *publishDateLabel;
@property (nonatomic, strong) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;

@end

