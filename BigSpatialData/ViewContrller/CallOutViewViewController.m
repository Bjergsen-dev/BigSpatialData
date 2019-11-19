//
//  CallOutViewViewController.m
//  BigSpatialData
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import "CallOutViewViewController.h"

@interface CallOutViewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *properTable;
@property (nonatomic,strong) NSMutableArray * properArray;
@end

@implementation CallOutViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //regist the delegate of table
    _properTable.delegate = self;
    _properTable.dataSource = self;
    
    //init the self.properArray
    _properArray = [[NSMutableArray alloc] init];
    
    
}


//implent the method
-(void) updatetheProperTbale:(NSMutableArray *) properArray{

    
    if (properArray) {
        _properArray = properArray;
        [_properTable reloadData];
    }

    
}


#pragma mark TableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_properArray) {
        
        return  _properArray.count;
    }
    
    return 1;
    
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    
    //get the string from array and regist the cell text
    NSString * cellStr = [_properArray objectAtIndex:indexPath.row];
    if (cellStr) {
        [cell.textLabel setText:cellStr];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }else{
        [cell.textLabel setText:@"属性：无"];
    }

    
    
    cell.backgroundColor = UIColor.greenColor;
    return cell;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
