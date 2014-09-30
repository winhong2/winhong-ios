//
//  DatacenterDetailCollectionVC.m
//  wincenterDemo01
//
//  Created by apple on 14-8-31.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MasterCollectionVC.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionHeader.h"
#import "PoolListResult.h"
#import "PoolVO.h"
#import "HostVO.h"
#import "HostListResult.h"
#import "StorageVO.h"
#import "StorageListResult.h"
#import "VmVO.h"
#import "VmListResult.h"
#import "BusinessVO.h"
#import "BusinessListResult.h"
#import "NetworkVO.h"
#import "NetworkListResult.h"
#import "MasterContainerVC.h"

@interface MasterCollectionVC ()
@property NSMutableDictionary *pools;
@property NSMutableDictionary *pools_needMoreButton;
@property NSMutableDictionary *dataList;
@end

@implementation MasterCollectionVC


- (void)viewDidLoad
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    
    self.pools = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    self.pools_needMoreButton = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    self.dataList = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    
    switch (self.pageType) {
        case MasterCollectionType_POOL_BY_DATACENTER:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getPoolListUrl, self.datacenterVO.id, 9]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[PoolListResult alloc] initWithJSONData:jsonResponse.rawBody].resourcePools forKey:self.datacenterVO.name];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_POOL_BY_DATACENTER_MORE:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getPoolListUrl_all, self.datacenterVO.id]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[PoolListResult alloc] initWithJSONData:jsonResponse.rawBody].resourcePools forKey:self.datacenterVO.name];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
            /***
             
             物理主机
             
             ***/
        case MasterCollectionType_HOST_BY_DATACENTER:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getPoolListUrl_all, self.datacenterVO.id]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                NSArray *pools = [[PoolListResult alloc] initWithJSONData:jsonResponse.rawBody].resourcePools;
                for(PoolVO *poolVO in pools){
                    UNIHTTPJsonResponse *jsonResponse = [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                        [simpleRequest setUrl:[NSString stringWithFormat:getHostListUrl_byPool, self.datacenterVO.id, poolVO.resourcePoolId, 7]];
                    }] asJson:nil];
                    [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                    NSMutableArray *hosts = [[NSMutableArray alloc] initWithArray:[[HostListResult alloc] initWithJSONData:jsonResponse.rawBody].hosts];
                    NSString *needMoreButton = @"FALSE";
                    
                    if(hosts.count==7){
                        needMoreButton = @"TRUE";
                        [hosts removeObjectAtIndex:6];
                    }
                    
                    [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                    [self.dataList setValue:hosts forKey:poolVO.resourcePoolName];
                }
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_HOST_BY_DATACENTER_MORE:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getHostListUrl_byPool_all, self.datacenterVO.id, self.poolVO.resourcePoolId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[HostListResult alloc] initWithJSONData:jsonResponse.rawBody].hosts forKey:self.poolVO.resourcePoolName];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_HOST_BY_POOL:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getHostListUrl_byPool_all, self.datacenterVO.id, ((PoolVO *)self.baseObject).resourcePoolId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[HostListResult alloc] initWithJSONData:jsonResponse.rawBody].hosts forKey:((PoolVO *)self.baseObject).resourcePoolName];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_HostNetwork:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getHostNetwork_external, self.datacenterVO.id, ((HostVO *)self.baseObject).hostId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[HostNetworkListResult alloc] initWithJSONData:jsonResponse.rawBody].networks forKey:@"外部网络"];
                
                [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                    [simpleRequest setUrl:[NSString stringWithFormat:getHostNetwork_internal, self.datacenterVO.id, ((HostVO *)self.baseObject).hostId]];
                }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                    [self.dataList setValue:[[HostNetworkListResult alloc] initWithJSONData:jsonResponse.rawBody].networks forKey:@"内部网络"];
                    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
                }];
            }];
            break;
        }
        case MasterCollectionType_HostNic:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getHostNic_isNull, self.datacenterVO.id, ((PoolVO *)self.baseObject).resourcePoolId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[HostNicListResult alloc] initWithJSONData:jsonResponse.rawBody].pnis forKey:@"非聚合网卡"];
                
                [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                    [simpleRequest setUrl:[NSString stringWithFormat:getHostNic_isNotNull, self.datacenterVO.id, ((PoolVO *)self.baseObject).resourcePoolId]];
                }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                    [self.dataList setValue:[[HostNicListResult alloc] initWithJSONData:jsonResponse.rawBody].pnis forKey:@"聚合网卡"];
                    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
                }];
            }];
            break;
        }
            /***
             
             存储池
             
             ***/
        case MasterCollectionType_STORAGE_BY_DATACENTER:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getPoolListUrl_all, self.datacenterVO.id]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                NSArray *pools = [[PoolListResult alloc] initWithJSONData:jsonResponse.rawBody].resourcePools;
                for(PoolVO *poolVO in pools){
                    UNIHTTPJsonResponse *jsonResponse = [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                        [simpleRequest setUrl:[NSString stringWithFormat:getStorageListUrl_byPool_all, self.datacenterVO.id, poolVO.resourcePoolId]];
                    }] asJson:nil];
                    NSArray *storageList = [[StorageListResult alloc] initWithJSONData:jsonResponse.rawBody].resultList;
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
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_STORAGE_BY_DATACENTER_MORE:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getStorageListUrl_byPool_all, self.datacenterVO.id, self.poolVO.resourcePoolId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                NSArray *storageList = [[StorageListResult alloc] initWithJSONData:jsonResponse.rawBody].resultList;
                NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
                for(StorageVO *item in storageList){
                    if([item.shared isEqualToString:@"true"]){
                        [shareList addObject:item];
                    }
                }
                [self.dataList setValue:shareList forKey:self.poolVO.resourcePoolName];
                
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_STORAGE_BY_POOL:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getStorageListUrl_byPool_all, self.datacenterVO.id, ((PoolVO *)self.baseObject).resourcePoolId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                NSArray *storageList = [[StorageListResult alloc] initWithJSONData:jsonResponse.rawBody].resultList;
                NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
                for(StorageVO *item in storageList){
                    if([item.shared isEqualToString:@"true"]){
                        [shareList addObject:item];
                    }
                }
                [self.dataList setValue:shareList forKey:((PoolVO *)self.baseObject).resourcePoolName];
                
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_STORAGE_BY_HOST:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getStorageListUrl_byHost, self.datacenterVO.id, ((HostVO *)self.baseObject).hostId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                NSArray *storageList = [[StorageListResult alloc] initWithJSONData:jsonResponse.rawBody].resultList;
                NSMutableArray *shareList = [[NSMutableArray alloc] initWithCapacity:0];
                for(StorageVO *item in storageList){
                    if(![item.shared isEqualToString:@"true"]){//非共享
                        [shareList addObject:item];
                    }
                }
                [self.dataList setValue:shareList forKey:((HostVO *)self.baseObject).hostName];
                
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
            /***
             
             虚拟主机
             
             ***/
        case MasterCollectionType_VM_BY_DATACENTER:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getPoolListUrl_all, self.datacenterVO.id]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                NSArray *pools = [[PoolListResult alloc] initWithJSONData:jsonResponse.rawBody].resourcePools;
                for(PoolVO *poolVO in pools){
                    UNIHTTPJsonResponse *jsonResponse = [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                        [simpleRequest setUrl:[NSString stringWithFormat:getVmListUrl_byPool, self.datacenterVO.id, poolVO.resourcePoolId, 7]];
                    }] asJson:nil];
                    
                    [self.pools setValue:poolVO forKey:poolVO.resourcePoolName];
                    
                    NSMutableArray *vms = [[NSMutableArray alloc] initWithArray:[[VmListResult alloc] initWithJSONData:jsonResponse.rawBody].vms];
                    NSString *needMoreButton = @"FALSE";
                    
                    if(vms.count==7){
                        needMoreButton = @"TRUE";
                        [vms removeObjectAtIndex:6];
                    }
                    
                    [self.pools_needMoreButton setValue:needMoreButton forKey:poolVO.resourcePoolName];
                    [self.dataList setValue:vms forKey:poolVO.resourcePoolName];
                }
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_VM_BY_DATACENTER_MORE:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getVmListUrl_byPool_all, self.datacenterVO.id, self.poolVO.resourcePoolId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[VmListResult alloc] initWithJSONData:jsonResponse.rawBody].vms forKey:self.poolVO.resourcePoolName];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_VM_BY_POOL:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getVmListUrl_byPool_all, self.datacenterVO.id, ((PoolVO *)self.baseObject).resourcePoolId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[VmListResult alloc] initWithJSONData:jsonResponse.rawBody].vms forKey:((PoolVO *)self.baseObject).resourcePoolName];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_VM_BY_HOST:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getVmListUrl_byHost, self.datacenterVO.id, ((HostVO *)self.baseObject).hostId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[VmListResult alloc] initWithJSONData:jsonResponse.rawBody].vms forKey:((HostVO *)self.baseObject).hostName];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_VMDisk:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getVmVolumn, self.datacenterVO.id, ((VmVO *)self.baseObject).vmId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[VmDiskListResult alloc] initWithJSONData:jsonResponse.rawBody].volumes forKey:((VmVO *)self.baseObject).name];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_VMNetwork:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getVmNic, self.datacenterVO.id, ((VmVO *)self.baseObject).vmId]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[VmNetworkListResult alloc] initWithJSONData:jsonResponse.rawBody].nics forKey:((VmVO *)self.baseObject).name];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
            /***
             
             业务系统
             
             ***/
        case MasterCollectionType_BUSINESS_BY_DATACENTER:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getBusinessListUrl, self.datacenterVO.id, 9]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[BusinessListResult alloc] initWithJSONData:jsonResponse.rawBody].resultList forKey:self.datacenterVO.name];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        case MasterCollectionType_BUSINESS_BY_DATACENTER_MORE:{
            [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
                [simpleRequest setUrl:[NSString stringWithFormat:getBusinessListUrl_all, self.datacenterVO.id]];
            }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                [self.dataList setValue:[[BusinessListResult alloc] initWithJSONData:jsonResponse.rawBody].resultList forKey:self.datacenterVO.name];
                [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
            }];
            break;
        }
        default:{
            break;
        }
    }
    

    
}

- (void) refresh{
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataList.allKeys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[section]]).count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    switch (self.pageType) {
        case MasterCollectionType_POOL_BY_DATACENTER:
        case MasterCollectionType_POOL_BY_DATACENTER_MORE:{
            PoolVO *poolVO = (PoolVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = poolVO.resourcePoolName;
            cell.label1.text = [NSString stringWithFormat:@"%d台", poolVO.hostNumber];
            cell.label2.text = [NSString stringWithFormat:@"%d台", poolVO.activeVmNumber];
            cell.label3.text = [NSString stringWithFormat:@"%d", poolVO.totalLogicalCpu];
            cell.label4.text = [NSString stringWithFormat:@"%.2fGB", poolVO.totalMemory/1024.0];
            cell.label5.text = [NSString stringWithFormat:@"%.2fGB", poolVO.totalStorage];
            return cell;
        }
        case MasterCollectionType_HOST_BY_DATACENTER:
        case MasterCollectionType_HOST_BY_DATACENTER_MORE:{
            HostVO *hostVO = (HostVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = hostVO.hostName;
            cell.label1.text = hostVO.ip;
            cell.label2.text = [NSString stringWithFormat:@"%d",hostVO.virtualMachineNum ];
            cell.label3.text = [NSString stringWithFormat:@"%.2fGB",hostVO.storage];
            cell.status.text = [hostVO state_text];
            cell.status.textColor = [hostVO state_color];
            return cell;
        }
        case MasterCollectionType_HOST_BY_POOL:{
            HostVO *hostVO = (HostVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = hostVO.hostName;
            cell.label1.text = hostVO.ip;
            cell.label2.text = [NSString stringWithFormat:@"%d",hostVO.virtualMachineNum];
            cell.label3.text = [NSString stringWithFormat:@"%d",hostVO.cpuSlots];
            cell.label4.text = [NSString stringWithFormat:@"%d",hostVO.cpu];
            cell.label5.text = [NSString stringWithFormat:@"%.2fGB",hostVO.memory/1024.0];
            cell.status.text = [hostVO state_text];
            cell.status.textColor = [hostVO state_color];

            return cell;
        }
        case MasterCollectionType_HostNetwork:{
            HostNetworkVO *hostNetworkVO = (HostNetworkVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = hostNetworkVO.name;
            
            cell.label2.text = @"";
            cell.label3.text = @"";
            cell.label4.text = @"";
            cell.label5.text = hostNetworkVO.vlanId;
            cell.label6.text = hostNetworkVO.pniName;
            cell.status.text = hostNetworkVO.state;
            //连接状态 linkeState
            return cell;
        }
        case MasterCollectionType_HostNic:{
            HostNicVO *hostNicVO = (HostNicVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = hostNicVO.name;
            cell.label1.text = hostNicVO.macAddress;
            cell.label2.text = [NSString stringWithFormat:@"%dMbit/s", hostNicVO.speed];
            cell.label3.text = [NSString stringWithFormat:@"%dByte",hostNicVO.mtu];
            cell.label4.text = hostNicVO.vendor;
            cell.label5.text = hostNicVO.device;
            cell.type.text = hostNicVO.duplex;
            //连接状态 linkeState
            return cell;
        }
        case MasterCollectionType_STORAGE_BY_DATACENTER:
        case MasterCollectionType_STORAGE_BY_DATACENTER_MORE:{
            StorageVO *storageVO = (StorageVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = storageVO.storagePoolName;
            cell.label1.text = [NSString stringWithFormat:@"%.2fGB剩余,共%.2fGB", storageVO.availStorage, storageVO.totalStorage];
            cell.label2.text = [NSString stringWithFormat:@"%d个", storageVO.volumeNum];
            cell.status.text = [storageVO state_text];
            cell.share.text = [storageVO shared_text];
            cell.progress.progress = (storageVO.totalStorage-storageVO.availStorage)/storageVO.totalStorage;
            if(cell.progress.progress>0.8){
                cell.progress.progressTintColor = [UIColor redColor];
            }else if(cell.progress.progress>0.6){
                cell.progress.progressTintColor = [UIColor yellowColor];
            }else{
                cell.progress.progressTintColor = [UIColor greenColor];
            }
            return cell;
        }
        case MasterCollectionType_STORAGE_BY_POOL:
        case MasterCollectionType_STORAGE_BY_HOST:{
            StorageVO *storageVO = (StorageVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = storageVO.storagePoolName;
            cell.label1.text = storageVO.type;
            cell.label2.text = storageVO.location;
            cell.label3.text = [NSString stringWithFormat:@"%d个", storageVO.volumeNum];
            cell.label4.text = [NSString stringWithFormat:@"%.2fGB剩余,共%.2fGB", storageVO.availStorage, storageVO.totalStorage];
            cell.status.text = [storageVO state_text];
            cell.share.text = [storageVO shared_text];
            cell.progress.progress = (storageVO.totalStorage-storageVO.availStorage)/storageVO.totalStorage;
            if(cell.progress.progress>0.8){
                cell.progress.progressTintColor = [UIColor redColor];
            }else if(cell.progress.progress>0.6){
                cell.progress.progressTintColor = [UIColor yellowColor];
            }else{
                cell.progress.progressTintColor = [UIColor greenColor];
            }
            return cell;
        }
        case MasterCollectionType_VM_BY_DATACENTER:
        case MasterCollectionType_VM_BY_DATACENTER_MORE:{
            VmVO *vmVO = (VmVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = vmVO.name;
            cell.label1.text = vmVO.ip;
            cell.label2.text = [NSString stringWithFormat:@"%d", vmVO.vcpu];
            cell.label3.text = [NSString stringWithFormat:@"%.2fGB", vmVO.memory/1024.0];
            cell.label4.text = [NSString stringWithFormat:@"%dGB", vmVO.storage];
            cell.status.text = [vmVO state_text];
            cell.status.textColor = [vmVO state_color];
            cell.osType_image.image = [UIImage imageNamed:[vmVO osType_imageName]];
            return cell;
        }
        case MasterCollectionType_VM_BY_POOL:
        case MasterCollectionType_VM_BY_HOST:{
            VmVO *vmVO = (VmVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = vmVO.name;
            cell.label1.text = vmVO.ip;
            cell.label2.text = [NSString stringWithFormat:@"%d", vmVO.vcpu];
            cell.label3.text = [NSString stringWithFormat:@"%.2fGB", vmVO.memory/1024.0];
            cell.label4.text = [NSString stringWithFormat:@"%dGB", vmVO.storage];
            cell.status.text = [vmVO state_text];
            cell.status.textColor = [vmVO state_color];
            cell.osType.text = vmVO.osType;
            return cell;
        }
        case MasterCollectionType_VMDisk:{
            VmDiskVO *vmDiskVO = (VmDiskVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = vmDiskVO.name;
            cell.label1.text = [vmDiskVO type_text];
            cell.label2.text = vmDiskVO.storagePoolName;
            cell.label3.text = [NSString stringWithFormat:@"%dGB", vmDiskVO.size];
            return cell;
        }
        case MasterCollectionType_VMNetwork:{
            VmNetworkVO *vmNetworkVO = (VmNetworkVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = vmNetworkVO.name;
            cell.label1.text = vmNetworkVO.type;
            cell.label2.text = vmNetworkVO.ip;
            cell.label3.text = vmNetworkVO.macAddr;
            cell.label4.text = [NSString stringWithFormat:@"%d", vmNetworkVO.vlanId];
            return cell;
        }
        case MasterCollectionType_BUSINESS_BY_DATACENTER:
        case MasterCollectionType_BUSINESS_BY_DATACENTER_MORE:{
            BusinessVO *businessVO = (BusinessVO *) [self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
            cell.title.text = businessVO.name;
            cell.label1.text = businessVO.managerId;
            cell.label2.text = [businessVO.createTime stringByReplacingOccurrencesOfString:@" 000" withString:@""];
            cell.label3.text = [NSString stringWithFormat:@"%d", businessVO.vmNum];
            return cell;
        }
        default:{
            
            return cell;
        }
    }
    
    
    
    return nil;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MasterCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MasterCollectionHeader" forIndexPath:indexPath];
    
    switch (self.pageType) {
        case MasterCollectionType_POOL_BY_DATACENTER:{
            header.titleHintView.hidden = YES;
            header.titleLabel.hidden = YES;
            header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
            break;
        }
        case MasterCollectionType_POOL_BY_DATACENTER_MORE:{
            header.titleHintView.hidden = YES;
            header.titleLabel.hidden = YES;
            header.moreButton.hidden = YES;
            break;
        }
        case MasterCollectionType_HOST_BY_DATACENTER:{
            header.titleLabel.text = [NSString stringWithFormat:@"%@下的物理机列表", self.dataList.allKeys[indexPath.section]];
            header.moreButton.hidden = [[self.pools_needMoreButton valueForKey:self.pools_needMoreButton.allKeys[indexPath.section]] isEqualToString:@"FALSE"];
            header.moreButton.tag = indexPath.section;
            break;
        }
        case MasterCollectionType_STORAGE_BY_DATACENTER:{
            header.titleLabel.text = [NSString stringWithFormat:@"%@下的共享存储列表", self.dataList.allKeys[indexPath.section]];
            header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<3);
            header.moreButton.tag = indexPath.section;
            break;
        }
        case MasterCollectionType_VM_BY_DATACENTER:{
            header.titleLabel.text = [NSString stringWithFormat:@"%@下的虚拟机列表", self.dataList.allKeys[indexPath.section]];
            header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<3);
            header.moreButton.tag = indexPath.section;
            break;
        }
        case MasterCollectionType_HOST_BY_DATACENTER_MORE:
        case MasterCollectionType_STORAGE_BY_DATACENTER_MORE:
        case MasterCollectionType_VM_BY_DATACENTER_MORE:
        case MasterCollectionType_BUSINESS_BY_DATACENTER_MORE:{
            header.titleHintView.hidden = YES;
            header.titleLabel.hidden = YES;
            header.moreButton.hidden = YES;
            break;
        }
        case MasterCollectionType_BUSINESS_BY_DATACENTER:{
            header.titleHintView.hidden = YES;
            header.titleLabel.hidden = YES;
            header.moreButton.hidden = (((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count<9);
            break;
        }
        case MasterCollectionType_HOST_BY_POOL:{
            header.titleLabel.text = [NSString stringWithFormat:@"物理机列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        case MasterCollectionType_HostNetwork:{
            header.titleLabel.text = [NSString stringWithFormat:@"%@列表(%li)", self.dataList.allKeys[indexPath.section], ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        case MasterCollectionType_HostNic:{
            header.titleLabel.text = [NSString stringWithFormat:@"%@列表(%li)", self.dataList.allKeys[indexPath.section], ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        case MasterCollectionType_STORAGE_BY_POOL:{
            header.titleLabel.text = [NSString stringWithFormat:@"共享存储列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        case MasterCollectionType_STORAGE_BY_HOST:{
            header.titleLabel.text = [NSString stringWithFormat:@"本地存储列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        case MasterCollectionType_VM_BY_POOL:
        case MasterCollectionType_VM_BY_HOST:{
            header.titleLabel.text = [NSString stringWithFormat:@"虚拟机列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        case MasterCollectionType_VMDisk:{
            header.titleLabel.text = [NSString stringWithFormat:@"虚拟磁盘列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        case MasterCollectionType_VMNetwork:{
            header.titleLabel.text = [NSString stringWithFormat:@"虚拟网络列表(%li)", ((NSArray*)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]]).count];
            header.moreButton.hidden = NO;
            break;
        }
        default:
            break;
    }

    
    
    return header;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toMorePage"]){
        MasterContainerVC *vc = segue.destinationViewController;
        vc.datacenterVO = self.datacenterVO;
        if(self.pools.allKeys.count>0){
            vc.poolVO = [self.pools valueForKey:self.pools.allKeys[((UIButton*)sender).tag]];
        }
        switch (self.pageType) {
            case MasterCollectionType_POOL_BY_DATACENTER:{
                vc.pageType = MasterPageType_POOL_MORE;
                break;
            }
            case MasterCollectionType_HOST_BY_DATACENTER:{
                vc.pageType = MasterPageType_HOST_MORE;
                break;
            }
            case MasterCollectionType_STORAGE_BY_DATACENTER:{
                vc.pageType = MasterPageType_STORAGE_MORE;
                break;
            }
            case MasterCollectionType_VM_BY_DATACENTER:{
                vc.pageType = MasterPageType_VM_MORE;
                break;
            }
            case MasterCollectionType_BUSINESS_BY_DATACENTER:{
                vc.pageType = MasterPageType_BUSINESS_MORE;
                break;
            }
            default:{
                break;
            }
        }
    }else{
        MasterContainerVC *vc = segue.destinationViewController;
        vc.datacenterVO = self.datacenterVO;
        vc.poolVO = self.poolVO;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:((UICollectionViewCell *)sender)];
        vc.baseObject = (BaseObject *)[self.dataList valueForKey:self.dataList.allKeys[indexPath.section]][indexPath.row];
        switch (self.pageType) {
            case MasterCollectionType_POOL_BY_DATACENTER:
            case MasterCollectionType_POOL_BY_DATACENTER_MORE:{
                vc.pageType = MasterPageType_POOL;
                break;
            }
            case MasterCollectionType_HOST_BY_DATACENTER:
            case MasterCollectionType_HOST_BY_DATACENTER_MORE:
            case MasterCollectionType_HOST_BY_POOL:{
                vc.pageType = MasterPageType_HOST;
                break;
            }
            case MasterCollectionType_STORAGE_BY_DATACENTER:
            case MasterCollectionType_STORAGE_BY_DATACENTER_MORE:
            case MasterCollectionType_STORAGE_BY_POOL:
            case MasterCollectionType_STORAGE_BY_HOST:{
                vc.pageType = MasterPageType_STORAGE;
                break;
            }
            case MasterCollectionType_VM_BY_DATACENTER:
            case MasterCollectionType_VM_BY_DATACENTER_MORE:
            case MasterCollectionType_VM_BY_POOL:
            case MasterCollectionType_VM_BY_HOST:{
                vc.pageType = MasterPageType_VM;
                break;
            }
            case MasterCollectionType_BUSINESS_BY_DATACENTER:
            case MasterCollectionType_BUSINESS_BY_DATACENTER_MORE:{
                vc.pageType = MasterPageType_BUSINESS;
                break;
            }
            default:{
                break;
            }
        }
    }
}

@end
