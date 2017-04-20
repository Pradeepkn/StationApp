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
#import "OtherCabinetQueryApi.h"
#import "QueriesResponseViewController.h"

@interface QueriesViewController () {
    NSInteger selectedSection;
    NSMutableSet* _collapsedSections;
    UIFont *appFont;
}

@property (strong, nonatomic) NSMutableArray *topicAreasArray;
@property (strong, nonatomic) NSArray *queriesArray;
@property (strong, nonatomic) User *loggedInUser;
@property (weak, nonatomic) IBOutlet UITableView *queriesTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) QueriesData *selectedQueryData;

@end

@implementation QueriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClicked:)];
    [leftButton setImage:[UIImage imageNamed:@"left-arrow"]];
    self.navigationItem.leftBarButtonItem = leftButton;
    _collapsedSections = [NSMutableSet new];
    self.topicAreasArray = [[NSMutableArray alloc] init];
    [self getOtherCabinetQueries];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.queriesTableView reloadData];
}

- (void)getOtherCabinetQueries {
    self.loggedInUser = [[CoreDataManager sharedManager] fetchLogedInUser];
    __weak QueriesViewController *weakSelf = self;
    OtherCabinetQueryApi *othersCabinetQueryApi = [OtherCabinetQueryApi new];
    othersCabinetQueryApi.email = [AppUtilityClass getUserEmail];
    [AppUtilityClass showLoaderOnView:self.view];
    [[APIManager sharedInstance]makeAPIRequestWithObject:othersCabinetQueryApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        [AppUtilityClass hideLoaderFromView:weakSelf.view];
        if (!error) {

            [self getTopicAreas];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}


- (void)getTopicAreas {
    NSArray *topicArray = [[CoreDataManager sharedManager] fetchQueriesForStationName:@"othersCabinetQuery"];
    for (QueriesData *queries in topicArray) {
        if (![self.topicAreasArray containsObject:queries.topicArea]) {
            [self.topicAreasArray addObject:queries.topicArea];
        }
    }
    [self.queriesTableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QueriesData *query = (QueriesData *) [self.queriesArray objectAtIndex:indexPath.row];
    CGFloat cellHeight = [AppUtilityClass sizeOfText:query.name widthOfTextView:self.queriesTableView.frame.size.width - 30 withFont:[UIFont fontWithName:self.titleLabel.font.fontName size:16.0f]].height + 40;
    if (cellHeight < kTableCellHeight) {
        return kTableCellHeight;
    }
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.topicAreasArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_collapsedSections containsObject:@(section)] ? [self queriesArrayCountForSection:section] : 0;
}

- (NSInteger)queriesArrayCountForSection:(NSInteger)section {
    NSString *topicArea = [self.topicAreasArray objectAtIndex:section];
    self.queriesArray = [[CoreDataManager sharedManager] fetchQueriesForTopicArea:topicArea andStationName:@"othersCabinetQuery"];
    return self.queriesArray.count;
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
    QueriesData *query = (QueriesData *) [self.queriesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n\nRecieved on : %@", query.name, [self getRecievedDate:query.dateReceived]];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont fontWithName:kProximaNovaRegular size:14];
    
    CGRect textLabelFrame = cell.textLabel.frame;
    textLabelFrame.origin.x += 10;
    textLabelFrame.size.width -= 10;
    cell.textLabel.frame = textLabelFrame;
    
    if (self.topicAreasArray.count == indexPath.section && self.queriesArray.count == indexPath.row - 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AppUtilityClass shapeBottomCell:cell.contentView withRadius:6.0];
        });
    }
    return cell;
}

- (NSString *)getRecievedDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
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
    self.selectedQueryData = (QueriesData *) [self.queriesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kQueriesResponseSegueIdentifier sender:self];
}

- (void)streamSectionClicked:(UIButton *)sender {
    selectedSection = sender.tag;
    bool shouldCollapse = [_collapsedSections containsObject:@(selectedSection)];
    if (shouldCollapse) {
        [self.queriesTableView beginUpdates];
        NSInteger numOfRows = [self.queriesTableView numberOfRowsInSection:selectedSection];
        NSArray* indexPaths = [self indexPathsForSection:selectedSection withNumberOfRows:numOfRows];
        if (indexPaths.count > 0) {
            [self.queriesTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        }
        [_collapsedSections removeObject:@(selectedSection)];
        [self.queriesTableView endUpdates];
    }
    else {
        [self.queriesTableView beginUpdates];
        NSInteger numOfRows = [self queriesArrayCountForSection:selectedSection];
        NSArray* indexPaths = [self indexPathsForSection:selectedSection withNumberOfRows:numOfRows];
        if (indexPaths.count > 0) {
            [self.queriesTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        }
        [_collapsedSections addObject:@(selectedSection)];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kQueriesResponseSegueIdentifier]) {
        QueriesResponseViewController *queriesResponseVC = (QueriesResponseViewController *)[segue destinationViewController];
        queriesResponseVC.selectedQueryData = self.selectedQueryData;
    }
}

@end
