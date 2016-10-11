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

static NSString *const kHomeSegueIdentifier = @"HomeSegue";
static NSString *const kSignUpSegueIdentifier = @"SignUpSegue";

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (nonatomic, strong) NSArray *array;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppUtilityClass shapeTopCell:self.usernameTxtField withRadius:3.0];
    [AppUtilityClass shapeBottomCell:self.passwordTxtField withRadius:3.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self getStationsAndDesignations];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)loginButtonClicked:(id)sender {
//    if (self.usernameTxtField.text.length <= 0 || self.passwordTxtField.text.length <= 0 || [AppUtilityClass validateEmail:self.usernameTxtField.text]) {
//        [AppUtilityClass showErrorMessage:@"Please enter valid user credentials."];
//        return;
//    }
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak LoginViewController *weakSelf = self;
    LoginApi *loginApi = [LoginApi new];
    loginApi.email = @"pradeepkn.pradi@gmail.com";
    loginApi.password = [AppUtilityClass calculateSHA:@"Prad33pkn"];
    
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
    if (sender.tag == 100) {
        sender.tag = 200;
    }else{
        sender.tag = 100;
    }
}

- (IBAction)forgotPasswordButtonClicked:(id)sender {

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
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:(curve << 16) animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
