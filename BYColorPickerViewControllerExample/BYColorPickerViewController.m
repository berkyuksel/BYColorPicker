//
//  BYColorPickerViewController.m
//  BYColorPickerViewControllerExample
//
//  Created by Berk Yuksel on 26/12/2016.
//  Copyright © 2016 Berk Yuksel. All rights reserved.
//

#import "BYColorPickerViewController.h"
#import "BYColorWheel.h"
#import "BYColorSwatch.h"
#import "BYGradientSlider.h"

#pragma mark - Global Constants

NSString * const kExitSegueIdentifier = @"ReturnToHomeViewSegue";

#pragma mark - Private Interface

@interface BYColorPickerViewController () <BYColorWheelDelegate> {
    UIColor *_color;
    CGFloat _hue;
    CGFloat _brightness;
    CGFloat _saturation;
}

@property (nonatomic, weak) IBOutlet BYColorWheel *colorWheel;
@property (nonatomic, weak) IBOutlet BYColorSwatch *colorSwatch;

@end

@implementation BYColorPickerViewController
@synthesize delegate;

#pragma mark - Initial Configuration

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    //Place crosshair position of colorWheel object.
    [self.colorWheel placeCrosshairByHue:_hue];
    
}

- (void)viewDidLayoutSubviews{
    
    [self.colorWheel prepare];
    [self updateColors];
    
    //Set initial state for IB objects after the have been layed out.
    
    //Set initial value for Saturation Slider
    BYGradientSlider *saturationSlider = (BYGradientSlider *)[self.view viewWithTag:10];
    [saturationSlider setValue:_saturation];
    
    //Set initial value for Brightness Slider
    BYGradientSlider *brightnessSlider = (BYGradientSlider *)[self.view viewWithTag:20];
    [brightnessSlider setValue:_brightness];    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Public Methods

- (void)setInitialColor:(UIColor *)color{
    
    CGFloat alpha;
    [color getHue:&_hue saturation:&_saturation brightness:&_brightness alpha:&alpha];
}

#pragma mark - Utility Methods


- (UIColor *)getColor{

    return [UIColor colorWithHue:_hue saturation:_saturation brightness:_brightness alpha:1.0];
}

- (void)updateColors{
    
    //Assign Color for colorSwatch
    [self.colorSwatch setColor:[self getColor]];
    
    //Assign edge colors for saturationSlider
    UIColor  *saturationStartColor = [UIColor colorWithHue:_hue saturation:0.0f brightness:_brightness alpha:1.0f];
    UIColor *saturationEndColor = [UIColor colorWithHue:_hue saturation:1.0f brightness:_brightness alpha:1.0f];
    BYGradientSlider *saturationSlider = (BYGradientSlider *)[self.view viewWithTag:10];
    [saturationSlider updateGradientLayerWithStartColor:saturationStartColor andEndColor:saturationEndColor];

    //Assign edge colors for brightnessSlider
    UIColor *brightnessStartColor = [UIColor colorWithHue:_hue saturation:_saturation brightness:0.0f alpha:1.0f];
    UIColor *brightnessEndColor = [UIColor colorWithHue:_hue saturation:_saturation brightness:1.0f alpha:1.0f];
    BYGradientSlider *brightnessSlider = (BYGradientSlider *)[self.view viewWithTag:20];
    [brightnessSlider updateGradientLayerWithStartColor:brightnessStartColor andEndColor:brightnessEndColor];

}

#pragma mark - IBAction Handlers

- (IBAction)doneButtonTapped:(id)sender{

    //Check if the delegate responds to setSelectedColor method to avoid errors.
    if ([self.delegate respondsToSelector:@selector(setSelectedColor:)]) {
        //Set color property of the delegate object
        [self.delegate setSelectedColor:[self getColor]];
    }
    
    //Perform exit segue to initiating view controller
    [self performSegueWithIdentifier:kExitSegueIdentifier sender:self];
}

- (IBAction)cancelButtonTapped:(id)sender{

    //Perform exit segue to initiating view controller
    [self performSegueWithIdentifier:kExitSegueIdentifier sender:self];
}

- (IBAction)brightnessValueDidChange:(id)sender{
    
    //Get brightness value from sender BYGradientSlider:UISlider object
    _brightness = ((UISlider*)sender).value;
    
    [self updateColors];
}


- (IBAction)saturationValueDidChange:(id)sender{
    
    //Get saturation value from sender BYGradientSlider:UISlider object
    _saturation = ((UISlider*)sender).value;
    
    [self updateColors];
}

#pragma mark - Color Wheel Delegate Methods

- (void)setHueFromColorWheel:(float)hue{
    
    //colorWheel object did update hue value, update colors.
    _hue = hue;
    [self updateColors];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

@end
