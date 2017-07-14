create table if not exists indexNumbers(
	TABLENAME varchar(50),
	INDEXNUMBER int(11) not null,
	primary key(tableName)
);	

-- 用户角色
create table if not exists systemRole (
	systemRoleID int(11) primary key, -- 主键ID
	name varchar(50), -- 名称
	priority varchar(1000), -- 权限字符串
	validFlag char(1) -- 是否有效
);

-- 系统用户
create table if not exists systemUser (
	systemUserID int(11) primary key, -- 主键ID
    userID varchar(20),
    userName varchar(50), -- 名称
    password varchar(50), -- 密码
	systemRoleID int(11), -- 角色ID
	validFlag char(1) -- 是否有效
);

-- 省份
create table if not exists province (
	provinceID int(11) primary key, -- 主键ID
	name varchar(20), -- 名称
	validFlag char(1) -- 是否有效
);
-- 城市
create table if not exists city (
	cityID int(11) primary key,
	provinceID int(11), -- 省份ID
	name varchar(20), -- 名称
	validFlag char(1) -- 是否有效
);
-- 县镇
create table if not exists town (
	townID int(11) primary key, -- 主键ID
	cityID int(11), -- 城市ID
	name varchar(20), -- 名称
	zip varchar(10), -- 邮编
	telZip varchar(10), -- 电话区号
	validFlag char(1) -- 是否有效
);


-- 商品大分类
create table if not exists bigType (
	bigTypeID int(11) primary key, -- 主键ID
	name varchar(20), -- 名称
	validFlag char(1) -- 是否有效
);

-- 商品小分类
create table if not exists smallType (
	smallTypeID int(11) primary key, -- 主键ID
	bigTypeID int(11),
	name varchar(20), -- 名称
	validFlag char(1) -- 是否有效
);

-- 商品细分类
create table if not exists tinyType (
	tinyTypeID int(11) primary key, -- 主键ID
	smallTypeID int(11),
	name varchar(20), -- 名称
	validFlag char(1) -- 是否有效
);

-- 商户自定义大分类
create table if not exists supplierBigType (
	supplierBigTypeID int(11) primary key,
	supplierID int(11),
	name varchar(20),
	sortIndex int(11) default 999999,
	validFlag char(1) default 1,
	deletedFlag char(1) default 0,
	index index_supplierID (supplierID)
);

-- 商户自定义小分类
create table if not exists supplierSmallType (
	supplierSmallTypeID int(11) primary key,
	supplierBigTypeID int(11),
	supplierID int(11),
	name varchar(20),
	sortIndex int(11) default 999999,
	validFlag char(1) default 1,
	deletedFlag char(1) default 0,
	index index_supplierID (supplierID),
	index index_supplierBigTypeID (supplierBigTypeID)
);

-- 商品属性
create table if not exists properties (
  propertiesID int(11) primary key,
  bigTypeID int(11),
  smallTypeID int(11),
  tinyTypeID int(11),
  name varchar(50),
  propTypeID int(11), -- 1:单选; 2:多选; 3:手动输入;
  alias varchar(50),
  sortIndex int(11),
  salePropFlag char(1), -- 0:否; 1:是;
  searchPropFlag char(1), -- 0:否; 1:是;
  validFlag char(1)
);

-- 商品属性值
create table if not exists propertiesValue (
  propertiesValueID int(11) primary key,
  propertiesID int(11),
  sortIndex int(11),
  name varchar(50),
  validFlag char(1)
);

-- 销售属性
create table if not exists skuProp (
	skuPropID int(11) primary key,
	name varchar(20), -- 属性名称
	allowImageFlag char(1), -- 是否允许上传图片
	sortIndex int(11),
	validFlag char(1)
);

-- 销售属性值表
create table if not exists skuPropValue (
	skuPropValueID int(11) primary key,
	skuPropID int(11),
	name varchar(20), -- 属性值名称
	sortIndex int(11),
	validFlag char(1)
);


create table if not exists user (
	userID int(11) primary key,-- 用户ID
	userTypeID int(11), -- 用户累心，参见c_userType表
	email varchar(50), -- 注册邮箱
	mobile varchar(20), -- 注册手机号
	userName varchar(20), -- 注册用户名
	nick varchar(50), -- 用户昵称
	password varchar(50), -- 用户密码（MD5加密）
	levelID int(11), -- 用户等级，参见c_userLevel
	registerTime varchar(19),  -- 注册时间
	registerIP varchar(20), -- 注册IP
	loginTime varchar(19), -- 最近一次登录时间
	loginIP varchar(20), -- 最近一次登录IP
	emailCheckFlag char(1), -- 邮箱是否通过验证
	mobileCheckFlag char(1), -- 手机是否通过验证
	name varchar(50), -- 真实姓名
	sex char(1), -- 性别   1 男  2 女  3 保密
	mainImage varchar(100), -- 用户头像
	phone varchar(20), -- 固定电话
	townID int(11), -- 用户所在地
	address varchar(100), -- 用户详细地址
	postalCode varchar(10), -- 用户邮编
	birthday varchar(10), -- 用户生日
	companyContactName varchar(20), -- 企业联系人
	companyContactPhone varchar(20), -- 企业联系联系人固定电话
	companyContactMobile varchar(20), -- 企业联系人手机号
	companyContactEmail varchar(50), -- 企业联系人邮箱
	companyName varchar(50), -- 公司名称
	companyTownID int(11), -- 公司所在地
	companyAddress varchar(100), -- 公司所在地详细地址
	companySite varchar(100), -- 公司网站
	companyDepartmentID int(11), -- 所属部门
	companyScaleID int(11), -- 公司规模
	companyIndustryID int(11), -- 公司所属行业
	companyNatureID int(11), -- 公司性质
	businessLicenseImage  varchar(100), -- 营业执照
	idCardImage1 varchar(200), -- 执法人身份证复印件正面
	idCardImage2 varchar(200), -- 执法人身份证复印件反面
	userMoney decimal(12,2), -- 用户账户余额
	autoLoginCode varchar(100), -- 自动登录Code
	autoLoginDeadDate varchar(10), -- 自动登录code失效日期
	point int(11), -- 用户可用积分
	historyPoint int(11), -- 用户历史总积分
	androidID varchar(50), -- 
	iosID varchar(50),         
	unionid varchar(50),         
	platTypeID int(11), -- 第三方登录平台ID，参见c_platType表
	orderCount int(11), -- 订单总数
	payOrderCount int(11), -- 支付订单总数
	consumeAmount decimal(12,2), -- 消费总金额
	lastShoppingTime varchar(19), -- 最后一次下单时间
	moneyCardCount int(11), -- 获得优惠券总数
	consumeCardCount int(11), -- 已使用的优惠券总数
	lastGetCardTime varchar(19), -- 最后一次获得优惠券时间
	memberCode varchar(50), -- 会员卡编号
	openID varchar(50), -- 微信openID
	parentUserID int(11), -- 上级用户ID
	sourceTypeID int(11), -- 注册来源，参见c_userSourceType
	payWayID int(11), -- 默认支付种类
	payTypeID int(11), -- 默认支付方式
	invoiceFlag char(1), -- 默认发票信息
	invoiceTypeID int(11), -- 默认发票信息
	invoiceTitle varchar(50), -- 默认发票信息
	invoiceContent varchar(200), -- 默认发票信息
	supplierID int(11),
	supplierStatus int(11),
	supplierLoginCode varchar(50),
	validFlag char(1), -- 用户状态 0 无效  1 有效
	famousFlag char(1) default 0, -- 是否是名企（只有企业用户才可以设置）
	famousSortIndex int(11) default 999999,
	groupFlag char(1) default 0, -- 是否集团客户（只有企业用户才可以设置）
	groupSortIndex int(11) default 999999,
	purchaseTotalAmount decimal(12, 2) default 0,
	purchaseTotalCount int(11) default 0,
	purchaseTotalFinishCount int(11) default 0,
	deletedFlag char(1) default 0
);


create table if not exists siteSetting (
	siteSettingID int(11) primary key,
	logo varchar(100),
	mobileLogo varchar(100),
	loginPageAD varchar(100),
	topADLink varchar(100),
	agreement text,
	mobileTopADImage varchar(100),
	topADImage varchar(100),
	seoDescription varchar(200),
	mobileTopADLink varchar(100),
	seoTitle varchar(100),
	copyRight varchar(200),
	favicon varchar(200),
	weiXinImage varchar(100),
	seoKeyword varchar(200),
	registerPageAD varchar(200),
	openZTFlag char(1)
);

create table if not exists banner (
	bannerID int(11) primary key,
	bannerGroupID int(11),
	title varchar(20),
	bannerImage varchar(200),
	productID int(11),
	link varchar(200),
	isTarget char(1),
	sortIndex int(11),
	context tex, -- 商品IDs
	content varchar(50), -- 描述
	validFlag char(1)
);

-- 退货选择物流公司
create table c_logisticsCompany (
	c_logisticsCompanyID int(11) primary Key,
	c_logisticsCompanyName varchar(20),
	c_logisticsCompanyCode varchar(20)
); 

-- app管理
create table appInfo (
	appInfoID int(11) primary key,
	name varchar(50),
	appTypeID int(11) ,
	userTypeID int(11) ,
	updateDate varchar(10),
	info varchar(500),
	downloadUrl varchar(1000),
	versionNumber int(5),
	code varchar(100),
	mandatoryFlag varchar(1)
);

-- 店铺信息表
create table if not exists supplier (
	supplierID int(11) primary key,
	name varchar(20),
	supplierLevelID int(11), -- 供应商等级
	linkMan varchar(50),
	linkPhone varchar(50),
	address varchar(300),
	postalCode varchar(10),
	validFlag char(1) default 1,
	userID int(11),
	logo varchar(100),
	townID int(11),
	businessLicenseImage  varchar(100),
	level int(11),
	applyTime varchar(19),
	auditFlag char(1) ,
	auditTime varchar(19),
	auditNote varchar(100),
	normalFlag char(1) ,
	linkEmail varchar(50),
	sortIndex int(11) default 999999,
	deletedFlag char(1) default 0,
	status int(11),
	qqNums varchar(100),
	mobileLogo varchar(100),
	info varchar(500),
	firstChar char(1),
	lockAmount decimal(12,2), -- 锁定金额 （已付款，但未完成的订单金额会累加到该字段）
	canCashAmount decimal(12,2), -- 可提现金额 （已完成的订单金额会累加到该字段）
	cashingAmount decimal(12,2), -- 提现中的金额
	hasCashAmount decimal(12,2), -- 已提现金额
	sampleDay int(11), -- 拿样返钱有效天数
	sampleAmount decimal(12,2), -- 拿样返还金额
	bankUserName varchar(20),
	bankName varchar(30),
	bankNum varchar(30),
	notifyMobile varchar(20),
	bankBatchName varchar(100),
	receiptType char(1),
	lng double,
	lngInt bigint(32),
	lat double,
	latInt bigint(32),
	servicePhones varchar(100),
	supplierTypeID int(11),
	idCardImage1 varchar(200),
	idCardImage2 varchar(200),
	supplierModeID int(11), -- 经营模式
	industryID int(11), -- 主营行业
	supplierMainProductIDs varchar(500), -- 主营产品（分类ID）
	supplierTagIDs varchar(100),
	pcBanner varchar(200), -- 移动端店招
	wapBanner varchar(200), -- 移动端店招
	excellentFlag char(1) default 0, -- 是否优质供应商
	waterMarkImageID int(11) default 0,  -- 水印位置 参照c_imageWaterMark
	waterMarkImage varchar(200), -- 水印图片
	waterMarkImageFloat decimal(3, 1) default 0.1, -- 图片水印透明度
 	taxRegistCertificateImage varchar(200), -- 税务登记证
	OrganSCreditCode varchar(30), -- 组织机构代码或者统一社会信用代码证
	taxPayerProofImage varchar(200), -- 一般纳税人证明
	channelType char(1), -- 渠道类型 1商标注册2品牌授权3渠道
	photoCopyAuthorDocImage varchar(200), -- 授权文件影印件
	copyAuthorDocImage varchar(200), -- 授权文件复印件
	productCount int(11) default 0, -- 商品总数
	totalScore decimal(12,2) default 0, -- 总得分
	commentScore decimal(12,2) default 0, -- 商品评分
	serviceScore decimal(12,2) default 0, -- 卖家服务评分
	deliveryScore decimal(12,2) default 0, -- 发货速度评分
	commentTimes int(11) default 0, -- 评论总数
	totalScoreAvg decimal(12,2) default 0, -- 总得分平均分
	commentScoreAvg decimal(12,2) default 0, -- 商品评分平均分
	serviceScoreAvg decimal(12,2) default 0, -- 卖家服务评分平均分
	deliveryScoreAvg decimal(12,2) default 0, -- 发货速度评分平均分
	index index_userID (userID)
);

-- 公司信息表
create table if not exists supplierDetail (
	supplierID int(11) primary key, -- 主键ID
	shortName varchar(50), -- 公司简称;
	fullName varchar(100), -- 公司全称
	registerTownID int(11), -- 注册地（城镇ID）
	detailAddress varchar(100), -- 公司详细地址
	companyIndustryID int(11), -- 公司行业
	operatorName varchar(20), -- 运营者姓名
	companyPhone varchar(20), -- 公司联系电话
	companyViewShow text, -- 公司全景
	orderDescription text, -- 订购说明
	content text,
	contentTxt text,
	configJson text,
	kfScript varchar(2000)
);

create table if not exists product (
	productID          int(11) primary key, -- 商品ID
	brandID            int(11), -- 品牌ID
	tag                varchar(20) ,
	tinyTypeID         int(11), -- 细分类ID
	supplierSmallTypeID int(11), -- 自定义分类ID
	supplierID         int(11), -- 供应商ID
	name               varchar(100), -- 商品名称
	searchKey          varchar(100), -- 搜索关键字
	normalPrice        decimal(12,2), -- 市场价
	priceModeID char(1) default 1, -- 报价方式   1 按产品数量报价   2 按产品规格报价 
	price              decimal(12,2), -- 价格范文（最低价）
	maxPrice decimal (12,2), -- 价格范围（最高价）
	minBuyNumber int(11) default 0, -- 起批量
	priceDetail varchar(100), -- 梯度价格详细（json字符串，如1:10.00,5:8.00,10:7.00）
	skuImgs            varchar(1000),
	mainImage          varchar(100),
	addTime            varchar(19) ,
	sellNumber         int(11) default 0,
	weekSellNumber     int(11) default 0,
	info               varchar(100),
	productCode        varchar(50) ,
	propertiesInfo     varchar(1000),
	commentPoint       float   default 0,
	commentTimes       int(11) default 0,
	lockStock		   int(11) default 0, -- 锁定库存
	freeStock		   int(11) default 0, -- 可用库存
	stock              int(11) default 0, -- 实际库存
	favoriteTime       int(11)  default 0,
	viewCount       int(11)  default 0,
	betterScore        int(11) default 0,
	mediumScore        int(11) default 0,
	worseScore         int(11) default 0,
	feeTemplateID      int(11), -- 商品运费模板ID
	sortIndex          int(11) default 999999,
	supplierSortIndex  int(11) default 999999,
	gg                 varchar(20) ,
	unit               varchar(20) ,
	levelID				int(11), -- 产品质量星级
	weight				decimal(12,2) default 0,
	size				decimal(12,2) default 0,
	auditStatus int(11), -- 审核状态，参加c_productAuditStatus表
	discountRate             float,
	discountFlag             char(1) default 0,
	discountLogID            int(11),
	needBuyNumber int(8), -- 折扣最少购买数量
	isRecommendFlag char(1), -- 推荐标识位
	recommendReason varchar(30), -- 推荐理由
	recommendNum int(1), -- 推荐指数
	defaultSkuFlag char(1) default 1, -- 是否只有默认的sku
	validFlag          char(1) default 1,
	deletedFlag        char(1) default 0
);

create table if not exists productDetailInfo (
	productDetailInfoID  int(11) primary key,
	productID            int(11),
	detailInfo           text,
	detailInfoTxt        text,
	seoTitle             varchar(500),
	seoKeyword           varchar(500),
	seoDescription       varchar(500),
	skuPropInfo          varchar(2000),
	skuPropAlias		 varchar(200),
	skuPropValueAlias    varchar(1000),   
	skuPropValueImg      varchar(1000)
);

create table if not exists sku (
	skuID            int(11) primary key,
	productID        int(11),
	props            varchar(1000),
	normalPrice 	decimal(12,2),
	price            decimal(12,2),
	lockStock		   int(11) default 0, -- 锁定库存
	freeStock		   int(11) default 0, -- 可用库存
	stock            int(11), -- 实际库存
	validFlag        char(1),
	barCode          varchar(100),
	defaultFlag      char(1),
	skuName          varchar(100)
);

-- 商户关注
create table if not exists followSupplier (
	followSupplierID int(11) primary key,
	supplierID int(11),
	userID int(11),
	addTime varchar(19)
);


-- 商户首页广告图
create table if not exists supplierBanner (
  supplierBannerID int(11) primary key,
  supplierBannerGroupID int(11),
  supplierID int(11),
  title varchar(50),
  image varchar(200),
  link varchar(200),
  sortIndex int(11),
  validFlag char(1)
);

-- 商户首页专区
create table if not exists supplierCollection (
  supplierCollectionID int(11) primary key,
  supplierID int(11),
  supplierCollectionsTypeID int(11),
  name varchar(50),
  link varchar(300),
  image varchar(200),
  wapImage varchar(200),
  sortIndex int(11),
  content text, -- 自定义内容
  validFlag char(1)
);

-- 商户首页有专区项
create table if not exists supplierCollectionItem (
  supplierCollectionItemID int(11) primary key,
  supplierCollectionID int(11),
  supplierID int(11),
  productID int(11),
  image varchar(200), -- pc端轮播图
  wapImage varchar(200), -- wap端轮播图
  sortIndex int(11)
);

-- 供应商账户金额记录
create table if not exists supplierAmountLog (
	supplierAmountLogID int(11) primary key,
	supplierID int(11),
	supplierAmountLogTypeID int(11),
	dataID bigInt(20), 
	amount decimal(12,2),
	addTime varchar(19),
	info varchar(500)
);

-- 商户提现表
create table if not exists supplierCash(
	supplierCashID int(11) primary key,
	supplierID int(11),
	amount decimal(12,2),
	bankUserName varchar(20), -- 银行开户名
	bankBatchName varchar(100),
	bankName varchar(30), -- 银行名称
	bankNum varchar(30), -- 银行卡号
	addTime varchar(19),
	note varchar(500),
	systemUserID int(11),
    systemUserName varchar(50),
	status char(1), -- 状态 1：提现中  2：提现完成  3：失败
	finishTime varchar(19), -- 提现完成时间
	deletedFlag char(1) -- 是否删除 0：未删除 1：删除
);

-- 订单操作记录
create table if not exists orderOptLog (
	orderOptLogID int(11) primary key,
	orderOptLogTypeID int(11), -- 操作类型ID
	operatorType char(1), -- 操作平台（1：console后台管理员 2：supplier）
  	operatorID int(11), -- 操作人ID（supplierID或siteManagerUserID）
  	operatorName varchar(50), -- 操作人名称
	dataID bigint(20), -- 订单ID
	note varchar(200), -- 备注
	addTime varchar(19) -- 添加时间
);

-- 运费模板
create table if not exists feeTemplate (
	feeTemplateID int(11) primary key,
	supplierID int(11) default 0,
	name varchar(50),
	townID int(11), -- 发货地区
	feeTemplateTypeID int(11),
	feeTemplateDeliveryModeIDs varchar(20), -- 支持的配送方式
	feeTemplateDeliveryTimeID int(11), -- 发货时间
	freeFlag char(1) default 0, -- 是否包邮
	addTime varchar(19),
	updateTime varchar(19),
	sortIndex int(11) default 999999,
	validFlag char(1) default 1,
	deliveryTypeID int(11), -- 默认物流公司ID， 非必填
	note varchar(500), -- 运费说明
	deletedFlag char(1) default 0
);

create table if not exists feeTemplateItem (
	feeTemplateItemID int(11) primary key,
	feeTemplateID int(11),
	supplierID int(11) default 0,
	provinceIDs varchar(500),
	cityIDs varchar(2000),
	firstUnit decimal(12,2), -- 首件、首重、首体积
	firstPrice decimal(12,2), -- 首件、首重、首体积运费
	secondUnit decimal(12,2), -- 续件、续重、续体积
	secondPrice decimal(12,2), -- 续件、续重、续体积运费
	defaultFlag char(1) default 0, -- 是否是默认
	index index_feeTemplateID (feeTemplateID)
);

create table if not exists productLevel (
	productLevelID int(11) primary key,
	name varchar(10)
);

create table if not exists auditLog (
	auditLogID int(11) primary key,
	auditLogTypeID int(11),
	auditResult varchar(50),
	auditNote varchar(500),
	auditTime varchar(19),
	dataID varchar(50),
	systemUserID int(11),
	systemUserName varchar(50)
);

-- 样品表
create table if not exists sampleProduct (
	sampleProductID int(11) primary key,
	supplierID int(11),
	productID int(11),
	sampleProductTypeID int(11), -- 样品类型
	number int(11), -- 样品数量
	sampleProductStock int(11), -- 样品库存
	price decimal(12,2), -- 样品价格
	validFlag char(1) default 1,
	index index_supplierID (supplierID),
	index index_productID (productID)
);

-- 优惠券表
create table if not exists card (
	cardID       int(11) primary key,
	batchID int(11),
	supplierID int(11) default 0,
	cardSourceTypeID   int(11),
	title        varchar(50),
	code         varchar(16),
	money        decimal(12,2),
	minBuyPrice  decimal(12,2),
	addTime      varchar(19),
	deadDate     varchar(10),
	userID       int(11),
	sendFlag char(1) default 0,
	sendTime varchar(19),
	usedFlag     char(1) default 0,
	usedTime     varchar(19),
	relateID     int(11),
	index index_supplierID (supplierID),
	index index_userID (userID),
	index index_code (code)
);

-- 店铺会员
create table if not exists shopUser (
	shopID int(11), -- 店铺ID
	shopUserID int(11), -- 用户ID
	shopUserLevelID int(11), -- 店铺会员等级
	shopUserMoney decimal(12, 2) default 0, -- 店铺会员账户余额
	shopOrderCount int(11) default 0, -- 订单总数
	shopPayOrderCount int(11) default 0, -- 支付订单总数
	shopConsumeAmount decimal(12,2) default 0, -- 消费总金额
	shopLastShoppingTime varchar(19), -- 最后一次下单时间
	shopMoneyCardCount int(11) default 0, -- 获得优惠券总数
	shopConsumeCardCount int(11) default 0, -- 已使用的优惠券总数
	shopLastGetCardTime varchar(19), -- 最后一次获得优惠券时间
	addTime varchar(19), -- 成为店铺会员时间
	memberFlag char(1) default 0, -- 是否成为店铺会员
	auditStatus char(1) default 0, -- 是否申请会员，0未申请，1已申请审核中，2审核通过，3审核失败
	shopDeletedFlag char(1) default 0, -- 是否删除(暂时不会用到该字段)
	primary key(shopID, shopUserID) -- 复合主键
);

-- 供应商会员等级表
create table if not exists shopUserLevel(
	shopID int(11), -- 供应商ID
	systemLevelID int(11), -- 系统会员等级ID，
	systemLevelName varchar(20), -- 系统会员等级名称，不可修改
	name varchar(20), -- 商户设置的会员等级名称
	image varchar(200), -- 会员等级图标
	rate decimal(5,2), -- 供应商会员等级折扣率
	minLimitMoney decimal(12,2), -- 会员升级至该等级所需要消费最低金额
	maxLimitMoney decimal(12,2), -- 会员升级至该等级所需要消费最高金额， 不填代表以上
	addTime varchar(19), -- 新增时间
	updateTime varchar(19), -- 最近修改时间
	changeContent text, -- 修改记录
	primary key(shopID, systemLevelID)
);

-- 社区板块
create table if not exists infoType (
	infoTypeID int(11) primary key, -- 主键ID
	name varchar(20), -- 名称
	icon varchar(200), -- 图标
	supplierID int(11), -- 店铺ID
	sortIndex int(11) default 999999, -- 排序
	validFlag char(1) default 1, -- 状态
	deletedFlag char(1) default 0 -- 是否删除
);

-- 社区文章
create table if not exists info (
	infoID int(11) primary key,
	infoTypeID int(11), -- 文章分类
	infoDirectoryID int(11), -- 文章目录ID
	supplierID int(11) default 0, -- 供应商ID
	title varchar(100), -- 标题
	subTitle varchar(200), -- 副标题
	tag varchar(50), -- 标签
	image varchar(200), -- 主图片
	tjFlag varchar(1) default 0, -- 是否推荐
	viewCount int(11) default 0, -- 浏览量
	praiseCount int(11) default 0, -- 点赞数
	addTime varchar(19), -- 添加时间
	sortIndex int(11) default 999999, -- 排序
	auditStatus int(11), -- 审核状态，参加c_productAuditStatus表
	publishFlag char(1) default 0, -- 发表状态 0：未发表 1：已发表
	publishTime varchar(19), -- 发表时间
	commentCount int(11) default 0, -- 评论数
	validFlag char(1) default 1,
	deletedFlag char(1) default 0,
	index index_supplierID (supplierID)
);

-- 社区文章详细
create table if not exists infoDetail (
	infoID int(11) primary key,
	content text,
	contentTxt text
);

-- 文章目录
create table if not exists infoDirectory (
	infoDirectoryID int(11) primary key, --  主键ID
	name varchar(20), -- 目录名称
	sortIndex int(11) default 999999, -- 排序
	supplierID int(11), -- 店铺ID
	validFlag char(1) default 1, -- 状态
	deletedFlag char(1) default 0 -- 删除状态
);


-- 相册表
create table if not exists photoAlbum (
	photoAlbumID int(12) primary key, -- 主键ID
	supplierID int(11), -- 店铺ID
	photoAlbumTypeID int(11), -- 相册分类，1企业相册，2商品相册
	name varchar(50), -- 相册名称
	totalSize decimal(12,1) default 0, -- 使用容量（单位：KB）
	imageCount int(11) default 0, -- 图片数量
	image varchar(100), -- 封面图片
	addTime varchar(19), -- 新建时间
	sortIndex int(11) default 999999, -- 排序
	validFlag char(1) default 1, -- 状态
	deletedFlag char(1) default 0 -- 删除状态
);

-- 相册图片表
create table if not exists photo (
	photoID int(11) primary key, -- 主键ID
	photoAlbumID int(11), -- 相册ID
	supplierID int(11), -- 店铺ID
	name varchar(20), -- 图片名称
	size decimal(12,1), -- 图片大小（单位：KB）
	image varchar(100), -- 图片地址
	addTime varchar(19), -- 添加时间
	sortIndex int(11) default 999999, -- 排序
	validFlag char(1) default 1, -- 状态
	deletedFlag char(1) default 0, -- 删除状态
	index index_photoID (photoID)
);
DROP TABLE IF EXISTS shoporder;
CREATE TABLE shoporder (
  shopOrderID bigint(20) NOT NULL,
  shopID int(11) default NULL,
  shopOrderTypeID int(11) default NULL,
  ip varchar(30) default NULL,
  userID int(11) default NULL,
  shouHuoRen varchar(20) default NULL,
  phone varchar(20) default NULL,
  mobile varchar(20) default NULL,
  email varchar(50) default NULL,
  townID int(11) default NULL,
  address varchar(100) default NULL,
  postalCode varchar(10) default NULL,
  deliveryTypeID int(11) default NULL,
  deliveryCode varchar(100) default NULL,
  deliveryTimeID int(11) default NULL,
  sitePayTypeID int(11) default NULL,
  onlinePayFlag char(1) default NULL,
  invoiceFlag char(1) default NULL,
  invoiceTypeID int(11) default NULL,
  invoiceTitle varchar(50) default NULL,
  invoiceContent varchar(200) default NULL,
  orderTime varchar(19) default NULL,
  payFlag char(1) default NULL,
  payTime varchar(19) default NULL,
  finishTime varchar(19) default NULL,
  refundStatus char(1) default NULL,
  returnGoodsStatus char(1) default NULL,
  exceptionFlag char(1) default NULL,
  itemCount int(11) default NULL,
  productMoney float default NULL,
  deliveryMoney float default NULL,
  recountMoney float default NULL,
  accountMoney float default NULL,
  point int(11) default NULL,
  pointAmount float default NULL,
  cardID int(11) default NULL,
  cardAmount float default NULL,
  totalPrice float default NULL,
  needPayMoney float default NULL,
  payAmount float default NULL,
  canRefundAmount float default NULL,
  refundAmount float default NULL,
  canRefundPoint int(11) default NULL,
  refundPoint int(11) default NULL,
  getPoint int(11) default NULL,
  note varchar(50) default NULL,
  status int(11) default NULL,
  exceptionTypeID int(11) default NULL,
  exceptionNote varchar(100) default NULL,
  autoCloseTimeMills bigint(20) default NULL,
  autoFinishDeadTimeMills bigint(20) default NULL,
  autoReviceGoodsDeadTimeMills bigint(20) default NULL,
  deliveryTimeMills bigint(20) default NULL,
  deliveryTime varchar(19) default NULL,
  transactionNum varchar(100) default NULL,
  payTypeID int(11) default NULL,
  useSysParaFlag char(1) default NULL,
  sourceTypeID char(1) default NULL,
  wholeSitePromotionFlag char(1) default NULL,
  promotionActiveTypeID int(11) default NULL,
  promotionActiveID int(11) default NULL,
  needMoney float default NULL,
  cutMoney float default NULL,
  onlineFlag char(1) default NULL,
  deliverTypeID int(11) default NULL,
  deleteFlag char(1) default NULL,
  ztCode varchar(50) default NULL,
  ztFlag char(1) default NULL,
  canRefundAccountMoney float default NULL,
  canRefundBankMoney float default NULL,
  rebateFlag char(1) default NULL,
  rebateToUserIDs varchar(50) default NULL,
  rebatePercent int(11) default NULL,
  rebateFinishFlag char(1) default NULL,
  rebateFinishTime varchar(19) default NULL,
  auditNote varchar(100) default NULL,
  rebateAmount float default NULL,
  payWayID int(11) default NULL,
  settlementShopID int(11) default NULL,
  settlementFinishFlag char(1) default NULL,
  settlementAmount decimal(12,2) default NULL,
  rebateInfo varchar(300) default NULL,
  changePriceFlag char(1) default NULL,
  oldTotalPrice float default NULL,
  oldNeedPayMoney float default NULL,
  supplierID int(11) default NULL,
  autoReceiveDay int(11) default NULL,
  supplierAmount decimal(12,2) default '0.00',
  canUseSampleFlag char(1) default NULL, -- 是否可用拿样返还标识 0，未使用，1 已使用。该字段只有订单类型为拿样订单才有效
  sampleMoney decimal(12,2) default NULL, -- 拿样商品返还总金额，该字段只有非拿样订单才有效
  sampleShopOrderID bigint(20) default NULL, -- 拿样商品返还对应拿样订单shopOrderID，该字段只有非拿样订单才有效
  PRIMARY KEY  (shopOrderID)
);

-- 满减满赠
DROP TABLE IF EXISTS promotionactive;
CREATE TABLE promotionactive (
  promotionActiveID int(11) NOT NULL,
  name varchar(50) default NULL,
  value int(11) default NULL,
  value2 int(11) default NULL,
  validFlag char(1) default NULL,
  promotionActiveTypeID int(11) default NULL,
  addTime varchar(19) default NULL,
  addUserID int(11) default NULL,
  modifyUserID int(11) default NULL,
  lastMdfTime varchar(19) default NULL,
  value3 float default NULL,
  value4 int(11) default NULL,
  supplierID int(11) default NULL,
  PRIMARY KEY  (promotionActiveID)
);

-- 2017-03-21 caihaifeng

-- 邮件发送日志表
create table if not exists mailLog (
	mailLogID int(11) primary key, -- 主键ID
	userID int(11), -- 会员ID
	email varchar(50), -- 收件箱
	randomCode varchar(10), -- 随机验证码
	nick varchar(50), -- 收件人邮箱昵称（邮箱账号）
	ip varchar(20), -- 请求IP
	validFlag char(1), -- 是否有效 0：失效 1：有效
	successFlag char(1), -- 成功状态 0：失败 1：成功
	mailLogTypeID int(11), -- 类型 1：注册验证码
	expiredTime varchar(19), -- 过期时间
	sendTime varchar(19) -- 发送时间
);

-- 采购单
create table if not exists purchase (
	purchaseID int(11) primary key, -- 主键ID
	userID int(11), -- 发布人ID
	title varchar(50), -- 标题
	purType char(1), -- 采购类型 1：现货/标准品  2：加工/定制品
	endDate varchar(10), -- 采购截止日期
	expectShouHuoDate varchar(10), -- 期望收货日期
	priceType char(1), -- 议价类型 1：可议价 2：不可议价 3：面议
	townID int(11), -- 收货地址县城ID
	address varchar(100), -- 详细地址
	offerProvinceID int(11), -- 要求卖家所在省份ID
	offerCityID int(11), -- 要求卖家所在城市ID
	invoiceFlag char(1), -- 发票 1：需要发票 0：不需要发票
	info varchar(200), -- 补充说明
	showQuotedPriceFlag char(1), -- 报价查看要求 1：报价截止时间到期后才能查看报价单 0：随时可以查看
	showLinkType char(1), -- 查看联系方式 1：报价后可看 2：公开
	linkMan varchar(20), -- 联系人
	mobile varchar(11), -- 手机号码
	phone varchar(20), -- 联系电话
	auditStatus char(1), -- 状态 0：待审核 1：审核通过 2：审核不通过
	auditNote varchar(100), -- 审核备注
	auditTime varchar(19), -- 最新审核时间
	addTime varchar(19), -- 添加时间
	quoteFlag char(1), -- 是否有商家报价
	validFlag char(1), -- 是否有效 1：有效（未关闭）  0：关闭
	quoteNum int(8) default 0, -- 报价单数量
	deletedFlag char(1) default 0
);
-- 采购单项
create table if not exists purchaseItem (
	purchaseItemID int(11) primary key,
	purchaseID int(11), -- 采购单ID
	productName varchar(50), -- 商品名称
	tinyTypeID int(11), -- 商品分类
	number int(11), -- 数量 
	price decimal(12, 2), -- 采购商品单价
	skuInfo varchar(100), -- 规格信息
	image varchar(100), -- 图片（预留字段）
	deletedFlag char(1) -- 删除标识0 未删除，1，已删除
);

-- 报价单
create table if not exists quote (
	quoteID int(11) primary key, -- 主键ID
	purchaseID int(11), -- 采购单
	supplierID int(11), -- 商户ID
	userID int(11), -- 会员ID
	type int(11), -- 1：网站报价  2：供应商报价
	linkMan varchar(20), -- 联系人
	mobile varchar(11), -- 手机号
	phone varchar(20), -- 联系电话
	addTime varchar(19), -- 添加时间
	info varchar(100), -- 备注
	fee decimal(12, 2), -- 总运费
	totalPrice decimal(12, 2), -- 总价
	priceDetail text, -- 单商品报价
	adoptFlag char(1), -- 买家是否采用
	validFlag char(1), -- 是否有效
	deletedFlag char(1) -- 删除标识0 未删除，1，已删除
);

-- 留言管理
create table if not exists questionFeedBackLog(
	questionFeedBackLogID int(11) primary key,
	content varchar(500), -- 反馈文本
	link varchar(100), -- 链接
	questionFeedBackLogTypeID int(11), -- 问题类型
	addTime varchar(19),
	userID int(11), -- 用户ID
	validFlag char(1),
	deletedFlag char(1)
);

-- 文章评论
drop table if exists infoComment;
create table if not exists infoComment (
	infoCommentID int(11) primary key,
	userID int(11), -- 评论用户ID
	infoID int(11), -- 评论文章ID
	supplierID int(11), -- 供应商ID
	content varchar(500), -- 评论内容
	addTime varchar(19), -- 评论时间
	-- auditStatus char(1), -- 审核状态0 未审核，1审核通过，2未通过
	-- auditNote varchar(50), -- 审核备注
	validFlag char(1),
	deletedFlag char(1)
);

-- 管理员操作日志表
create table if not exists systemUserLog (
	systemUserLogID int(11) primary key auto_increment,
	systemUserID int(11), -- 操作用户ID
	systemUserName varchar(50), -- 操作员姓名
	sessionID varchar(50), -- sessionID
	module varchar(50), -- 操作模块
	action varchar(50), -- 操作动作
	os varchar(50), -- 操作系统
	browser varchar(50), -- 浏览器
	browserVersion varchar(50), -- 浏览器版本号
	ip varchar(50), -- 操作者来源ID
	logTime varchar(19) -- 操作时间
);

-- 商户首页模板
create table if not exists supplierTheme (
	supplierThemeID int(11) primary key, -- 模板ID
	name varchar(20), -- 模板名称
	image varchar(200), -- 模板效果图
	validFlag char(1), -- 是否有效 0 无效  1有效
	content text -- 模板HTML内容
);

-- 交易单表
DROP TABLE IF EXISTS transaction;
CREATE TABLE transaction (
  transactionID bigint(20) NOT NULL,
  transactionTypeID int(11) default NULL,
  userID int(11) default NULL,
  title varchar(1000) default NULL,
  amount decimal(12,2) default NULL,
  actualAmount decimal(12,2) default NULL,
  addTime varchar(19) default NULL,
  payTime varchar(19) default NULL,
  transactionNum varchar(100) default NULL,
  relateIDs varchar(1000) default NULL,
  status char(1) default NULL,
  auditTime varchar(19) default NULL,
  auditNote varchar(200) default NULL,
  auditSystemUserID int(11) default NULL,
  auditUserName varchar(50) default NULL,
  sitePayTypeID int(11) default NULL,
  sendPayRequestFlag char(1) default NULL,
  formData text,
  rePayFlag char(1) default NULL,
  refundAmount float default NULL,
  proberlem varchar(200) default NULL,
  phone varchar(20) default NULL,
  mobile varchar(20) default NULL,
  townID int(11) default NULL,
  postalCode varchar(10) default NULL,
  address varchar(100) default NULL,
  shouHuoRen varchar(20) default NULL,
  payTypeID int(11) default NULL,
  useSysParaFlag char(1) default NULL,
  rgzyfkFlag char(1) default NULL,
  rgzyfkSystemUserID int(11) default NULL,
  rgzyfkUserName varchar(50) default NULL,
  rgzyfkTime varchar(19) default NULL,
  shopOrderTypeID int(11) default NULL,
  shopID int(11) default NULL,
  agentID int(11) default NULL,
  PRIMARY KEY  (transactionID)
);

-- 友情链接和平台合作客户
create table if not exists friendshipLink (
	friendshipLinkID int(11) primary key,
	friendshipLinkTypeID char(1),  -- 1 友情链接，2 平台合作客户
	name varchar(50),  -- 名称
	link varchar(200), -- 链接
	sortIndex int(11), -- 排序
	supplierID int(11), -- 供应商ID
	validFlag char(1) -- 是否有效
);


-- 缺货通知
create table if not exists productNotify (
	productID int(11),
	userID int(11),
	notifyMobile varchar(20),
	addTime varchar(19),
	expireDate varchar(10), -- 失效日期
	primary key (productID, userID, notifyMobile),
	index index_expireDate (expireDate),
	index index_productID (productID)
);

-- 店铺主营产品
create table if not exists supplierMainProduct (
	supplierMainProductID int(11) primary key,
	name varchar(20), -- 名称
	companyIndustryID int(11),
	validFlag char(1) default 1,
	deletedFlag char(1) default 1  --删除的标识  0表示的可用，1表示的是删除
);

-- 店铺等级
create table if not exists supplierLevel (
	supplierLevelID int(11) primary key,
	name varchar(20) -- 名称
);

-- 文章点赞记录表
create table if not exists infoPraise (
	infoPraiseID int(11) primary key,
	infoID int(11),
	userID int(11),
	addTime varchar(19),
	unique key uni_infoID_userID (infoID, userID)
);

-- 商品评论
create table if not exists comment (
	commentID       int(11) primary key,
	orderProductID  int(11), -- 订单项ID
	userID          int(11), -- 评论用户ID
	showUserName    varchar(100), -- 评论用户昵称
	orderTime       varchar(19), -- 下单时间（冗余）
	productID       int(11), -- 评论商品ID
	price           float, -- 评论商品价格
	number          int(11), -- 商品购买数量
	propName        varchar(1000), -- 商品属性         
	commentScore    int(11), -- 商品评分
	serviceScore int(11), -- 服务评分
	deliveryScore int(11), -- 发货速度
	deliveryServiceScore int(11), -- 物流评分
	postTime        varchar(19),
	commentContent  varchar(500),
	replyContent    varchar(500),
	replyTime       varchar(19),
	replyFlag       char(1)    ,
	siteManagerID   int(11),
	autoComment2Flag char(1), -- 是否可追评标识， 0 可追评，1 追评成功， 2追评失效
	autoComment2TimeMills bigint(20), -- 追评期限
	replyContent2 varchar(500), -- 追评内容
	validFlag       char(1)    ,
	imageNames      varchar(500)
);

-- 店铺评论维度占比
create table if not exists commentDimension (
	commentDimensionID varchar(50) primary key,
	name varchar(10),
	percent int(11)
);

-- 投诉/咨询 
DROP TABLE IF EXISTS consultation;
CREATE TABLE consultation (
  consultationID int(11) NOT NULL,
  productID int(11) default NULL, -- 产品ID
  userID int(11) default NULL, -- 用户ID
  postTime varchar(19) default NULL, -- 提交时间
  consultationContent varchar(500) default NULL, -- 提交内容
  replyContent varchar(500) default NULL, -- 回复内容，只有consultationTypeID = 1 时可回复，即只有是咨询的时候可回复
  replyTime varchar(19) default NULL, -- 回复时间
  replyFlag char(1) default NULL, -- 是否回复 0 否 1 是
  siteManagerUserID int(11) default NULL, -- 操作人。即后台管理员
  validFlag char(1) default NULL, 是否显示 0 否 1 是
  showUserName varchar(100) default NULL, -- 咨询或投诉人的昵称
  consultationTypeID char(1) default NULL,  -- 1 咨询，2 投诉
  PRIMARY KEY  (consultationID)
);
-- 品牌分类管理
create table brandType (
	brandTypeID int(11) primary key,
	name varchar(20), -- 名称
	sortIndex int(8), -- 排序
	validFlag char(1), -- 是否有效
	deletedFlag char(1) -- 是否删除
);

-- 版本更新
drop table if exists appInfo;
create table appInfo(
	appInfoID int(11) primary key,
	name varchar(50), 
	appTypeID int(11), -- 安卓手机：3， ios手机：1
	userTypeID int(11), 
	updateDate varchar(10), -- 更新日期
	info varchar(500), 
	downloadUrl varchar(1000), -- 下载地址
	versionNumber int(5), -- 版本号
	code varchar(100), 
	mandatoryFlag varchar(1)
);

-- 店铺信誉值管理表
create table if not exists c_shopReputation (
	c_shopReputationID int(11) primary key,
	c_shopReputationName varchar(20), -- 店铺信誉名称
	c_shopReputationValue int(8), -- 信誉值
	c_shopReputationImage varchar(200), -- 信誉图标
	validFlag char(1)
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


