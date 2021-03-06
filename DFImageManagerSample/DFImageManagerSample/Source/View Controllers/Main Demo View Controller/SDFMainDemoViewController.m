//
//  SDFMainDemoViewController.m
//  DFImageManagerSample
//
//  Created by Alexander Grebenyuk on 1/5/15.
//  Copyright (c) 2015 Alexander Grebenyuk. All rights reserved.
//

#import "SDFFlickrPhoto.h"
#import "SDFFlickrRecentPhotosModel.h"
#import "SDFMainDemoViewController.h"
#import "UIViewController+SDFImageManager.h"
#import <DFImageManager/DFImageManagerKit.h>


@interface SDFMainDemoViewController () <SDFFlickrRecentPhotosModelDelegate>

@end


static NSString * const reuseIdentifier = @"Cell";

@implementation SDFMainDemoViewController {
    UIActivityIndicatorView *_activityIndicatorView;
    NSMutableArray *_photos;
    SDFFlickrRecentPhotosModel *_model;
}

- (instancetype)init {
    return [self initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberOfItemsPerRow = 3;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    _activityIndicatorView = [self df_showActivityIndicatorView];
    
    _photos = [NSMutableArray new];
    
    _model = [SDFFlickrRecentPhotosModel new];
    _model.delegate = self;
    [_model poll];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:235.f/255.f alpha:1.f];
    
    DFImageView *imageView = (id)[cell viewWithTag:15];
    if (!imageView) {
        imageView = [[DFImageView alloc] initWithFrame:cell.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.tag = 15;
        [cell addSubview:imageView];
    }
        
    SDFFlickrPhoto *photo = _photos[indexPath.row];
    [imageView prepareForReuse];
    [imageView setImageWithResource:[NSURL URLWithString:photo.photoURL]];
    
    return cell;
}

#pragma mark - <SDFFlickrRecentPhotosModelDelegate>

- (void)flickrRecentPhotosModel:(SDFFlickrRecentPhotosModel *)model didLoadPhotos:(NSArray *)photos forPage:(NSInteger)page {
    [_activityIndicatorView removeFromSuperview];
    [_photos addObjectsFromArray:photos];
    [self.collectionView reloadData];
    if (page == 0) {
        self.collectionView.alpha = 0.f;
        [UIView animateWithDuration:0.25f animations:^{
            self.collectionView.alpha = 1.f;
        }];
    }
}

@end
