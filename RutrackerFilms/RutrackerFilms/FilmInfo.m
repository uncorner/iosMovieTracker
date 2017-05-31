//
//  FilmInfo.m
//  RutrackerFilms
//
//  Created by denis on 31.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import "FilmInfo.h"

@implementation FilmInfo

+ (instancetype) initWithData:(NSString*)name :(NSString*)relativeUrl :(NSString*)torrentAuthor {
    FilmInfo* instance = [[FilmInfo alloc] init];
    instance.name = name;
    instance.relativeUrl = relativeUrl;
    instance.torrentAuthor = torrentAuthor;
    
    return instance;
}

@end
