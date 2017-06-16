//
//  ContentParser.m
//  RutrackerFilms
//
//  Created by denis on 02.06.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import "ContentParser.h"

@implementation ContentParser

- (NSMutableArray<FilmInfo*>*) parseFilmListFromHtml:(NSData*)htmlData contentType:(NSString*)contentType {
    NSLog(@"parseHtml");
    HTMLDocument *doc = [HTMLDocument documentWithData:htmlData contentTypeHeader:contentType];
    
    NSMutableArray<FilmInfo*> *filmInfoItems = [[NSMutableArray alloc] init];
    
    NSArray<HTMLElement*> *elements = [doc nodesMatchingSelector:@"#main_content_wrap tr.hl-tr"];
    //NSLog(@"elements %lu", (unsigned long)elements.count);
    
    for (HTMLElement *element in elements) {
        
        NSString *name = nil;
        NSString *relativeUrl = nil;
        NSString *torrentAuthor = nil;
        
        HTMLElement *torTopicElement = [element firstNodeMatchingSelector:@"td .torTopic a"];
        if (torTopicElement != nil)
        {
            name = [torTopicElement textContent];
            //NSLog(@"%@", name);
            NSString *partUrl = [[torTopicElement attributes] objectForKey:@"href"];
            relativeUrl = [@"forum/" stringByAppendingString:partUrl];
            //NSLog(@"%@", relativeUrl);
        }
        
        HTMLElement *topicAuthorElemet = [element firstNodeMatchingSelector:@"td .topicAuthor a"];
        if (topicAuthorElemet != nil) {
            torrentAuthor = [topicAuthorElemet textContent];
            //NSLog(@"%@", torrentAuthor);
        }
        
        FilmInfo *filmInfo = [FilmInfo createWithData:name :relativeUrl :torrentAuthor];
        [filmInfoItems addObject:filmInfo];
    }
    
    return filmInfoItems;
}

- (NSString*) parsePosterUrlFromHtml:(NSData*)htmlData contentType:(NSString*)contentType {
    NSLog(@"parsePosterUrlFromHtml");
    
    HTMLDocument *doc = [HTMLDocument documentWithData:htmlData contentTypeHeader:contentType];
    HTMLElement *varElement = [doc firstNodeMatchingSelector:@"#main_content_wrap .post_body var.postImg"];
    
    //NSArray<HTMLElement*> *elements = [varElement childElementNodes];
    //[varElement firstNodeMatchingSelector:@"img"];
    
    //    if (imgElement != nil) {
    //        NSString *url = [[imgElement attributes] objectForKey:@"src"];
    //        return url;
    //    }
    
    return [[varElement attributes] objectForKey:@"title"];
}


@end
