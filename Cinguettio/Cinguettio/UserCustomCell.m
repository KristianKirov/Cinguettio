//
//  UserCustomCell.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 1/4/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "UserCustomCell.h"

@implementation UserCustomCell

@synthesize fullNameLabel;
@synthesize photoImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
