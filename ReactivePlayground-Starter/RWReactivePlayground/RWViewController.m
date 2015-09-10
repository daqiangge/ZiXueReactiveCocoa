//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInService = [RWDummySignInService new];
    
    
    // initially hide the failure message
    self.signInFailureText.hidden = YES;
    
    RACSignal *validUsernameSingal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    RACSignal *validPasswordSingal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    RAC(self.passwordTextField,backgroundColor) = [validPasswordSingal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue]?[UIColor clearColor]:[UIColor redColor];
    }];
    
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSingal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue]?[UIColor clearColor]:[UIColor redColor];
    }];
    
    RACSignal *singUpActiveSingel = [RACSignal combineLatest:@[validUsernameSingal,validPasswordSingal] reduce:^id(NSNumber *usernameValid,NSNumber *passwordValid){
        return @([usernameValid boolValue]&&[passwordValid boolValue]);
    }];
    
    [singUpActiveSingel subscribeNext:^(NSNumber *singUpActive) {
        self.signInButton.enabled = [singUpActive boolValue];
    }];
    
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){
           self.signInButton.enabled =NO;
           self.signInFailureText.hidden =YES;
       }]
      flattenMap:^id(id x){
          return[self signInSignal];
      }]
     subscribeNext:^(NSNumber*signedIn){
         self.signInButton.enabled =YES;
         BOOL success = [signedIn boolValue];
         self.signInFailureText.hidden = success;
         if(success){
             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
         }
     }];
    
    /*
    [[[self.signInButton
       rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^id(id x){
          return[self signInSignal];
      }]
     subscribeNext:^(NSNumber *signedIn){
         BOOL success = [signedIn boolValue];
         self.signInFailureText.hidden = success;
         if (success) {
             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
         }
     }];
     */
    
    /*
    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
      map:^id(id x) {
          return[self signInSignal];
     }]
     subscribeNext:^(id x) {
         NSLog(@"Sign in result: %@", x);
     }];
     */
    
    /*
     [[validPasswordSingal map:^id(NSNumber *passwordValid) {
     return [passwordValid boolValue]?[UIColor clearColor]:[UIColor yellowColor];
     }]
     subscribeNext:^(UIColor *color) {
     self.passwordTextField.backgroundColor = color;
     }];
     */
    /*
     [self.usernameTextField.rac_textSignal subscribeNext:^(id x){
     NSLog(@"%@", x);
     }];
     
     [[self.usernameTextField.rac_textSignal filter:^BOOL(NSString *value) {
     NSString *text = value;
     return text.length > 3;
     }]
     subscribeNext:^(id x) {
     NSLog(@"%@", x);
     }];
     
     [[[self.usernameTextField.rac_textSignal map:^id(NSString *text) {
     return @(text.length);
     }]
     filter:^BOOL(NSNumber *length) {
     return [length integerValue] > 3;
     }]
     subscribeNext:^(id x) {
     NSLog(@"%@",x);
     }];
     */
    
}

- (BOOL)isValidUsername:(NSString *)username
{
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password
{
    return password.length > 3;
}

- (RACSignal *)signInSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
