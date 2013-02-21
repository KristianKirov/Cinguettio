//
//  EditTextDelegate.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol EditTextDelegate <NSObject>
-(void)textEditCompleted:(id)sender value:(NSString*)val;
@end
