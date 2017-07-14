insert into systemRole values (1, '系统管理员', 'xiTong','1');
insert into systemUser values (1, 'admin', '管理员', '0192023A7BBD73250516F069DF18B500', '1', '1');



create table siteModule (
	siteModuleID int(11) primary key,
	name varchar (50),
	moduleTypeID int(11) ,
	processName varchar (100),
	ico varchar (200),
	sortIndex int(11) ,
	validFlag varchar (3)
); 
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1035','商品管理','40','product','other/LF7RPIQYIY20160504111546.png','3','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1036','订单管理','40','order','other/QIFWGZBMF820160504111611.png','4','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1038','基础设置','40','config','other/TJ7DN9WNUZ20160510181546.png','7','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1039','客服系统','40','comment','other/9JI947K8EU20160513142225.png','8','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1040','统计报表','40','saleReport','other/U5W63NC3TV20160513152511.png','99','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1041','店铺装修','40','supplierCollection','other/EY8PC4CQKL20160601102754.png','1','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1043','促销管理','40','groupBuy','other/GTBSLTVQNK20160614133134.png','5','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1046','资金管理','40','supplierCash','other/JV9CW5VQ7M20160831155339.png','9','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1047','运费模板','40','feeTemplate','other/JV9CW5VQ7M20160831155339.png','6','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1048','会员管理','40','shopUser','other/NVDQIYSX4920151006171003.png','6','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1049','文章管理','40','info','other/E9TDKMMKI820151125181122.png','7','1');
insert into siteModule (siteModuleID, name, moduleTypeID, processName, ico, sortIndex, validFlag) values('1050','相册管理','40','photoAlbum','other/JV9CW5VQ7M20160831155339.png','11','1');

insert into supplier(supplierID, status) values(0, 20);

insert into sysConfig values('openQueHuoTongZhiFlag', '1', '是否开启缺货通知（0：关闭，1：开启）');

insert into sysConfig values('useVerifyFlag', '0', '是否启用验证码（0：关闭，1：开启）');

insert into sysConfig values('commentDeadDay', '7', '评价期限（单位：天，大于0天开启，否则关闭）');
insert into sysConfig values('commentDeadDay2', '7', '追评期限（单位：天，大于0天开启，否则关闭）');
insert into sysConfig values('commentAudtiFlag', '0', '评论是否需要审核（0：关闭，1：开启）');
insert into sysConfig values('openAutoGoodCommentFlag', '0', '评论到期是否自动好评（0：关闭，1：开启）');