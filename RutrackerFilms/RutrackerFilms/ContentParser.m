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
    NSLog(@"parsePosterUrl");
    
    HTMLDocument *doc = [HTMLDocument documentWithData:htmlData contentTypeHeader:contentType];
    HTMLElement *element = [doc firstNodeMatchingSelector:@"#main_content .topic .post_wrap img.postImg"];
    if (element != nil) {
        NSString *url = [[element attributes] objectForKey:@"src"];
        return url;
    }
    
    return nil;
}


@end
