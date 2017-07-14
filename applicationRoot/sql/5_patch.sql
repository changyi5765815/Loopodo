alter table shopOrder add canUseSampleFlag char(1); -- 是否可用拿样返还标识 0，未使用，1 已使用。该字段只有订单类型为拿样订单才有效
alter table shopOrder add sampleMoney decimal(12, 2); -- 拿样商品返还总金额，该字段只有非拿样订单才有效
alter table shopOrder add sampleShopOrderID bigint(20); -- 拿样商品返还对应拿样订单shopOrderID，该字段只有非拿样订单才有效

drop view if exists shopOrder_V;
create view shopOrder_V as (
	select a.*, 
	b.c_orderStatusName as statusName, 
	c.name townName, 
	d.cityID, 
	d.name cityName, 
	e.provinceID, 
	e.name provinceName,
	s.name supplierName,
	s.linkPhone supplierLinkPhone
	from shopOrder a, c_orderStatus b, town c, city d, province e, supplier s
	where a.status = b.c_orderStatusID and a.townID = c.townID and c.cityID = d.cityID and d.provinceID = e.provinceID and a.supplierID = s.supplierID
	order by a.shopOrderID desc
);

alter table orderProduct add autoCommentTimeMills bigint(20); -- 到期时间
alter table orderProduct add autoCommentFlag char(1) DEFAULT 0; -- 到期标识

alter table comment add autoComment2Flag char(1); -- 是否可追评标识， 0 可追评，1 追评成功， 2追评失效
alter table comment add autoComment2TimeMills bigint(20); -- 追评期限
alter table comment add replyContent2 varchar(500); -- 追评内容
alter table comment add auditFlag char(1); -- 审核标识 0 待审核，1通过，2 不通过


drop view if exists orderProduct_V;
create view orderProduct_V as (
	select a.*, b.name, b.mainImage,b.bigTypeID,b.bigTypeName,b.smallTypeID,b.smallTypeName,b.tinyTypeID,b.tinyTypeName,
	c.userID, c.status shopOrderStatus, c.orderTime, c.supplierID,c.sourceTypeID, c.shouHuoRen
	from orderProduct a, product_V b, shopOrder c
	where a.productID = b.productID and a.shopOrderID = c.shopOrderID
	order by orderTime desc
);

alter table supplier add reputationID int(11); -- 信誉值ID
alter table supplier add reputationValue int(8); -- 信誉值

-- 店铺信誉值管理表
create table if not exists c_shopReputation (
	c_shopReputationID int(11) primary key,
	c_shopReputationName varchar(20), -- 店铺信誉名称
	c_shopReputationValue int(8), -- 信誉值
	c_shopReputationImage varchar(200), -- 信誉图标
	validFlag char(1)
);


DROP VIEW IF EXISTS product_V;
CREATE VIEW product_V AS (
	SELECT
		a.*, b.name AS tinyTypeName,
		c.smallTypeID,
		c.name AS smallTypeName,
		d.bigTypeID,
		d.name AS bigTypeName,
		f.name AS brandName,
		e.name AS supplierName,
		e.STATUS supplierStatus,
		e.address as supplierAddress,
		e.deletedFlag AS supplierDeletedFlag,
		e.sampleDay, 
		e.sampleAmount,
		e.supplierTagIDs,
		e.supplierModeID, 
		e.supplierMainProductIDs,
		e.applyTime,
		e.qqNums,
		e.townID as supplierTownID,
		e.industryID,
		e.productCount,
		e.commentScoreAvg,
		e.serviceScoreAvg,
		e.deliveryScoreAvg,
		e.supplierLevelID,
		e.reputationID,
		e.reputationValue,
		g.name AS supplierSmallTypeName,
		g.supplierBigTypeName,
		g.supplierBigTypeID
	FROM
		product a
	LEFT JOIN brand f ON (a.brandID = f.brandID)
	LEFT JOIN supplierSmallType_V g ON (
		a.supplierSmallTypeID = g.supplierSmallTypeID
		AND g.deletedFlag = 0
	),
	tinyType b,
	smallType c,
	bigType d,
	supplier e
	WHERE
		a.tinyTypeID = b.tinyTypeID
	AND b.smallTypeID = c.smallTypeID
	AND c.bigTypeID = d.bigTypeID
	AND e.supplierID = a.supplierID
	ORDER BY
	productID DESC
);

drop view if exists product_Valid;
create view product_Valid as (
	select a.*
	from product_V a
	where a.deletedFlag = 0 and a.validFlag = 1 and a.auditStatus = 20
	and (a.supplierStatus is null or a.supplierStatus = 20) and (a.supplierDeletedFlag is null or a.supplierDeletedFlag = 0)
);

drop view if exists productDetailInfo_V;
create view productDetailInfo_V as (
	select a.*, b.detailInfo, 
	b.skuPropInfo, b.skuPropAlias, b.skuPropValueAlias, b.skuPropValueImg, 
	b.productDetailInfoID, b.seoTitle, 
	b.seoKeyword, b.seoDescription
	from product_V a, productDetailInfo b
	where a.productID = b.productID
);

drop view if exists sku_V;
create view sku_V as (
	select a.*, 
	b.tinyTypeID, b.tinyTypeName, b.smallTypeID, b.smallTypeName, b.bigTypeID, b.bigTypeName, 
	b.priceModeID, b.price as productPrice, b.maxPrice as productMaxPrice, b.priceDetail, 
	b.name, b.auditStatus, b.deletedFlag, b.mainImage, c.skuPropAlias, c.skuPropValueAlias
	from sku a, product_V b, productDetailInfo c
	where a.productID = b.productID and a.productID = c.productID
);
alter table photoAlbum add photoAlbumTypeID int(11); -- 相册类型
-- 相册图片视图
drop view if exists photo_V;
create view photo_V as (
	select a.*, b.name as photoAlbumName, b.photoAlbumTypeID
	from photo a, photoAlbum b
	where a.photoAlbumID = b.photoAlbumID
);

-- 商户流水日志
drop view if exists supplierAmount_V;
create view supplierAmount_V as (
	select a.*, s.name from supplierAmountLog a, supplier s where a.supplierID = s.supplierID
);

-- 商户流水统计
drop view if exists supplierAmountReport_V;
create view supplierAmountReport_V as (
	select "addTime" as addTime, "supplierID" as supplierID, "amountIn" as amountIn, "amountOut" as amountOut, "name" as name 
);

drop table if exists c_smtpHost;
create table c_smtpHost (
	c_smtpHostID varchar(100) primary key,
	c_smtpHostName varchar(20),
	sortIndex int(11)
);
insert into c_smtpHost values('smtp.qq.com',  'QQ个人邮箱', 1);
insert into c_smtpHost values('smtp.exmail.qq.com',  'QQ企业邮箱', 2);
insert into c_smtpHost values('smtp.sina.com', '新浪邮箱', 3);
insert into c_smtpHost values('smtp.ym.163.com', '网易免费企业邮箱', 4);
insert into c_smtpHost values('smtp.qiye.163.com', '网易收费企业邮箱', 5);
insert into c_smtpHost values('smtp.mail.yahoo.com.cn', '雅虎邮箱', 6);
insert into c_smtpHost values('smtp.sohu.com', '搜狐邮箱', 7);
insert into c_smtpHost values('smtp.126.com', '126邮箱', 8);
insert into c_smtpHost values('smtp.sogou.com', '搜狗邮箱', 9);

drop view if exists orderProduct_V;
create view orderProduct_V as (
	select a.*, b.name, b.mainImage,
	b.bigTypeID,b.bigTypeName,
	b.smallTypeID,b.smallTypeName,b.tinyTypeID,
	b.tinyTypeName,
	b.supplierName,
	c.userID, c.status shopOrderStatus, c.orderTime, c.supplierID,c.sourceTypeID, c.shouHuoRen
	from orderProduct a, product_V b, shopOrder c
	where a.productID = b.productID and a.shopOrderID = c.shopOrderID
	order by orderTime desc
);

-- 商品销量统计
drop view if exists orderReport2_V;
create view orderReport2_V as (
	select "supplierID" as supplierID, "totalNum" as totalNum, "sumPrice" as sumPrice, "supplierName" as supplierName, "name" as name, "productID" productID
);

-- 店铺营销情况统计
drop view if exists orderReport3_V;
create view orderReport3_V as (
	select "supplierID" as supplierID, "countShopOrder" as countShopOrder, "countRefund" as countRefund, "supplierName" as supplierName, "countRet" as countRet
);

-- 询价单
create table if not exists inquirySheet (
	inquirySheetID int(11) primary key,
	supplierID int(11), -- 店铺ID
	userID int(11), -- 用户ID
	name varchar(30), -- 产品名称
	number decimal(12, 2), -- 产品数量
	unit varchar(5), -- 产品单位
	note varchar(1000), -- 详细说明
	image varchar(200), -- 产品图片
	linkMan varchar(20), -- 联系人
	linkMobile varchar(20), -- 联系电话
	status char(1), -- 冗余状态
	addTime varchar(19), -- 添加时间
	deletedFlag char(1) -- 是否删除
);


