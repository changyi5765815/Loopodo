drop view if exists COUNT_V;
create view COUNT_V as (
	select '1' as COUNT
);

drop view if exists SUM_V;
create view SUM_V as (
	select '1' as SUM
);

drop view if exists count_sum_V;
create view count_sum_V  as (
	select '1' as COUNT, '1' AS SUM
);

drop view if exists freeColumn_V;
create view freeColumn_V  as (
	select '1' as column1, '1' as column2, '1' as column3, '1' as column4, '1' as column5 
);

drop view if exists systemUser_V;
create view systemUser_V as (
	select a.*, b.name, b.priority
	from systemUser a, systemRole b
	where a.systemRoleID = b.systemRoleID
);

drop view if exists systemUserValid_V;
create view systemUserValid_V as (
	select a.*, b.priority
	from systemUser a, systemRole b
	where a.systemRoleID = b.systemRoleID and a.validFlag = '1' and b.validFlag = '1'
);

drop view if exists supplierSmallType_V;
create view supplierSmallType_V as (
	select a.*, b.name as supplierBigTypeName
	from supplierSmallType a, supplierBigType b
	where a.supplierBigTypeID = b.supplierBigTypeID and b.deletedFlag = 0
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

drop view if exists productRelate_V;
create view productRelate_V as (
	select a.*, b.name, b.mainImage, b.normalPrice, b.price, b.validFlag, b.deletedFlag
	from productRelate a, product b
	where a.productID2 = b.productID
);

drop view if exists groupBuy_V;
create view groupBuy_V as (
	select a.*, 
	b.name as productName, 
	b.price productPrice, 
	b.mainImage, 
	b.validFlag, 
	b.deletedFlag, 
	b.supplierName,
	b.supplierStatus,
	b.supplierAddress,
	b.supplierDeletedFlag,
	b.sampleDay, 
	b.sampleAmount
	from groupBuy a, product_V b
	where a.productID = b.productID
);

drop view if exists banner_V;
create view banner_V as (
	select a.*, b.name as productName, b.info as productInfo, b.normalPrice as productNormalPrice, b.price as productPrice, b.mainImage as productImage
	from banner a left join product b on (a.productID = b.productID)
);

drop view if exists comment_V;
create view comment_V as (
	select a.*, b.name as productName, b.mainImage, b.supplierID
	from comment a, product b
	where a.productID = b.productID order by a.commentID desc
);

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
	s.linkPhone supplierLinkPhone,
	u.nick as userNick
	from shopOrder a, c_orderStatus b, town c, city d, province e, supplier s, user u
	where a.status = b.c_orderStatusID and a.townID = c.townID and c.cityID = d.cityID and d.provinceID = e.provinceID and a.supplierID = s.supplierID and a.userID = u.userID
	order by a.shopOrderID desc
);


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

drop view if exists refund_V;
create view refund_V as (
	select a.*, b.email, b.mobile, c.transactionNum, c.payTypeID, c.useSysParaFlag, s.name as supplierName
	from refund a, user b, shopOrder c, supplier s
	where a.userID = b.userID and a.shopOrderID = c.shopOrderID and a.supplierID = s.supplierID
	order by a.refundID desc
);

drop view if exists card_V;
create view card_V as (
	select a.*, b.name as userName, b.nick as userNick,  b.sex as userSex, b.mobile as userMobile, b.email as userEmail, s.name as supplierName
	from card a left join user b on (a.userID = b.userID), supplier s  where a.supplierID = s.supplierID
	order by a.deadDate asc
);

drop view if exists collectionItem_V;
create view collectionItem_V as (
	select a.*, b.name, b.mainImage, b.normalPrice, b.price, b.validFlag, b.deletedFlag, b.needBuyNumber, b.discountRate, b.maxPrice, b.discountFlag
	from collectionItem a, product b
	where a.productID = b.productID
);

drop view if exists consultation_V;
create view consultation_V as (
	select a.*, b.name as productName, b.mainImage, b.supplierID, b.supplierName
	from consultation a, product_V b
	where a.productID = b.productID
);

drop view if exists favoriteproduct_V;
create view favoriteproduct_V as (
	select a.*, b.name, b.mainImage, b.price, b.normalPrice
	from favoriteproduct a, product b
	where a.productID = b.productID
);

drop view if exists helpPage_V;
create view helpPage_V as (
	select a.*, b.helpPageTypeName
	from helpPage a left join helpPageType b on (a.helpPageTypeID = b.helpPageTypeID)
	order by b.helpPageTypeID asc, a.sortIndex, a.helpPageID
);

drop view if exists infocollectionitem_V;
create view infocollectionitem_V as (
	select a.*, b.title, b.image, b.validFlag
	from infocollectionitem a, info b
	where a.infoID = b.infoID
);


drop view if exists returnGoods_V;
create view returnGoods_V as (
	select a.*, b.name as productName, b.mainImage, b.propName, b.price, c.email, c.mobile, d.transactionNum, d.payTypeID, d.useSysParaFlag, s.name as supplierName
	from returnGoods a, orderProduct_V b, user c, shopOrder d, supplier s
	where a.orderProductID = b.orderProductID and a.userID = c.userID and a.shopOrderID = d.shopOrderID and a.supplierID = s.supplierID
);

drop view if exists singlePageDetail_V;
create view singlePageDetail_V as (
	select a.*, b.content, b.contentTxt
	from singlePage a, singlePageDetail b
	where a.singlePageID = b.singlePageID
);

drop view if exists transaction_V;
create view transaction_V as (
	select a.*, b.name
	from transaction a, payType b
	where a.payTypeID = b.payTypeID
	order by transactionID desc
);

drop view if exists userMoneyHistory_V;
create view userMoneyHistory_V as (
	select a.*, b.c_userMoneyHistoryTypeName as userMoneyHistoryTypeName, s.name as supplierName
	from userMoneyHistory a, c_userMoneyHistoryType b, supplier s
	where a.userMoneyHistoryTypeID = b.c_userMoneyHistoryTypeID and a.shopID = s.supplierID 
);

drop view if exists userRegister_Sum_V;
create view userRegister_Sum_V as (
	select '1' as userRegisterCount, '1' as registerTime
);

drop view if exists orderReport_V;
create view orderReport_V as (
	select "orderTime" as orderTime, "totalOrderNum" as totalOrderNum, "status1Num" as status1Num, "status2Num" as status2Num, 
	"status3Num" as status3Num, "status4Num" as status4Num, "status5Num" as status5Num,
	"status6Num" as status6Num, "status7Num" as status7Num, 
	"status8Num" as status8Num,
	"sumPrice" as sumPrice
);

drop view if exists followSupplier_V;
create view followSupplier_V as (
	select a.*, b.name, b.logo, b.qqNums, b.status, b.deletedFlag
	from followSupplier a, supplier b
	where a.supplierID = b.supplierID
);

drop view if exists supplierCollectionItem_V;
create view supplierCollectionItem_V as (
	select 
	a.supplierCollectionItemID, 
	a.supplierCollectionID, 
	a.sortIndex , 
	a.image as collectionImage , 
	a.wapImage as collectionWapImage , 
	a.bannerLink, 
	a.wapBannerLink,
	a.supplierID,
	b.productID,
	b.mainImage,
	b.name,
	b.price,
	b.maxPrice,
	b.sellNumber,
	c.supplierCollectionsTypeID
	from supplierCollectionItem a left join product_V b on( a.productID = b.productID), supplierCollection c
	where a.supplierCollectionID = c.supplierCollectionID
);

drop view if exists supplierCash_V;
create view supplierCash_V as (
	select a.*, b.name as supplierName, b.linkMan as supplierLinkMan, b.linkPhone as supplierLinkPhone, b.linkEmail as supplierLinkEmail
	from supplierCash a, supplier b 
	where a.supplierID = b.supplierID
);

drop view if exists orderProduct_report_V;
create view orderProduct_report_V as (
	select a.*, b.name, b.supplierID, b.mainImage, b.bigTypeID, b.bigTypeName, b.smallTypeID, b.smallTypeName, b.tinyTypeID, b.tinyTypeName, 
	b.stock, c.userID, c.status shopOrderStatus, c.orderTime, c.shopID, c.sourceTypeID
	from orderProduct a, product_V b, shopOrder c
	where a.productID = b.productID and a.shopOrderID = c.shopOrderID
	order by orderTime desc
);


drop view if exists sampleProduct_V;
create view sampleProduct_V as (
	select a.*, b.name as productName, b.mainImage, b.feeTemplateID, b.unit, b.price as productPrice, b.maxPrice as productMaxPrice
	from sampleProduct a, product b
	where a.productID = b.productID
);

drop view if exists shopUser_V;
create view shopUser_V as (
	select a.*, b.*, c.name as shopUserLevelName, s.name as supplierName
	from shopUser a left join shopUserLevel c on (a.shopUserLevelID = c.systemLevelID and a.shopID = c.shopID), user b, supplier s
	where a.shopUserID = b.userID and  a.shopID = s.supplierID and b.deletedFlag = 0 
);

drop view if exists info_V;
create view info_V as (
	select a.*, b.name as infoTypeName, c.name as supplierName, d.name as infoDirectoryName
	from info a left join infoDirectory d on(a.infoDirectoryID = d.infoDirectoryID), infoType b, supplier c
	where a.infoTypeID = b.infoTypeID and c.supplierID = a.supplierID 
);

drop view if exists promotionActive_V;
create view promotionActive_V as (
	select a.*, b.name as supplierName 
	from promotionActive a, supplier b 
	where a.supplierID=b.supplierID
);

drop view if exists infoDetail_V;
create view infoDetail_V as (
	select a.*, b.content, b.contentTxt
	from info_V a, infoDetail b
	where a.infoID = b.infoID
);

drop view if exists info_Valid;
create view info_Valid as (
	select a.*, b.name as infoTypeName, c.name as infoDirectoryName
	from info a, infoType b, infoDirectory c
	where a.infoTypeID = b.infoTypeID and a.auditStatus = 20 and a.validFlag = 1 and a.deletedFlag = 0 
	and b.validFlag = 1 and b.deletedFlag = 0 and c.validFlag = 1 and c.deletedFlag = 0
);

-- 相册图片视图
drop view if exists photo_V;
create view photo_V as (
	select a.*, b.name as photoAlbumName, b.photoAlbumTypeID
	from photo a, photoAlbum b
	where a.photoAlbumID = b.photoAlbumID
);

-- 采购单项
drop view if exists purchaseItem_V;
create view purchaseItem_V as (
	select a.*, 
	t.name as tinyTypeName, 
	s.smallTypeID, 
	s.name as smallTypeName, 
	b.bigTypeID, 
	b.name as bigTypeName
	from purchaseItem a, tinyType t, smallType s, bigType b
	where a.tinyTypeID = t.tinyTypeID and t.smallTypeID = s.smallTypeID and s.bigTypeID = b.bigTypeID
);

-- 采购单视图
drop view if exists purchase_V;
create view purchase_V as (
	select a.*, 
	b.companyName, 
	b.mainImage, 
	b.townID as userTownID, 
	b.userTypeID, 
	b.famousFlag, 
	b.famousSortIndex,
	c.cityID,
	p.provinceID
	from purchase a, user b, town t, city c, province p
	where a.userID = b.userID and a.townID = t.townID and t.cityID = c.cityID and c.provinceID = p.provinceID
);

drop view if exists infoComment_V;
create view infoComment_V as (
	select a.*, b.companyName, b.mainImage, b.townID as userTownID, b.userTypeID, b.famousFlag, b.famousSortIndex, b.nick, s.name as supplierName, i.title
	from infoComment a, user b, supplier s, info i
	where a.userID = b.userID and a.supplierID = s.supplierID and a.infoID = i.infoID
);

drop view if exists productNotify_V;
create view productNotify_V as (
	select a.*, b.name, b.stock
	from productNotify a, product b
	where a.productID = b.productID
);

drop view if exists discountLog_V;
create view discountLog_V as (
	select a.*, 
	b.name as supplierName
	from discountLog a, supplier b
	where a.supplierID = b.supplierID
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