//
//  BYColorPickerViewController.h
//  BYColorPickerViewControllerExample
//
//  Created by Berk Yuksel on 26/12/2016.
//  Copyright © 2016 Berk Yuksel. All rights reserved.
//

#import <UIKit/UIKit.h>

//BYColorPickerViewController Delegation
@protocol  BYColorPickerViewControllerDelegate <NSObject>

- (void)setSelectedColor:(UIColor *)color;

@end

//Public interface for BYColorPickerViewController
@interface BYColorPickerViewController : UIViewController

@property (nonatomic, assign) id <BYColorPickerViewControllerDelegate> delegate;

//Setter method for initial color state of BYColorPickerViewController upon openning
- (void)setInitialColor:(UIColor *)color;

@end
