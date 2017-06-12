//
//  FilmTableViewCell.h
//  RutrackerFilms
//
//  Created by denis on 11.06.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;


@end
