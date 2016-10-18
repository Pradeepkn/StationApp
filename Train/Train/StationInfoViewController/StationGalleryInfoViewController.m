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

static NSString *const kGalleryCellIdentifier=  @"galleryCell";
static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";
static NSString *const kUploadImageSegueIdentifier = @"UploadImageSegue";

@interface StationGalleryInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
}

@property (weak, nonatomic) IBOutlet UILabel *line1Label;
@property (weak, nonatomic) IBOutlet UILabel *line2Label;
@property (weak, nonatomic) IBOutlet UILabel *line3Label;
@property (weak, nonatomic) IBOutlet UITableView *galleryTableView;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (strong, nonatomic) User *loggedInUser;
@property (nonatomic, strong) NSArray *weekKeys;

@end

@implementation StationGalleryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
            weakSelf.line1Label.text = stationGalleryApi.established;
            weakSelf.line2Label.text = stationGalleryApi.area;
            weakSelf.line3Label.text = stationGalleryApi.avgPassengerFootfail;
            weakSelf.stationNameLabel.text = stationGalleryApi.stationName;
            weakSelf.weekKeys = stationGalleryApi.weekKeys;
            [weakSelf.galleryTableView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weekKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationGalleryViewCell *cell = (StationGalleryViewCell *)[tableView dequeueReusableCellWithIdentifier:kGalleryCellIdentifier forIndexPath:indexPath];
    cell.weekLabel.text = [self.weekKeys objectAtIndex:indexPath.row];
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

#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = [[CoreDataManager sharedManager] fetchStationGalleryImagesForKey:[self.weekKeys objectAtIndex:section]].count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell forIndexPath:indexPath];
//    [AppUtilityClass addOverlayOnView:cell.collectionImageView];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    NSArray *galleryArray = [[CoreDataManager sharedManager] fetchStationGalleryImagesForKey:[self.weekKeys objectAtIndex:indexPath.section]];
    StationGalleryInfo *stationGalleryInfo = (StationGalleryInfo *)[galleryArray objectAtIndex:indexPath.row];
    cell.imageTitleLabel.text = stationGalleryInfo.imageName;
    cell.imageDescription.text = stationGalleryInfo.stationName;
    [cell.collectionImageView sd_setImageWithURL:[NSURL URLWithString:stationGalleryInfo.imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.collectionImageView setImage:image];
    }];
}

#pragma mark -
#pragma mark - Collection View deleagete

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *galleryArray = [[CoreDataManager sharedManager] fetchStationGalleryImagesForKey:[self.weekKeys objectAtIndex:indexPath.section]];
    ImagesGalleryViewController *imageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesGalleryViewController"];
    imageGalleryVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    imageGalleryVC.galleryInfoArray = galleryArray;
    [self presentViewController:imageGalleryVC animated:YES completion:^{
        ;
    }];
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
