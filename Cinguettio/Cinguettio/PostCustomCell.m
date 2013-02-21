//
//  PostCustomCell.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/29/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "PostCustomCell.h"

@implementation PostCustomCell

@synthesize titleLabel;
@synthesize publishDateLabel;
@synthesize contentTextView;

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
