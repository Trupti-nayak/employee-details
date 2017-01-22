//
//  EmployeeContent.m
//  EmployeeDetailsApp
//
//  Created by prabhudev avarasang on 21/01/17.
//  Copyright © 2017 Trupti. All rights reserved.
//

#import "EmployeeContent.h"

@interface EmployeeContent()

@property(nonatomic,strong)NSArray *contentArray;
@property(nonatomic,strong)NSArray *hobbiesConetntArray;





@end
@implementation EmployeeContent

@synthesize contentArray;


-(NSArray *)getGenderArray
{
    contentArray=[[NSArray alloc]initWithObjects:@"Male",@"Female",@"Other", nil];
    
    return contentArray;
}

-(NSArray *)getHobbiesArray
{
    _hobbiesConetntArray=[[NSArray alloc]initWithObjects:@"Cricket",@"Football",@"Coding",@"Listening to music",@"Swimming", nil];
    
    return _hobbiesConetntArray;
}

@end
