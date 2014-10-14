//
//  PoolCollectionVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "DatacenterDetailCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "PoolContainerVC.h"
#import "DatacenterDetailMoreVC.h"
#import "PoolContainerVC.h"
#import "HostContainerVC.h"
#import "StorageContainerVC.h"
#import "VmContainerVC.h"
#import "BusinessContainerVC.h"
#import "MasterCollectionFooter.h"
#import "DatacenterDetailCollectionHeader.h"

@implementation DatacenterDetailCollectionVC

-(void)reloadData{
    switch (self.pageType) {
        case Page_Pool:{
            [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
                [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
                [self.collectionView reloadData];
            } limit:(self.isMore ? 0 : 9)];
            break;
        }
        case Page_Host:{
            if(self.poolVO){
                if(self.isMore){
                    [self.poolVO getHostListAsync:^(NSArray *allRemote, NSError *error) {
                        [self.dataList setValue:allRemote forKey:self.poolVO.resourcePoolName];
                        [self.collectionView reloadData];
                    }];
                }else{
                    [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
                        for(PoolVO *poolVO in allRemote){
                            [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                            NSMutableArray *hosts = [[NSMutableArray alloc] initWithArray:[poolVO getHostLisWithlimit:7 error:nil]];
                            NSString *needMoreButton = @"FALSE";
                            
                            if(hosts.count==7){
                                needMoreButton = @"TRUE";
                                [hosts removeObjectAtIndex:6];
                            }
                            
                            [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                            [self.dataList setValue:hosts forKey:poolVO.resourcePoolName];
                        }
                        [self.collectionView reloadData];
                    }];
                }
            }else{
                [[RemoteObject getCurrentDatacenterVO] getHostListAsync:^(NSArray *allRemote, NSError *error) {
                    [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
                    [self.collectionView reloadData];
                }];
            }
            break;
        }
        case Page_Storage:{
            if(self.poolVO){
                if(self.isMore){
                    [self.poolVO getStorageListAsync:^(NSArray *allRemote, NSError *error) {
                        NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
                        for(StorageVO *item in allRemote){
                            if([item.shared isEqualToString:@"true"]){
                                [shareList addObject:item];
                            }
                        }
                        [self.dataList setValue:shareList forKey:self.poolVO.resourcePoolName];
                        [self.collectionView reloadData];
                    }];
                    
                }else{
                    [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
                        for(PoolVO *poolVO in allRemote){
                            NSArray *storageList = [poolVO getStorageList:nil];
                            NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
                            NSString *needMoreButton = @"FALSE";
                            int count = 0;
                            for(StorageVO *item in storageList){
                                if([item.shared isEqualToString:@"true"]){
                                    count++;
                                    if(count==7){
                                        needMoreButton = @"TRUE";
                                        break;
                                    }
                                    [shareList addObject:item];
                                }
                            }
                            //if(shareList.count>0){
                            [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                            [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                            [self.dataList setValue:shareList forKey:poolVO.resourcePoolName];
                            //}
                        }
                        [self.collectionView reloadData];
                    }];
                }
            }else{
                [[RemoteObject getCurrentDatacenterVO] getStorageListAsync:^(NSArray *allRemote, NSError *error) {
                    [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
                    [self.collectionView reloadData];
                }];
            }
            break;
        }
        case Page_VM:{
            if(self.poolVO){
                if(self.isMore){
                    [self.poolVO getVmListAsync:^(NSArray *allRemote, NSError *error) {
                        [self.dataList setValue:allRemote forKey:self.poolVO.resourcePoolName];
                        [self.collectionView reloadData];
                    }];
                }else{
                    [[RemoteObject getCurrentDatacenterVO] getPoolListAsync:^(NSArray *allRemote, NSError *error) {
                        for(PoolVO *poolVO in allRemote){
                            [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                            
                            NSMutableArray *vms = [[NSMutableArray alloc] initWithArray:[poolVO getVmListWithlimit:7 error:nil]];
                            NSString *needMoreButton = @"FALSE";
                            
                            if(vms.count==7){
                                needMoreButton = @"TRUE";
                                [vms removeObjectAtIndex:6];
                            }
                            
                            [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                            [self.dataList setValue:vms forKey:poolVO.resourcePoolName];
                        }
                        [self.collectionView reloadData];
                    }];
                }
            }else{
                [[RemoteObject getCurrentDatacenterVO] getVmListAsync:^(NSArray *allRemote, NSError *error) {
                    [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
                    [self.collectionView reloadData];
                }];
            }
            break;
        }
        case Page_Business:{
            [[RemoteObject getCurrentDatacenterVO] getBusinessListAsync:^(NSArray *allRemote, NSError *error) {
                [self.dataList setValue:allRemote forKey:[RemoteObject getCurrentDatacenterVO].name];
                [self.collectionView reloadData];
            } limit:(self.isMore ? 0 : 9)];
            break;
        }
        default:
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.pageType) {
        case Page_Pool:{
            MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterPoolCollectionCell" forIndexPath:indexPath];
            
            
            PoolVO *poolVO = (PoolVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = poolVO.resourcePoolName;
            cell.label1.text = [NSString stringWithFormat:@"%d台", poolVO.hostNumber];
            cell.label2.text = [NSString stringWithFormat:@"%d台", poolVO.activeVmNumber];
            cell.label3.text = [NSString stringWithFormat:@"%.2fGHz", poolVO.totalCpu/1000.0];
            cell.label4.text = [NSString stringWithFormat:@"%.2fGB", poolVO.totalMemory/1024.0];
            cell.label5.text = [NSString stringWithFormat:@"%.2fGB", poolVO.totalStorage];
            return cell;
        }
        case Page_Host:{
            MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterHostCollectionCell" forIndexPath:indexPath];
            
            HostVO *hostVO = (HostVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = hostVO.hostName;
            cell.label1.text = hostVO.ip;
            cell.label2.text = [NSString stringWithFormat:@"%d",hostVO.virtualMachineNum ];
            cell.label3.text = [NSString stringWithFormat:@"%.2fGB",hostVO.storage];
            cell.label4.text = [NSString stringWithFormat:@"%d",hostVO.cpuSlots];
            cell.label5.text = [NSString stringWithFormat:@"%d",hostVO.cpu];
            cell.label6.text = [NSString stringWithFormat:@"%.2fGB",hostVO.memory/1024.0];
            cell.status.text = [hostVO state_text];
            cell.status.textColor = [hostVO state_color];
            return cell;
        }
        case Page_Storage:{
            MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterStorageCollectionCell" forIndexPath:indexPath];
            
            StorageVO *storageVO = (StorageVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = storageVO.storagePoolName;
            cell.label1.text = [NSString stringWithFormat:@"%.2fGB剩余,共%.2fGB", storageVO.availStorage, storageVO.totalStorage];
            cell.label2.text = [NSString stringWithFormat:@"%d个", storageVO.volumeNum];
            cell.label3.text = [NSString stringWithFormat:@"%@", storageVO.location];
            cell.status.text = [storageVO state_text];
            cell.status.textColor = [storageVO state_color];
            cell.share_image.hidden = [storageVO.shared isEqualToString:@"false"];
            cell.progress.progress = (storageVO.totalStorage-storageVO.availStorage)/storageVO.totalStorage;
            if(cell.progress.progress>0.8){
                cell.progress.progressTintColor = PNRed;
            }else if(cell.progress.progress>0.6){
                cell.progress.progressTintColor = PNYellow;
            }else{
                cell.progress.progressTintColor = PNGreen;
            }
            return cell;
        }
        case Page_VM:{
            MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterVmCollectionCell" forIndexPath:indexPath];
            
            VmVO *vmVO = (VmVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = vmVO.name;
            cell.label1.text = vmVO.ip;
            if(vmVO.ip == nil){
                cell.label1.text = @"(尚未配置ip)";
            }
            cell.label2.text = [NSString stringWithFormat:@"%d", vmVO.vcpu];
            cell.label3.text = [NSString stringWithFormat:@"%.2fGB", vmVO.memory/1024.0];
            cell.label4.text = [NSString stringWithFormat:@"%dGB", vmVO.storage];
            cell.status.text = [vmVO state_text];
            cell.status.textColor = [vmVO state_color];
            cell.osType_image.image = [UIImage imageNamed:[vmVO osType_imageName]];
            return cell;
        }
        case Page_Business:{
            MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatacenterBusinessCollectionCell" forIndexPath:indexPath];
            
            BusinessVO *businessVO = (BusinessVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = businessVO.name;
            cell.label1.text = businessVO.managerId;
            cell.label2.text = [businessVO.createTime stringByReplacingOccurrencesOfString:@" 000" withString:@""];
            cell.label3.text = [NSString stringWithFormat:@"%d", businessVO.vmNum];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(self.isDetailPagePushed){

                switch (self.pageType) {
                    case Page_Pool:{
                        DatacenterDetailCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DatacenterPoolCollectionHeader" forIndexPath:indexPath];
                        
                        header.poolCount.text = [NSString stringWithFormat:@"%d",0];
                        header.cpuUsedCount.text = [NSString stringWithFormat:@"%.2fGHz",20.0];
                        header.cpuUnitUnusedCount.text = [NSString stringWithFormat:@"%.2fGHz",20.0];
                        header.memeryUsedSize.text = [NSString stringWithFormat:@"%.2fG",10.00];
                        header.memoryUnusedSize.text = [NSString stringWithFormat:@"%.2fG",10.00];
                        header.storageUsedSize.text = [NSString stringWithFormat:@"%.2fT",1.0];
                        header.storageUnusedSize.text = [NSString stringWithFormat:@"%.2fT",1.0];
                        
                        //圈图
                        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:header.cpuChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart.backgroundColor = [UIColor clearColor];
                        circleChart.labelColor = [UIColor clearColor];
                        circleChart.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:88.0/255 green:206.0/255 blue:96.0/255 alpha:1]];//已使用填充颜色
                        [circleChart strokeChart];
                        [header.cpuChartGroup addSubview:circleChart];
                        
                        
                        PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:header.memoryChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart2.backgroundColor = [UIColor clearColor];
                        circleChart2.labelColor = [UIColor clearColor];
                        circleChart2.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart2.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart2.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:88.0/255 green:206.0/255 blue:96.0/255 alpha:1]];//已使用填充颜色
                        [circleChart2 strokeChart];
                        [header.memoryChartGroup addSubview:circleChart2];
                        
                        PNCircleChart * circleChart3 = [[PNCircleChart alloc] initWithFrame:header.storageChartGroup.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart3.backgroundColor = [UIColor clearColor];
                        circleChart3.labelColor = [UIColor clearColor];
                        circleChart3.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart3.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart3.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:88.0/255 green:206.0/255 blue:96.0/255 alpha:1]];//已使用填充颜色
                        [circleChart3 strokeChart];
                        [header.storageChartGroup addSubview:circleChart3];
                        
                        return header;
                    }
                    case Page_Host:{
                        DatacenterDetailCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DatacenterHostCollectionHeader" forIndexPath:indexPath];
                        
                        header.hostCount.text = [NSString stringWithFormat:@"%d",0];
                        header.label1.text = [NSString stringWithFormat:@"%d",0];
                        header.label2.text = [NSString stringWithFormat:@"%d",0];
                        header.label3.text = [NSString stringWithFormat:@"%d",0];
                        header.label4.text = [NSString stringWithFormat:@"%d",0];
                        header.label5.text = [NSString stringWithFormat:@"%d",0];
                        
                        //圈图
                        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:header.hostTypeChart.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart.backgroundColor = [UIColor clearColor];
                        circleChart.labelColor = [UIColor clearColor];
                        circleChart.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:71.0/255 green:145.0/255 blue:210.0/255 alpha:1]];//已使用填充颜色
                        [circleChart strokeChart];
                        [header.hostTypeChart addSubview:circleChart];
                        
                        
                        PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:header.hostStatusChart.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart2.backgroundColor = [UIColor clearColor];
                        circleChart2.labelColor = [UIColor clearColor];
                        circleChart2.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart2.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart2.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:88.0/255 green:206.0/255 blue:96.0/255 alpha:1]];//已使用填充颜色
                        [circleChart2 strokeChart];
                        [header.hostStatusChart addSubview:circleChart2];
                        
                        return header;
                    }
                    case Page_Storage:{
                        DatacenterDetailCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DatacenterStorageCollectionHeader" forIndexPath:indexPath];
                        
                        header.label1.text = [NSString stringWithFormat:@"%.2fG",0.0];
                        header.label2.text = [NSString stringWithFormat:@"%.2fG",0.0];
                        header.label3.text = [NSString stringWithFormat:@"%.2fG",0.0];
                        header.label4.text = [NSString stringWithFormat:@"%.2fG",0.0];
                        header.label5.text = [NSString stringWithFormat:@"%.2fG",0.0];
                        header.label6.text = [NSString stringWithFormat:@"%.2fG",0.0];
                        header.label7.text = [NSString stringWithFormat:@"%.2f",0.0];
                        header.label8.text = [NSString stringWithFormat:@"%.2f",0.0];
                        header.label9.text = [NSString stringWithFormat:@"%.2f",0.0];
                        header.label10.text = [NSString stringWithFormat:@"%.2f",0.0];
                        
                        //圈图
                        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:header.storageShareChart.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart.backgroundColor = [UIColor clearColor];
                        circleChart.labelColor = [UIColor clearColor];
                        circleChart.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:248.0/255 green:123.0/255 blue:56.0/255 alpha:1]];//已使用填充颜色
                        [circleChart strokeChart];
                        [header.storageShareChart addSubview:circleChart];
                        
                        
                        PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:header.storageUseChart.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart2.backgroundColor = [UIColor clearColor];
                        circleChart2.labelColor = [UIColor clearColor];
                        circleChart2.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart2.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart2.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:248.0/255 green:123.0/255 blue:56.0/255 alpha:1]];//已使用填充颜色
                        [circleChart2 strokeChart];
                        [header.storageUseChart addSubview:circleChart2];
                        
                        return header;
                    }
                    case Page_VM:{
                        DatacenterDetailCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DatacenterVmCollectionHeader" forIndexPath:indexPath];
                        
                        header.vmCount.text =[NSString stringWithFormat:@"%d",0];
                        header.label1.text =[NSString stringWithFormat:@"%d",0];
                        header.label2.text =[NSString stringWithFormat:@"%d",0];
                        header.label3.text =[NSString stringWithFormat:@"%d",0];
                        header.label4.text =[NSString stringWithFormat:@"%d",0];
                        header.label5.text =[NSString stringWithFormat:@"%d",0];
                        header.label6.text =[NSString stringWithFormat:@"%d",0];
                        header.label7.text =[NSString stringWithFormat:@"%d",0];
                        header.label8.text =[NSString stringWithFormat:@"%d",0];
                        
                        //圈图
                        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:header.vmOsTypeChart.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart.backgroundColor = [UIColor clearColor];
                        circleChart.labelColor = [UIColor clearColor];
                        circleChart.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:71.0/255 green:145.0/255 blue:210.0/255 alpha:1]];//已使用填充颜色
                        [circleChart strokeChart];
                        [header.vmOsTypeChart addSubview:circleChart];
                        
                        
                        PNCircleChart * circleChart2 = [[PNCircleChart alloc] initWithFrame:header.vmStatusChart.bounds andTotal:@100 andCurrent:[NSNumber numberWithFloat:50] andClockwise:YES andShadow:YES];
                        circleChart2.backgroundColor = [UIColor clearColor];
                        circleChart2.labelColor = [UIColor clearColor];
                        circleChart2.circleBG.strokeColor = [UIColor colorWithRed:255.0/255 green:216.0/255 blue:0/255 alpha:1].CGColor;//未使用填充颜色
                        circleChart2.circle.lineCap = kCALineCapSquare;//直角填充
                        circleChart2.lineWidth = @11.0f;//线宽度
                        [circleChart setStrokeColor:[UIColor colorWithRed:88.0/255 green:206.0/255 blue:96.0/255 alpha:1]];//已使用填充颜色
                        [circleChart2 strokeChart];
                        [header.vmStatusChart addSubview:circleChart2];
                        
                        return header;
                    }
                    case Page_Business:{
                        DatacenterDetailCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DatacenterBusinessCollectionHeader" forIndexPath:indexPath];
                        //
                        return header;
                    }
                    default:
                        break;
                }
            return nil;

        }else{
            MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
            
            if(header){
                switch (self.pageType) {
                    case Page_Pool:{
                        header.titleHintView.hidden = YES;
                        header.titleLabel.hidden = YES;
                        header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
                        break;
                    }
                    case Page_Host:{
                        header.titleLabel.text = [NSString stringWithFormat:@"%@下的物理机列表", self.dataList.allKeys[indexPath.section]];
                        header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<6);
                        header.moreButton.tag = indexPath.section;
                        break;
                    }
                    case Page_Storage:{
                        header.titleLabel.text = [NSString stringWithFormat:@"%@下的共享存储列表", self.dataList.allKeys[indexPath.section]];
                        header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<6);
                        header.moreButton.tag = indexPath.section;
                        break;
                    }
                    case Page_VM:{
                        header.titleLabel.text = [NSString stringWithFormat:@"%@下的虚拟机列表", self.dataList.allKeys[indexPath.section]];
                        header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<6);
                        header.moreButton.tag = indexPath.section;
                        break;
                    }
                    case Page_Business:{
                        header.titleHintView.hidden = YES;
                        header.titleLabel.hidden = YES;
                        header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
                        break;
                    }
                    default:
                        break;
                }
            }
            
            if (self.isMore) {
                header.hidden = YES;
            }else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"isDemo"]isEqualToString:@"true"]){
                header.moreButton.hidden = NO;
            }
            
            return header;
        }
    }else{
        MasterCollectionFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MasterCollectionFooter" forIndexPath:indexPath];
        
        if(footer){
            switch (self.pageType) {
                case Page_Pool:{
                    footer.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
                    break;
                }
                case Page_Host:{
                    footer.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<6);
                    footer.moreButton.tag = indexPath.section;
                    break;
                }
                case Page_Storage:{
                    footer.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<6);
                    footer.moreButton.tag = indexPath.section;
                    break;
                }
                case Page_VM:{
                    footer.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<6);
                    footer.moreButton.tag = indexPath.section;
                    break;
                }
                case Page_Business:{
                    footer.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
                    break;
                }
                default:
                    break;
            }
        }
        
        if (self.isMore) {
            footer.hidden = YES;
        }else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"isDemo"]isEqualToString:@"true"]){
            footer.moreButton.hidden = NO;
        }
        
        return footer;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.pageType) {
        case Page_Pool:{
            UIViewController *root = [[UIStoryboard storyboardWithName:@"Pool"] instantiateInitialViewController];
            PoolContainerVC *vc;
            if([root isKindOfClass:[PoolContainerVC class]]){
                vc = (PoolContainerVC*) root;
            }else{
                vc = [[root childViewControllers] firstObject];
            }
            vc.poolVO = (PoolVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            
            if(self.isDetailPagePushed){
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self presentViewController:root animated:YES completion:nil];
            }
            break;
        }
        case Page_Host:{
            UIViewController *root = [[UIStoryboard storyboardWithName:@"Host"] instantiateInitialViewController];
            HostContainerVC *vc;
            if([root isKindOfClass:[HostContainerVC class]]){
                vc = (HostContainerVC*) root;
            }else{
                vc = [[root childViewControllers] firstObject];
            }
            vc.hostVO = (HostVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];

            
            if(self.isDetailPagePushed){
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self presentViewController:root animated:YES completion:nil];
            }
            break;
        }
        case Page_Storage:{
            UIViewController *root = [[UIStoryboard storyboardWithName:@"Storage"] instantiateInitialViewController];
            StorageContainerVC *vc;
            if([root isKindOfClass:[StorageContainerVC class]]){
                vc = (StorageContainerVC*) root;
            }else{
                vc = [[root childViewControllers] firstObject];
            }
            vc.storageVO = (StorageVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];

            if(self.isDetailPagePushed){
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self presentViewController:root animated:YES completion:nil];
            }
            
            break;
        }
        case Page_VM:{
            UIViewController *root = [[UIStoryboard storyboardWithName:@"VM"] instantiateInitialViewController];
            VmContainerVC *vc;
            if([root isKindOfClass:[VmContainerVC class]]){
                vc = (VmContainerVC*) root;
            }else{
                vc = [[root childViewControllers] firstObject];
            }
            vc.vmVO = (VmVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];

            if(self.isDetailPagePushed){
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self presentViewController:root animated:YES completion:nil];
            }
            
            break;
        }
        case Page_Business:{
            UIViewController *root = [[UIStoryboard storyboardWithName:@"Business"] instantiateInitialViewController];
            BusinessContainerVC *vc;
            if([root isKindOfClass:[BusinessContainerVC class]]){
                vc = (BusinessContainerVC*) root;
            }else{
                vc = [[root childViewControllers] firstObject];
            }
            vc.businessVO = (BusinessVO *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];

            if(self.isDetailPagePushed){
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self presentViewController:root animated:YES completion:nil];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toMore"]){
        UIViewController *root = segue.destinationViewController;
        DatacenterDetailMoreVC *vc;
        if([root isKindOfClass:[DatacenterDetailMoreVC class]]){
            vc = (DatacenterDetailMoreVC*)root;
        }else{
            vc = (DatacenterDetailMoreVC*) [[root childViewControllers] firstObject];
        }
        if(self.pools && self.pools.allKeys.count>0){
            vc.poolVO = [self.pools valueForKey:self.pools.allKeys[((UIButton*)sender).tag]];
        }
        vc.pageType = self.pageType;
    }
}


-(IBAction)showWarningInfoVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Warning"] instantiateInitialViewController];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(IBAction)showControlRecordVC:(id)sender{
    if(self.popover!=nil){
        [self.popover dismissPopoverAnimated:NO];
    }
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task"] instantiateInitialViewController];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


@end
