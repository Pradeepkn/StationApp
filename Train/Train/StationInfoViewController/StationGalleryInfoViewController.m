//
//  StationGalleryInfoViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/10/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "StationGalleryInfoViewController.h"
#import <JTSActionSheet/JTSActionSheet.h>
#import "GalleryCollectionViewCell.h"
#import "LocalizationKeys.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"

static NSString *const kGalleryCellIdentifier=  @"galleryCell";
static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";

@interface StationGalleryInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UILabel *line1Label;
@property (weak, nonatomic) IBOutlet UILabel *line2Label;
@property (weak, nonatomic) IBOutlet UILabel *line3Label;
@property (weak, nonatomic) IBOutlet UITableView *galleryTableView;

@end

@implementation StationGalleryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonClicked:(id)sender {
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kGalleryCellIdentifier forIndexPath:indexPath];
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
    NSUInteger count = 4;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)cell {
}

#pragma mark -
#pragma mark - Collection View deleagete

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self launchImage];
}

- (void)launchImage {
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.delegate = self;
        
        JTSActionSheetTheme *theme = [JTSActionSheetTheme defaultTheme];
        theme.normalButtonColor = [UIColor redColor];
        theme.destructiveButtonColor = [UIColor blackColor];
        
        NSMutableArray *actionSheetItemsArray = [NSMutableArray new];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            JTSActionSheetItem *camera = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kUploadImageActionSheetButtonCamera, nil) action:^{
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            } isDestructive:YES];
            
            JTSActionSheetItem *gallery = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kUploadImageActionSheetButtonGallery, nil) action:^{
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            } isDestructive:YES];
            
            [actionSheetItemsArray addObjectsFromArray:@[camera,gallery]];
        } else {
            JTSActionSheetItem *gallery = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kUploadImageActionSheetButtonGallery, nil) action:^{
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            } isDestructive:YES];
            
            [actionSheetItemsArray addObjectsFromArray:@[gallery]];
        }
        
        JTSActionSheetItem *cancel = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kGlobalButtonCancel, nil) action:nil isDestructive:NO];
        
        // Create & Show an Action Sheet
        JTSActionSheet *sheet = [[JTSActionSheet alloc] initWithTheme:theme title:nil actionItems:actionSheetItemsArray cancelItem:cancel];
        [sheet showInView:self.view];
    }
}
#pragma mark - Image picker delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
