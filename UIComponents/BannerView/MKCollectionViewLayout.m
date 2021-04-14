//
//  MKCollectionViewLayout.m
//  Basic
//
//  Created by zhengmiaokai on 2020/2/12.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import "MKCollectionViewLayout.h"

@implementation MKCollectionViewLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1.获取cell对应的attributes对象
    NSArray *temps = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    // 不缩放直接返回数据
    if(!self.isZoom) return temps;
    
    // 2.计算整体的中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    // 3.修改一下attributes对象
    for (UICollectionViewLayoutAttributes *attributes in temps) {
        // 计算每个cell的中心点距离
        CGFloat centerDistance = ABS(attributes.center.x - centerX);
        // 距离越大，缩放比越小，距离越小，缩放比越大
        CGFloat scale = 1.0 / (1 + centerDistance * 0.0007/*space系数*/);
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return temps;
}

- (void)prepareLayout {
    [super prepareLayout];
}

@end
