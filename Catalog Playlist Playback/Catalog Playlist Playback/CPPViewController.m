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
    self.catalog = [[BCOVCatalogService alloc] initWithToken:@"nFCuXstvl910WWpPnCeFlDTNrpXA5mXOO9GPkuTCoLKRyYpPF1ikig.."];
    
    self.facade = [[BCOVPlayerSDKManager sharedManager] newPlaybackFacadeWithFrame:self.view.frame];
    [self.view addSubview:[self.facade view]];
    
    //This is how you playback videos from a playlist
    @weakify(self);
    [self.catalog
     findPlaylistWithPlaylistID:@"2149006311001" parameters:nil
     completion:^(BCOVPlaylist *playlist, NSDictionary *jsonResponse, NSError *error) {
         
         @strongify(self);
         if(!error){
             self.facade.queue.autoAdvance = YES;
             [self.facade setVideos:playlist];
             
             [self.facade advanceToNextAndPlay];
         }
     }];
    
    NSLog(@"%@", [[self.catalog requestFactory] defaultVideoFields]);
    
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
    NSArray *default_fields = [[self.catalog requestFactory] defaultVideoFields];
    NSArray *fields = [default_fields arrayByAddingObject:@"tags"];
    
    NSDictionary *video_fields = @{@"video_fields": [fields componentsJoinedByString:@","]};
    
    [self.catalog findVideoWithReferenceID:@"lucy" parameters:video_fields completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        if(!error){
            
            //Getting properties from the video, these keys can be found in BCOVCatalogConstants.h
            NSLog(@"Name: %@", [video.properties objectForKey:kBCOVCatalogJSONKeyName]);
            NSLog(@"Description: %@", [video.properties objectForKey:kBCOVCatalogJSONKeyShortDescription]);
            
            //Custom field:
            NSLog(@"Tags: %@", [video.properties objectForKey:@"tags"]);
            
            //Sources from the video can be accessed by the following:
            [[video sources] enumerateObjectsUsingBlock:^(BCOVSource *source, NSUInteger idx, BOOL *stop) {
                NSLog(@"Source %i, Delivery Method: %@ URL: %@", idx, [source deliveryMethod], [source url]);
                
                //There are other values of importance that are stored in source properties
                NSLog(@"Source %i, Properties %@", idx, [source properties]);
            }];
        }
    }];
    
}


@end
