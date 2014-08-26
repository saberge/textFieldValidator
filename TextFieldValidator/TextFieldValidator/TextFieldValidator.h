//
//  TextFieldValidator.h
//  TextFieldValidator
//
//  Created by 郑来贤 on 14-8-26.
//  Copyright (c) 2014年 zhenglaixian. All rights reserved.
//

typedef NS_ENUM(NSInteger, TextFieldValidatorEditStyle) {
    TextFieldValidatorNecessary,
    TextFieldValidatorOptional
};


#import <UIKit/UIKit.h>
/**
 Image name for showing error on textfield.
 */
#define IconImageName @"error.png"

/**
 Background color of message popup.
 */
#define ColorPopUpBg [UIColor colorWithRed:0.702 green:0.000 blue:0.000 alpha:1.000]

/**
 Font color of the message.
 */
#define ColorFont [UIColor whiteColor]

/**
 Font size of the message.
 */
#define FontSize 15

/**
 Font style name of the message.
 */
#define FontName @"Helvetica-Bold"

/**
 Padding in pixels for the popup.
 */
#define PaddingInErrorPopUp 5

/**
 Default message for validating length, you can also assign message separately using method 'updateLengthValidationMsg:' for textfields.
 */
#define MsgValidateLength @"This field cannot be blank"



@interface TextFieldValidator : UIView

/*
 * 文本框是否是必需填写的，default is TextFieldValidatorOptional;
 */
@property (assign , nonatomic) TextFieldValidatorEditStyle editStyle;

/*
 * 当文本框是必填的时候， 右边显示的图标, 不需要的话，不需要的话 可以设置nil;
 */
@property (strong , nonatomic) UIImage *necessaryIcon;

/*
 * 当文本框变为可输入状态是边框的颜色，  默认是绿色
 */
@property (strong , nonatomic) UIColor *boardColor;

/*
 * 当文本框变为可输入状态是边框的颜色的宽度， 默认是1.0f;
 */
@property (assign , nonatomic) float boardWidth;

/*
 * 当文本框变为可输入状态是边框的颜色，  默认是红色
 */
@property (strong , nonatomic) UIColor *boardColorforError;

/*
 * 当文本框变为可输入状态是边框的颜色的宽度， 默认是1.0f;
 */
@property (assign , nonatomic) float boardWidthForError;

/*
 * 文本框的正则表达式
 */
@property (copy , nonatomic) NSString *strRegx;
/*
 * 当文本框变的正则表达式验证不通过，显示的错误信息
 */
@property (copy , nonatomic) NSString *validatorErrorStr;

/*
 * 当文本框变的正则表达式验证不通过
 */
@property (assign , nonatomic , readonly) BOOL validatorSuccess;
/*
 * 动态提醒用户，输入错误, 一般在确定的时候
 */
- (void)animateError;


@end
