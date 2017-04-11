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
#import "UpdateRemarksStatusApi.h"
#import "GetRemarksApi.h"

static NSString *const kSubTasksCellIdentifier = @"SubTasksCellIdentifier";
static NSString *const kOverallStatusInfoCellIdentifier = @"OverallStatusInfoCell";
static NSString *const kTasksHeaderViewNibName = @"TasksHeaderView";
static NSString *const kSubTaskHeaderViewNibName = @"SubActivitiesHeaderView";
static NSString *const kRemarksStatusUpdateSegueIdentifier = @"RemarksStatusUpdateSegue";

@interface StationSubTasksViewController ()<NSFetchedResultsControllerDelegate, RemarksStatusDelegate>

@property (strong, nonatomic) User *loggedInUser;
@property (nonatomic, strong) NSMutableArray *subActivitiesArray;
@property (nonatomic, strong) NSMutableArray *remarksArray;
@property (nonatomic, strong) NSString *activityName;

@property (nonatomic, strong) NSFetchedResultsController *stationInfoFetchedResultsController;

@property (nonatomic, strong) SubTasks *selectedSubTask;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) BOOL isViewEditable;
@property (weak, nonatomic) IBOutlet PaddedLabel *subActivityName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIView *subActivityHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *subTasksListTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@end

@implementation StationSubTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.selectedStation.stationName;
    self.navigationController.navigationBarHidden = NO;
    self.subActivitiesArray = [[NSMutableArray alloc] init];
    self.remarksArray = [[NSMutableArray alloc] init];
//    [self initializeStationsInfoFetchedResultsController];
    [self getStationTasks];
    [self hideRightBarButton:YES];
    self.subTasksListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)updateHeaderView {
    CGFloat heightOfHeader = [self getHeightForText:self.activityName];
    self.subActivityHeaderView.frame = CGRectMake(0, 74, self.view.bounds.size.width - 32, heightOfHeader);
    self.subActivityName.text  = self.activityName;
    self.subActivityName.backgroundColor = [UIColor appGreyBGColor];
    self.subActivityName.textColor = [UIColor appGreyColor];
    [AppUtilityClass shapeTopCell:self.subActivityHeaderView withRadius:kBubbleRadius];
    self.topViewHeightConstraint.constant = heightOfHeader;
    self.subActivitiesArray = [NSMutableArray arrayWithArray:[[CoreDataManager sharedManager] fetchStationsSubTasksForTaskId:self.selectedTask.refId]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.subTasksListTableView reloadData];
    });
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButtonClicked:(UIBarButtonItem *)sender {
    if (sender.tag == 100) {
        sender.tag = 200;
        self.isViewEditable = YES;
        self.navigationItem.rightBarButtonItem.title = @"Done";
    }else {
        sender.tag = 100;
        self.isViewEditable = NO;
        self.navigationItem.rightBarButtonItem.title = @"Edit";
    }
}

- (void)getStationTasks {
    self.loggedInUser = [[CoreDataManager sharedManager] fetchLogedInUser];
    __weak StationSubTasksViewController *weakSelf = self;
    GetStationSubTasksApi *stationsubTasksApi = [GetStationSubTasksApi new];
    stationsubTasksApi.stationId = self.selectedStation.stationId;
    stationsubTasksApi.email = [AppUtilityClass getUserEmail];
    stationsubTasksApi.taskId = self.selectedTask.refId;
    [AppUtilityClass showLoaderOnView:self.view];
    [[APIManager sharedInstance]makeAPIRequestWithObject:stationsubTasksApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        [AppUtilityClass hideLoaderFromView:weakSelf.view];
        NSLog(@"Response = %@", responseDictionary);
        if (!error) {
            self.activityName = stationsubTasksApi.activityName;
            self.isEditable = stationsubTasksApi.editStatus;
            [self updateHeaderView];
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
        //NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (NSFetchRequest *)getTasksFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SubTasks"];
    NSSortDescriptor *deadline = [NSSortDescriptor sortDescriptorWithKey:@"deadline" ascending:YES];
    NSSortDescriptor *sortDate = [NSSortDescriptor sortDescriptorWithKey:@"sortDate" ascending:YES];

    [request setSortDescriptors:@[sortDate,deadline]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId == %@",self.selectedTask.refId];
    [request setPredicate:predicate];
    return request;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.subActivitiesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SubTasks *object = [self.subActivitiesArray objectAtIndex:section];
    return [[CoreDataManager sharedManager] fetchRemarksFor:object.stationSubActivityId].count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubTasks *object = [self.subActivitiesArray objectAtIndex:indexPath.section];
    NSArray *remarksArray = [[CoreDataManager sharedManager] fetchRemarksFor:object.stationSubActivityId];
    Remarks *remarkObject;
    if (remarksArray.count > indexPath.row) {
        remarkObject = (Remarks*)remarksArray[indexPath.row];
    }else {
        return 0;
    }
    CGFloat heightOffSet = 25.0f;
    if (indexPath.row != 0) {
        heightOffSet = 5.0f;
    }
    if (remarkObject.message.length > 0) {
        heightOffSet += [AppUtilityClass sizeOfText:remarkObject.message widthOfTextView:self.subTasksListTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaSemibold size:20]].height;
    }else {
        heightOffSet = 0.0f;
    }
    return heightOffSet;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SubTasks *object = [self.subActivitiesArray objectAtIndex:section];
    return [AppUtilityClass sizeOfText:object.name widthOfTextView:self.subTasksListTableView.frame.size.width/2 - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:16]].height + 25;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SubTasks *object = [self.subActivitiesArray objectAtIndex:section];
    CGFloat heightOfHeader = [self getHeightForText:object.name];
    SubActivitiesHeaderView *subHeader = (SubActivitiesHeaderView *)[[NSBundle mainBundle] loadNibNamed:kSubTaskHeaderViewNibName owner:nil options:nil][0];
    subHeader.frame = CGRectMake(0, 0, self.view.bounds.size.width - 32, heightOfHeader);
    subHeader.tag = section;
    [subHeader.actionButton addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self configureMessagesCell:subHeader withSubTask:object];
    return subHeader;
}

- (CGFloat)getHeightForText:(NSString *)string {
    CGFloat heightOfHeader = [AppUtilityClass sizeOfText:string widthOfTextView:self.subTasksListTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaSemibold size:18]].height;
    if (heightOfHeader < 30) {
        heightOfHeader = 30;
    }else if (heightOfHeader > 120) {
        heightOfHeader = 120.0f;
    }
    return heightOfHeader + 64;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubTasksCell *subTasksCell = (SubTasksCell *)[tableView dequeueReusableCellWithIdentifier:kSubTasksCellIdentifier forIndexPath:indexPath];
    [self configureRemarksCell:subTasksCell atIndexPath:indexPath];
    return subTasksCell;
}

- (void)configureRemarksCell:(SubTasksCell *)remarksCell atIndexPath:(NSIndexPath*)indexPath {
    SubTasks *object = [self.subActivitiesArray objectAtIndex:indexPath.section];
    Remarks *remarkObject = (Remarks*)[[CoreDataManager sharedManager] fetchRemarksFor:object.stationSubActivityId][indexPath.row];
    remarksCell.remarksMessageLabel.text = remarkObject.message;
    if (indexPath.row != 0) {
        remarksCell.remarksHeaderLabel.text = @"";
        remarksCell.remarksHeaderHeightConstraint.constant = 10.0f;
    }else {
        remarksCell.remarksHeaderLabel.text = @"Remarks";
        remarksCell.remarksHeaderHeightConstraint.constant = 20.0f;
    }
}

- (void)configureMessagesCell:(SubActivitiesHeaderView *)subActivityHeaderView
                  withSubTask:(SubTasks *)subTaskObject {
    subActivityHeaderView.mileStoneLabel.text = subTaskObject.name;
    subActivityHeaderView.deadLineLabel.text = subTaskObject.deadline;
    subActivityHeaderView.statusInfoSymbol.hidden = NO;
    subActivityHeaderView.statusInfoSymbol.userInteractionEnabled = NO;
    switch (subTaskObject.status) {
        case kTaskToStart:
            [subActivityHeaderView.statusInfoSymbol setImage:[UIImage imageNamed:@"to-start"] forState:UIControlStateNormal];
            subActivityHeaderView.mileStoneLabel.textColor = [UIColor lightGrayColor];
            subActivityHeaderView.deadLineLabel.textColor = [UIColor lightGrayColor];
            break;
        case kTaskOnTrack:
            [subActivityHeaderView.statusInfoSymbol setImage:[UIImage imageNamed:@"ongoing"] forState:UIControlStateNormal];
            subActivityHeaderView.mileStoneLabel.textColor = [UIColor appTextColor];
            subActivityHeaderView.deadLineLabel.textColor = [UIColor appTextColor];
            break;
        case kTaskDelayed:
            [subActivityHeaderView.statusInfoSymbol setImage:[UIImage imageNamed:@"caution-icon"] forState:UIControlStateNormal];
            subActivityHeaderView.mileStoneLabel.textColor = [UIColor appRedColor];
            subActivityHeaderView.deadLineLabel.textColor = [UIColor appRedColor];
            break;
        case kTaskCompleted:
            [subActivityHeaderView.statusInfoSymbol setImage:[UIImage imageNamed:@"tick-mark"] forState:UIControlStateNormal];
            subActivityHeaderView.mileStoneLabel.textColor = [UIColor grayColor];
            subActivityHeaderView.deadLineLabel.textColor = [UIColor grayColor];
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

- (void)sectionButtonTapped:(UIButton *)sender {
    if (!self.isViewEditable) {
        return;
    }
    self.selectedSubTask = [self.subActivitiesArray objectAtIndex:sender.tag];
    RemarksStatusUpdateViewController *remarksStatusVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RemarksStatusUpdateViewController"];
    remarksStatusVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    remarksStatusVC.delegate = self;
    remarksStatusVC.selectedStation = self.selectedStation;
    [self presentViewController:remarksStatusVC animated:YES completion:^{
        ;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)remarksButtonClicked:(id)sender {
    [self displayRemarksStatusUpdateViewWithMessage:NO];
}

- (void)displayRemarksStatusUpdateViewWithMessage:(BOOL)withMessage {
    RemarksStatusUpdateViewController *remarksStatusVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RemarksStatusUpdateViewController"];
    remarksStatusVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    remarksStatusVC.delegate = self;
    remarksStatusVC.selectedStation = self.selectedStation;
    [self presentViewController:remarksStatusVC animated:YES completion:^{
        ;
    }];
}

- (void)updateRemarks:(NSString *)remarksMessage {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak StationSubTasksViewController *weakSelf = self;
    SendRemarksApi *sendRemarksApiObject = [SendRemarksApi new];
    sendRemarksApiObject.email = [AppUtilityClass getUserEmail];
    sendRemarksApiObject.stationId = self.selectedStation.stationId;
    sendRemarksApiObject.message = remarksMessage;
    sendRemarksApiObject.taskId = self.selectedTask.refId;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:sendRemarksApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              //NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              if (dataDict.allKeys.count > 0) {
                                              }else{
                                                  if (errorDict.allKeys.count > 0) {
                                                      if ([AppUtilityClass getErrorMessageFor:errorDict]) {
                                                          [AppUtilityClass showErrorMessage:[AppUtilityClass getErrorMessageFor:errorDict]];
                                                          return;
                                                      }
                                                  }
                                                  [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                              }
                                          }];
}

- (void)updateStatus:(TasksStatus)status withRemarksMessage:(NSString *)remarksMessage{
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak StationSubTasksViewController *weakSelf = self;
    UpdateSubTasksStatusApi *updateSubTaskStatusApiObject = [UpdateSubTasksStatusApi new];
    updateSubTaskStatusApiObject.status = status;
    updateSubTaskStatusApiObject.stationSubActivityId = self.selectedSubTask.stationSubActivityId;
    updateSubTaskStatusApiObject.remarks = remarksMessage;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:updateSubTaskStatusApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              //NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self getStationTasks];
                                              }else{
                                                  if (errorDict.allKeys.count > 0) {
                                                      if ([AppUtilityClass getErrorMessageFor:errorDict]) {
                                                          [AppUtilityClass showErrorMessage:[AppUtilityClass getErrorMessageFor:errorDict]];
                                                          return;
                                                      }
                                                  }
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
