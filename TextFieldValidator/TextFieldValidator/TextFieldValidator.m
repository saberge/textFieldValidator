//
//  TextFieldValidator.m
//  TextFieldValidator
//
//  Created by 郑来贤 on 14-8-26.
//  Copyright (c) 2014年 zhenglaixian. All rights reserved.
//



#import "TextFieldValidator.h"

@interface IQPopUp : UIView

@property (nonatomic,assign) CGRect showOnRect;
@property (nonatomic,assign) int popWidth;
@property (nonatomic,assign) CGRect fieldFrame;
@property (nonatomic,copy)   NSString *strMsg;
@property (nonatomic,retain) UIColor *popUpColor;

@end

@implementation IQPopUp
@synthesize showOnRect,popWidth,fieldFrame,popUpColor;

-(void)drawRect:(CGRect)rect
{
    const CGFloat *color=CGColorGetComponents(popUpColor.CGColor);
    
    UIGraphicsBeginImageContext(CGSizeMake(30, 20));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, color[0], color[1], color[2], 1);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 7.0, [UIColor blackColor].CGColor);
	CGPoint points[3] = { CGPointMake(15, 5), CGPointMake(25, 25),
		CGPointMake(5,25)};
    CGContextAddLines(ctx, points, 3);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect imgframe=CGRectMake((showOnRect.origin.x+((showOnRect.size.width-30)/2)), ((showOnRect.size.height/2)+showOnRect.origin.y), 30, 13);
    
    UIImageView *img=[[UIImageView alloc] initWithImage:viewImage highlightedImage:nil];
    [self addSubview:img];
    
    img.translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary *dict=NSDictionaryOfVariableBindings(img);
    [img.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[img(%f)]",imgframe.origin.x,imgframe.size.width] options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
    [img.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[img(%f)]",imgframe.origin.y,imgframe.size.height] options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
    
    UIFont *font=[UIFont fontWithName:FontName size:FontSize];
    CGSize size=[self.strMsg boundingRectWithSize:CGSizeMake(fieldFrame.size.width-(PaddingInErrorPopUp*2), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    size=CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    [self insertSubview:view belowSubview:img];
    view.backgroundColor=self.popUpColor;
    view.layer.cornerRadius=5.0;
    view.layer.shadowColor=[[UIColor blackColor] CGColor];
    view.layer.shadowRadius=5.0;
    view.layer.shadowOpacity=1.0;
    view.layer.shadowOffset=CGSizeMake(0, 0);
    view.translatesAutoresizingMaskIntoConstraints=NO;
    dict=NSDictionaryOfVariableBindings(view);
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[view(%f)]",fieldFrame.origin.x+(fieldFrame.size.width-(size.width+(PaddingInErrorPopUp*2))),size.width+(PaddingInErrorPopUp*2)] options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view(%f)]",imgframe.origin.y+imgframe.size.height,size.height+(PaddingInErrorPopUp*2)] options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectZero];
    lbl.font=font;
    lbl.numberOfLines=0;
    lbl.backgroundColor=[UIColor clearColor];
    lbl.text=self.strMsg;
    lbl.textColor=ColorFont;
    [view addSubview:lbl];
    
    lbl.translatesAutoresizingMaskIntoConstraints=NO;
    dict=NSDictionaryOfVariableBindings(lbl);
    [lbl.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[lbl(%f)]",(float)PaddingInErrorPopUp,size.width] options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
    [lbl.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[lbl(%f)]",(float)PaddingInErrorPopUp,size.height] options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    [self removeFromSuperview];
    return NO;
}

@end

@interface TextFieldValidator ()<UITextFieldDelegate>
{
    UITextField *inputTextField;
    UIImageView *necessaryIconImageView;
    IQPopUp *popUp;
}

@property (assign , nonatomic , readwrite) BOOL validatorSuccess;

@end

@implementation TextFieldValidator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultDataInitialize];
        [self buildUI];
        [self registerNoti];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       
        [self defaultDataInitialize];
        [self buildUI];
        [self registerNoti];
    }
    return self;
}

- (void)registerNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validator) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)unRegisterNoti
{
    [[NSNotificationCenter alloc] removeObserver:self];
}

- (void)buildUI
{
    
    CGRect f = self.frame;
    
    inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, f.size.width-10, f.size.height)];
    inputTextField.delegate  =self;
    inputTextField.textColor = [UIColor blackColor];
    inputTextField.layer.borderColor = self.boardColor.CGColor;
    inputTextField.layer.borderWidth = self.boardWidth;
    [self addSubview:inputTextField];
    
    necessaryIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(inputTextField.frame.origin.x+inputTextField.frame.size.width, f.size.height/2-5, 10, 10)];
    [self addSubview:necessaryIconImageView];
    
}
- (void)defaultDataInitialize
{
    self.boardWidth = 1.0f;
    self.boardColor = [UIColor greenColor];
    self.boardColorforError  = [UIColor redColor];
    self.boardWidthForError  = 1.0f;
    self.validatorErrorStr = @"验证不通过";
}

- (BOOL)validateString:(NSString*)stringToSearch withRegex:(NSString*)regexString
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [regex evaluateWithObject:stringToSearch];
}

- (void)validator
{
    BOOL result = [self validateString:inputTextField.text withRegex:self.strRegx];
    self.validatorSuccess = result;

    inputTextField.layer.borderColor  = result? self.boardColor.CGColor:self.boardColorforError.CGColor;
    inputTextField.layer.borderWidth  = result? self.boardWidth:self.boardWidthForError;
    [self showErrorIconWithResult:result];
}

-(void)showErrorIconWithResult:(BOOL )result
{
    if (!result)
    {
        UIButton *btnError=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btnError addTarget:self action:@selector(tapOnError) forControlEvents:UIControlEventTouchUpInside];
        [btnError setBackgroundImage:[UIImage imageNamed:IconImageName] forState:UIControlStateNormal];
        inputTextField.rightView=btnError;
        inputTextField.rightViewMode=UITextFieldViewModeAlways;
       
    }else
    {
        inputTextField.rightView=nil;
        inputTextField.rightViewMode=UITextFieldViewModeNever;
       
    }
}

- (void)animateError
{
    [inputTextField.layer removeAllAnimations];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0) ];
    animation.duration = 0.4;
    
    animation.additive = YES;
    
    [inputTextField.layer addAnimation:animation forKey:@"shake"];
}

-(void)tapOnError
{
    [self showErrorWithMsg:self.validatorErrorStr];
}
-(void)showErrorWithMsg:(NSString *)msg
{
    popUp=[[IQPopUp alloc] initWithFrame:CGRectZero];
    popUp.strMsg=msg;
    popUp.popUpColor=[UIColor redColor];
    popUp.showOnRect=[self convertRect:inputTextField.rightView.frame toView:self];
    popUp.fieldFrame=[self.superview convertRect:self.frame toView:self];
    popUp.backgroundColor=[UIColor clearColor];
    [self addSubview:popUp];
    
    popUp.translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary *dict=NSDictionaryOfVariableBindings(popUp);
    [popUp.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[popUp]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
    [popUp.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[popUp]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing  metrics:nil views:dict]];
}


#pragma mark  UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [inputTextField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [self unRegisterNoti];
}



@end
