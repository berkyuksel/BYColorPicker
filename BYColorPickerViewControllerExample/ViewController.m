//
//  ViewController.m
//  BYColorPickerViewControllerExample
//
//  Created by Berk Yuksel on 26/12/2016.
//  Copyright © 2016 Berk Yuksel. All rights reserved.
//

#import "ViewController.h"
#import "BYColorPickerViewController.h"

@interface ViewController () <BYColorPickerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Handlers

/*
- (IBAction)showColorPickerVC:(id)sender{

    BYColorPickerViewController *colorPickerVC = [[BYColorPickerViewController alloc] init];
    [self showViewController:colorPickerVC sender:self];
}
 */

#pragma mark - ColorPickerViewController Delegation

- (void)setSelectedColor:(UIColor *)color{

    [self.view setBackgroundColor:color];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ShowColorPickerViewSegue"]){
        
        BYColorPickerViewController *colorPicker = (BYColorPickerViewController*)segue.destinationViewController;
        [colorPicker setDelegate:self];
        [colorPicker setInitialColor:self.view.backgroundColor];
    }
}


- (IBAction)returnToHomeViewSegue:(UIStoryboardSegue *)seque{}

@end
