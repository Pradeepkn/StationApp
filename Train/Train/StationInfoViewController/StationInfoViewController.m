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

static NSString *const kOverallStatusInfoCellIdentifier = @"OverallStatusInfoCell";
static NSString *const kOverallStatusHeaderCellIdentifier = @"OverallStatusHeaderCell";

@interface StationInfoViewController ()<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *stationInfoTableView;
@property (nonatomic, strong) NSFetchedResultsController *stationInfoFetchedResultsController;

@end

@implementation StationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self getStationTasks];
    [self initializeStationsInfoFetchedResultsController];
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
    OverallStatusCell *overallStatusHeaderCell = (OverallStatusCell *)[tableView dequeueReusableCellWithIdentifier:kOverallStatusHeaderCellIdentifier];
    [AppUtilityClass shapeTopCell:overallStatusHeaderCell withRadius:kBubbleRadius];
    return overallStatusHeaderCell;
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
    NSLog(@"Event name = %@", object.eventName);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
