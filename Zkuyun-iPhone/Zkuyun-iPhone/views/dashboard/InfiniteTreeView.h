//
//  PushTreeView.h
//  Sword
//
//  Created by Sword on 14-4-8.
//  Copyright (c) 2014年 KSY. All rights reserved.
//

@protocol PushTreeViewDataSource;
@protocol PushTreeViewDelegate;

@interface InfiniteTreeView : UIView
{
}

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) id<PushTreeViewDataSource>dataSource;
@property (nonatomic, assign) id<PushTreeViewDelegate>delegate;

- (void)back;

- (void)reloadData;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)selectedAtLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath animated:(BOOL)animated;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier level:(NSInteger)level NS_AVAILABLE_IOS(6_0);

@end

@protocol PushTreeViewDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInLevel:(NSInteger)level;
- (NSInteger)numberOfRowsInLevel:(NSInteger)level section:(NSInteger)section;
- (UITableViewCell *)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level indexPath:(NSIndexPath*)indexPath;

@end

@protocol PushTreeViewDelegate <NSObject>
@required
- (void)pushTreeViewWillReloadAtLevel:(InfiniteTreeView*)pushTreeView currentLevel:(NSInteger)currentLevel level:(NSInteger)level indexPath:(NSIndexPath*)indexPath;

@optional
- (void)pushTreeView:(InfiniteTreeView *)pushTreeView didSelectedLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath;
- (BOOL)pushTreeViewHasNextLevel:(InfiniteTreeView *)pushTreeView currentLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath;
- (NSString *)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level titleForHeaderInSection:(NSInteger)section;
//- (UIView *)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level viewForHeaderInSection:(NSInteger)section;
- (CGFloat)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level heightForHeaderInSection:(NSInteger)section;
- (CGFloat)pushTreeView:(InfiniteTreeView *)pushTreeView level:(NSInteger)level heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
