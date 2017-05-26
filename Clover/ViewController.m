//
//  ViewController.m
//  Clover
//
//  Created by Aswini Ramesh on 5/26/17.
//  Copyright © 2017 Aswini Ramesh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.acronymTableView.delegate=self;
    self.acronymTableView.dataSource=self;
    
    self.acronyms = [[NSMutableArray alloc]init];
    
    self.acronymTableView.hidden = YES;
    
    }

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (IBAction)getInfoButtonPressed:(id)sender {
    
    
    self.inputAcronym=self.acronymTextField.text;
    
    if([self.inputAcronym  isEqualToString:BLANK_STRING])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:INFO_BUTTON_PROMPT preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self getDataForAcronym:self.inputAcronym];
    }
}



-(void) getDataForAcronym:(NSString*) acronymInput
{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    //Background Thread
        NSString *getDataString = [BASE_URL stringByAppendingString:acronymInput];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:getDataString] options:NSDataReadingUncached error:&error];
        
        if(error)
        {
             dispatch_async(dispatch_get_main_queue(), ^(void){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            });
            
        }
        else
        {
            
        NSDictionary* parsedObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
       
        dispatch_async(dispatch_get_main_queue(), ^(void){
        // UI Updates in main thread
            if([parsedObject count]==0)
            {
                UIAlertController *noDataAlert = [UIAlertController alertControllerWithTitle:nil
                                                                               message:NO_DATA_ALERT
                                                        preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:noDataAlert animated:YES completion:nil];
                
            }
            else
            {
                  [self parseData:parsedObject];
                  self.acronymTableView.hidden=NO;
                  [self.acronymTableView reloadData];
            }
        
    });
        }
});
    
    
    
    }
    

- (void)parseData:(NSDictionary*) parsedObject
{
    
    [self.acronyms removeAllObjects];
    NSArray *results = [parsedObject valueForKey:@"lfs"];
   
    
    for (NSDictionary *groupDic in results) {
        
        for (NSDictionary *acDetails in groupDic) {
            
            
            Acronym * acronym = [[Acronym alloc]init];
            
            acronym.longform = [acDetails objectForKey:@"lf"];
            acronym.frequency = [acDetails objectForKey:@"freq"];
            acronym.year = [acDetails objectForKey:@"since"];
            
            [self.acronyms addObject:acronym];
            
        }
    }

}
#pragma TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.acronyms count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *acronymTableIdentifier = TABLE_ID;
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:acronymTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:acronymTableIdentifier];
    }
    
    Acronym *tableRowAcronym =[self.acronyms objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tableRowAcronym.longform;
    cell.textLabel.numberOfLines=3;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSString *freqDetail =[NSString stringWithFormat: @"Frequency:  %@",tableRowAcronym.frequency];
    NSString *sinceDetail =[NSString stringWithFormat: @"  Since:  %@",tableRowAcronym.year];
    NSString *detail = [freqDetail stringByAppendingString:sinceDetail];

    cell.detailTextLabel.text = detail;
    cell.detailTextLabel.numberOfLines=3;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

#pragma TextField DataSource Methods

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
