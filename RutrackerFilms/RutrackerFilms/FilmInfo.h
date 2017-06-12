//
//  FilmInfo.h
//  RutrackerFilms
//
//  Created by denis on 31.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *relativeUrl;
@property (nonatomic, strong) NSString *torrentAuthor;
@property (nonatomic, assign) BOOL isServiceMessage;

+ (instancetype) createWithData:(NSString*)name :(NSString*)relativeUrl :(NSString*)torrentAuthor;
+ (instancetype) createServiceMessage:(NSString*) message;

@end
