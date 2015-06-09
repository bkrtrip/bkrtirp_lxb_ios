//
//  SupplierProduct.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierProduct.h"

@implementation SupplierProduct

- (id)initWithDict:(NSDictionary *)dict
{
    self.productLineClass = [dict[@"category_code"] isKindOfClass:[NSNull class]]?nil:dict[@"category_code"];
    self.productCompanyName = [dict[@"company_name"] isKindOfClass:[NSNull class]]?nil:dict[@"company_name"];
    self.productCompanyContactPhone = [dict[@"company_contactcallphone"] isKindOfClass:[NSNull class]]?nil:dict[@"company_contactcallphone"];
    
    self.productDetailURL = [dict[@"details_url"] isKindOfClass:[NSNull class]]?nil:dict[@"details_url"];
    self.productIntroduceURL = [dict[@"introduce_url"] isKindOfClass:[NSNull class]]?nil:dict[@"introduce_url"];
    self.productShareURL = [dict[@"share_url"] isKindOfClass:[NSNull class]]?nil:dict[@"share_url"];
    self.productPreviewURL = [dict[@"preview_url"] isKindOfClass:[NSNull class]]?nil:dict[@"preview_url"];

    
    self.productIntroduce = [dict[@"goods_introduce"] isKindOfClass:[NSNull class]]?nil:dict[@"goods_introduce"];
    self.productIsTourServices = [dict[@"is_tour_services"] isKindOfClass:[NSNull class]]?nil:dict[@"is_tour_services"];
    self.productMarketPrice = [dict[@"market_price"] isKindOfClass:[NSNull class]]?nil:dict[@"market_price"];
    
    
    NSString *temp = [dict[@"market_ticket_group"] isKindOfClass:[NSNull class]]?nil:dict[@"market_ticket_group"];
    
    id object = [self arrayOrDictinaryWithJsonString:temp];
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *temp2 = [[NSMutableArray alloc] init];
        [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MarketTicketGroup *group = [[MarketTicketGroup alloc] initWithDict:obj];
            [temp2 addObject:group];
        }];
        self.productMarketTicketGroup = [temp2 copy];
    }
    
    
    
    self.productPeerNotice = [dict[@"peer_notice"] isKindOfClass:[NSNull class]]?nil:dict[@"peer_notice"];
    self.productTravelApplyTime = [dict[@"travel_apply_time"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_apply_time"];
    self.productTravelGoodsCode = [dict[@"travel_goods_code"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_code"];
    self.productTravelGoodsCompanyId = [dict[@"travel_goods_companyid"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_companyid"];
    self.productTravelGoodsImg1 = [dict[@"travel_goods_img1"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_img1"];
    self.productTravelGoodsImg2 = [dict[@"travel_goods_img2"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_img2"];
    self.productTravelGoodsImg3 = [dict[@"travel_goods_img3"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_img3"];
    self.productTravelGoodsImg4 = [dict[@"travel_goods_img4"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_img4"];
    self.productTravelGoodsImg5 = [dict[@"travel_goods_img5"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_img5"];
    
    self.productTravelGoodsName = [dict[@"travel_goods_name"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_name"];
    self.productTravelGoodsUpdateTime = [dict[@"travel_goods_updatetime"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_updatetime"];
    self.productTravelJourneyDays = [dict[@"travel_journey_days"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_journey_days"];
    self.productTravelPrice = [dict[@"travel_price"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_price"];



    temp = [dict[@"travel_ticket_group"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_ticket_group"];
    
    object = [self arrayOrDictinaryWithJsonString:temp];
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *temp2 = [[NSMutableArray alloc] init];
        [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TravelTicketGroup *group = [[TravelTicketGroup alloc] initWithDict:obj];
            [temp2 addObject:group];
        }];
        self.productTravelTicketGroup = [temp2 copy];
    }
    
    self.productWalkType = [dict[@"walk_type"] isKindOfClass:[NSNull class]]?nil:dict[@"walk_type"];

    return self;
}

#pragma mark - Private methods
- (id)arrayOrDictinaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return obj;
}


@end
