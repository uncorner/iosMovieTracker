//
//  ContentParser.h
//  RutrackerFilms
//
//  Created by denis on 02.06.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilmInfo.h"
@import HTMLReader;


@interface ContentParser : NSObject

- (NSMutableArray<FilmInfo*>*) parseFilmListFromHtml:(NSData*)htmlData contentType:(NSString*)contentType;
- (NSString*) parsePosterUrlFromHtml:(NSData*)htmlData contentType:(NSString*)contentType;

@end
