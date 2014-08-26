//
//  ZLXRootViewController.m
//  TextFieldValidator
//
//  Created by 郑来贤 on 14-8-26.
//  Copyright (c) 2014年 zhenglaixian. All rights reserved.
//

#import "ZLXRootViewController.h"
#import "TextFieldValidator.h"

@interface ZLXRootViewController ()
{
    TextFieldValidator *textFieldValidator;
}

@end

@implementation ZLXRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    textFieldValidator = [[TextFieldValidator alloc]initWithFrame:CGRectMake(0, 40, 200, 40)];
    [self.view addSubview:textFieldValidator];
    textFieldValidator.strRegx = @"^.{3,10}$";
    textFieldValidator.validatorErrorStr = @"请输入 3 -- 10个字符";

}

- (void)sumbitBtnClicked:(id)sender
{
    if (!textFieldValidator.validatorSuccess) {
        [textFieldValidator animateError];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
