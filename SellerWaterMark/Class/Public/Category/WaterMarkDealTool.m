//
//  WaterMarkDealTool.m
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/5.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import "WaterMarkDealTool.h"
#import "FMDB.h"

@implementation WaterMarkDealTool

static FMDatabase *_db;

+ (void)initialize
{
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
   
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+ (NSArray *)imageDeals:(int)page
{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *array = [NSMutableArray array];
    while (set.next) {
        EditorLabelModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [array addObject:model];
    }
    //    NSLog(@"++++%@",array);
    return array;
}

+ (void)addImageDeals:(EditorLabelModel *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %d);", data, deal.num];
}

+ (void)removeImageDeals:(EditorLabelModel *)deal
{
    NSString *str = [NSString stringWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %d",deal.num];
    [_db executeUpdate:str];
}

+ (BOOL)isCollected:(EditorLabelModel *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %d;", deal.num];
    [set next];
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}

@end
