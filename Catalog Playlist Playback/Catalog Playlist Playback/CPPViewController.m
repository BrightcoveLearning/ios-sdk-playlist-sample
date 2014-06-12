//
//  CPPViewController.m
//  Catalog Playlist Playback
//
//  Created by Jeff Doktor on 6/11/14.
//  Copyright (c) 2014 Brightcove. All rights reserved.
//

#import "CPPViewController.h"

#import "BCOVPlayerSDK.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface CPPViewController ()

@end

@implementation CPPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.mediaRequestFactory = [[BCOVMediaRequestFactory alloc] initWithToken:@"nFCuXstvl910WWpPnCeFlDTNrpXA5mXOO9GPkuTCoLKRyYpPF1ikig.." baseURLString:@"http://api.brightcove.com/services/library"];
    self.catalog = [[BCOVCatalogService alloc] initWithMediaRequestFactory:self.mediaRequestFactory];
    
    self.controller = [[BCOVPlayerSDKManager sharedManager] createPlaybackControllerWithViewStrategy:[self viewStrategy]];
    self.controller.view.frame = self.view.bounds;
    [self.view addSubview:self.controller.view];
    
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
