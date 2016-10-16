//
//  StationSubTasksViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "StationSubTasksViewController.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"
#import "UIColor+AppColor.h"
#import "GetStationSubTasksApi.h"
#import "SubTasksCell.h"
#import "OverallStatusCell.h"
#import "TasksHeaderView.h"

static NSString *const kSubTasksCellIdentifier = @"SubTasksCellIdentifier";
static NSString *const kOverallStatusInfoCellIdentifier = @"OverallStatusInfoCell";
static NSString *const kTasksHeaderViewNibName = @"TasksHeaderView";

@interface StationSubTasksViewController ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) User *loggedInUser;
@property (weak, nonatomic) IBOutlet UITableView *subTasksListTableView;
@property (weak, nonatomic) IBOutlet UITableView *remarksTableView;
@property (nonatomic, strong) NSMutableArray *subActivitiesArray;
@property (nonatomic, strong) NSMutableArray *remarksArray;
@property (nonatomic, strong) NSString *activityName;

@property (nonatomic, strong) NSFetchedResultsController *stationInfoFetchedResultsController;

@end

@implementation StationSubTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.subActivitiesArray = [[NSMutableArray alloc] init];
    self.remarksArray = [[NSMutableArray alloc] init];
    [self initializeStationsInfoFetchedResultsController];
    [self getStationTasks];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getStationTasks {
    self.loggedInUser = [[CoreDataManager sharedManager] fetchLogedInUser];
    __weak StationSubTasksViewController *weakSelf = self;
    GetStationSubTasksApi *stationsubTasksApi = [GetStationSubTasksApi new];
    stationsubTasksApi.stationId = self.selectedStation.stationId;
    stationsubTasksApi.email = self.loggedInUser.email;
    stationsubTasksApi.taskId = self.selectedTask.refId;
    [[APIManager sharedInstance]makeAPIRequestWithObject:stationsubTasksApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        if (!error) {
            self.activityName = stationsubTasksApi.activityName;
            [weakSelf.subTasksListTableView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)initializeStationsInfoFetchedResultsController
{
    NSManagedObjectContext *moc = [[CoreDataManager sharedManager] managedObjectContext];
    
    [self setStationInfoFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getTasksFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self stationInfoFetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self stationInfoFetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (NSFetchRequest *)getTasksFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SubTasks"];
    NSSortDescriptor *message = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:NO];
    [request setSortDescriptors:@[message]];
    return request;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.subTasksListTableView]) {
        SubTasks *object = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.name widthOfTextView:self.subTasksListTableView.frame.size.width/3 - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:16]].height + 25;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.subTasksListTableView]) {
        id< NSFetchedResultsSectionInfo> sectionInfo = [[self stationInfoFetchedResultsController] sections][section];
        NSLog(@"Number of rows = %ld", [sectionInfo numberOfObjects]);
        return [sectionInfo numberOfObjects];
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TasksHeaderView *headerView = (TasksHeaderView *)[[NSBundle mainBundle] loadNibNamed:kTasksHeaderViewNibName owner:nil options:nil][0];
    headerView.frame = CGRectMake(0, 0, self.subTasksListTableView.bounds.size.width, 50);
    [AppUtilityClass shapeTopCell:headerView withRadius:kBubbleRadius];
    headerView.percentageLabel.hidden = YES;
    [headerView.progressView setProgress:0];
    if ([tableView isEqual:self.subTasksListTableView]) {
        headerView.overallStatusHeaderLabel.text = self.activityName;
    }else {
        headerView.overallStatusHeaderLabel.text = @"Remarks";
    }
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.subTasksListTableView]) {
        SubTasksCell *subTasksCell = (SubTasksCell *)[tableView dequeueReusableCellWithIdentifier:kSubTasksCellIdentifier forIndexPath:indexPath];
        [self configureMessagesCell:subTasksCell atIndexPath:indexPath];
        return subTasksCell;
    }else {
        OverallStatusCell *overallStatusHeaderCell = (OverallStatusCell *)[tableView dequeueReusableCellWithIdentifier:kOverallStatusInfoCellIdentifier forIndexPath:indexPath];
        return overallStatusHeaderCell;
    }
}

- (void)configureMessagesCell:(SubTasksCell *)subTasksCell atIndexPath:(NSIndexPath*)indexPath
{
    SubTasks *object = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
    subTasksCell.mileStoneLabel.text = object.name;
    subTasksCell.deadLineLabel.text = object.deadline;
    subTasksCell.statusLabel.hidden = YES;
    subTasksCell.statusInfoSymbol.hidden = NO;
    switch (object.status) {
        case kTaskToStart:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"to-start"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appGreyColor];
            break;
        case kTaskOnTrack:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"ongoing"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appTextColor];
        case kTaskDelayed:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"caution-icon"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appRedColor];
        case kTaskCompleted:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"tick-mark"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appTextColor];
            break;
        default:
            break;
    }
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
    self.selectedTask = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self subTasksListTableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self subTasksListTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self subTasksListTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self subTasksListTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self subTasksListTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureMessagesCell:[[self subTasksListTableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self subTasksListTableView] endUpdates];
}

- (IBAction)remarksButtonClicked:(id)sender {
    
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
