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

@property (strong, nonatomic) NSMutableArray *addImages;
@property (strong, nonatomic) NSMutableArray *imagesTitle;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation UploadImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addImages = [[NSMutableArray alloc] init];
    self.imagesTitle = [[NSMutableArray alloc] init];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.imagePickerController.delegate = self;
    [AppUtilityClass addBorderToView:self.imageContainerView];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = self.addImages.count;
    if (count < 5) {
        count += 1;
    }
    if (count > 5) {
        count = 5;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.addImages.count) {
        cell.closeButton.hidden = YES;
        [cell.collectionImageView setImage:[UIImage imageNamed:@"plus-icon-smal"]];
        cell.collectionImageView.contentMode = UIViewContentModeCenter;
        [AppUtilityClass addDashedBorderWithColor:[UIColor blackColor].CGColor ForView:cell];
        [AppUtilityClass addBorderToView:cell.collectionImageView];
    }else {
        cell.closeButton.hidden = NO;
        [cell.closeButton addTarget:self action:@selector(deleteSelectedImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.closeButton.tag = indexPath.row;
        cell.collectionImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *cellImage = [self.addImages objectAtIndex:indexPath.row];
        [cell.collectionImageView setImage:cellImage];
        cell.collectionImageView.layer.borderWidth = 0.0f;
    }
}

#pragma mark -
#pragma mark - Collection View deleagete

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.addImages.count) {
        self.galleryButton.hidden = NO;
        self.cameraButton.hidden = NO;
        self.selectedImageView.hidden = YES;
        self.separatorView.hidden = NO;
    }else {
        UIImage *cellImage = [self.addImages objectAtIndex:indexPath.row];
        self.selectedImageView.image = cellImage;
        self.galleryButton.hidden = YES;
        self.cameraButton.hidden = YES;
        self.selectedImageView.hidden = NO;
        self.separatorView.hidden = YES;
    }
}

- (void)deleteSelectedImage:(UIButton *)sender {
    [self.addImages removeObjectAtIndex:sender.tag];
    [self.galleryCollectionView reloadData];
}

#pragma mark - Image picker delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.addImages addObject:[AppUtilityClass imageWithImage:image scaledToSize:self.selectedImageView.frame.size]];
    [self.galleryCollectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
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
