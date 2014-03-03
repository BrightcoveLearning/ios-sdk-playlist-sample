//
//  CPPViewController.m
//  Catalog Playlist Playback
//
//  Created by Robert Crooks on 10/9/13.
//  Copyright (c) 2013 Brightcove. All rights reserved.
//

#import "CPPViewController.h"

// import the SDK master header
#import "BCOVPlayerSDK.h"


#import <ReactiveCocoa/RACEXTScope.h>

@implementation CPPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // the following line is the basic way to access the catalog for non-Japanese accounts, not using a proxy
    // self.catalog = [[BCOVCatalogService alloc] initWithToken:@"nFCuXstvl910WWpPnCeFlDTNrpXA5mXOO9GPkuTCoLKRyYpPF1ikig.."];
    
    // the following lines use the media request factory - you must use this method for Japanese accounts
    // or if you make the calls via a proxy
    // note that for accounts in Japan, the baseURLString will be "http://api.brightcove.co.jp/services/library"
    
    self.mediaRequestFactory = [[BCOVMediaRequestFactory alloc] initWithToken:@"nFCuXstvl910WWpPnCeFlDTNrpXA5mXOO9GPkuTCoLKRyYpPF1ikig.." baseURLString:@"http://api.brightcove.com/services/library"];
    
    self.catalog = [[BCOVCatalogService alloc] initWithMediaRequestFactory:self.mediaRequestFactory];
    
    self.controller = [[BCOVPlayerSDKManager sharedManager] createPlaybackControllerWithViewStrategy:[self viewStrategy]];
    self.controller.view.frame = self.view.bounds;
    [self.view addSubview:self.controller.view];
    
    //This is how you playback videos from a playlist
    @weakify(self);
    [self.catalog
     findPlaylistWithPlaylistID:@"2149006311001" parameters:nil
     completion:^(BCOVPlaylist *playlist, NSDictionary *jsonResponse, NSError *error) {
         
         @strongify(self);
         if(playlist){
             self.controller.autoAdvance = YES;
             [self.controller setVideos:playlist];
             
             [self.controller play];
         }
     }];
    
    NSLog(@"%@", self.catalog.requestFactory.defaultVideoFields);
    
    //The above line will output
    
    /*
     (
     renditions,
     FLVFullLength,
     videoStillURL,
     name,
     shortDescription,
     referenceId,
     id,
     accountId,
     customFields,
     FLVURL,
     cuePoints,
     HLSURL
     )
     */
    
    // To ask for additional information - you can pass information to parameters
    NSArray *fields = [self.catalog.requestFactory.defaultVideoFields arrayByAddingObject:@"tags"];
    
    NSDictionary *videoFields = @{@"video_fields": [fields componentsJoinedByString:@","]};
    
    [self.catalog findVideoWithReferenceID:@"lucy" parameters:videoFields completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        if(video){
            
            //Getting properties from the video, these keys can be found in BCOVCatalogConstants.h
            NSLog(@"Name: %@", video.properties[kBCOVCatalogJSONKeyName]);
            NSLog(@"Description: %@", video.properties[kBCOVCatalogJSONKeyShortDescription]);
            
            //Custom field:
            NSLog(@"Tags: %@", video.properties[@"tags"]);
            
            //Sources from the video can be accessed by the following:
            [video.sources enumerateObjectsUsingBlock:^(BCOVSource *source, NSUInteger idx, BOOL *stop) {
                NSLog(@"Source %i, Delivery Method: %@ URL: %@", idx, source.deliveryMethod, source.url);
                
                //There are other values of importance that are stored in source properties
                NSLog(@"Source %i, Properties %@", idx, source.properties);
            }];
        }
    }];
    
}

- (id)viewStrategy
{
    // Most apps can create a playback controller with a `nil` view strategy,
    // but for the purposes of this demo we use the stock controls.
    return [[BCOVPlayerSDKManager sharedManager] defaultControlsViewStrategy];
}

@end
