
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DiskView.h"
#import "RATreeView.h"
#import "DiskDataObject.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface DiskView () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) IBOutlet RATreeView *treeView;

@end

@implementation DiskView

- (void)viewDidLoad
{
  [super viewDidLoad];


    NSMutableArray *datacenters = [[NSMutableArray alloc] init];
    for(int i=0; i<5; i++){
        NSMutableArray *virtualTypes = [[NSMutableArray alloc] init];
        for(int j=0; j<5; j++){
            NSMutableArray *pools = [[NSMutableArray alloc] init];
            for(int k=0; k<5; k++){
                NSMutableArray *physicals = [[NSMutableArray alloc] init];
                for(int m=0; m<5; m++){
                    NSMutableArray *vms = [[NSMutableArray alloc] init];
                    for(int n=0; n<5; n++){
                        DiskDataObject *vm = [DiskDataObject dataObjectWithName:[NSString stringWithFormat:@"文件-0%d", n] children:nil];
                        [vms addObject:vm];
                    }
                    DiskDataObject *physical = [DiskDataObject dataObjectWithName:[NSString stringWithFormat:@"文件夹-0%d", m] children:vms];
                    [physicals addObject:physical];
                }
                DiskDataObject *pool = [DiskDataObject dataObjectWithName:[NSString stringWithFormat:@"文件夹-0%d", k] children:physicals];
                [pools addObject:pool];
            }
            DiskDataObject *virtualType = [DiskDataObject dataObjectWithName:[NSString stringWithFormat:@"文件夹-0%d", j] children:pools];
            [virtualTypes addObject:virtualType];
        }
        DiskDataObject *datacenter = [DiskDataObject dataObjectWithName:[NSString stringWithFormat:@"文件夹-0%d", i] children:virtualTypes];
        [datacenters addObject:datacenter];
    }
  
    self.data = datacenters;
    
  self.treeView.delegate = self;
  self.treeView.dataSource = self;
  self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
  
  [self.treeView reloadData];
//  [treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
  [self.treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
  if ([item isEqual:self.expanded]) {
    return YES;
  }
  return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  if (treeNodeInfo.treeDepthLevel == 0) {
    cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
  } else if (treeNodeInfo.treeDepthLevel == 1) {
    cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
  } else if (treeNodeInfo.treeDepthLevel == 2) {
    cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
  } else if (treeNodeInfo.treeDepthLevel == 3) {
      cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
  } else if (treeNodeInfo.treeDepthLevel == 4) {
      cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
  } else if (treeNodeInfo.treeDepthLevel == 5) {
      cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
  }
    
    
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
  NSInteger numberOfChildren = [treeNodeInfo.children count];
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
  cell.textLabel.text = ((DiskDataObject *)item).name;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (treeNodeInfo.treeDepthLevel == 0) {
    cell.detailTextLabel.textColor = [UIColor blackColor];
  }
  return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
  if (item == nil) {
    return [self.data count];
  }
  DiskDataObject *data = item;
  return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
  DiskDataObject *data = item;
  if (item == nil) {
    return [self.data objectAtIndex:index];
  }
  return [data.children objectAtIndex:index];
}

@end
