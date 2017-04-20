//
//  QueriesResponseViewController.m
//  Train
//
//  Created by pradeep on 4/20/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "QueriesResponseViewController.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"
#import "SubActivitiesHeaderView.h"
#import "SubStreamStatusCell.h"
#import "TasksStatusHeaderView.h"

@interface QueriesResponseViewController ()

@property (weak, nonatomic) IBOutlet UITableView *queriesResponseTableView;
@property (strong, nonatomic) NSString *queryName;

@end

@implementation QueriesResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = self.selectedQueryData.topicArea;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClicked)];
    [leftButton setImage:[UIImage imageNamed:@"left-arrow"]];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.queryName = [NSString stringWithFormat:@"%@\nRecieved on : %@\n", self.selectedQueryData.name, [self getRecievedDate:self.selectedQueryData.dateReceived]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getRecievedDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40.0f;
    }
    CGFloat heightOffSet = [AppUtilityClass sizeOfText:@"" widthOfTextView:self.queriesResponseTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:16]].height;
    if (heightOffSet < kTableCellHeight) {
        heightOffSet = kTableCellHeight;
    }
    return heightOffSet;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat heightOffSet = [AppUtilityClass sizeOfText:self.queryName widthOfTextView:self.queriesResponseTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:18]].height;
    if (heightOffSet < kTableCellHeight) {
        heightOffSet = kTableCellHeight;
    }
    return heightOffSet;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat heightOfHeader = [self getHeightForText:self.queryName];
    TasksStatusHeaderView *subHeader = (TasksStatusHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"TasksStatusHeaderView" owner:nil options:nil][0];
    subHeader.frame = CGRectMake(0, 0, self.view.bounds.size.width - 32, heightOfHeader);
    subHeader.nameLabel.text = [NSString stringWithFormat:@"%@\n", self.selectedQueryData.name];
    subHeader.receivedOnLabel.hidden = NO;
    subHeader.receivedOnLabel.text = [NSString stringWithFormat:@"Recieved on : %@", [self getRecievedDate:self.selectedQueryData.dateReceived]];
    return subHeader;
}


- (NSInteger)getHeightForText:(NSString*)message {
    CGFloat heightOfText = [AppUtilityClass sizeOfText:message widthOfTextView:self.queriesResponseTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:20.0f]].height;
    return  heightOfText;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        return cell;

    }
    SubStreamStatusCell *subStreamStatusCell = (SubStreamStatusCell *) [tableView dequeueReusableCellWithIdentifier:kSubStreamStatusCellIdentifier forIndexPath:indexPath];
    subStreamStatusCell.nameLabel.hidden = YES;
    [subStreamStatusCell.timeLabel setTitle:[self getRecievedDate:self.selectedQueryData.dateResponded] forState:UIControlStateNormal];
    subStreamStatusCell.titleLabel.text = self.selectedQueryData.response;
    return subStreamStatusCell;
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
