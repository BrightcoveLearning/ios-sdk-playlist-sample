//
//  CPPViewController.h
//  Catalog Playlist Playback
//
//  Created by Robert Crooks on 10/9/13.
//  Copyright (c) 2013 Brightcove. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward references for playback controller protocol and the catalog service class
@protocol BCOVPlaybackController;
@class BCOVCatalogService;
// create media request factory
// allows access to Catalog for Japan accounts
// and via proxy
@class BCOVMediaRequestFactory;

@interface CPPViewController : UIViewController

// declare the playback controller and catalog properties
@property (strong, nonatomic) id<BCOVPlaybackController> controller;
@property (strong, nonatomic) BCOVCatalogService *catalog;
// declare property for the media request factory
@property (strong, nonatomic) BCOVMediaRequestFactory *mediaRequestFactory;

@end
