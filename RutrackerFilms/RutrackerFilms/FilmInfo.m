//
//  FilmInfo.m
//  RutrackerFilms
//
//  Created by denis on 31.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import "FilmInfo.h"

@implementation FilmInfo

+ (instancetype) createWithData:(NSString*)name :(NSString*)relativeUrl :(NSString*)torrentAuthor {
    FilmInfo* instance = [[FilmInfo alloc] init];
    instance.name = name;
    instance.relativeUrl = relativeUrl;
    instance.torrentAuthor = torrentAuthor;
    instance.isServiceMessage = NO;
    
    return instance;
}

+ (instancetype) createServiceMessage:(NSString*) message {
    FilmInfo* instance = [[FilmInfo alloc] init];
    instance.name = message;
    instance.isServiceMessage = YES;
    
    return instance;
}

@end
