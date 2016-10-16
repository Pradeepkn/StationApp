//
//  StationInfoViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/2/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "StationInfoViewController.h"
#import "OverallStatusCell.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"
#import "GetStationTasksApi.h"
#import "GetStationSubTasksApi.h"
#import "TasksHeaderView.h"
#import "UIColor+AppColor.h"
#import "StationSubTasksViewController.h"

static NSString *const kOverallStatusInfoCellIdentifier = @"OverallStatusInfoCell";
static NSString *const kOverallStatusHeaderCellIdentifier = @"OverallStatusHeaderCell";
static NSString *const kTasksHeaderViewNibName = @"TasksHeaderView";
static NSString *const kStationSubTaskSegueIdentifier = @"StationSubTaskSegue";

@interface StationInfoViewController ()<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *stationInfoTableView;
@property (nonatomic, strong) NSFetchedResultsController *stationInfoFetchedResultsController;
@property (nonatomic, strong) NSString *percentageCompleted;
@property (nonatomic, strong) Tasks *selectedTask;

@end

@implementation StationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self getStationTasks];
    [self initializeStationsInfoFetchedResultsController];
    self.title = self.selectedStation.stationName;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getStationTasks {
    __weak StationInfoViewController *weakSelf = self;
    GetStationTasksApi *stationTasksApi = [GetStationTasksApi new];
    stationTasksApi.stationId = self.selectedStation.stationId;
    [[APIManager sharedInstance]makeAPIRequestWithObject:stationTasksApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        weakSelf.percentageCompleted = [NSString stringWithFormat:@"%ld%%", stationTasksApi.percentageCompleted];
        if (!error) {
            [weakSelf.stationInfoTableView reloadData];
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tasks"];
    NSSortDescriptor *message = [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:NO];
    [request setSortDescriptors:@[message]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationId == %@",self.selectedStation.stationId];
    [request setPredicate:predicate];
    return request;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tasks *object = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
    return [AppUtilityClass sizeOfText:object.eventName widthOfTextView:self.stationInfoTableView.frame.size.width - 30 withFont:[UIFont fontWithName:kProximaNovaRegular size:18]].height + 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self stationInfoFetchedResultsController] sections][section];
    return [sectionInfo numberOfObjects]; ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TasksHeaderView *headerView = (TasksHeaderView *)[[NSBundle mainBundle] loadNibNamed:kTasksHeaderViewNibName owner:nil options:nil][0];
    headerView.frame = CGRectMake(0, 0, self.stationInfoTableView.bounds.size.width, 50);
    [AppUtilityClass shapeTopCell:headerView withRadius:kBubbleRadius];
    headerView.percentageLabel.text = self.percentageCompleted;
    [headerView.progressView setProgress:([self.percentageCompleted floatValue]/100)];
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OverallStatusCell *overallStatusHeaderCell = (OverallStatusCell *)[tableView dequeueReusableCellWithIdentifier:kOverallStatusInfoCellIdentifier forIndexPath:indexPath];
    [self configureMessagesCell:overallStatusHeaderCell atIndexPath:indexPath];
    return overallStatusHeaderCell;
}

- (void)configureMessagesCell:(OverallStatusCell *)overallStatusHeaderCell atIndexPath:(NSIndexPath*)indexPath
{
    Tasks *object = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
    overallStatusHeaderCell.statusInfoLabel.text = object.eventName;
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
    self.selectedTask = [[self stationInfoFetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kStationSubTaskSegueIdentifier sender:self];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self stationInfoTableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self stationInfoTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self stationInfoTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
            [[self stationInfoTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self stationInfoTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureMessagesCell:[[self stationInfoTableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self stationInfoTableView] endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kStationSubTaskSegueIdentifier]) {
        StationSubTasksViewController *stationInfoVC = (StationSubTasksViewController *)[segue destinationViewController];
        stationInfoVC.selectedTask = self.selectedTask;
        stationInfoVC.selectedStation = self.selectedStation;
    }
}

@end
