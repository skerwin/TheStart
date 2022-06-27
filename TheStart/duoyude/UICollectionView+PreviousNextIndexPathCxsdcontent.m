#import "UICollectionView+PreviousNextIndexPathCxsdcontent.h"
@implementation UICollectionView (PreviousNextIndexPathCxsdcontent)
+ (BOOL)previousIndexPathOfIndexPathCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 32 == 0;
}

@end
