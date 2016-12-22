//
//  PasterDealTool.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/22.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "PasterDealTool.h"
#import "FMDB.h"

@implementation PasterDealTool

static FMDatabase *_base;

+ (void)initialize
{
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"water.sqlite"];
    _base = [FMDatabase databaseWithPath:file];
    if (![_base open]) return;
    
    [_base executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+ (NSArray *)imageDeals:(int)page
{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_base executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *array = [NSMutableArray array];
    while (set.next) {
        EditorLabelModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [array addObject:model];
    }
    //    NSLog(@"++++%@",array);
    return array;
}

+ (void)addPasterImageDeals:(EditorLabelModel *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_base executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %d);", data, deal.num];
}

+ (void)removePasterImageDeals:(EditorLabelModel *)deal
{
    NSString *str = [NSString stringWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %d",deal.num];
    [_base executeUpdate:str];
}

+ (BOOL)isPasterCollected:(EditorLabelModel *)deal
{
    FMResultSet *set = [_base executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %d;", deal.num];
    [set next];
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}



@end
