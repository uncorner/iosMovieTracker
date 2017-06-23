//
//  MainTableViewController.m
//  RutrackerFilms
//
//  Created by denis on 24.05.17.
//  Copyright © 2017 uncorner. All rights reserved.
//

#import "MainTableViewController.h"
#import "FilmInfo.h"
#import "ContentParser.h"
#import "DetailViewController.h"
#import "Common.h"
#import "FilmTableViewCell.h"


@interface MainTableViewController ()
{
    NSMutableArray<FilmInfo*> *_filmItems;
}


@end

@implementation MainTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filmItems = [[NSMutableArray alloc] init];
    [self updateTableItems];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) updateTableItems {
    self.tableView.userInteractionEnabled = NO;
    [self setArrayByWaitMessageItem];
    [self makeRequestForLoadingItems];
}

- (void) setArrayByWaitMessageItem {
    FilmInfo *loadingItem = [FilmInfo createAsServiceMessage:@"Data loading..."];
    [_filmItems removeAllObjects];
    [_filmItems addObject:loadingItem];
}

- (void) makeRequestForLoadingItems {
    NSMutableString *stringUrl = [NSMutableString stringWithString:WebsiteUrl];
    [stringUrl appendString:@"/forum/viewforum.php?f=2200"];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset" ];
    [request setValue:@"ru-RU" forHTTPHeaderField:@"Content-Language"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [request setValue:@"application/x-www-form-urlencoded charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"completionHandler");
                                          
                                          if (error) {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка загрузки"
                                                                                              message:[NSString stringWithFormat:@"%@: %@", error.localizedFailureReason, error.localizedDescription]
                                                                                             delegate:self
                                                                                    cancelButtonTitle:@"Accept"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              return;
                                          }
                                          
                                          NSString *contentType = nil;
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                              contentType = headers[@"Content-Type"];
                                          }
                                          
                                          ContentParser *parser = [[ContentParser alloc]init];
                                          NSMutableArray<FilmInfo*>* filmInfoItems = [parser parseFilmListFromHtml:data contentType:contentType];
                                          
                                          NSLog(@"parseHtml has returned %lu items", (unsigned long)filmInfoItems.count);
                                          
                                          [_filmItems removeAllObjects];
                                          //self.arrayFilms = filmInfoItems;
                                          //self.arrayFilms = [[NSMutableArray<FilmInfo*> alloc] arrayByAddingObjectsFromArray:filmInfoItems];
                                          [_filmItems addObjectsFromArray:filmInfoItems];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.tableView reloadData];
                                              self.tableView.userInteractionEnabled = YES;
                                          });
                                          
                                          //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                          NSLog(@"table view was updated");
                                          
                                          //[self logFilmInfoItems:filmInfoItems];
                                      }];
    [dataTask resume];
}

- (void) logFilmInfoItems:(NSMutableArray<FilmInfo*>*) items {
    for (FilmInfo* filmInfo in items) {
        NSLog(@"--------------");
        NSLog(@"%@", filmInfo.name);
        NSLog(@"%@", filmInfo.torrentAuthor);
        NSLog(@"%@", filmInfo.relativeUrl);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filmItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TorrentCell";
    
    FilmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    FilmInfo *filmInfo = [_filmItems objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = filmInfo.name;
    
    if (! filmInfo.isServiceMessage) {
        cell.authorLabel.text = [NSString stringWithFormat:@"[%@]", filmInfo.torrentAuthor];
        cell.posterImage.hidden = NO;
        
        if (filmInfo.posterImageData == nil) {
            UIImage *image = [UIImage imageNamed: @"no_poster.png"];
            cell.posterImage.image = image;
            
            //NSData *imageData = [self loadImageDataByUrl:filmInfo.relativeUrl];
            //cell.posterImage.image = [UIImage imageWithData: imageData];
            //[self loadImageDataByUrl:filmInfo.relativeUrl];
            [self loadImageDataByUrl:filmInfo.relativeUrl indexPath:indexPath];
        }
        else {
            cell.posterImage.image = [UIImage imageWithData: filmInfo.posterImageData];
        }
        
    }
    else {
        cell.authorLabel.text = nil;
        cell.posterImage.hidden = YES;
    }
    
    return cell;
}

- (void) loadImageDataByUrl: (NSString*)urlPart indexPath: (NSIndexPath*)indexPath  {
    NSMutableString *stringUrl = [NSMutableString stringWithString:WebsiteUrl];
    [stringUrl appendString:@"/"];
    [stringUrl appendString:urlPart];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset" ];
    [request setValue:@"ru-RU" forHTTPHeaderField:@"Content-Language"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [request setValue:@"application/x-www-form-urlencoded charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSString *contentType = nil;
                                          
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                              contentType = headers[@"Content-Type"];
                                          }
                                          
                                          ContentParser *parser = [[ContentParser alloc] init];
                                          NSString* imageUrl = [parser parsePosterUrlFromHtml:data contentType:contentType];
                                          
                                          NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
                                          
                                          if (imageData != nil) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  // save in cache
                                                  FilmInfo *filmInfo = [_filmItems objectAtIndex:indexPath.row];
                                                  filmInfo.posterImageData = imageData;
                                                  
                                                  FilmTableViewCell *updateCell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
                                                  if (updateCell) {
                                                      updateCell.posterImage.image = [UIImage imageWithData: imageData];
                                                  }
                                              });
                                          }
                                          
                                      }];
    
    [dataTask resume];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FilmInfo *filmInfo = [_filmItems objectAtIndex:indexPath.row];
    
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    detailView.relativeUrl = filmInfo.relativeUrl;
    detailView.name = filmInfo.name;
    
    [self.navigationController pushViewController:detailView animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
