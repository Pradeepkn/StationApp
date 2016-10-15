//
//  ResetPasswordViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/15/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "IQKeyboardManager.h"
#import "AppUtilityClass.h"
#import "ForgotpasswordAuthKeyApi.h"
#import "ResetPasswordApi.h"
#import "ForgotPasswordApi.h"

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stationAppLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *codeTxtField;
@property (weak, nonatomic) IBOutlet UIButton *displayPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *displayPassword2Btn;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (IBAction)displayPasswordTxtField:(UIButton *)sender {
    UIImage *hiddenImage = [UIImage imageNamed:@"eyeHidden"];
    UIImage *visibleImage = [UIImage imageNamed:@"visible-icon"];
    if ([sender.imageView.image isEqual:visibleImage]) {
        if (sender.tag == 100) {
            self.passwordTxtField.secureTextEntry = NO;
            // * Redundant (but necessary) line *
            [self.passwordTxtField setText:self.passwordTxtField.text];
        }else {
            self.confirmPasswordTxtField.secureTextEntry = NO;
            // * Redundant (but necessary) line *
            [self.confirmPasswordTxtField setText:self.confirmPasswordTxtField.text];
        }
        [sender setImage:hiddenImage forState:UIControlStateNormal];
    }else {
        if (sender.tag == 100) {
            self.passwordTxtField.secureTextEntry = YES;
            // * Redundant (but necessary) line *
            [self.passwordTxtField setText:self.passwordTxtField.text];
        }else {
            self.confirmPasswordTxtField.secureTextEntry = YES;
            // * Redundant (but necessary) line *
            [self.confirmPasswordTxtField setText:self.confirmPasswordTxtField.text];
        }
        [sender setImage:visibleImage forState:UIControlStateNormal];
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updatePasswordButtonClicked:(id)sender {
    if (self.codeTxtField.text.length <= 0) {
        [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please enter valid code.", nil)];
        return;
    }else if (self.passwordTxtField.text.length <= 0) {
        [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please enter new password to reset", nil)];
        return;
    }else if (![self.passwordTxtField.text isEqualToString:self.confirmPasswordTxtField.text]) {
        [AppUtilityClass showErrorMessage:NSLocalizedString(@"Passwords doesn't match. Please enter valid password again", nil)];
        return;
    }
    __weak ResetPasswordViewController *weakSelf = self;
    [AppUtilityClass showLoaderOnView:self.view];
    
    ForgotpasswordAuthKeyApi *forgotPasswordAuthApiObject = [ForgotpasswordAuthKeyApi new];
    forgotPasswordAuthApiObject.email = [AppUtilityClass getUserEmail];
    forgotPasswordAuthApiObject.authKey = self.codeTxtField.text;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:forgotPasswordAuthApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              if (!error) {
                                                  [weakSelf callResetPasswordApi];
                                              }else{
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Unique code not matched. Please try again.", nil)];
                                              }
                                          }];
}

- (IBAction)resendButtonClicked:(id)sender {
    [AppUtilityClass showLoaderOnView:self.view];
    __weak ResetPasswordViewController *weakSelf = self;
    ForgotPasswordApi *forgotPasswordApiObject = [ForgotPasswordApi new];
    forgotPasswordApiObject.email = [AppUtilityClass getUserEmail];
    [[APIManager sharedInstance]makePostAPIRequestWithObject:forgotPasswordApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              if (!error) {
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Sent unique code to your email id.", nil)];
                                              }else{
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                              }
                                          }];

}

- (void)callResetPasswordApi {
    __weak ResetPasswordViewController *weakSelf = self;
    ResetPasswordApi *resetPasswordApiObject = [ResetPasswordApi new];
    resetPasswordApiObject.email = [AppUtilityClass getUserEmail];
    resetPasswordApiObject.authKey = self.codeTxtField.text;
    resetPasswordApiObject.password = self.passwordTxtField.text;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:resetPasswordApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              if (!error) {
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Password updated successfully.", nil)];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              }else{
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please enter valid code.", nil)];
                                              }
                                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
