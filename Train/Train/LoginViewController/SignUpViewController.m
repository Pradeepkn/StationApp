//
//  SignUpViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/9/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpApi.h"
#import "AppConstants.h"
#import "AppUtilityClass.h"
#import "SignUpEntryCell.h"
#import "IQKeyboardManager.h"
#import "StationsListViewController.h"

static NSString *const kSignUpEntryCellIdentifier = @"SignUpEntryCell";

@interface SignUpViewController ()<UITextFieldDelegate, StationDesignationDelegate> {
    NSMutableDictionary *inputValues;
}

@property (weak, nonatomic) IBOutlet UITableView *signUpTableView;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    inputValues = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    self.signUpTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpButtonClicked:(id)sender {
    if (![inputValues objectForKey:@"0"]) {
        [AppUtilityClass showErrorMessage:@"Please enter first name"];
        return;
    }else if (![inputValues objectForKey:@"1"]) {
        [AppUtilityClass showErrorMessage:@"Please enter last name"];
        return;
    }else if (![inputValues objectForKey:@"2"]) {
        [AppUtilityClass showErrorMessage:@"Please choose designation."];
        return;
    }else if (![inputValues objectForKey:@"3"]) {
        [AppUtilityClass showErrorMessage:@"Please choose station."];
        return;
    }else if (![inputValues objectForKey:@"4"]) {
        [AppUtilityClass showErrorMessage:@"Please enter valid email address"];
        return;
    }else if (![[inputValues objectForKey:@"5"] isEqualToString:[inputValues objectForKey:@"6"]]) {
        [AppUtilityClass showErrorMessage:@"Password entered doesn't match"];
        return;
    }
    [self callSignUpApi];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignUpEntryCell *signUpEntryCell = (SignUpEntryCell *)[tableView dequeueReusableCellWithIdentifier:kSignUpEntryCellIdentifier forIndexPath:indexPath];
    [signUpEntryCell.placeHolderButton setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    signUpEntryCell.dropDownButton.hidden = YES;
    signUpEntryCell.entryTextField.secureTextEntry = NO;
    signUpEntryCell.entryTextField.tag = indexPath.row;
    signUpEntryCell.entryTextField.delegate = self;
    [signUpEntryCell.dropDownButton addTarget:self action:@selector(showStationsOrDesignationsList:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *keyValue = [NSString stringWithFormat:@"%ld", indexPath.row];
    signUpEntryCell.entryTextField.text = [inputValues objectForKey:keyValue];
    
    switch (indexPath.row) {
        case 0:
            [signUpEntryCell.entryTextField setPlaceholder:@"First name"];
            break;
        case 1:
            [signUpEntryCell.entryTextField setPlaceholder:@"Last name"];
            break;
        case 2:
            [signUpEntryCell.entryTextField setPlaceholder:@"Designation"];
            signUpEntryCell.dropDownButton.hidden = NO;
            signUpEntryCell.dropDownButton.tag = 100;
            signUpEntryCell.entryTextField.userInteractionEnabled = NO;
            break;
        case 3:
            [signUpEntryCell.entryTextField setPlaceholder:@"Choose station"];
            signUpEntryCell.dropDownButton.hidden = NO;
            signUpEntryCell.dropDownButton.tag = 200;
            signUpEntryCell.entryTextField.userInteractionEnabled = NO;
            break;
        case 4:
            [signUpEntryCell.entryTextField setPlaceholder:@"Email address"];
            break;
        case 5:
            [signUpEntryCell.entryTextField setPlaceholder:@"Password"];
            signUpEntryCell.entryTextField.secureTextEntry = YES;
            break;
        case 6:
            [signUpEntryCell.entryTextField setPlaceholder:@"Confirm password"];
            signUpEntryCell.entryTextField.secureTextEntry = YES;
            break;
        default:
            break;
    }
    return signUpEntryCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //For iOS 8, we need the following code to set the cell separator line stretching to both left and right edge of the view.
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)callSignUpApi {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak SignUpViewController *weakSelf = self;
    SignUpApi *signUpApi = [SignUpApi new];
    for (int index = 0; index < 7; index++) {
        NSString *keyValue = [NSString stringWithFormat:@"%ld", (long)index];
        switch (index) {
            case 0:
                signUpApi.firstName = [inputValues objectForKey:keyValue];
                break;
            case 1:
                signUpApi.lastName = [inputValues objectForKey:keyValue];
                break;
            case 2:
                signUpApi.designation = [inputValues objectForKey:keyValue];
                break;
            case 3:
                signUpApi.stationName = [inputValues objectForKey:keyValue];
                break;
            case 4:
                signUpApi.email = [inputValues objectForKey:keyValue];
                break;
            case 5:
                signUpApi.password = [inputValues objectForKey:keyValue];
                break;
            default:
                break;
        }
    }

    [[APIManager sharedInstance]makePostAPIRequestWithObject:signUpApi
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
            [AppUtilityClass storeIntValue:-1 forKey:kSelectedStationIndex];
            [AppUtilityClass storeIntValue:-1 forKey:kSelectedDesignationIndex];
            NSLog(@"Response = %@", responseDictionary);
            [AppUtilityClass hideLoaderFromView:weakSelf.view];
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"User registered successfully. Please login.", nil)];
            [self.navigationController popViewControllerAnimated:YES];
            if (!error) {
            }else{
                [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
            }
    }];
}

- (void)showStationsOrDesignationsList:(UIButton *)sender {
    StationsListViewController *stationsListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StationsListViewController"];
    stationsListVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    if (sender.tag == 100) {
        stationsListVC.isStationSelected = NO;
    }else {
        stationsListVC.isStationSelected = YES;
    }
    stationsListVC.delegate = self;
    [self presentViewController:stationsListVC animated:YES completion:^{
        ;
    }];
}

- (void)userSelectedState:(Stations *)selectedStation{
    NSString *keyValue = @"3";
    [inputValues setObject:selectedStation.stationName forKey:keyValue];
    [self.signUpTableView reloadData];
}

- (void)userSelectedDesignations:(Designation *)selectedDesignation {
    NSString *keyValue = @"2";
    [inputValues setObject:selectedDesignation.designationName forKey:keyValue];
    [self.signUpTableView reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *keyValue = [NSString stringWithFormat:@"%ld", (long)textField.tag];
    [inputValues setObject:textField.text forKey:keyValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
