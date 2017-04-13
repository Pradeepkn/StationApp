//
//  IRSDCViewController.m
//  Train
//
//  Created by pradeep on 4/5/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "IRSDCViewController.h"
#import "AppConstants.h"
#import "UIColor+AppColor.h"
#import "IRSDCSectionHeaderView.h"
#import "AppUtilityClass.h"
#import "IRSDCProjectsTableViewController.h"
#import "IRSDCApi.h"
#import "CoreDataManager.h"

static NSString *kIRSDCProjectsIdentifier = @"IRSDCProjectsIdentifier";

@interface IRSDCViewController ()<StationProjectsDelegate> {
    NSInteger selectedSection;
    NSMutableSet* _collapsedSections;
}

@property (strong, nonatomic) NSMutableArray *irsdcProjectArray;
@property (strong, nonatomic) NSArray *irsdcStreamsArray;
@property (strong, nonatomic) NSArray *irsdcsubStreamsArray;
@property (weak, nonatomic) IBOutlet UITableView *irsdcTableView;
@property (weak, nonatomic) IBOutlet RightAlignImageButton *chooseProductButton;
@property (strong, nonatomic) Stations *selectedStation;

@end

@implementation IRSDCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collapsedSections = [NSMutableSet new];
    self.chooseProductButton.layer.cornerRadius = 6.0;
    self.chooseProductButton.clipsToBounds = YES;
    if (self.irsdcStreamsArray.count > 0) {
        self.irsdcTableView.hidden = NO;
    }else {
        self.irsdcTableView.hidden = YES;
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseProjectsClicked:(id)sender {
    [self performSegueWithIdentifier:kIRSDCProjectsIdentifier sender:self];
}


- (void)getIRSDCStationTasksWithStationId:(NSString*)stationId {
    [AppUtilityClass setToFirstPhaseFlow:YES];
    IRSDCGetStationTasks *irsdcStationsTasksApi = [IRSDCGetStationTasks new];
    irsdcStationsTasksApi.stationId = stationId;
    [[APIManager sharedInstance]makeAPIRequestWithObject:irsdcStationsTasksApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        self.irsdcStreamsArray = [[CoreDataManager sharedManager] fetchIRSDCAllStationTasksForStationId:stationId];
        if (self.irsdcStreamsArray.count > 0) {
            self.irsdcTableView.hidden = NO;
        }else {
            self.irsdcTableView.hidden = YES;
        }
        [self fetchSubStreams];
        if (!error) {
            [self.irsdcTableView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)fetchSubStreams {
    for (Tasks *taskObject in self.irsdcStreamsArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [AppUtilityClass setToFirstPhaseFlow:YES];
            IRSDCGetStationSubTasks *irsdcStationsTasksApi = [IRSDCGetStationSubTasks new];
            irsdcStationsTasksApi.stationId = self.selectedStation.stationId;
            irsdcStationsTasksApi.taskId = taskObject.refId;
            [[APIManager sharedInstance]makeAPIRequestWithObject:irsdcStationsTasksApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                NSLog(@"Response = %@", responseDictionary);
            }];
        });
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubTasks *subTasks = (SubTasks *)[self.irsdcsubStreamsArray objectAtIndex:indexPath.row];
    CGFloat headerHeight = [self getHeightForText:subTasks.name];
    if ( headerHeight < kTableSectionCellHeight) {
        headerHeight =  kTableSectionCellHeight;
    }
    return headerHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.irsdcStreamsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_collapsedSections containsObject:@(section)] ? self.irsdcsubStreamsArray.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    Tasks *taskObject = [self.irsdcStreamsArray objectAtIndex:section];
    CGFloat headerHeight = [self getHeightForText:taskObject.eventName];
    if ( headerHeight < kTableSectionCellHeight) {
        headerHeight =  kTableSectionCellHeight;
    }
    return headerHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IRSDCSectionHeaderView *headerView = (IRSDCSectionHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"IRSDCSectionHeaderView" owner:nil options:nil][0];
    headerView.frame = CGRectMake(0, 0, self.irsdcTableView.frame.size.width, kTableSectionCellHeight);
    Tasks *taskObject = [self.irsdcStreamsArray objectAtIndex:section];
    [headerView.streamName setTitle:taskObject.eventName forState:UIControlStateNormal];
    headerView.streamName.titleLabel.numberOfLines = 0;
//    headerView.streamName.lineBreakMode = NSLineBreakByWordWrapping;
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
    SubTasks *subTasks = (SubTasks *)[self.irsdcsubStreamsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = subTasks.name;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (self.irsdcStreamsArray.count == indexPath.section && self.irsdcsubStreamsArray.count == indexPath.row - 1) {
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

- (NSInteger)getHeightForText:(NSString*)message {
    CGFloat heightOfText = [AppUtilityClass sizeOfText:message widthOfTextView:self.irsdcTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:20.0f]].height;
    return  heightOfText;
}

- (void)streamSectionClicked:(UIButton *)sender {
    if (selectedSection != sender.tag) {
        [self.irsdcTableView beginUpdates];
        NSInteger numOfRows = [self.irsdcTableView numberOfRowsInSection:selectedSection];
        NSArray* indexPaths = [self indexPathsForSection:selectedSection withNumberOfRows:numOfRows];
        [self.irsdcTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections removeObject:@(selectedSection)];
        [self.irsdcTableView endUpdates];
    }
    selectedSection = sender.tag;
    Tasks *taskObject = [self.irsdcStreamsArray objectAtIndex:selectedSection];
    self.irsdcsubStreamsArray = [[CoreDataManager sharedManager] fetchStationsSubTasksForTaskId:taskObject.refId];

    bool shouldCollapse = [_collapsedSections containsObject:@(selectedSection)];
    if (shouldCollapse) {
        [self.irsdcTableView beginUpdates];
        NSInteger numOfRows = [self.irsdcTableView numberOfRowsInSection:selectedSection];
        NSArray* indexPaths = [self indexPathsForSection:selectedSection withNumberOfRows:numOfRows];
        [self.irsdcTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections removeObject:@(selectedSection)];
        [self.irsdcTableView endUpdates];
    }
    else {
        [self.irsdcTableView beginUpdates];
        NSInteger numOfRows = self.irsdcsubStreamsArray.count;
        NSArray* indexPaths = [self indexPathsForSection:selectedSection withNumberOfRows:numOfRows];
        [self.irsdcTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [_collapsedSections addObject:@(selectedSection)];
        [self.irsdcTableView endUpdates];
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

- (void)userSelectedIRSDCProjects:(Stations *)selectedStation {
    self.selectedStation = selectedStation;
    [self.chooseProductButton setTitle:selectedStation.stationName forState:UIControlStateNormal];
    [self getIRSDCStationTasksWithStationId:selectedStation.stationId];
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
    if ([segue.identifier isEqualToString:kIRSDCProjectsIdentifier]) {
        IRSDCProjectsTableViewController *irsdcProjectsTableVC = (IRSDCProjectsTableViewController *)[segue destinationViewController];
        irsdcProjectsTableVC.delegate = self;
    }
}

@end
