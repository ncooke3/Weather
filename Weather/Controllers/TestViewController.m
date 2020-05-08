//
//  HimeVC.m
//  Weather
//
//  Created by Nicholas Cooke on 4/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <UITextFieldDelegate>

@property (nonatomic) UITextField *textfield;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    _textfield.backgroundColor = UIColor.yellowColor;
//    _textfield.delegate = self;
    [self.view addSubview:_textfield];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"%i", [textField isFirstResponder]);
    return YES;
}

@end
