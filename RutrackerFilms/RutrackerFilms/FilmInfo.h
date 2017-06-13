//
//  FilmInfo.h
//  RutrackerFilms
//
//  Created by denis on 31.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FilmInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *relativeUrl;
@property (nonatomic, strong) NSString *torrentAuthor;
@property (nonatomic, assign) BOOL isServiceMessage;
@property (nonatomic, strong) NSString *posterUrl;
@property (nonatomic, strong) UIImage *posterImage;

+ (instancetype) createWithData:(NSString*)name :(NSString*)relativeUrl :(NSString*)torrentAuthor;
+ (instancetype) createAsServiceMessage:(NSString*) message;

@end
