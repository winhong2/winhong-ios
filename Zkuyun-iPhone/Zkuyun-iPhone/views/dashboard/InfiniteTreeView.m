//
//  PushTreeView.m
//  Sword
//
//  Created by Sword on 14-4-8.
//  Copyright (c) 2014年 KSY. All rights reserved.
//

#import "UIView+ITTAdditions.h"
#import "InfiniteTreeView.h"

//#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define SAME_INDEXPATH(i1, i2) (i1.section == i2.section && i1.row == i2.row)
#define left_size 120
#define right_size 200
@interface InfiniteTreeView()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL            _animating;
    BOOL            _animated;
    NSInteger       _selectedLevel;
    NSInteger       _currentReloadDataLevel;
    NSIndexPath     *_selectedIndexPath;
    NSIndexPath     *_previousIndexPath;
    NSMutableSet    *_tableViews;
    NSMutableSet    *_recyleTableViews;
    UIView          *_lineView;
    NSMutableDictionary *_selectedLevelIndexDic;
}
@end

@implementation InfiniteTreeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _animating = FALSE;
        _animated = TRUE;
        _level = 0;
        _selectedLevel = NSNotFound;
        _selectedIndexPath = nil;
        _currentReloadDataLevel = 0;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(left_size, 0, 1, CGRectGetHeight(self.bounds))];
        _lineView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
        _lineView.hidden = TRUE;
        _selectedLevelIndexDic = [[NSMutableDictionary alloc] init];
        [self addSubview:_lineView];
        [self collectTableViews];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _animating = FALSE;
        _animated = TRUE;
        _level = 0;
        _selectedLevel = NSNotFound;
        _selectedIndexPath = nil;
        _currentReloadDataLevel = 0;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(left_size, 0, 1, CGRectGetHeight(self.bounds))];
        _lineView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
        _lineView.hidden = TRUE;
        _selectedLevelIndexDic = [[NSMutableDictionary alloc] init];
        [self addSubview:_lineView];
        [self collectTableViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _lineView.height = CGRectGetHeight(self.bounds);
}

#pragma mark - private methods
- (void)collectTableViews
{
    _tableViews = [[NSMutableSet alloc] init];
    _recyleTableViews = [[NSMutableSet alloc] init];
    for(int i=0; i<3; i++){
        UITableView *treeTableView = [[UITableView alloc] initWithFrame:self.frame];
        if (0 == i) {
            treeTableView.dataSource = self;
            treeTableView.delegate = self;
            treeTableView.hidden = FALSE;
            treeTableView.tag = 0;
            [_tableViews addObject:treeTableView];
        }
        else {
            treeTableView.dataSource = nil;
            treeTableView.delegate = nil;
            treeTableView.tag = NSNotFound;
            treeTableView.hidden = TRUE;
            [_recyleTableViews addObject:treeTableView];
        }
        [self addSubview:treeTableView];
    }
}

- (UITableView*)dequeueTableView
{
    UITableView *tableView = [_recyleTableViews anyObject];
    if (tableView) {
        [_recyleTableViews removeObject:tableView];
    }
    tableView.dataSource = self;
    tableView.delegate = self;
    return tableView;
}

- (UITableView*)tableViewWithLevel:(NSInteger)level
{
    UITableView *foundTableView = nil;
    for (UITableView *tableView in _tableViews) {
        if (tableView.tag == level) {
            foundTableView = tableView;
            break;
        }
    }
    foundTableView.dataSource = self;
    foundTableView.delegate = self;
    return foundTableView;
}

- (void)updateLineView
{
    NSInteger visibleCount = [_tableViews count];
    if (visibleCount > 1) {
        _lineView.hidden = FALSE;
        [self bringSubviewToFront:_lineView];
    }
    else {
        _lineView.hidden = TRUE;
    }
}

- (void)recyleTableViews:(BOOL)push
{
    UITableView *recyleTableView = nil;
    if (push) {
        if (_level >= 2) {
            recyleTableView = [self tableViewWithLevel:_level - 2];
        }
    }
    else {
        recyleTableView = [self tableViewWithLevel:_level + 1];
    }
    if (recyleTableView) {
        recyleTableView.tag = NSNotFound;
        recyleTableView.hidden = TRUE;
        recyleTableView.dataSource = nil;
        recyleTableView.delegate = nil;
        [_recyleTableViews addObject:recyleTableView];
        [_tableViews removeObject:recyleTableView];
    }
    [self updateLineView];
}

- (void)applyNextAnimation:(UITableView*)tableView currentLevel:(NSInteger)currentLevel
{
    CGRect frame = tableView.frame;
    frame.origin.x = 320;
    tableView.frame = frame;
    tableView.hidden = FALSE;
    
    frame.origin.x = left_size;
    frame.size.width = right_size;
    UITableView *currentTableView = [self tableViewWithLevel:currentLevel];
    if (_animated) {
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.left = 0;
            currentTableView.left = 0;
            tableView.frame = frame;
        } completion:^(BOOL finished){
            if (finished) {
                _animating = FALSE;
                _lineView.left = left_size;
                [self recyleTableViews:TRUE];
            }
        }];
    }
    else {
        _animating = FALSE;
        _animated = TRUE;
        currentTableView.left = 0;
        tableView.frame = frame;
        _lineView.left = left_size;
        [self recyleTableViews:TRUE];
    }
}

- (void)applyBackAnimation:(UITableView*)tableView currentLevel:(NSInteger)currentLevel
{
    tableView.hidden = FALSE;
    UITableView *lastTableView = [self tableViewWithLevel:currentLevel];
    if (currentLevel >= 2) {
        UITableView *secondLastTableView = [self tableViewWithLevel:currentLevel - 1];
        CGRect secondFrame = secondLastTableView.frame;
        secondFrame.origin.x = left_size;
        secondFrame.size.width = right_size;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.left = 320;
            lastTableView.left = 320;
            secondLastTableView.frame = secondFrame;
        } completion:^(BOOL finished){
            if (finished) {
                _animating = FALSE;
                _lineView.left = left_size;
                [self recyleTableViews:FALSE];
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.left = 320;
            lastTableView.left = 320;
        } completion:^(BOOL finished){
            if (finished) {
                _animating = FALSE;
                [self recyleTableViews:FALSE];
            }
        }];
    }
}

- (void)back
{
    if (!_animating) {
        
        _animating = TRUE;
        
        [self removeSelectedIndex:_level];
        NSInteger lastLevel = _level;
        NSInteger needReloadDataLevel = _level - 2;
        if (needReloadDataLevel >= 0) {
        }
        else {
            needReloadDataLevel = 0;
        }
        _currentReloadDataLevel = needReloadDataLevel;
        _level--;
        UITableView *tableView = [self tableViewWithLevel:needReloadDataLevel];
        if (!tableView) {
            tableView = [self dequeueTableView];
        }
        tableView.tag = needReloadDataLevel;
        NSAssert(tableView != nil, @"nil table view");
        if ([_delegate respondsToSelector:@selector(pushTreeViewWillReloadAtLevel:currentLevel:level:indexPath:)]) {
            [_delegate pushTreeViewWillReloadAtLevel:self currentLevel:lastLevel level:_currentReloadDataLevel indexPath:nil];
            
            [tableView reloadData];
            [_tableViews addObject:tableView];
            if (needReloadDataLevel <= 0) {
                tableView.frame = self.bounds;
            }
            else {
                tableView.frame = CGRectMake(0, 0, right_size, CGRectGetHeight(self.bounds));
            }
            [self addSubview:tableView];
            [self sendSubviewToBack:tableView];
            [self applyBackAnimation:tableView currentLevel:lastLevel];
        }
        else {
            NSAssert(TRUE, @"pushTreeViewWillReload:previousLevel:level: not implemented");
        }
    }
}

- (void)reloadData
{
    for (UITableView *pushTreeTableView in _tableViews) {
        [pushTreeTableView reloadData];
    }
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    UITableView *treeTableView = [self tableViewWithLevel:_currentReloadDataLevel];
    [treeTableView deselectRowAtIndexPath:indexPath animated:animated];
}

- (void)selectedAtLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath animated:(BOOL)animated
{
    _animated = animated;
    UITableView *treeTableView = [self tableViewWithLevel:_currentReloadDataLevel];
    [treeTableView.delegate tableView:treeTableView didSelectRowAtIndexPath:indexPath];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier level:(NSInteger)level
{
    UITableView *treeTableView = [self tableViewWithLevel:level];
    [treeTableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    UITableView *treeTableView = [self tableViewWithLevel:_currentReloadDataLevel];
    return [treeTableView numberOfRowsInSection:section];
}

- (UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
    UITableView *treeTableView = [self tableViewWithLevel:_currentReloadDataLevel];
    return [treeTableView dequeueReusableCellWithIdentifier:identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UITableView *treeTableView = (UITableView*)tableView;
    return [_dataSource numberOfSectionsInLevel:treeTableView.tag];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UITableView *treeTableView = (UITableView*)tableView;
    return [_dataSource numberOfRowsInLevel:treeTableView.tag section:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *treeTableView = (UITableView*)tableView;
    UITableViewCell *cell = [_dataSource pushTreeView:self level:treeTableView.tag indexPath:indexPath];
    if (_level == 0) {
        cell.width = 320;
    }
    else {
        cell.width = right_size;
    }
    [cell setNeedsLayout];
    if ([self indexSelected:treeTableView.tag indexPath:indexPath]) {
        [treeTableView selectRowAtIndexPath:indexPath animated:FALSE scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UITableView *treeTableView = (UITableView*)tableView;
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:level:heightForHeaderInSection:)]) {
        return [_delegate pushTreeView:self level:treeTableView.tag heightForHeaderInSection:section];
    }
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *treeTableView = (UITableView*)tableView;
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:level:heightForRowAtIndexPath:)]) {
        return [_delegate pushTreeView:self level:treeTableView.tag heightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_delegate pushTreeView:self level:tableView.tag titleForHeaderInSection:section];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UITableView *treeTableView = (UITableView*)tableView;
//    return [_delegate pushTreeView:self level:treeTableView.tag viewForHeaderInSection:section];
//}

- (void)setSeletedIndexForLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath
{
    NSString *key = [NSString stringWithFormat:@"LEVEL%d", level];
    _selectedLevelIndexDic[key] = indexPath;
}

- (void)removeSelectedIndexAfterLevel:(NSInteger)level
{
    for (NSInteger i = level + 1; i <= _level; i++) {
        [self removeSelectedIndex:i];
    }
}

- (void)removeSelectedIndex:(NSInteger)level
{
    NSString *key = [NSString stringWithFormat:@"LEVEL%d", level];
    [_selectedLevelIndexDic removeObjectForKey:key];
}

- (BOOL)indexSelected:(NSInteger)level indexPath:(NSIndexPath*)indexPath
{
    NSString *key = [NSString stringWithFormat:@"LEVEL%d", level];
    NSIndexPath *selectedIndexPath = _selectedLevelIndexDic[key];
    if (selectedIndexPath && selectedIndexPath.section == indexPath.section &&
        selectedIndexPath.row == indexPath.row) {
        return TRUE;
    }
    return FALSE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *treeTableView = (UITableView*)tableView;
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:didSelectedLevel:indexPath:)]) {
        [_delegate pushTreeView:self didSelectedLevel:treeTableView.tag indexPath:indexPath];
    }
    [self setSeletedIndexForLevel:treeTableView.tag indexPath:indexPath];
    BOOL hasNext = FALSE;
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeViewHasNextLevel:currentLevel:indexPath:)]) {
        hasNext = [_delegate pushTreeViewHasNextLevel:self currentLevel:treeTableView.tag indexPath:indexPath];
    }
    if (hasNext) {
        
        //_animating = TRUE;
        
        NSInteger currentNeedReloadLevel = treeTableView.tag;
        if ([_delegate respondsToSelector:@selector(pushTreeViewWillReloadAtLevel:currentLevel:level:indexPath:)]) {
            [self removeSelectedIndexAfterLevel:currentNeedReloadLevel];            
            if (_selectedLevel == currentNeedReloadLevel) {
                if (!SAME_INDEXPATH(_selectedIndexPath, indexPath)) {
                    _currentReloadDataLevel = treeTableView.tag + 1;
                    [_delegate pushTreeViewWillReloadAtLevel:self currentLevel:treeTableView.tag level:_currentReloadDataLevel indexPath:indexPath];
                    UITableView *tableView = [self tableViewWithLevel:_currentReloadDataLevel];
                    [tableView reloadData];
                    if (!tableView) {
                        _level++;
                        tableView = [self dequeueTableView];
                        tableView.tag = _currentReloadDataLevel;
                        [tableView reloadData];
                        [_tableViews addObject:tableView];
                        tableView.frame = CGRectMake(0, 0, right_size, CGRectGetHeight(self.bounds));
                        [self applyNextAnimation:tableView currentLevel:_currentReloadDataLevel - 1];
                    }
                }
                else {
                    _currentReloadDataLevel = treeTableView.tag + 1;
                    [_delegate pushTreeViewWillReloadAtLevel:self currentLevel:treeTableView.tag level:_currentReloadDataLevel indexPath:indexPath];
                    UITableView *tableView = [self tableViewWithLevel:_currentReloadDataLevel];
                    if (!tableView) {
                        _level++;
                        tableView = [self dequeueTableView];
                        NSAssert(tableView != nil, @"nil table view");                        
                        tableView.tag = _currentReloadDataLevel;
                        [tableView reloadData];
                        [_tableViews addObject:tableView];
                        tableView.frame = CGRectMake(0, 0, right_size, CGRectGetHeight(self.bounds));
                        [self addSubview:tableView];
                        [self applyNextAnimation:tableView currentLevel:_level - 1];
                    }
                }
            }
            else {
                if (currentNeedReloadLevel > _selectedLevel || _selectedLevel == NSNotFound) {
                    _level++;
                    _currentReloadDataLevel = treeTableView.tag + 1;
                    NSInteger currentLevel = _selectedLevel;
                    if (_selectedLevel == NSNotFound) {
                        currentLevel = 0;
                    }
                    [_delegate pushTreeViewWillReloadAtLevel:self currentLevel:treeTableView.tag level:_currentReloadDataLevel indexPath:indexPath];
                    UITableView *tableView = [self tableViewWithLevel:_currentReloadDataLevel];
                    if (!tableView) {
                        tableView = [self dequeueTableView];
                    }
                    NSAssert(tableView != nil, @"nil table view");
                    tableView.tag = _currentReloadDataLevel;
                    [tableView reloadData];
                    [_tableViews addObject:tableView];
                    [self addSubview:tableView];
                    [self applyNextAnimation:tableView currentLevel:_currentReloadDataLevel - 1];
                }
                else {
                    _currentReloadDataLevel = treeTableView.tag + 1;
                    [_delegate pushTreeViewWillReloadAtLevel:self currentLevel:treeTableView.tag level:_currentReloadDataLevel indexPath:indexPath];
                    UITableView *tableView = [self tableViewWithLevel:_currentReloadDataLevel];
                    [tableView reloadData];
                    if (!tableView) {
                        _level++;
                        tableView = [self dequeueTableView];
                        tableView.tag = _currentReloadDataLevel;
                        [tableView reloadData];
                        [_tableViews addObject:tableView];
                        tableView.frame = CGRectMake(0, 0, right_size, CGRectGetHeight(self.bounds));
                        [self applyNextAnimation:tableView currentLevel:_currentReloadDataLevel - 1];
                    }
                    NSAssert(tableView != nil, @"nil table view");
                }
            }
            _selectedIndexPath = indexPath;
            _selectedLevel = treeTableView.tag;
        }
        else {
            NSAssert(TRUE, @"pushTreeViewWillReload:previousLevel:level: not implemented");
        }
    }
}
@end
