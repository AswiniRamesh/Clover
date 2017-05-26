//
//  ViewController.h
//  Clover
//
//  Created by Aswini Ramesh on 5/26/17.
//  Copyright © 2017 Aswini Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "CloverServiceManager.h"
#import "Acronym.h"


@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *acronymTextField;
@property (weak, nonatomic) IBOutlet UIButton *getInfoButton;
@property (weak, nonatomic) IBOutlet UITableView *acronymTableView;


@property (strong, nonatomic) NSMutableArray *acronymList;
@property (strong, nonatomic) NSMutableArray *acronyms;
@property (strong, nonatomic) NSString *inputAcronym;
@property (strong, nonatomic) NSDictionary* parsedObject;


- (IBAction)getInfoButtonPressed:(id)sender;

- (void)parseData:(NSDictionary*) parsedObject;
- (void) getDataForAcronym:(NSString*) acronymInput;


@end

