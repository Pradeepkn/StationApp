//
//  QueriesViewController.m
//  Train
//
//  Created by pradeep on 4/10/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "QueriesViewController.h"
#import "AppConstants.h"
#import "UIColor+AppColor.h"
#import "IRSDCSectionHeaderView.h"
#import "AppUtilityClass.h"

@interface QueriesViewController () {
    NSInteger selectedSection;
    NSMutableSet* _collapsedSections;
}

@property (strong, nonatomic) NSMutableArray *topicAreasArray;
@property (strong, nonatomic) NSMutableArray *queriesArray;

@end

@implementation QueriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collapsedSections = [NSMutableSet new];
    self.topicAreasArray = [NSMutableArray arrayWithObjects:@"Pre-feasibility study", @"Authorization",@"Appointment of consultant",@"Master plan study",@"Station business plan", nil];
    self.queriesArray = [NSMutableArray arrayWithObjects:@"Study",@"Report submission",@"Acceptance by IRSDC", nil];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.topicAreasArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_collapsedSections containsObject:@(section)] ? 0 : self.queriesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableSectionCellHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IRSDCSectionHeaderView *headerView = (IRSDCSectionHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"IRSDCSectionHeaderView" owner:nil options:nil][0];
    headerView.frame = CGRectMake(0, 0, self.queriesTableView.frame.size.width, kTableSectionCellHeight);
    
    [headerView.streamName setTitle:[self.topicAreasArray objectAtIndex:section] forState:UIControlStateNormal];
    headerView.streamName.tag = section;
    [headerView.streamName addTarget:self action:@selector(streamSectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AppUtilityClass shapeTopCell:headerView withRadius:6.0];
        });
    }
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.queriesArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    if (self.topicAreasArray.count == indexPath.section && self.queriesArray.count == indexPath.row - 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AppUtilityClass shapeBottomCell:cell.contentView withRadius:6.0];
        });
    }
    return cell;
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

- (void)streamSectionClicked:(UIButton *)sender {
    selectedSection = sender.tag;
    bool shouldCollapse = ![_collapsedSections containsObject:@(selectedSection)];
    if (shouldCollapse) {
        [self.queriesTableView beginUpdates];
        NSInteger numOfRows = [self.queriesTableView numberOfRowsInSection:selectedSection];
        NSArray* indexPaths = [self indexPathsForSection:selectedSection withNumberOfRows:numOfRows];
        [self.queriesTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections addObject:@(selectedSection)];
        [self.queriesTableView endUpdates];
    }
    else {
        [self.queriesTableView beginUpdates];
        NSInteger numOfRows = self.queriesArray.count;
        NSArray* indexPaths = [self indexPathsForSection:selectedSection withNumberOfRows:numOfRows];
        [self.queriesTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections removeObject:@(selectedSection)];
        [self.queriesTableView endUpdates];
    }
    NSLog(@"Sender Section = %ld", sender.tag);
}

-(NSArray*) indexPathsForSection:(NSInteger)section withNumberOfRows:(NSInteger)numberOfRows {
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
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
