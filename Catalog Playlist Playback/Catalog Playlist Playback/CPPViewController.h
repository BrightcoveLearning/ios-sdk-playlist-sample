//
//  CPPViewController.h
//  Catalog Playlist Playback
//
//  Created by Jeff Doktor on 6/11/14.
//  Copyright (c) 2014 Brightcove. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCOVPlaybackController;
@class BCOVCatalogService;
@class BCOVMediaRequestFactory;

@interface CPPViewController : UIViewController

@property (strong, nonatomic) id<BCOVPlaybackController> controller;
@property (strong, nonatomic) BCOVCatalogService *catalog;
@property (strong, nonatomic) BCOVMediaRequestFactory *mediaRequestFactory;

@end
