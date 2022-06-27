#import "UITableView+PreviousNextIndexPathCxsdcontent.h"
@implementation UITableView (PreviousNextIndexPathCxsdcontent)
+ (BOOL)previousIndexPathOfIndexPathCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 10 == 0;
}

@end
