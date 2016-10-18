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
#import "SendRemarksApi.h"
#import "UpdateSubTasksStatusApi.h"
#import "SubActivitiesHeaderView.h"
#import "RemarksStatusUpdateViewController.h"

static NSString *const kSubTasksCellIdentifier = @"SubTasksCellIdentifier";
static NSString *const kOverallStatusInfoCellIdentifier = @"OverallStatusInfoCell";
static NSString *const kTasksHeaderViewNibName = @"TasksHeaderView";
static NSString *const kSubTaskHeaderViewNibName = @"SubActivitiesHeaderView";
static NSString *const kRemarksStatusUpdateSegueIdentifier = @"RemarksStatusUpdateSegue";

@interface StationSubTasksViewController ()<NSFetchedResultsControllerDelegate, RemarksStatusDelegate>

@property (strong, nonatomic) User *loggedInUser;
@property (weak, nonatomic) IBOutlet UITableView *subTasksListTableView;
@property (weak, nonatomic) IBOutlet UITableView *remarksTableView;
@property (nonatomic, strong) NSMutableArray *subActivitiesArray;
@property (nonatomic, strong) NSMutableArray *remarksArray;
@property (nonatomic, strong) NSString *activityName;
@property (weak, nonatomic) IBOutlet UIButton *remarksButton;

@property (nonatomic, strong) NSFetchedResultsController *stationInfoFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *remarksFetchedResultsController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (nonatomic, assign) BOOL isRemarksUpdate;
@property (nonatomic, strong) SubTasks *selectedSubTask;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) BOOL isViewEditable;

@end

@implementation StationSubTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.selectedStation.stationName;
    self.navigationController.navigationBarHidden = NO;
    self.subActivitiesArray = [[NSMutableArray alloc] init];
    self.remarksArray = [[NSMutableArray alloc] init];
    [self initializeStationsInfoFetchedResultsController];
    [self getStationTasks];
    [self hideRightBarButton:YES];
    self.remarksButton.hidden = YES;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButtonClicked:(UIBarButtonItem *)sender {
    if (sender.tag == 100) {
        sender.tag = 200;
        self.isViewEditable = YES;
        self.navigationItem.rightBarButtonItem.title = @"Done";
        self.remarksButton.hidden = NO;
    }else {
        sender.tag = 100;
        self.isViewEditable = NO;
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        self.remarksButton.hidden = YES;
    }
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
            self.isEditable = stationsubTasksApi.editStatus;
            [weakSelf hideRightBarButton:self.isEditable];
            [weakSelf.subTasksListTableView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)hideRightBarButton:(BOOL)isHidden {
    if (!isHidden) {
        self.navigationItem.rightBarButtonItem.title = @"";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
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
    
    [self setRemarksFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getRemarksFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self remarksFetchedResultsController] setDelegate:self];
    
    if (![[self remarksFetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (NSFetchRequest *)getTasksFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SubTasks"];
    NSSortDescriptor *message = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:NO];
    [request setSortDescriptors:@[message]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId == %@",self.selectedTask.refId];
    [request setPredicate:predicate];
    return request;
}

- (NSFetchRequest *)getRemarksFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Remarks"];
    NSSortDescriptor *message = [NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO];
    [request setSortDescriptors:@[message]];
    NSLog(@"View Task ID = %@", self.selectedTask.refId);

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId == %@",self.selectedTask.refId];
    [request setPredicate:predicate];
    return request;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.subTasksListTableView]) {
        SubTasks *object = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.name widthOfTextView:self.subTasksListTableView.frame.size.width/2 - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:16]].height + 25;
    }else {
        Remarks *object = [[self remarksFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.message widthOfTextView:self.remarksTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:16]].height + 25;
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
        id< NSFetchedResultsSectionInfo> sectionInfo = [[self remarksFetchedResultsController] sections][section];
        NSLog(@"Number of rows = %ld", [sectionInfo numberOfObjects]);
        return [sectionInfo numberOfObjects];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.subTasksListTableView]) {
        return 86.0f;
    }else {
        return 50.0f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.subTasksListTableView]) {
         SubActivitiesHeaderView *subHeader = (SubActivitiesHeaderView *)[[NSBundle mainBundle] loadNibNamed:kSubTaskHeaderViewNibName owner:nil options:nil][0];
        subHeader.frame = CGRectMake(0, 0, self.view.bounds.size.width - 32, 86);
        subHeader.subActivityName.text  = self.activityName;
        [AppUtilityClass shapeTopCell:subHeader withRadius:kBubbleRadius];
        return subHeader;
    }else {
        TasksHeaderView *headerView = (TasksHeaderView *)[[NSBundle mainBundle] loadNibNamed:kTasksHeaderViewNibName owner:nil options:nil][0];
        headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 32, 50);
        [AppUtilityClass shapeTopCell:headerView withRadius:kBubbleRadius];
        headerView.percentageLabel.hidden = YES;
        [headerView.progressView setProgress:0];
        headerView.overallStatusHeaderLabel.text = @"Remarks";
        return headerView;
    }
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
        [self configureRemarksCell:overallStatusHeaderCell atIndexPath:indexPath];
        return overallStatusHeaderCell;
    }
}

- (void)configureMessagesCell:(SubTasksCell *)subTasksCell atIndexPath:(NSIndexPath*)indexPath
{
    SubTasks *object = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
    subTasksCell.mileStoneLabel.text = object.name;
    subTasksCell.deadLineLabel.text = object.deadline;
    subTasksCell.statusInfoSymbol.hidden = NO;
    switch (object.status) {
        case kTaskToStart:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"to-start"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appGreyColor];
            subTasksCell.deadLineLabel.textColor = [UIColor appGreyColor];
            break;
        case kTaskOnTrack:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"ongoing"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appTextColor];
            subTasksCell.deadLineLabel.textColor = [UIColor appTextColor];
            break;
        case kTaskDelayed:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"caution-icon"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appRedColor];
            subTasksCell.deadLineLabel.textColor = [UIColor appRedColor];
            break;
        case kTaskCompleted:
            [subTasksCell.statusInfoSymbol setImage:[UIImage imageNamed:@"tick-mark"] forState:UIControlStateNormal];
            subTasksCell.mileStoneLabel.textColor = [UIColor appTextColor];
            subTasksCell.deadLineLabel.textColor = [UIColor appTextColor];
            break;
        default:
            break;
    }
}

- (void)configureRemarksCell:(OverallStatusCell *)overallStatusHeaderCell atIndexPath:(NSIndexPath*)indexPath
{
    Remarks *object = [[self remarksFetchedResultsController] objectAtIndexPath:indexPath];
    overallStatusHeaderCell.statusInfoLabel.text = object.message;
    switch (object.status) {
        case kTaskToStart:
            [overallStatusHeaderCell.statusInfoSymbol setImage:[UIImage imageNamed:@"to-start"] forState:UIControlStateNormal];
            overallStatusHeaderCell.statusInfoLabel.textColor = [UIColor appGreyColor];
            break;
        case kTaskOnTrack:
            [overallStatusHeaderCell.statusInfoSymbol setImage:[UIImage imageNamed:@"ongoing"] forState:UIControlStateNormal];
            overallStatusHeaderCell.statusInfoLabel.textColor = [UIColor appTextColor];
        case kTaskDelayed:
            [overallStatusHeaderCell.statusInfoSymbol setImage:[UIImage imageNamed:@"caution-icon"] forState:UIControlStateNormal];
            overallStatusHeaderCell.statusInfoLabel.textColor = [UIColor appRedColor];
        case kTaskCompleted:
            [overallStatusHeaderCell.statusInfoSymbol setImage:[UIImage imageNamed:@"tick-mark"] forState:UIControlStateNormal];
            overallStatusHeaderCell.statusInfoLabel.textColor = [UIColor appTextColor];
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
    if (!self.isViewEditable) {
        return;
    }
    if ([tableView isEqual:self.subTasksListTableView]) {
        self.selectedSubTask = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
        self.isRemarksUpdate = NO;
        [self displayRemarksStatusUpdateView];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:self.stationInfoFetchedResultsController]) {
        [[self subTasksListTableView] beginUpdates];
    }else {
        [[self remarksTableView] beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if ([controller isEqual:self.stationInfoFetchedResultsController]) {
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
    }else {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [[self remarksTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self remarksTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeMove:
            case NSFetchedResultsChangeUpdate:
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([controller isEqual:self.stationInfoFetchedResultsController]) {
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
    }else {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [[self remarksTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self remarksTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureRemarksCell:[[self remarksTableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeMove:
                break;
        }
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:self.stationInfoFetchedResultsController]) {
        [[self subTasksListTableView] endUpdates];
    }else {
        [[self remarksTableView] endUpdates];
    }
}

- (IBAction)remarksButtonClicked:(id)sender {
    self.isRemarksUpdate = YES;
    [self displayRemarksStatusUpdateView];
}

- (void)displayRemarksStatusUpdateView {
    RemarksStatusUpdateViewController *remarksStatusVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RemarksStatusUpdateViewController"];
    remarksStatusVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    remarksStatusVC.delegate = self;
    remarksStatusVC.isRemarksUpdate = self.isRemarksUpdate;
    remarksStatusVC.selectedStation = self.selectedStation;
    if (!self.isRemarksUpdate) {
        remarksStatusVC.statusCode = self.selectedSubTask.status;
    }
    [self presentViewController:remarksStatusVC animated:YES completion:^{
        ;
    }];
}

- (void)updateRemarks:(NSString *)remarksMessage {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak StationSubTasksViewController *weakSelf = self;
    SendRemarksApi *sendRemarksApiObject = [SendRemarksApi new];
    sendRemarksApiObject.email = self.loggedInUser.email;
    sendRemarksApiObject.stationId = self.selectedStation.stationId;
    sendRemarksApiObject.message = remarksMessage;
    sendRemarksApiObject.taskId = self.selectedTask.refId;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:sendRemarksApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self getStationTasks];
                                              }else{
                                                  if (errorDict.allKeys.count > 0) {
                                                      if ([AppUtilityClass getErrorMessageFor:errorDict]) {
                                                          [AppUtilityClass showErrorMessage:[AppUtilityClass getErrorMessageFor:errorDict]];
                                                      }else {
                                                          [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                                      }
                                                  }
                                              }
                                          }];
}

- (void)updateStatus:(TasksStatus)status{
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak StationSubTasksViewController *weakSelf = self;
    UpdateSubTasksStatusApi *updateSubTaskStatusApiObject = [UpdateSubTasksStatusApi new];
    updateSubTaskStatusApiObject.status = status;
    updateSubTaskStatusApiObject.stationSubActivityId = self.selectedSubTask.stationSubActivityId;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:updateSubTaskStatusApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self getStationTasks];
                                              }else{
                                                  if (errorDict.allKeys.count > 0) {
                                                      if ([AppUtilityClass getErrorMessageFor:errorDict]) {
                                                          [AppUtilityClass showErrorMessage:[AppUtilityClass getErrorMessageFor:errorDict]];
                                                      }else {
                                                          [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                                      }
                                                  }
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
