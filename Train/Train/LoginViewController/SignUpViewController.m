//
//  SignUpViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/9/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpApi.h"
#import "AppUtilityClass.h"
#import "SignUpEntryCell.h"
#import "IQKeyboardManager.h"

static NSString *const kSignUpEntryCellIdentifier = @"SignUpEntryCell";

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITableView *signUpTableView;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    signUpEntryCell.entryTextField.tag = indexPath.row;
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
            break;
        case 3:
            [signUpEntryCell.entryTextField setPlaceholder:@"Choose station"];
            signUpEntryCell.dropDownButton.hidden = NO;
            break;
        case 4:
            [signUpEntryCell.entryTextField setPlaceholder:@"Email address"];
            break;
        case 5:
            [signUpEntryCell.entryTextField setPlaceholder:@"Password"];
            break;
        case 6:
            [signUpEntryCell.entryTextField setPlaceholder:@"Confirm password"];
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
    signUpApi.email = @"pradeepkn.pradi@gmail.com";
    signUpApi.password = [AppUtilityClass calculateSHA:@"Prad33pkn"];
    signUpApi.designation = @"Member Engineering";
    signUpApi.stationName = @"Old Delhi";
    signUpApi.firstName = @"Pradeep";
    signUpApi.lastName = @"KN";

    [[APIManager sharedInstance]makePostAPIRequestWithObject:signUpApi
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        [AppUtilityClass hideLoaderFromView:weakSelf.view];
        if (!error) {
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
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
