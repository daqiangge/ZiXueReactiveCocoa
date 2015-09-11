//
//  ViewController.m
//  自学reactivecocoa
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 蝶尚软件. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LQlogInRequest.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.usernameTextField.layer.cornerRadius = 5;
    self.usernameTextField.layer.borderWidth  = 1.0;

    self.passwordTextField.layer.cornerRadius = 5;
    self.passwordTextField.layer.borderWidth  = 1.0;
    
    //判断账号是否为11位
    RACSignal *usernameSingal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @(text.length == 11);
    }];
    
    //判断密码是否为大于6位
    RACSignal *passwordSingal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @(text.length > 6);
    }];
    
    //判断当账号不为11位时，边框线为红色
    RAC(self.usernameTextField,layer.borderColor) = [usernameSingal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue]?(id)[UIColor lightGrayColor].CGColor:(id)[UIColor redColor].CGColor;
    }];
    
    //判断当密码小于6位时，边框线为红色
    RAC(self.passwordTextField,layer.borderColor) = [passwordSingal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue]?(id)[UIColor lightGrayColor].CGColor:(id)[UIColor redColor].CGColor;
    }];
    
    //将账号和密码的条件信号绑定到登陆按钮上,来判断按钮是否可用
    [[RACSignal combineLatest:@[usernameSingal,passwordSingal] reduce:^id(NSNumber *usernameValid , NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }]
     subscribeNext:^(NSNumber *loginBtnSingal) {
         self.loginBtn.enabled = [loginBtnSingal boolValue];
     }];
    
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^RACStream *(id value) {
        return [self loginRequest];
    }]
     subscribeNext:^(NSNumber *success) {
         if ([success boolValue])
         {
             [self performSegueWithIdentifier:@"loginSuccess" sender:self];
         }
     }];
    
}

- (RACSignal *)loginRequest
{
    LQlogInRequest *loginRequest = [LQlogInRequest new];
    
   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       [loginRequest loginRequest:@"123" complete:^(BOOL success) {
           [self.view endEditing:YES];
           [subscriber sendNext:@(success)];
           [subscriber sendCompleted];
       }];
        return nil;
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)changeMyViewBackgroundColor:(changeMyViewBackgroundColor)changeMyViewBackgroundColor
{
    changeMyViewBackgroundColor(self.myView);
}

@end
