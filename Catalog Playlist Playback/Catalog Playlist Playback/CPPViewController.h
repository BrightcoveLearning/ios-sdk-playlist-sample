//
//  CPPViewController.h
//  Catalog Playlist Playback
//
//  Created by Robert Crooks on 10/9/13.
//  Copyright (c) 2013 Brightcove. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward references for facade protocol and the catalog service class
@protocol BCOVPlaybackFacade;
@class BCOVCatalogService;
// create media request factory
// allows access to Catalog for Japan accounts
// and via proxy
@class BCOVMediaRequestFactory;

@interface CPPViewController : UIViewController

// declare the facade and catalog properties
@property (strong, nonatomic) id<BCOVPlaybackFacade> facade;
@property (strong, nonatomic) BCOVCatalogService *catalog;
// declare property for the media request factory
@property (strong, nonatomic) BCOVMediaRequestFactory *mediaRequestFactory;

@end
