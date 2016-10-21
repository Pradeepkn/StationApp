//
//  UploadImagesViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "UploadImagesViewController.h"
#import "GalleryCollectionViewCell.h"
#import "AppUtilityClass.h"
#import "UIColor+AppColor.h"
#import "UploadImagesApi.h"
#import <TTPLLibrary/NSData+Base64.h>

static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";

@interface UploadImagesViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *addTitleTxtField;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (strong, nonatomic) NSMutableArray *imagesTitle;
@property (strong, nonatomic) NSMutableArray *uploadingImages;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation UploadImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImages = [[NSMutableArray alloc] init];
    self.imagesTitle = [[NSMutableArray alloc] init];
    self.uploadingImages = [[NSMutableArray alloc] init];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.imagePickerController.delegate = self;
    self.addTitleTxtField.tag = 0;
    self.separatorView.backgroundColor = [UIColor clearColor];
    [self.galleryCollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.selectedImages.count;
    if (count < 5) {
        count += 1;
    }
    if (count > 5) {
        count = 5;
    }
    if (count == 1) {
        self.collectionViewHeightConstraint.constant = 0;
        self.sendButton.enabled = NO;
        self.sendButton.alpha = 0.5f;
        [self hideImageView];
    }else {
        self.collectionViewHeightConstraint.constant = 100;
        self.sendButton.enabled = YES;
        self.sendButton.alpha = 1.0f;
        self.addTitleTxtField.enabled = YES;
        self.selectedImageView.hidden = NO;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectedImages.count) {
        cell.closeButton.hidden = YES;
        [cell.collectionImageView setImage:[UIImage imageNamed:@"plus-icon-smal"]];
        cell.collectionImageView.contentMode = UIViewContentModeCenter;
        [AppUtilityClass addDottedBorderToView:cell.collectionImageView];
    }else {
        cell.closeButton.hidden = NO;
        [cell.closeButton addTarget:self action:@selector(deleteSelectedImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.closeButton.tag = indexPath.row;
        cell.collectionImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *cellImage = [self.selectedImages objectAtIndex:indexPath.row];
        [cell.collectionImageView setImage:cellImage];
        cell.collectionImageView.layer.borderWidth = 0.0f;
    }
}

#pragma mark -
#pragma mark - Collection View deleagete

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.addTitleTxtField.tag = indexPath.row;
    if (indexPath.row == self.selectedImages.count) {
        [self hideImageView];
    }else {
        [self showImageViewForIndex:indexPath.row];
    }
}

- (void)showImageViewForIndex:(NSInteger)rowIndex {
    self.galleryButton.hidden = YES;
    self.cameraButton.hidden = YES;
    self.separatorView.hidden = YES;
    self.selectedImageView.hidden = NO;
    self.addTitleTxtField.enabled = YES;
    if (self.imagesTitle.count > rowIndex) {
        self.addTitleTxtField.text = [self.imagesTitle objectAtIndex:rowIndex];
    }else {
        self.addTitleTxtField.text = @"";
    }
    if (self.selectedImages.count > rowIndex) {
        UIImage *cellImage = [self.selectedImages objectAtIndex:rowIndex];
        self.selectedImageView.image = cellImage;
    }
}

- (void)hideImageView {
    self.addTitleTxtField.enabled = NO;
    self.selectedImageView.image = nil;
    self.selectedImageView.hidden = YES;
    self.cameraButton.hidden = NO;
    self.galleryButton.hidden = NO;
    self.separatorView.hidden = NO;
    self.addTitleTxtField.text = @"";
}

- (void)deleteSelectedImage:(UIButton *)sender {
    [self.selectedImages removeObjectAtIndex:sender.tag];
    [self.imagesTitle removeObjectAtIndex:sender.tag];
    [self.galleryCollectionView reloadData];
    [self autoSelectCollectionViewRowAtIndex:[self getCellCount] - 1];
}

#pragma mark - Image picker delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.selectedImages addObject:[AppUtilityClass imageWithImage:image scaledToSize:self.selectedImageView.frame.size]];
    [self.addTitleTxtField becomeFirstResponder];
    [self.galleryCollectionView reloadData];
    if (self.selectedImages.count > 0) {
        if (self.selectedImages.count == 5) {
            [self autoSelectCollectionViewRowAtIndex:self.selectedImages.count - 1];
        }else {
            [self autoSelectCollectionViewRowAtIndex:[self getCellCount] - 2];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self autoSelectCollectionViewRowAtIndex:[self getCellCount] - 1];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)getCellCount {
    NSUInteger count = self.selectedImages.count;
    if (count < 5) {
        count += 1;
    }
    if (count > 5) {
        count = 5;
    }
    return count;
}

- (void)autoSelectCollectionViewRowAtIndex:(NSInteger)index {
    NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:index inSection:0];
    [self.galleryCollectionView selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.galleryCollectionView didSelectItemAtIndexPath:indexPathForFirstRow];
}

- (IBAction)galleryButtonClicked:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)cameraButtonClicked:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)sendButtonClicked:(id)sender {
    for (int index = 0; index < self.selectedImages.count; index++) {
        NSMutableDictionary *imageObject = [[NSMutableDictionary alloc] init];
        [imageObject setObject:[self.imagesTitle objectAtIndex:index] forKey:@"imageTitle"];
        UIImage *selectedImage = (UIImage*)[self.selectedImages objectAtIndex:index];
        [imageObject setObject:[UIImagePNGRepresentation(selectedImage) base64String] forKey:@"imageBase64"];
        [self.uploadingImages addObject:imageObject];
    }
    [self postImagesToServer];
}

- (void)postImagesToServer {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak UploadImagesViewController *weakSelf = self;
    UploadImagesApi *uploadImagesApi = [UploadImagesApi new];
    uploadImagesApi.email = [AppUtilityClass getUserEmail];
    uploadImagesApi.stationId = self.selectedStation.stationId;
    uploadImagesApi.images = self.uploadingImages;
    
    [[APIManager sharedInstance]makePostAPIRequestWithObject:uploadImagesApi
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self.navigationController popViewControllerAnimated:YES];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please enter image title", nil)];
        return NO;
    }
    
    [self.imagesTitle addObject:textField.text];
    [self.galleryCollectionView reloadData];
    [textField resignFirstResponder];
    return YES;
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
