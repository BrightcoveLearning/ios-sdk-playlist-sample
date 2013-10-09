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

@interface CPPViewController : UIViewController

// declare the facade and catalog properties
@property (strong, nonatomic) id<BCOVPlaybackFacade> facade;
@property (strong, nonatomic) BCOVCatalogService *catalog;

@end
