//
//  SupplierCollectionViewFlowLayout.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierCollectionViewFlowLayout.h"
#import "AppMacro.h"

@implementation SupplierCollectionViewFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
        CGFloat itemWidth = (SCREEN_WIDTH - LIST_HOR_MARGIN_SUPPLIER*2 - (NUM_OF_IMAGES_PER_ROW_SUPPLIER-1)*LIST_HOR_SPACING_SUPPLIER*2)/NUM_OF_IMAGES_PER_ROW_SUPPLIER;
        CGFloat itemHeight = itemWidth/LIST_WIDTH_HEIGHT_PROPORTION_SUPPLIER;
        
        self.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        //        NSLog(@"self.itemSize: %@", NSStringFromCGSize(self.itemSize));
        // 行margin
        self.sectionInset = UIEdgeInsetsMake(LIST_VER_MARGIN_SUPPLIER, LIST_HOR_MARGIN_SUPPLIER, LIST_VER_MARGIN_SUPPLIER, LIST_HOR_MARGIN_SUPPLIER);
        // 行距
        self.minimumLineSpacing = LIST_VER_SPACING_SUPPLIER;
        // 间距
        self.minimumInteritemSpacing = LIST_HOR_SPACING_SUPPLIER;
    }
    return self;
}

//- (CGSize)collectionViewContentSize
//{
//    return self.collectionView.frame.size;
//}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemWidth = (SCREEN_WIDTH - LIST_HOR_MARGIN_SUPPLIER*2 - (NUM_OF_IMAGES_PER_ROW_SUPPLIER-1)*LIST_HOR_SPACING_SUPPLIER)/NUM_OF_IMAGES_PER_ROW_SUPPLIER;
    CGFloat itemHeight = itemWidth/LIST_WIDTH_HEIGHT_PROPORTION_SUPPLIER;
    
    attributes.size = CGSizeMake(itemWidth, itemHeight);
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    attributes.size = CGSizeMake(self.collectionView.frame.size.width, 52.f);
    return attributes;
}

//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return NO;
//}


@end
