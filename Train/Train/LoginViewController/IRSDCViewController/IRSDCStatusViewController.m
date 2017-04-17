//
//  IRSDCStatusViewController.m
//  Train
//
//  Created by pradeep on 4/13/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "IRSDCStatusViewController.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"
#import "SubTasksCell.h"
#import "SubActivitiesHeaderView.h"
#import "SubStreamStatusCell.h"
#import "SubTasksCell.h"
#import "RemarksStatusUpdateViewController.h"
#import "UpdateSubTasksStatusApi.h"
#import "IRSDCApi.h"
#import "TasksStatusHeaderView.h"

static NSString *kSubStreamStatusCellIdentifier = @"subStreamStatusCellIdentifier";

@interface IRSDCStatusViewController ()<RemarksStatusDelegate>

@property (weak, nonatomic) IBOutlet UITableView *statusTableView;
@property (strong, nonatomic) NSMutableArray *statusArray;
@property (nonatomic, assign) BOOL isViewEditable;
@property (weak, nonatomic) IBOutlet UILabel *editInfoLabel;

@end

@implementation IRSDCStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editInfoLabel.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
    self.statusArray = [[NSMutableArray alloc] initWithObjects:@"",@"Start Date",@"Target Completion Date", @"Owner",@"Status",  nil];
    
    self.title = self.selectedStations.stationName;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClicked)];
    [leftButton setImage:[UIImage imageNamed:@"left-arrow"]];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self getStationSubTasksRemarks];
    [self hideRightBarButton:self.isEditable];
}

- (void)addRighBarButton {
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(editButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    rightBarButton.tag = 100;
}

- (void)hideRightBarButton:(BOOL)isHidden {
    self.navigationItem.rightBarButtonItem.title = @"";
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (!isHidden) {
        self.editInfoLabel.hidden = YES;
        self.isViewEditable = NO;
    } else {
        self.editInfoLabel.hidden = NO;
        self.isViewEditable = YES;
    }
}

- (void)backButtonClicked {
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


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightOffSet = 0.0f;

    switch (indexPath.row) {
        case 0: {
            heightOffSet = [AppUtilityClass sizeOfText:self.selectedSubTasks.name widthOfTextView:self.statusTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:22]].height;
            if (heightOffSet < kTableCellHeight) {
                heightOffSet = kTableCellHeight;
            }
            return heightOffSet;
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return kTableCellHeight;
        break;
            
        default:
            break;
    }
    NSArray *remarksArray = [[CoreDataManager sharedManager] fetchRemarksFor:self.selectedSubTasks.stationSubActivityId];
    Remarks *remarkObject;
    if (remarksArray.count > indexPath.row - 5) {
        remarkObject = (Remarks*)remarksArray[indexPath.row - 5];
    }else {
        return 0;
    }
    if (indexPath.row != 0) {
        heightOffSet = 0.0f;
    }else {
        heightOffSet = 30.0f;
    }
    if (remarkObject.message) {
        heightOffSet += [AppUtilityClass sizeOfText:remarkObject.message widthOfTextView:self.statusTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:15]].height;
        if (heightOffSet < kTableCellHeight) {
            heightOffSet = kTableCellHeight;
        }
    }else {
        heightOffSet = 0.0f;
    }
    return heightOffSet;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat heightOffSet = [AppUtilityClass sizeOfText:self.selectedTasks.eventName widthOfTextView:self.statusTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:20]].height;
    if (heightOffSet < kTableCellHeight) {
        heightOffSet = kTableCellHeight;
    }
    return heightOffSet;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat heightOfHeader = [self getHeightForText:self.selectedTasks.eventName];
    TasksStatusHeaderView *subHeader = (TasksStatusHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"TasksStatusHeaderView" owner:nil options:nil][0];
    subHeader.frame = CGRectMake(0, 0, self.view.bounds.size.width - 32, heightOfHeader);
    subHeader.nameLabel.text = self.selectedTasks.eventName;
    return subHeader;
}


- (NSInteger)getHeightForText:(NSString*)message {
    CGFloat heightOfText = [AppUtilityClass sizeOfText:message widthOfTextView:self.statusTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:20.0f]].height;
    return  heightOfText;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row < 5) {
        SubStreamStatusCell *subStreamStatusCell = (SubStreamStatusCell *) [tableView dequeueReusableCellWithIdentifier:kSubStreamStatusCellIdentifier forIndexPath:indexPath];
        subStreamStatusCell.nameLabel.hidden = YES;
        subStreamStatusCell.titleLabel.hidden = NO;
        subStreamStatusCell.timeLabel.hidden = NO;

        switch (indexPath.row) {
            case 0: {
                subStreamStatusCell.nameLabel.hidden = NO;
                subStreamStatusCell.titleLabel.hidden = YES;
                subStreamStatusCell.timeLabel.hidden = YES;
                subStreamStatusCell.nameLabel.text = self.selectedSubTasks.name;
            }
                break;
            case 1: {
                [subStreamStatusCell.timeLabel setTitle:@"NA" forState:UIControlStateNormal];
                break;
            }
            case 2: {
                [subStreamStatusCell.timeLabel setTitle:self.selectedSubTasks.deadline forState:UIControlStateNormal];
                break;
            }
            case 3: {
                [subStreamStatusCell.timeLabel setTitle:@"NA" forState:UIControlStateNormal];
            }
                break;
            case 4: {
                [self configureMessagesCell:subStreamStatusCell];
            }
                break;
                
            default:
                break;
        }
        subStreamStatusCell.titleLabel.text = [self.statusArray objectAtIndex:indexPath.row];
        return subStreamStatusCell;
    }
    SubTasksCell *remarksCell = (SubTasksCell *)[tableView dequeueReusableCellWithIdentifier:kSubTasksCellIdentifier forIndexPath:indexPath];
    Remarks *remarkObject = self.statusArray[indexPath.row];
    remarksCell.remarksMessageLabel.text = remarkObject.message;
    
    if (indexPath.row != 5) {
        remarksCell.remarksHeaderLabel.text = @"";
        remarksCell.remarksHeaderHeightConstraint.constant = 10.0f;
    }else {
        remarksCell.remarksHeaderLabel.text = @"Remarks";
        remarksCell.remarksHeaderHeightConstraint.constant = 20.0f;
    }

    return remarksCell;
}

- (void)configureRemarksCell:(SubTasksCell *)remarksCell atIndexPath:(NSIndexPath*)indexPath {
    }

- (void)configureMessagesCell:(SubStreamStatusCell *)overallStatusHeaderCell {
    switch (self.selectedSubTasks.status) {
        case kTaskToStart:
            [overallStatusHeaderCell.timeLabel setImage:[UIImage imageNamed:@"to-start"] forState:UIControlStateNormal];
            break;
        case kTaskOnTrack:
            [overallStatusHeaderCell.timeLabel setImage:[UIImage imageNamed:@"ongoing"] forState:UIControlStateNormal];
            break;
        case kTaskDelayed:
            [overallStatusHeaderCell.timeLabel setImage:[UIImage imageNamed:@"caution-icon"] forState:UIControlStateNormal];
            break;
        case kTaskCompleted:
            [overallStatusHeaderCell.timeLabel setImage:[UIImage imageNamed:@"tick-mark"] forState:UIControlStateNormal];
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
    if (indexPath.row == 4 && self.isViewEditable) {
        RemarksStatusUpdateViewController *remarksStatusVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RemarksStatusUpdateViewController"];
        remarksStatusVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        remarksStatusVC.delegate = self;
        remarksStatusVC.selectedStation = self.selectedStations;
        remarksStatusVC.statusCode = self.selectedSubTasks.status;
        [self presentViewController:remarksStatusVC animated:YES completion:^{
            ;
        }];
    }
}

- (void)updateStatus:(TasksStatus)status withRemarksMessage:(NSString *)remarksMessage{
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak IRSDCStatusViewController *weakSelf = self;
    UpdateSubTasksStatusApi *updateSubTaskStatusApiObject = [UpdateSubTasksStatusApi new];
    updateSubTaskStatusApiObject.status = status;
    updateSubTaskStatusApiObject.stationSubActivityId = self.selectedSubTasks.stationSubActivityId;
    updateSubTaskStatusApiObject.remarks = remarksMessage;
    [[APIManager sharedInstance]makePostAPIRequestWithObject:updateSubTaskStatusApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              //NSLog(@"Response = %@", responseDictionary);

                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self fetchSubStreams];
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

- (void)fetchSubStreams {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AppUtilityClass setToFirstPhaseFlow:YES];
        IRSDCGetStationSubTasks *irsdcStationsTasksApi = [IRSDCGetStationSubTasks new];
        irsdcStationsTasksApi.stationId = self.selectedStations.stationId;
        irsdcStationsTasksApi.taskId = self.selectedTasks.refId;
        [[APIManager sharedInstance]makeAPIRequestWithObject:irsdcStationsTasksApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
            NSLog(@"Response = %@", responseDictionary);
            [self getStationSubTasksRemarks];
        }];
    });
}

- (void)getStationSubTasksRemarks {
    NSArray *remarksArray = [[CoreDataManager sharedManager] fetchRemarksFor:self.selectedSubTasks.stationSubActivityId];
    for (Remarks *remarkObject in remarksArray) {
        if (![remarkObject.message isEqualToString:@""] && ![self.statusArray containsObject:remarkObject]) {
            [self.statusArray addObject:remarkObject];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.statusTableView reloadData];
    });
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
