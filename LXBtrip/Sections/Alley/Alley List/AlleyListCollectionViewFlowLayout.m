//
//  AlleyListCollectionViewFlowLayout.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyListCollectionViewFlowLayout.h"
#import "AppMacro.h"

@implementation AlleyListCollectionViewFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
        CGFloat itemWidth = SCREEN_WIDTH/2.0 + 0.5f;
        CGFloat itemHeight = itemWidth/(LIST_WIDTH_HEIGHT_PROPORTION_ALLEY);
        
        self.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        //        NSLog(@"self.itemSize: %@", NSStringFromCGSize(self.itemSize));
        // 行margin
        self.sectionInset = UIEdgeInsetsMake(10.f, LIST_HOR_MARGIN_ALLEY, LIST_VER_MARGIN_ALLEY, LIST_HOR_MARGIN_ALLEY);
        // 行距
        self.minimumLineSpacing = LIST_VER_SPACING_ALLEY;
        // 间距
        self.minimumInteritemSpacing = LIST_HOR_SPACING_ALLEY;
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
    
    CGFloat itemWidth = (self.collectionView.frame.size.width-LIST_HOR_MARGIN_ALLEY*2-(NUM_OF_IMAGES_PER_ROW_ALLEY-1)*LIST_HOR_SPACING_ALLEY)/NUM_OF_IMAGES_PER_ROW_ALLEY;
    CGFloat itemHeight = itemWidth/LIST_WIDTH_HEIGHT_PROPORTION_ALLEY;
    
    attributes.size = CGSizeMake(itemWidth, itemHeight);
    return attributes;
}

//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return NO;
//}

@end
