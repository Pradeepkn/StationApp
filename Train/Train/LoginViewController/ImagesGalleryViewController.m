//
//  ImagesGalleryViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/18/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "ImagesGalleryViewController.h"
#import "ImagesGalleryView.h"
#import "DRPageScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+AutoCapitalizeString.h"
#import "UIImage+ProportionalFill.h"
#import "UIImage+ImageAdditions.h"

@interface ImagesGalleryViewController () {
    BOOL isFirstTimeLaunch;
}

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@end

@implementation ImagesGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstTimeLaunch = YES;
    self.title = @"Images";
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    [self.imageScrollView setContentSize:CGSizeMake(self.galleryInfoArray.count * screenWidth, screenHeight)];
    for (int index = 0; index < self.galleryInfoArray.count; index++) {
        StationGalleryInfo *stationGalleryInfo;
        HomeImages *homeGalleryInfo;
        NSString *imagePath;
        if (self.isFromDashBoard) {
            homeGalleryInfo = (HomeImages *)[self.galleryInfoArray objectAtIndex:index];
            imagePath = homeGalleryInfo.imagePath;
        }else {
            stationGalleryInfo = (StationGalleryInfo *)[self.galleryInfoArray objectAtIndex:index];
            imagePath = stationGalleryInfo.imagePath;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*screenWidth, 80, screenWidth, screenHeight - 160)];
        [imageView  sd_setImageWithURL:[NSURL URLWithString:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [imageView setImage:image];
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageScrollView addSubview:imageView];
    }
    [self autoScrollToIndex:self.selectedImageIndex];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    isFirstTimeLaunch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!isFirstTimeLaunch) {
        [self updateNextButtonTitleAtIndex:[self currentPageNumber]];
    }
}

- (void)autoScrollToIndex:(NSInteger)index {
    [self.imageScrollView setContentOffset:CGPointMake(index * self.view.frame.size.width, 0) animated:YES];
    [self updateNextButtonTitleAtIndex:index];
}

- (void)updateImageNamesAtIndex:(NSInteger)currentPage {
    if (self.isFromDashBoard) {
        HomeImages *homeGalleryInfo = (HomeImages *)[self.galleryInfoArray objectAtIndex:currentPage];
        self.stationNameLabel.text = [NSString autoCapitalize:homeGalleryInfo.stationName]?:@"NA";
        self.imageNameLabel.text = [NSString autoCapitalize:homeGalleryInfo.imageName]?:@"NA";
    }else {
        StationGalleryInfo *stationGalleryInfo = (StationGalleryInfo *)[self.galleryInfoArray objectAtIndex:currentPage];
        self.stationNameLabel.text = [NSString autoCapitalize:stationGalleryInfo.stationName]?:@"NA";
        self.imageNameLabel.text = [NSString autoCapitalize:stationGalleryInfo.imageName]?:@"NA";
    }
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (IBAction)previousButtonClicked:(id)sender {
    int page = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    if (page == 0) {
        return;
    }
    [self autoScrollToIndex:page-1];
}

- (IBAction)nextButtonClicked:(id)sender {
    int page = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    if (page == self.galleryInfoArray.count - 1) {
        return;
    }
    [self autoScrollToIndex:page + 1];
}

- (NSInteger)currentPageNumber {
    int page = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
    return page;
}

- (void)updateNextButtonTitleAtIndex:(NSInteger)index {
    NSString *nextButtonTitle = [NSString stringWithFormat:@"%ld from %lu", index + 1, (unsigned long)self.galleryInfoArray.count];
    [self.nextButton setTitle:nextButtonTitle forState:UIControlStateNormal];
    [self updateImageNamesAtIndex:index];
    if (index == 0) {
        self.previousButton.alpha = 0.5;
    }else {
        self.previousButton.alpha = 1.0f;
    }
    if (index == self.galleryInfoArray.count - 1) {
        self.nextButton.alpha = 0.5;
    }else {
        self.nextButton.alpha = 1.0f;
    }
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
