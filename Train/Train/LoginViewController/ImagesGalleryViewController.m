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

@interface ImagesGalleryViewController ()

@property (nonatomic, strong) DRPageScrollView *pageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageNameLabel;

@end

@implementation ImagesGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Images";
    self.pageScrollView = [DRPageScrollView new];
    self.pageScrollView.pageReuseEnabled = NO;
    [self.view addSubview:self.pageScrollView];
    applyConstraints(self.pageScrollView);
    // Note: you can either take this nib approach or directly instantiate your UI elements programatically and add them to pageView.
    __weak ImagesGalleryViewController *weakSelf = self;

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
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"ImagesGalleryView" owner:self options:nil];
        ImagesGalleryView *view = (ImagesGalleryView *) [nibViews firstObject];
        [self.pageScrollView addPageWithHandler:^(UIView *pageView) {
            [view.imageView  sd_setImageWithURL:[NSURL URLWithString:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [view.imageView setImage:image];
            }];
            [pageView addSubview:view];
            applyConstraints(view);
        }];
    }
    self.pageScrollView.scrollHandler = ^(BOOL isScrolled) {
        if (isScrolled) {
            [weakSelf updateNextButtonTitle];
        }
    };
    [self.view bringSubviewToFront:self.closeButton];
    [self.view bringSubviewToFront:self.nextButton];
    [self.view bringSubviewToFront:self.previousButton];
    [self.view bringSubviewToFront:self.stationNameLabel];
    [self.view bringSubviewToFront:self.imageNameLabel];
//    [self autoScrollToSelectedIndex];
}

- (void)autoScrollToSelectedIndex {
    __weak ImagesGalleryViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.nextButton setTitle:[NSString stringWithFormat:@"%ld from %lu", (long)self.selectedImageIndex + 1, (unsigned long)self.galleryInfoArray.count] forState:UIControlStateNormal];
        [weakSelf updateImageNamesAtIndex:self.selectedImageIndex];
        weakSelf.pageScrollView.currentPage = weakSelf.selectedImageIndex;
    });
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
    [UIView animateWithDuration:0.3 animations:^{
        if (self.pageScrollView.currentPage == 0) {
            return;
        }
        self.pageScrollView.currentPage = self.pageScrollView.currentPage - 1;
    } completion:^(BOOL finished) {
        [self updateNextButtonTitle];
    }];
}

- (IBAction)nextButtonClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.pageScrollView.currentPage == self.galleryInfoArray.count - 1) {
            return;
        }
        self.pageScrollView.currentPage = self.pageScrollView.currentPage + 1;
    } completion:^(BOOL finished) {
        [self updateNextButtonTitle];
    }];
}

- (void)updateNextButtonTitle {
    [self.nextButton setTitle:[NSString stringWithFormat:@"%ld from %lu", (long)self.pageScrollView.currentPage + 1, (unsigned long)self.galleryInfoArray.count] forState:UIControlStateNormal];
    NSInteger currentPage = self.pageScrollView.currentPage;
    if (currentPage <= 0) {
        currentPage = 0;
    }
    [self updateImageNamesAtIndex:currentPage];
}

void applyConstraints(UIView *view) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *attributeArray = @[@(NSLayoutAttributeTop), @(NSLayoutAttributeLeft), @(NSLayoutAttributeBottom), @(NSLayoutAttributeRight)];
    
    for (NSNumber *attributeNumber in attributeArray) {
        NSLayoutAttribute attribute = (NSLayoutAttribute)[attributeNumber integerValue];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:attribute multiplier:1 constant:0];
        
        [view.superview addConstraint:constraint];
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
