//
//  StationGalleryInfoViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/10/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "StationGalleryInfoViewController.h"
#import "GalleryCollectionViewCell.h"
#import "LocalizationKeys.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"
#import "StaionGalleryInfoApi.h"
#import "StationGalleryViewCell.h"
#import "UploadImagesViewController.h"
#import "ImagesGalleryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+AppColor.h"
#import "NSString+AutoCapitalizeString.h"
#import "StationGalleryHeaderView.h"
#import "UIImage+ImageAdditions.h"
#import "IRSDCSectionHeaderView.h"
#import "CustomAlertViewController.h"

static NSString *const kGalleryCellIdentifier=  @"galleryCell";
static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";
static NSString *const kUploadImageSegueIdentifier = @"UploadImageSegue";
static NSString *const kGalleryCollectionHeaderIdentifier = @"GalleryCollectionHeader";

@interface StationGalleryInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource> {
    BOOL isEmptyCells;
    UIColor *unselectedButtonColor;
    UIColor *selectedButtonColor;
    NSInteger selectedSection;
    NSMutableSet* _collapsedSections;
}

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *divisionLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageDailyFootFallLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *imageGalleryCollectionView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (strong, nonatomic) User *loggedInUser;
@property (nonatomic, strong) NSArray *weekKeys;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *queriesButton;
@property (weak, nonatomic) IBOutlet UIView *queriesView;
@property (weak, nonatomic) IBOutlet UITableView *queriesTableView;
@property (strong, nonatomic) NSMutableArray *topicAreasArray;
@property (strong, nonatomic) NSArray *queriesArray;

@end

@implementation StationGalleryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEmptyCells = YES;
    selectedButtonColor = self.galleryButton.titleLabel.textColor;
    unselectedButtonColor = self.queriesButton.titleLabel.textColor;
    
    _collapsedSections = [NSMutableSet new];
    self.topicAreasArray = [[NSMutableArray alloc] init];
    [self queriesButtonClicked:self.queriesButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self isViewEditable:NO];
    [self getStationTasks];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)galleryButtonClicked:(UIButton *)sender {
    self.queriesView.hidden = YES;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.queriesButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.queriesButton setTintColor:unselectedButtonColor];
    [self.queriesButton setImage:[UIImage imageNamed:@"whats-news-unactive"] forState:UIControlStateNormal];
    [self.galleryButton setImage:[UIImage imageNamed:@"information-active"] forState:UIControlStateNormal];
}

- (IBAction)queriesButtonClicked:(UIButton *)sender {
    self.queriesView.hidden = NO;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.galleryButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.galleryButton setTintColor:unselectedButtonColor];
    [self.queriesButton setImage:[UIImage imageNamed:@"whats-news-active"] forState:UIControlStateNormal];
    [self.galleryButton setImage:[UIImage imageNamed:@"information-unactive"] forState:UIControlStateNormal];
}


- (IBAction)addButtonClicked:(id)sender {
    [self performSegueWithIdentifier:kUploadImageSegueIdentifier sender:self];
}

- (void)getStationTasks {
    self.loggedInUser = [[CoreDataManager sharedManager] fetchLogedInUser];
    __weak StationGalleryInfoViewController *weakSelf = self;
    StaionGalleryInfoApi *stationGalleryApi = [StaionGalleryInfoApi new];
    stationGalleryApi.stationId = self.selectedStation.stationId;
    stationGalleryApi.email = [AppUtilityClass getUserEmail];
    [AppUtilityClass showLoaderOnView:self.view];
    [[APIManager sharedInstance]makeAPIRequestWithObject:stationGalleryApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        [AppUtilityClass hideLoaderFromView:weakSelf.view];
        if (!error) {
            if (stationGalleryApi.stationData == nil) {
                CustomAlertModel *alertModel = [[CustomAlertModel alloc] init];
                alertModel.secondaryButtonColor = [UIColor appRedColor];
                alertModel.kAlertMarginOffSet = 20.0f;
                alertModel.alertMessageBody = @"Information is not available yet. Please try later.";
                alertModel.alertType = kVKInfoType;
                alertModel.buttonsArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Ok", nil), nil];
                [[CustomAlertViewController sharedInstance] displayAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withModel:alertModel andCallBack:^(UIButton *sender) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            weakSelf.stateLabel.attributedText = [AppUtilityClass updateBoldFontForText:stationGalleryApi.stateName withLightFontForText:@"State"];
            weakSelf.zoneLabel.attributedText = [AppUtilityClass updateBoldFontForText:stationGalleryApi.zoneName withLightFontForText:@"Zone"];
            weakSelf.divisionLabel.attributedText = [AppUtilityClass updateBoldFontForText:stationGalleryApi.divisionName withLightFontForText:@"Division"];
            weakSelf.stationAreaLabel.attributedText = [AppUtilityClass updateBoldFontForText:[NSString stringWithFormat:@"%@ sq.m.", stationGalleryApi.area] withLightFontForText:@"Area"];
            weakSelf.averageDailyFootFallLabel.attributedText = [AppUtilityClass updateBoldFontForText:[stationGalleryApi.avgPassengerFootfail stringByReplacingOccurrencesOfString:@"Average Passanger Footfail" withString:@""] withLightFontForText:@"Average Passenger Footfail"];
            weakSelf.stationNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", stationGalleryApi.stationName,stationGalleryApi.stationCode];
            weakSelf.weekKeys = stationGalleryApi.weekKeys;
            
            weakSelf.weekKeys = [weakSelf.weekKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
            }];
            
            [weakSelf isViewEditable:stationGalleryApi.editStatus];
            [self getTopicAreas];
            [weakSelf.imageGalleryCollectionView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)isViewEditable:(BOOL)editable {
    if (editable) {
        self.rightBarButton.hidden = NO;
    } else {
        self.rightBarButton.hidden = YES;
    }
}

#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.weekKeys.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 30) / 2, 100.f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        StationGalleryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGalleryCollectionHeaderIdentifier forIndexPath:indexPath];
        NSArray *galleryArray = [self getStationGalleryArrayForKey:[self.weekKeys objectAtIndex:indexPath.section]];
        StationGalleryInfo *stationGalleryInfo = (StationGalleryInfo *)[galleryArray firstObject];
        headerView.sectionHeaderLabel.text = stationGalleryInfo.galleryWeek;
        reusableview = headerView;
    }
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = [self getStationGalleryArrayForKey:[self.weekKeys objectAtIndex:section]].count;
    if (count > 0 && isEmptyCells) {
        isEmptyCells = NO;
        self.emptyView.hidden = YES;
    }
    if (isEmptyCells) {
        self.emptyView.hidden = NO;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    NSArray *galleryArray = [self getStationGalleryArrayForKey:[self.weekKeys objectAtIndex:indexPath.section]];
    StationGalleryInfo *stationGalleryInfo = (StationGalleryInfo *)[galleryArray objectAtIndex:indexPath.row];
    cell.imageTitleLabel.text = [NSString autoCapitalize:stationGalleryInfo.imageName?:@"NA"];
    cell.imageDescription.text = [NSString autoCapitalize:stationGalleryInfo.stationName?:@"NA"];

    [cell.collectionImageView sd_setImageWithURL:[NSURL URLWithString:stationGalleryInfo.imagePath] placeholderImage:[UIImage imageNamed:@"Escalator-circle"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.collectionImageView setImage:image];
//        [cell.collectionImageView setImage:[AppUtilityClass scaleImage:image toSize:cell.collectionImageView.frame.size]];

    }];
}

#pragma mark -
#pragma mark - Collection View deleagete

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ImagesGalleryViewController *imageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesGalleryViewController"];
    imageGalleryVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    imageGalleryVC.galleryInfoArray = [self getStationGalleryArrayForKey:[self.weekKeys objectAtIndex:indexPath.section]];
    imageGalleryVC.isFromDashBoard = NO;
    imageGalleryVC.selectedImageIndex = indexPath.row;
    [self presentViewController:imageGalleryVC animated:YES completion:^{
        ;
    }];
}

- (NSArray *)getStationGalleryArrayForKey:(NSString *)imageKey {
    NSArray *galleryArray = [[CoreDataManager sharedManager] fetchStationGalleryImagesForKey:imageKey forStationName:self.selectedStation.stationName];
    return galleryArray;
}

- (void)getTopicAreas {
    NSArray *topicArray = [[CoreDataManager sharedManager] fetchQueriesForStationName:self.selectedStation.stationName];
    for (QueriesData *queries in topicArray) {
        if (![self.topicAreasArray containsObject:queries.topicArea]) {
            [self.topicAreasArray addObject:queries.topicArea];
        }
    }
    [self.queriesTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QueriesData *query = (QueriesData *) [self.queriesArray objectAtIndex:indexPath.row];
    CGFloat cellHeight = [AppUtilityClass sizeOfText:query.name widthOfTextView:self.queriesTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:18.0f]].height + 20;
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
    self.queriesArray = [[CoreDataManager sharedManager] fetchQueriesForTopicArea:topicArea];
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
    cell.textLabel.text = query.name;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kUploadImageSegueIdentifier]) {
        UploadImagesViewController *uploadImageVC = (UploadImagesViewController *)[segue destinationViewController];
        uploadImageVC.selectedStation = self.selectedStation;
    }
}

@end
