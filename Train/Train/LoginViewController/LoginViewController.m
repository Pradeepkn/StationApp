//
//  ViewController.m
//  Train
//
//  Created by Pradeep Narendra on 9/29/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "LoginViewController.h"
#import "AppUtilityClass.h"
#import "IQKeyboardManager.h"
#import "LoginApi.h"
#import "GetStationDesignationApi.h"
#import "CoreDataManager.h"
#import "AppConstants.h"
#import "UIColor+AppColor.h"
#import "ForgotPasswordApi.h"

static NSString *const kHomeSegueIdentifier = @"HomeSegue";
static NSString *const kSignUpSegueIdentifier = @"SignUpSegue";

static NSInteger kKeyBoardOffSet = 100;

@interface LoginViewController () {
    BOOL isPasswordHidden;
    BOOL isRememberMeEnabled;
}

@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeLabelBtn;
@property (nonatomic, strong) NSArray *array;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPasswordHidden = YES;
    isRememberMeEnabled = NO;
    [AppUtilityClass shapeTopCell:self.usernameTxtField withRadius:3.0];
    [AppUtilityClass shapeBottomCell:self.passwordTxtField withRadius:3.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self getStationsAndDesignations];
    if ([AppUtilityClass getUserEmail] && [AppUtilityClass getUserPassword]) {
        self.usernameTxtField.text = [AppUtilityClass getUserEmail];
        self.passwordTxtField.text = [AppUtilityClass getUserPassword];
        [self loginButtonClicked:self.loginButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    self.navigationController.navigationBarHidden = YES;
    [self.appNameLabel setAttributedText: [AppUtilityClass updateStationAppTextForLabel:self.appNameLabel]];
}

- (IBAction)loginButtonClicked:(id)sender {
    if (self.usernameTxtField.text.length <= 0 || self.passwordTxtField.text.length <= 0) {
        [AppUtilityClass showErrorMessage:@"Please enter valid user credentials."];
        return;
    }
    if (isRememberMeEnabled) {
        [AppUtilityClass storeUserEmail:self.usernameTxtField.text];
        [AppUtilityClass storePassword:self.passwordTxtField.text];
    }
    
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak LoginViewController *weakSelf = self;
    LoginApi *loginApi = [LoginApi new];
    loginApi.email = self.usernameTxtField.text;
    loginApi.password = [AppUtilityClass calculateSHA:self.passwordTxtField.text];
    
    [[APIManager sharedInstance]makePostAPIRequestWithObject:loginApi
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              if (!error) {
                                                  [self performSegueWithIdentifier:kHomeSegueIdentifier sender:nil];
                                              }else{
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                              }
                                          }];
}

- (void)getStationsAndDesignations {
    GetStationDesignationApi *stationsDesignationsApiObject = [GetStationDesignationApi new];
    [[APIManager sharedInstance]makeAPIRequestWithObject:stationsDesignationsApiObject shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        if (!error) {
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (IBAction)rememberMeButtonClicked:(UIButton *)sender {
    if (self.rememberMeButton.tag == 100 || self.rememberMeLabelBtn.tag == 100) {
        self.rememberMeLabelBtn.tag = self.rememberMeButton.tag = 200;
        isRememberMeEnabled = YES;
        [self.rememberMeButton setBackgroundColor:[UIColor appRedColor]];
        [self.rememberMeLabelBtn setTitleColor:[UIColor appRedColor] forState:UIControlStateNormal];
    }else{
        self.rememberMeLabelBtn.tag = self.rememberMeButton.tag = 100;
        isRememberMeEnabled = NO;
        [self.rememberMeButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.rememberMeLabelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)enablePasswordButtonClicked:(UIButton *)sender {
    if (isPasswordHidden) {
        isPasswordHidden = NO;
        self.passwordTxtField.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"eyeHidden"] forState:UIControlStateNormal];
    }else {
        self.passwordTxtField.secureTextEntry = YES;
        isPasswordHidden = YES;
        [sender setImage:[UIImage imageNamed:@"visible-icon"] forState:UIControlStateNormal];
    }
    // * Redundant (but necessary) line *
    [self.passwordTxtField setText:self.passwordTxtField.text];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender {
    if (self.usernameTxtField.text.length <= 0) {
        [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please enter valid e-mail address.", nil)];
        return;
    }
    __weak LoginViewController *weakSelf = self;

    ForgotPasswordApi *forgotPasswordApiObject = [ForgotPasswordApi new];
    forgotPasswordApiObject.email = self.usernameTxtField.text;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:forgotPasswordApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please enter unique code sent to your email", nil)];
                                              if (!error) {
                                              }else{
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                              }
                                          }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)signUpButtonClicked:(id)sender {
    [self performSegueWithIdentifier:kSignUpSegueIdentifier sender:nil];
}

#pragma keyboard hide/show
- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //The table view scroll inset and keyboard location should animate seamlessly with the keyboard.
    [UIView animateWithDuration:animationDuration delay:0.0 options:(curve << 16) animations:^{
        [self resetViewFrameToOriginal:YES];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:(curve << 16) animations:^{
        [self resetViewFrameToOriginal:NO];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)resetViewFrameToOriginal:(BOOL)toOriginalFrame {
    CGRect viewFrame = self.view.frame;
    if (toOriginalFrame) {
        viewFrame.origin.y = 0;
    }else {
        viewFrame.origin.y = -kKeyBoardOffSet;
    }
    self.view.frame = viewFrame;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
