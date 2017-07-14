package admin.customer.guanwangbao.processor;

import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;

public class BannerProcessor extends BaseProcessor {
	public BannerProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}
	
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			initPageByQueryDataList("banner_V", getFormDatas(), "datas");
			
			setFormData("queryBannerGroupSelect", makeSelectElementString("q_bannerGroupID", 
					LocalDataCache.getInstance().getTableDatas("c_bannerGroup"), 
					"c_bannerGroupID", "c_bannerGroupName", ""));
		} else {
			setFormData("bannerGroupSelect", makeSelectElementString("bannerGroupID", 
					LocalDataCache.getInstance().getTableDatas("c_bannerGroup"), 
					"c_bannerGroupID", "c_bannerGroupName", "setBannerTr()"));
		}
		
		if (!getFormData("action").equals("list")) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("banner_V"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void groupDefaultViewAction() throws Exception {
		Vector<Hashtable<String, String>> c_bannerGroups = DBProxy.query(getConnection(), "c_bannerGroup");
		setJSPData("groupDatas", c_bannerGroups);
	}
	
	public void groupEditViewAction() throws Exception {
		getData("c_bannerGroup", DATA_TYPE_TABLE);
	}
	
	public void confirmGroupAction() throws Exception {
		confirmValue("c_bannerGroup");
		groupDefaultViewAction();
		setFormData("action", "groupDefaultView");
	}
	
	
	public void addViewAction() throws Exception {
		String[] items = {"bannerID"};
		clearDatas(items);
	}
	
	public void editViewAction() throws Exception {
		getData("banner", DATA_TYPE_VIEW);
		Vector<Hashtable<String, String>> resultProductDatas = new Vector<Hashtable<String,String>>();
		if(getFormData("bannerGroupID").equals("13") 
				|| getFormData("bannerGroupID").equals("12")
				|| getFormData("bannerGroupID").equals("17")
				|| getFormData("bannerGroupID").equals("18")
				|| getFormData("bannerGroupID").equals("19")
				|| getFormData("bannerGroupID").equals("20")
				) {
			String productIDs = getFormData("context");
			if(!productIDs.equals("")) {
				String[] split = StringUtil.split(productIDs, ",");
				String sql = "select * from product_V where deletedFlag = '0' and validFlag = '1' and  productID ";
				StringBuffer sb = new StringBuffer();
				Vector<String> v = new Vector<String>();
				Hashtable<String, Integer> productHash = new Hashtable<String, Integer>();  
				for(int i = 0; i < split.length; i++) {
					String productID = split[i];
					if(productHash.containsKey(productID)) {
						continue;
					}
					sb.append(",").append("?");
					v.add(productID);
					productHash.put(productID, 0);
				}
				sql += " in(" + sb.toString().substring(1) + ")";
				Vector<Hashtable<String, String>> products = DBProxy.query(getConnection(), "product_V", sql, v);
				Hashtable<String, Hashtable<String, String>> productHash_ = new Hashtable<String, Hashtable<String,String>>();
				for(int i = 0; i < products.size(); i++) {
					Hashtable<String, String> productD = products.get(i);
					productHash_.put(productD.get("productID"), productD);
				}
				for(int i = 0; i < split.length; i++) {
					String productID = split[i];
					if(productHash_.containsKey(productID)) {
						resultProductDatas.add(new Hashtable<String, String>(productHash_.get(productID)));
					}
				}
			}
		}
		setJSPData("productDatas", resultProductDatas);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("bannerGroupID", "所属分组", true));
		list.addCheckItem(new StringCheckItem("title", "标题", true));
		list.addCheckItem(new StringCheckItem("link", "链接", true));
		
//		if (list.check()) {
//			if (getFormData("bannerGroupID").equals("12")) {
//				list.addCheckItem(new PriceCheckItem("activityPrice", "抢购价", true));
//				list.addCheckItem(new StringCheckItem("startTime", "抢购时间", true));
//				list.addCheckItem(new StringCheckItem("endTime", "抢购时间", true));
//				if (list.check()) {
//					if (getFormData("startTime").compareTo(getFormData("endTime")) >= 0) {
//						setErrorMessage("抢购结束时间不能小于开始时间");
//						return false;
//					}
//				}
//			}
//		}
		
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		if(!getFormData("bannerGroupID").equals("13")
				&& !getFormData("bannerGroupID").equals("17")
				&& !getFormData("bannerGroupID").equals("12")
				&& !getFormData("bannerGroupID").equals("18")
				&& !getFormData("bannerGroupID").equals("19")
				&& !getFormData("bannerGroupID").equals("20")) {
			setFormData("context", "");
		}
		//判断链接是否是本站链接
		String link = getFormData("link");
		if (!link.startsWith("http://")) {
			setAjaxJavascript("alert('你输入的链接不正确！')");
		} else {
		if (link.startsWith("http://") || link.startsWith("https://") || link.startsWith("//")) {
			link = link.replaceFirst("http://", "").replace("https://", "").replace("//", "");
			String domains = "";
			if (link.indexOf("/") != -1) {
				domains = link.substring(0, link.indexOf("/"));
			} else {
				domains = link;
			}
			domains = domains.indexOf(":") != -1 ? domains.substring(0, domains.indexOf(":")) : domains;
			String domain_www = AppKeys.DOMAIN_WWW;
			domain_www = domain_www.indexOf(":") != -1 ? domain_www.substring(0, domain_www.indexOf(":")) : domain_www;
			String domain_wap = AppKeys.DOMAIN_WAP;
			domain_wap = domain_wap.indexOf(":") != -1 ? domain_wap.substring(0, domain_wap.indexOf(":")) : domain_wap;
			
			if (!(domains.equals(domain_wap) || domains.equals(domain_www))) {
				setAjaxJavascript("alert('请输入本站内链接！')");
			} else {
				confirmValue("banner");
				setAjaxJavascript("postModuleAndAction('banner', 'list')");
			}
		}
		
		}
	}
	
	public void selectProductAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		
		if (selectedValues.equals("")) {
			setAjaxInfoMessage("请选择一个商品");
			return;
		}
		
		String[] productIDs = StringUtil.split(selectedValues, ",");
		if (productIDs.length > 1) {
			setAjaxInfoMessage("只能选择一个商品");
			return;
		}
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("productID", productIDs[0]);
		k.put("deletedFlag", "0");
		Vector<Hashtable<String, String>> products = DBProxy.query(getConnection(), "product", k);
		if (products.size() == 0) {
			setAjaxInfoMessage("不存在该商品");
			return;
		}
		
		Hashtable<String, String> product = products.get(0);
		
		setAjaxJavascript("$('#productID').val('" + product.get("productID") + "');"
				+ "$('#productName').val('" + StringUtil.convertXmlChars(product.get("name")) + "');"
				+ "$('#productNormalPrice').val('" + product.get("normalPrice") + "');"
				+ "$('#productPrice').val('" + product.get("price") + "');"
				+ "$('#productImage').attr('src', '" + AppUtil.getProductImage(product, AppKeys.IMAGE_SIZE_SMALL) + "');"
						+ "closeInfoWindow()");
	}
	
	public void selectBrandWindowAction() throws Exception {
		setFormData("count", getFormData("windowCount"));
		setFormData("pageCount", getFormData("windowPageCount"));
		setFormData("pageNumber", getFormData("windowPageNumber"));
		setFormData("pageFrom", getFormData("windowPageFrom"));
		setFormData("pageTo", getFormData("windowPageTo"));
		setFormData("pageIndex", getFormData("windowPageIndex"));
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("q_validFlag", "1");
		setFormData(key);
		
		initPageByQueryDataList("brand", getFormDatas(), "brandDatas");
		
		setFormData("windowCount", getFormData("count"));
		setFormData("windowPageCount", getFormData("pageCount"));
		setFormData("windowPageNumber", getFormData("pageNumber"));
		setFormData("windowPageFrom", getFormData("pageFrom"));
		setFormData("windowPageTo", getFormData("pageTo"));
		setFormData("windowPageIndex", getFormData("pageIndex"));
	}
	
	public void selectBrandAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		
		if (selectedValues.equals("")) {
			setAjaxInfoMessage("请选择一个品牌");
			return;
		}
		
		String[] brandIDs = StringUtil.split(selectedValues, ",");
		if (brandIDs.length > 1) {
			setAjaxInfoMessage("只能选择一个品牌");
			return;
		}
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("brandID", brandIDs[0]);
		k.put("validFlag", "1");
		Vector<Hashtable<String, String>> brands = DBProxy.query(getConnection(), "brand", k);
		if (brands.size() == 0) {
			setAjaxInfoMessage("不存在该品牌");
			return;
		}
		
		Hashtable<String, String> brand = brands.get(0);
		
		setAjaxJavascript("$('#brandID').val('" + brand.get("brandID") + "');"
				+ "$('#brandName').val('" + StringUtil.convertXmlChars(brand.get("name")) + "');"
				+ "$('#brandImage').attr('src', '" + AppUtil.getImageURL("brand", brand.get("image"), 0) + "');"
						+ "closeInfoWindow()");
	}
}
