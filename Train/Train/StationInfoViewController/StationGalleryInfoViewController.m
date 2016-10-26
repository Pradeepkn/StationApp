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

static NSString *const kGalleryCellIdentifier=  @"galleryCell";
static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";
static NSString *const kUploadImageSegueIdentifier = @"UploadImageSegue";
static NSString *const kGalleryCollectionHeaderIdentifier = @"GalleryCollectionHeader";

@interface StationGalleryInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    BOOL isEmptyCells;
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

@end

@implementation StationGalleryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEmptyCells = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self isViewEditable:NO];
    [self getStationTasks];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
            weakSelf.stateLabel.attributedText = [AppUtilityClass updateBoldFontForText:stationGalleryApi.stateName withLightFontForText:@"State"];
            weakSelf.zoneLabel.attributedText = [AppUtilityClass updateBoldFontForText:stationGalleryApi.zoneName withLightFontForText:@"Zone"];
            weakSelf.divisionLabel.attributedText = [AppUtilityClass updateBoldFontForText:stationGalleryApi.divisionName withLightFontForText:@"Division"];
            weakSelf.stationAreaLabel.attributedText = [AppUtilityClass updateBoldFontForText:[NSString stringWithFormat:@"%@ sq.m.", stationGalleryApi.area] withLightFontForText:@"Area"];
            weakSelf.averageDailyFootFallLabel.attributedText = [AppUtilityClass updateBoldFontForText:stationGalleryApi.avgPassengerFootfail withLightFontForText:@"Average Passenger Footfail"];
            weakSelf.stationNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", stationGalleryApi.stationName,stationGalleryApi.stationCode];
            weakSelf.weekKeys = stationGalleryApi.weekKeys;
            
            weakSelf.weekKeys = [weakSelf.weekKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
            }];
            
            [weakSelf isViewEditable:stationGalleryApi.editStatus];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
