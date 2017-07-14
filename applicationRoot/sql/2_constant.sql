-- 用户类型表
drop table if exists c_userType;
create table c_userType (
	c_userTypeID int(11) primary key,
	c_userTypeName varchar(20)
);
insert into c_userType values(1, '普通用户');
insert into c_userType values(2, '企业用户');

-- 用户等级表
drop table if exists c_userLevel;
create table c_userLevel (
	c_userLevelID int(11) primary key,
	c_userLevelName varchar(20)
);
insert into c_userLevel values(1, '铜牌会员');
insert into c_userLevel values(2, '银牌会员');
insert into c_userLevel values(3, '金牌会员');
insert into c_userLevel values(4, '白金会员');
insert into c_userLevel values(5, '钻石会员');

-- 第三方平台
drop table if exists c_platType;
create table c_platType (
	c_platTypeID int(11) primary key,
	c_platTypeName varchar(20)
);
insert into c_platType values(10, '新浪微博');
insert into c_platType values(20, 'QQ');
insert into c_platType values(30, '支付宝');
insert into c_platType values (40, '微信');

-- 用户来源
drop table if exists c_userSourceType;
create table c_userSourceType (
	c_userSourceTypeID int(11) primary key,
	c_userSourceTypeName varchar(20)
);
insert into c_userSourceType values(1, 'PC端');
insert into c_userSourceType values(2, '移动端');

insert into c_bigSystemmodule values (6, '商品管理');
insert into c_bigSystemmodule values (8, '会员管理');

insert into c_systemModule values (81, 8, 'user', '会员管理', '0');
insert into c_systemModule values (232, 8, 'famousCompany', '名企管理', '0');
insert into c_systemModule values (231, 8, 'groupCompany', '集团客户管理', '0');

insert into sysConfig values ('level1DiscountRate', '', '铜牌会员折扣率');
insert into sysConfig values ('level2DiscountRate', '', '银牌会员折扣率');
insert into sysConfig values ('level3DiscountRate', '', '金牌会员折扣率');
insert into sysConfig values ('level4DiscountRate', '', '白金会员折扣率');
insert into sysConfig values ('level5DiscountRate', '', '钻石会员折扣率');

insert into c_systemModule values (61, 6, 'product', '商品信息管理', '0');

-- 标签
drop table if exists c_productTag;
create table c_productTag (
	c_productTagID int(11) primary key,
	c_productTagName varchar(20)
);
insert into c_productTag values(1,'新品');
insert into c_productTag values(2,'推荐');
insert into c_productTag values(3,'特价');
insert into c_productTag values(4,'爆款');
insert into c_productTag values(5,'热卖');

insert into c_systemModule values (62, 6, 'collection', '商品专区管理', '0');
insert into c_systemModule values (63, 6, 'brand', '品牌管理', '0');
insert into c_systemModule values (64, 6, 'supplier', '供应商管理', '0');

insert into c_bigSystemmodule values (13, '订单管理');

insert into c_systemModule values (131, 13, 'allShopOrder', '全部订单', '0');
insert into c_systemModule values (132, 13, 'dfkShopOrder', '待付款', '0');
insert into c_systemModule values (133, 13, 'dshShopOrder', '待审核', '0');
insert into c_systemModule values (134, 13, 'dphShopOrder', '待配货', '0');
insert into c_systemModule values (136, 13, 'dfhShopOrder', '待发货', '0');
insert into c_systemModule values (137, 13, 'fhzShopOrder', '发货中', '0');
insert into c_systemModule values (138, 13, 'ywcShopOrder', '已完成', '0');
insert into c_systemModule values (139, 13, 'ygbShopOrder', '已关闭', '0');
insert into c_systemModule values (140, 13, 'ycShopOrder', '异常订单', '0');
insert into c_systemModule values (141, 13, 'transaction', '付款记录', '0');
insert into c_systemModule values (142, 13, 'refund', '退款管理', '0');
insert into c_systemModule values (143, 13, 'returnGoods', '退货管理', '0');


alter table orderProduct add rebatePercent1 decimal(12,2);
alter table orderProduct add rebatePercent2 decimal(12,2);
alter table orderProduct add rebatePercent3 decimal(12,2);

insert into c_bigSystemmodule values (15, '用户帮助');
insert into c_systemModule values (151, 15, 'helpPage', '帮助页管理', '0');


insert into c_bigSystemmodule values (16, '促销管理');
insert into c_systemModule values (161, 16, 'promotionActive', '全站促销', '0');
insert into c_systemModule values (162, 16, 'discount', '折扣特价', '0');
insert into c_systemModule values (163, 16, 'groupBuy', '团购秒杀', '0');
insert into c_systemModule values (164, 16, 'card', '优惠券管理', '0');

insert into c_bigSystemmodule values (18, '内容管理');
insert into c_systemModule values (181, 18, 'normalSinglePage', '普通单页', '0');
insert into c_systemModule values (182, 18, 'promotionSinglePage', '促销活动页', '0');
insert into c_systemModule values (183, 18, 'article', '文章管理', '0');
insert into c_systemModule values (184, 18, 'articleArea', '文章专区管理', '0');
insert into c_systemModule values (185, 18, 'communityPlate', '文章分类', '0');


insert into c_bigSystemmodule values (19, '客服管理');
insert into c_systemModule values (191, 19, 'productComment', '商品评论管理', '0');
insert into c_systemModule values (192, 19, 'productInformation', '商品咨询管理', '0');

insert into c_bigSystemmodule values (20, '库存管理');
insert into c_systemModule values (201, 20, 'stockMaintenance', '库存维护', '0');
insert into c_systemModule values (202, 20, 'storage', '入库管理', '0');
insert into c_systemModule values (203, 20, 'stockOut', '出库管理', '0');


insert into c_bigSystemmodule values (21, '微信公众号');
insert into c_systemModule values (211, 21, 'wechatIntegrate', '微信公众号集成账号', '0');
insert into c_systemModule values (212, 21, 'wechatMenu', '微信公众号菜单', '0');


insert into sysConfig values ('deliveryFromCompany', '', '发货公司');
insert into sysConfig values ('deliveryFromAddress', '', '发货地址');
insert into sysConfig values ('deliveryFromPerson', '', '发货人');
insert into sysConfig values ('deliveryFromPhone', '', '发货联系电话');
insert into sysConfig values ('deliveryFromPostal', '', '发货邮编');
insert into sysConfig values ('weixinAppID', '', 'weixinAppID');
insert into sysConfig values ('weixinAppSecret', '', 'weixinAppSecret');


insert into c_logisticsCompany values('1','顺丰速运','shunfeng');
insert into c_logisticsCompany values('2','中通快递','zhongtong');
insert into c_logisticsCompany values('3','申通快递','shentong');
insert into c_logisticsCompany values('4','圆通快递','yuantong');
insert into c_logisticsCompany values('5','韵达物流','yunda');
insert into c_logisticsCompany values('6','全峰快递','test');
insert into c_logisticsCompany values('7','EMS','test');
insert into c_logisticsCompany values('8','天天快递','tiantian');
insert into c_logisticsCompany values('99','其他','test');


insert into c_systemModule values (27, 1, 'deliveryFee', '运费设置', '0');
insert into c_systemModule values (28, 1, 'appInfo', 'APP管理', '0');


alter table banner add color varchar(20);

insert into c_systemModule values (186, 18, 'helpPageType', '帮助页分组', '0');
insert into sysConfig values ('websiteName', '', '网站名');

insert into c_systemModule values (71, 7, 'userRegisterReport', '会员注册统计', '0');
insert into c_systemModule values (72, 7, 'orderReport', '订单统计', '0');


-- 供应商状态表
drop table if exists c_supplierStatus;
create table c_supplierStatus (
	c_supplierStatusID int(11) primary key,
	c_supplierStatusName varchar(10)
);
insert into c_supplierStatus values(10, '待审核');
insert into c_supplierStatus values(20, '已上线');
insert into c_supplierStatus values(30, '已下线');
insert into c_supplierStatus values(90, '审核不通过');

-- 商品审核状态表
drop table if exists c_productAuditStatus;
create table c_productAuditStatus (
	c_productAuditStatusID int(11) primary key,
	c_productAuditStatusName varchar(10)
);
insert into c_productAuditStatus values(10, '待审核');
insert into c_productAuditStatus values(20, '审核通过');
insert into c_productAuditStatus values(90, '审核不通过');

-- 广告图片
drop table if exists c_bannerGroup;
create table c_bannerGroup (
	c_bannerGroupID int(11) primary key,
	c_bannerGroupName varchar(20),
	link varchar(200)
	
);

INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('10', '首页轮播图', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('11', '首页广告图', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('12', '首页限时秒杀', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('13', '首页推荐特区', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('14', '首页热销商品', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('15', '首页热销品牌背景', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('16', '首页热销品牌LOGO', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('17', '日用套装1', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('18', '日用套装2', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('19', '日用套装3', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('20', '日用套装4', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('21', '首页保障服务', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('22', '装修服务', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('23', '陶瓷小知识', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('24', '推荐商品页轮播图', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('25', '推荐商品页广告', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('26', '采购信息页轮播图', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES(27, '首页广告图（自适应）', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('99', '登录页广告图【1920*580】', NULL);
INSERT INTO c_bannergroup (c_bannerGroupID, c_bannerGroupName, link) VALUES ('100', '注册页广告图【320*235】', NULL);

-- 订单支付途径
create table if not exists c_payWay (
	c_payWayID int(11) primary key,
	c_payWayName varchar(20)
);

INSERT INTO c_payWay VALUES (1, '线上支付');
INSERT INTO c_payWay VALUES (80, '银行转账/汇款');
INSERT INTO c_payWay VALUES (99, '货到付款');

-- 订单类型
create table if not exists c_shopOrderType (
	c_shopOrderTypeID int(11) primary key, 
	c_shopOrderTypeName varchar(20)
);

insert into c_shopOrderType values (1, '普通订单');
insert into c_shopOrderType values (2, '团购秒杀订单');
insert into c_shopOrderType values (6, '拼团订单');

create table if not exists c_supplierBannerGroup (
	c_supplierBannerGroupID int(11) primary key,
	c_supplierBannerGroupName varchar(20)
);
insert into c_supplierBannerGroup values (10, '轮播广告组');
insert into c_supplierBannerGroup values (20, '手机端顶部广告图');


-- 供应商金额记录类型
create table if not exists c_supplierAmountLogType (
	c_supplierAmountLogTypeID int (11) primary key,
	c_supplierAmountLogTypeName varchar(20)
);
insert into c_supplierAmountLogType values (10, '订单收入');
insert into c_supplierAmountLogType values (20, '提现支出');


-- 订单操作记录类型
create table if not exists c_orderOptLogType (
	c_orderOptLogTypeID int(11) primary key, -- 主键ID
	c_orderOptLogTypeName varchar(20) -- 操作名称
);

insert into c_orderOptLogType values (1, '修改价格'); -- 在note里记录修改前的价格和修改后的价格
insert into c_orderOptLogType values (2, '置已付款');
insert into c_orderOptLogType values (3, '审核'); -- note里记录审核备注
insert into c_orderOptLogType values (4, '配货完成');
insert into c_orderOptLogType values (5, '发货');
insert into c_orderOptLogType values (6, '已提货');
insert into c_orderOptLogType values (7, '已收货');
insert into c_orderOptLogType values (8, '置为异常订单');
insert into c_orderOptLogType values (9, '删除');



-- 运费模板计价方式
drop table if exists c_feeTemplateType;
create table c_feeTemplateType (
	c_feeTemplateTypeID int(11) primary key,
	c_feeTemplateTypeName varchar(20)
);
insert into c_feeTemplateType values (10, '件数');
insert into c_feeTemplateType values (20, '重量');
insert into c_feeTemplateType values (30, '体积');

drop table if exists c_feeTemplateDeliveryMode;
create table c_feeTemplateDeliveryMode (
	c_feeTemplateDeliveryModeID int(11) primary key,
	c_feeTemplateDeliveryModeName varchar(20)
);
insert into c_feeTemplateDeliveryMode values (10, '快递');
insert into c_feeTemplateDeliveryMode values (20, 'EMS');
insert into c_feeTemplateDeliveryMode values (30, '平邮');

drop table if exists c_feeTemplateDeliveryTime;
create table c_feeTemplateDeliveryTime (
	c_feeTemplateDeliveryTimeID int(11) primary key,
	c_feeTemplateDeliveryTimeName varchar(20)
);
insert into c_feeTemplateDeliveryTime values (10, '4小时内');
insert into c_feeTemplateDeliveryTime values (20, '8小时内');
insert into c_feeTemplateDeliveryTime values (30, '12小时内');
insert into c_feeTemplateDeliveryTime values (40, '16小时内');
insert into c_feeTemplateDeliveryTime values (50, '20小时内');
insert into c_feeTemplateDeliveryTime values (60, '1天内');
insert into c_feeTemplateDeliveryTime values (70, '2天内');
insert into c_feeTemplateDeliveryTime values (80, '3天内');
insert into c_feeTemplateDeliveryTime values (90, '4天内');
insert into c_feeTemplateDeliveryTime values (100, '5天内');
insert into c_feeTemplateDeliveryTime values (110, '6天内');
insert into c_feeTemplateDeliveryTime values (120, '7天内');
insert into c_feeTemplateDeliveryTime values (130, '8天内');
insert into c_feeTemplateDeliveryTime values (140, '9天内');
insert into c_feeTemplateDeliveryTime values (150, '10天内');
insert into c_feeTemplateDeliveryTime values (160, '12天内');
insert into c_feeTemplateDeliveryTime values (170, '15天内');
insert into c_feeTemplateDeliveryTime values (180, '17天内');
insert into c_feeTemplateDeliveryTime values (190, '20天内');
insert into c_feeTemplateDeliveryTime values (200, '25天内');
insert into c_feeTemplateDeliveryTime values (210, '30天内');
insert into c_feeTemplateDeliveryTime values (220, '35天内');
insert into c_feeTemplateDeliveryTime values (230, '45天内');


drop table if exists c_auditLogType;
create table c_auditLogType (
	c_auditLogTypeID int(11) primary key,
	c_auditLogTypeName varchar(50)
);
insert into c_auditLogType values(1, '商品审核');
insert into c_auditLogType values(2, '折扣特价审核');
insert into c_auditLogType values(3, '团购审核');


drop table if exists c_sampleProductType;
create table c_sampleProductType (
	c_sampleProductTypeID int(11) primary key,
	c_sampleProductTypeName varchar(10)
);
insert into c_sampleProductType values(1, '现货');
insert into c_sampleProductType values(2, '预售');



-- 公司部门
drop table if exists c_companyDepartment;
create table c_companyDepartment (
	c_companyDepartmentID int(11) primary key,
	c_companyDepartmentName varchar(10)
);
insert into c_companyDepartment values(1, '办公室');
insert into c_companyDepartment values(2, '市场部');
insert into c_companyDepartment values(3, '采购部');
insert into c_companyDepartment values(4, '技术部');
insert into c_companyDepartment values(5, '人力资源部');
insert into c_companyDepartment values(9, '其他');

-- 公司规模
drop table if exists c_companyScale;
create table c_companyScale (
	c_companyScaleID int(11) primary key,
	c_companyScaleName varchar(20)
);
insert into c_companyScale values('1', '1-49');
insert into c_companyScale values('2', '50-99');
insert into c_companyScale values('3', '100-499');
insert into c_companyScale values('4', '500-999');
insert into c_companyScale values('5', '1000以上');

-- 公司行业
drop table if exists c_companyIndustry;
create table c_companyIndustry (
	c_companyIndustryID int(11) primary key,
	c_companyIndustryName varchar(50)
);
insert into c_companyIndustry values('1', '计算机硬件及网络设备');
insert into c_companyIndustry values('2', '计算机软件');
insert into c_companyIndustry values('3', 'IT服务（系统/数据/维护）/多领域经营');
insert into c_companyIndustry values('4', '互联网/电子商务');
insert into c_companyIndustry values('5', '网络游戏');
insert into c_companyIndustry values('6', '通讯（设备/运营/增值服务）');
insert into c_companyIndustry values('7', '电子技术/半导体/集成电路');
insert into c_companyIndustry values('8', '仪器仪表及工业自动化');
insert into c_companyIndustry values('9', '金融/银行/投资/基金/证券');
insert into c_companyIndustry values('10', '保险');
insert into c_companyIndustry values('11', '房地产/建筑/建材/工程');
insert into c_companyIndustry values('12', '家居/室内设计/装饰装潢');
insert into c_companyIndustry values('13', '物业管理/商业中心');
insert into c_companyIndustry values('14', '广告/会展/公关/市场推广');
insert into c_companyIndustry values('15', '媒体/出版/影视/文化/艺术');
insert into c_companyIndustry values('16', '印刷/包装/造纸');
insert into c_companyIndustry values('17', '咨询/管理产业/法律/财会');
insert into c_companyIndustry values('18', '教育/培训');
insert into c_companyIndustry values('19', '检验/检测/认证');
insert into c_companyIndustry values('20', '中介服务');
insert into c_companyIndustry values('21', '贸易/进出口');
insert into c_companyIndustry values('22', '零售/批发');
insert into c_companyIndustry values('23', '快速消费品（食品/饮料/烟酒/化妆品');
insert into c_companyIndustry values('24', '耐用消费品（服装服饰/纺织/皮革/家具/家电）');
insert into c_companyIndustry values('25', '办公用品及设备');
insert into c_companyIndustry values('26', '礼品/玩具/工艺美术/收藏品');
insert into c_companyIndustry values('27', '大型设备/机电设备/重工业');
insert into c_companyIndustry values('28', '加工制造（原料加工/模具）');
insert into c_companyIndustry values('29', '汽车/摩托车（制造/维护/配件/销售/服务）');
insert into c_companyIndustry values('30', '交通/运输/物流');
insert into c_companyIndustry values('31', '医药/生物工程');
insert into c_companyIndustry values('32', '医疗/护理/美容/保健');
insert into c_companyIndustry values('33', '医疗设备/器械');
insert into c_companyIndustry values('34', '酒店/餐饮');
insert into c_companyIndustry values('35', '娱乐/体育/休闲');
insert into c_companyIndustry values('36', '旅游/度假');
insert into c_companyIndustry values('37', '石油/石化/化工');
insert into c_companyIndustry values('38', '能源/矿产/采掘/冶炼');
insert into c_companyIndustry values('39', '电气/电力/水利');
insert into c_companyIndustry values('40', '航空/航天');
insert into c_companyIndustry values('41', '学术/科研');
insert into c_companyIndustry values('42', '政府/公共事业/非盈利机构');
insert into c_companyIndustry values('43', '环保');
insert into c_companyIndustry values('44', '农/林/牧/渔');
insert into c_companyIndustry values('45', '跨领域经营');
insert into c_companyIndustry values('46', '其它');

-- 公司性质
drop table if exists c_companyNature;
create table c_companyNature (
	c_companyNatureID int(11) primary key,
	c_companyNatureName varchar(20)
);
insert into c_companyNature values('1', '政府机关/事业单位');
insert into c_companyNature values('2', '国营');
insert into c_companyNature values('3', '私营');
insert into c_companyNature values('4', '中外合资');
insert into c_companyNature values('5', '外资');
insert into c_companyNature values('6', '其他');

insert into sysConfig values('indexType', '', '首页促销公告分类');
insert into sysConfig values('serviceEmail', '', '平台方客服电子邮件');
insert into sysConfig values('serviceTownID', '', '平台所在地区');
insert into sysConfig values('serviceAddress', '', '平台详细地址');
insert into sysConfig values('serviceQrCode', '', '商城微信二维码');
insert into sysConfig values('serviceWeiBolink', '', '商城微博链接');

-- 商户标签
drop table if exists c_supplierTag;
create table c_supplierTag (
	c_supplierTagID int(11) primary key,
	c_supplierTagName varchar(10),
	c_supplierTagInfo varchar(10),
	c_supplierTagIcon varchar(200)
);
insert into c_supplierTag values(10, '诚信', '诚信通会员', 'cheng.png');
insert into c_supplierTag values(11, '保', '品质保障', 'bao.png');
insert into c_supplierTag values(12, '赔', '假一赔十', 'pei.png');


-- 商户首页类型
create table if not exists c_supplierCollectionsType(
	c_supplierCollectionsTypeID int(11) primary key,
	name varchar(20)
);
insert into c_supplierCollectionsType values(1, '轮播');
insert into c_supplierCollectionsType values(2, '推荐');
insert into c_supplierCollectionsType values(3, '广告');
insert into c_supplierCollectionsType values(4, '商品');
insert into c_supplierCollectionsType values(5, '自定义页面');


create table if not exists c_supplierNavigateType (
	c_supplierNavigateTypeID int(11) primary key,
	c_supplierNavigateTypeName varchar(50),
	validFlag char(1),
	sortIndex int(11)
);
insert into c_supplierNavigateType values (1, '全部商品', '1', 1);
insert into c_supplierNavigateType values (2, '公司简介', '1', 2);
insert into c_supplierNavigateType values (3, '公司相册', '1', 3);
insert into c_supplierNavigateType values (4, '公司动态', '1', 4);

create table if not exists c_imageWaterMark (
	c_imageWaterMarkID int(11) primary key,
	c_imageWaterMarkName varchar(20)
);

insert into c_imageWaterMark values (0, '无水印');
insert into c_imageWaterMark values (1, '左上水印');
insert into c_imageWaterMark values (2, '左下水印');
insert into c_imageWaterMark values (3, '右上水印');
insert into c_imageWaterMark values (4, '右下水印');
insert into c_imageWaterMark values (5, '居中水印');

-- 留言管理类型
create table if not exists c_questionFeedBackLogType(
	c_questionFeedBackLogTypeID int(11) primary key,
	c_questionFeedBackLogTypeName varchar(50)
);

insert into c_questionFeedBackLogType values(1, '有错别字');
insert into c_questionFeedBackLogType values(2, '链接失效');
insert into c_questionFeedBackLogType values(3, '发货太慢');
insert into c_questionFeedBackLogType values(4, '文字太小');
insert into c_questionFeedBackLogType values(5, '支付失败');
insert into c_questionFeedBackLogType values(6, '无法下单');
insert into c_questionFeedBackLogType values(7, '搜不到商品');
insert into c_questionFeedBackLogType values(8, '页面打开慢');
insert into c_questionFeedBackLogType values(9, '免邮门槛高');
insert into c_questionFeedBackLogType values(99, '其他问题');

insert into c_systemModule values (217, 10, 'purchaseManager', '供需管理', '0');
insert into c_systemModule values (218, 10, 'question', '意见反馈', '0');

insert into c_systemModule values (219, 10, 'infoComment', '文章评论', '0');
insert into c_systemModule values (220, 11, 'systemUserLog', '系统操作日志', '0');
insert into c_systemModule values (221, 9, 'shopUserReport', '会员统计', '0');
insert into c_systemModule values (222, 10, 'productInformation2', '商品投诉管理', '0');
insert into c_systemModule values (223, 1, 'friendshipLink', '友情链接管理', '0');

insert into c_bigSystemModule values(12, '社区管理');

insert into c_systemModule values(224, 12, 'infoType', '分类管理', '0');
insert into c_systemModule values(225, 12, 'info', '文章管理', '0');
insert into c_systemModule values(226, 12, 'info2', '商户文章管理', '0');

-- 文章审核状态表
create table if not exists c_infoAuditType (
	c_infoAuditTypeID int(11) primary key,
	c_infoAuditTypeName varchar(20)
);

insert into c_infoAuditType values(10, '待审核');
insert into c_infoAuditType values(20, '审核通过');
insert into c_infoAuditType values(30, '审核不通过');

-- 店铺经营模式
drop table if exists c_supplierMode;
create table c_supplierMode (
	c_supplierModeID int(11) primary key,
	c_supplierModeName varchar(20)
);
insert into c_supplierMode values (1, '生产厂家');
insert into c_supplierMode values (2, '经销批发');
insert into c_supplierMode values (3, '招商代理');
insert into c_supplierMode values (4, '商业服务');

insert into commentDimension values('commentScore', '商品评分', 40);
insert into commentDimension values('serviceScore', '服务评分', 30);
insert into commentDimension values('deliveryScore', '物流评分', 30);

insert into c_systemModule values(227, 3, 'brandType', '品牌分类管理', '0');
insert into c_systemModule values (228, 1, 'appInfo', 'APP管理', '0');
insert into c_systemModule values (229, 1, 'companyIndustry', '主营行业', '0');
insert into c_systemModule values (230, 1, 'supplierLevel', '店铺等级', '0');
insert into c_systemModule values (233, 1, 'supplierTheme', '商户首页模板管理', '0');
insert into c_systemModule values (234, 1, 'shopReputation', '店铺信誉管理', '0');
insert into c_systemModule values (235, 7, 'supplierAmountReport', '商户交易统计', '0');

insert into collection value(1, '猜你喜欢', null);

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

insert into c_suppliernavigatetype values(5,'公司全景',1,5);
insert into c_suppliernavigatetype values(6,'订购说明',1,6);
insert into c_suppliernavigatetype values(7,'在线询价',1,7);
insert into c_suppliernavigatetype values(8,'接单动态',1,8);