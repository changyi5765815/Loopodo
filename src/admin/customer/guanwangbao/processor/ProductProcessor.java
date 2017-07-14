package admin.customer.guanwangbao.processor;

import java.io.File;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.http.Cookie;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.HTMLUtil;
import simpleWebFrame.util.StringUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.PriceCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.AppUtil;
import admin.customer.guanwangbao.LocalDataCache;
import admin.customer.guanwangbao.tool.ExcelUtils;
import admin.customer.guanwangbao.tool.StockBillTool;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

public class ProductProcessor extends BaseProcessor {

	public ProductProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		String action = getFormData("action");
		if ("list".equals(action)) {
			String extendSql = "";
//			if (getFormData("product_opt").equals("waitAudit")) {
//				setFormData("q_auditStatus", "10");
//			} else if (getFormData("product_opt").equals("hasAudit")) {
//				extendSql = " auditStatus in (20, 90)";
//			} else {
//				setFormData("q_auditStatus", "20");
//			}
			setFormData("q_deletedFlag", "0");
			initPageByQueryDataList("product_V", getFormDatas(), "datas", extendSql, new Vector<String>(), "order by productID desc");
			setFormData("queryProductTypeSelect", getQueryProductTypeSelect());
			setFormData("queryProductTagSelect", makeSelectElementString("q_tag", getConstantValues(getConnection(), "c_productTag"), "c_productTagName", "c_productTagName", ""));
			Vector<Hashtable<String, String>> auditStatusVector = new Vector<Hashtable<String,String>>();
			Hashtable<String, String> data = new Hashtable<String, String>();
			data.put("q_auditStatus", "10");
			data.put("c_yesOrNotName", "否");
			auditStatusVector.add(data);
			Hashtable<String, String> data2 = new Hashtable<String, String>();
			data2.put("q_auditStatus", "20");
			data2.put("c_yesOrNotName", "是");
			auditStatusVector.add(data2);
			setFormData("auditStatusSelect", makeSelectElementString("q_auditStatus", auditStatusVector, "q_auditStatus", "c_yesOrNotName", "", "form-control", true, "", ""));
//			setFormData("validFlagSelect", makeSelectElementString("q_validFlag", DBProxy.query(getConnection(), "c_yesOrNot"), "c_yesOrNotID", "c_yesOrNotName", "", "form-control", true, "", ""));
		} else if ("addView".equals(action)|| "editView".equals(action)) {
			setFormData("brandSelect", getBrandSelect());
			setFormData("supplierSelect", getSupplierSelect());
			setFormData("queryProductTypeSelect2", getQueryProductTypeSelect2());
			setFormData("productTagSelect", makeSelectElementString("tag", getConstantValues(getConnection(), "c_productTag"), "c_productTagName", "c_productTagName", ""));
			
			setProductProps();
			makePriceDatas(getFormData("priceDetail"));
		} else if (getFormData("action").equals("productImageList")
				|| getFormData("action").equals("productImageConfirm")) {
			setJSPData("productImageDatas", 
					getProductImages(getFormData("productID")));
		} else if (getFormData("action").equals("productRelateList")) {
			String productID = getFormData("productID");
			String sql1 = "select * from productRelate_V where productID1 = ? and deletedFlag = ?";
			Vector<String> values1 = new Vector<String>();
			values1.add(productID);
			values1.add("0");
			Vector<Hashtable< String, String>> datas1 = 
				DBProxy.query(getConnection(), "productRelate_V", sql1, values1);
			
			setJSPData("datas1", datas1);
		} else if (getFormData("action").equals("skuList")) {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("productID", getFormData("productID"));
			Hashtable<String, String> product = DBProxy.query(getConnection(), "productDetailInfo", k).get(0);
			setFormData(product);
			
			setProductSkuPropInfo();
			
			setProductSkuPropValueAlias();
			
			setProductSkuPropValueImg();
			
			setSkuInfo();
		}

	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}

	public void addViewAction() throws Exception {
		String[] items = {"productID", "detailInfo"};
		clearDatas(items);
	}
	
	public void setProductProps() throws Exception {
		String tinyTypeID = getFormData("tinyTypeID");
		String smallTypeID = getFormData("smallTypeID");
		String bigTypeID = getFormData("bigTypeID");
		
		Vector<Hashtable<String, String>> properties = getProperties(bigTypeID, smallTypeID, tinyTypeID);
		
		setJSPData("properties", properties);
		
		for (Hashtable<String, String> property : properties) {
			
			if (!"1".equals(property.get("propTypeID")) && !"2".equals(property.get("propTypeID"))) {
				continue;
			}

			Vector<Hashtable<String, String>> propertiesValues = LocalDataCache.getInstance().getPropertiesValuesByPropertiesID(property.get("propertiesID"));
			if (propertiesValues.size() > 0) {
				
				if ("1".equals(property.get("propTypeID"))) {
					setFormData("propertiesValue" + property.get("propertiesID") + "Select", makeSelectElementOfPropertiesValue(property.get("propertiesID"), propertiesValues));
				} else {
					setFormData("propertiesValue" + property.get("propertiesID") + "Select", makeCheckBoxOfPropertiesValue(property.get("propertiesID"), propertiesValues));
				}
				
			}
		}
	}
			
		
	public String makeSelectElementOfPropertiesValue(String propertiesID, Vector<Hashtable<String, String>> propertiesValues) throws Exception {
		
		Vector<Hashtable<String, String>> propertiesValueDatasClone = new Vector<Hashtable<String,String>>();
		
		for (int i = 0; i < propertiesValues.size(); ++i) {
			propertiesValueDatasClone.add((Hashtable<String, String>) (propertiesValues.get(i).clone()));
		}
		
		for (int i = 0; i < propertiesValueDatasClone.size(); ++i) {
			propertiesValueDatasClone.get(i).put("propertiesValueID", 
					propertiesID + ":" + propertiesValueDatasClone.get(i).get("propertiesValueID"));
		}
		String str = makeSelectElementString("properties_" + propertiesID, 
				propertiesValueDatasClone, "propertiesValueID", "name", "");
		
		return str;
	}
	
	
	public String makeCheckBoxOfPropertiesValue(String propertiesID, Vector<Hashtable<String, String>> propertiesValues) throws Exception {
		
		StringBuffer sb = new StringBuffer();
		String checkboxID = "properties_" + propertiesID;
		String saveCheckboxValueInputID = "properties_SelectedValues_" + propertiesID;
		String onchangeEvent = "setSelectedValues('" + checkboxID + "', '" + saveCheckboxValueInputID + "');";
		for (int i = 0; i < propertiesValues.size(); ++i) {
			Hashtable<String, String> tmpPropertiesValue = propertiesValues.get(i);
			boolean checked = ("," + getFormData("properties_SelectedValues_" + propertiesID) + ",")
					.indexOf("," + tmpPropertiesValue.get("propertiesValueID") + ",") != -1;
			
			sb.append("<input " + (checked ? "checked='checked'" : "") + " type='checkbox' name='").append(checkboxID).append("' id='").append(checkboxID)
			.append("' onchange=\"" + onchangeEvent + "\" value='").append(propertiesID).append(":").append(tmpPropertiesValue.get("propertiesValueID"))
			.append("' />&nbsp;").append(tmpPropertiesValue.get("name")).append("&nbsp;");
		}
		
		sb.append("<input type='hidden' name='").append(saveCheckboxValueInputID).append("' id='").append(saveCheckboxValueInputID)
		.append("' value='").append(getFormData(saveCheckboxValueInputID)).append("' />");
		
		sb.append("<script>initSelectedValues('" + checkboxID + "', '" + saveCheckboxValueInputID + "');</script>");
		
		return sb.toString();
	}
	
	public void refreshpropAction() throws Exception {
		setProductProps();
		dispatch("product/porp.jsp");
	}
	
	public void confirmProductAction() throws Exception {
		
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "商品名称", true));
		list.addCheckItem(new IntegerCheckItem("tinyTypeID", "分类", true));
		list.addCheckItem(new PriceCheckItem("price", "商场价", true));
		list.addCheckItem(new PriceCheckItem("normalPrice", "市场价", false));
		list.addCheckItem(new IntegerCheckItem("brandID", "品牌", false));
		list.addCheckItem(new IntegerCheckItem("supplierID", "供应商", false));
		list.addCheckItem(new IntegerCheckItem("stock", "库存", true));
		
		if (!list.check()) {
			return;
		}
		
		if (!checkProps()) {
			return;
		}
		
		if (isExistsBarCode(getFormData("productCode"), getFormData("productID"), "")) {
			setErrorMessage("商品条码" + getFormData("productCode") + "重复");
			return;
		}
		
		saveProduct();
		
		setAjaxJavascript("postModuleAndAction('product', 'defaultView')");
	}
	
	private boolean checkProps() throws Exception {	
		String tinyTypeID = getFormData("tinyTypeID");
		String smallTypeID = getFormData("smallTypeID");
		String bigTypeID = getFormData("bigTypeID");
		
		Vector<Hashtable<String, String>> properties = getProperties(bigTypeID, smallTypeID, tinyTypeID);
		
		for (int i = 0; i < properties.size(); i++) {
			Hashtable<String, String> property = properties.get(i);
			if (property.get("propTypeID").equals("3")) { 
				String propertiesID = "properties_" + property.get("propertiesID");
				if (getFormData(propertiesID).indexOf(",") != -1 
						|| getFormData(propertiesID).indexOf(":") != -1
						|| getFormData(propertiesID).indexOf(";") != -1) {
					setErrorMessageAndFocusItem(property.get("name") + "的属性名不能包含,号和:号;号", propertiesID);
					return false;
				}
			}
		}
		
		return true;
	}
	
	public Vector<Hashtable<String, String>> getProperties(String bigTypeID, String smallTypeID, String tinyTypeID) throws Exception {
		
		Vector<Hashtable<String, String>> properties = new Vector<Hashtable<String,String>>();
		properties.addAll(LocalDataCache.getInstance().getPropertiesByType("::"));
		if (!"".equals(bigTypeID)) {
			properties.addAll(LocalDataCache.getInstance().getPropertiesByType(bigTypeID + "::"));
		}
		if (!"".equals(bigTypeID) && !"".equals(smallTypeID)) {
			properties.addAll(LocalDataCache.getInstance().getPropertiesByType(bigTypeID + ":" + smallTypeID + ":"));
		}
		if (!"".equals(bigTypeID) && !"".equals(smallTypeID) && !"".equals(tinyTypeID)) {
			properties.addAll(LocalDataCache.getInstance().getPropertiesByType(bigTypeID + ":" + smallTypeID + ":" + tinyTypeID));
		}
		return properties;
	}
	
	private boolean isExistsBarCode(String barCode, String productID, String skuID) throws Exception {
		if (barCode.equals("")) {
			return false;
		}
		
		String sql = "select count(*) as COUNT from product where productCode = ?";
		Vector<String> p = new Vector<String>();
		p.add(barCode);
		if (!productID.equals("")) {
			sql += " and productID != ?";
			p.add(productID);
		}
		int count = Integer.parseInt(DBProxy.query(getConnection(), "count_V", sql, p).get(0).get("COUNT"));
		if (count > 0) {
			return true;
		}
		
		sql = "select count(*) as COUNT from sku where barCode = ? and defaultFlag != '1'";
		p = new Vector<String>();
		p.add(barCode);
		if (!skuID.equals("")) {
			sql += " and skuID != ?";
			p.add(skuID);
		}
		count = Integer.parseInt(DBProxy.query(getConnection(), "count_V", sql, p).get(0).get("COUNT"));
		if (count > 0) {
			return true;
		}
		
		return false;
	}

	private void saveProduct() throws Exception {
		setFormDataOfProps();
		operatorPropDatas();
		if (getFormData("productID").equals("")) {
			setFormData("validFlag", "0");
			setFormData("deletedFlag", "0");
			setFormData("addTime", DateTimeUtil.getCurrentDateTime());
			setFormData("sellNumber", "0");
			setFormData("weekSellNumber", "0");
			setFormData("commentPoint", "0");
			setFormData("commentTimes", "0");
			setFormData("betterScore", "0");
			setFormData("mediumScore", "0");
			setFormData("worseScore", "0");
			setFormData("favoriteTime", "0");
			setFormData("groupBuyFlag", "0");
			setFormData("stockNumber", "0");
			setFormData("discountFlag", "0");
			
			String productID = IndexGenerater.getTableIndex("product", getConnection());
			setFormData("productID", productID);
			
			setFormData("productDetailInfoID", 
					IndexGenerater.getTableIndex("productDetailInfo", getConnection()));
			setFormData("productID", productID);
			String detailInfo = getFormData("detailInfo");
			String detailInfoTxt = HTMLUtil.parseHtml(detailInfo);
			setFormData("detailInfo", detailInfo);
			setFormData("detailInfoTxt", detailInfoTxt);
			setFormData("seoTitle", getFormData("seoTitle"));
			setFormData("seoKeyword", getFormData("seoKeyword"));
			setFormData("seoDescription", getFormData("seoDescription"));
			setFormData("propValueAlias", getFormData("newPropValueAlias"));
			
			DBProxy.insert(getConnection(), "product", getFormDatas());
			DBProxy.insert(getConnection(), "productDetailInfo", getFormDatas());
			
			insertDefaultSku(productID, getFormData("productCode"), getFormData("stock"), getFormData("price"), getFormData("settlementPrice"));
		} else {
			if (getFormData("saveValidFlag").equals("1")) {
				setFormData("validFlag", "1");
			}
			Hashtable<String, String> key = new Hashtable<String, String>();
			key.put("productID", getFormData("productID"));

			DBProxy.update(getConnection(), "product", key, getFormDatas());
			
			String detailInfo = getFormData("detailInfo");
			String detailInfoTxt = HTMLUtil.parseHtml(detailInfo);
			setFormData("detailInfo", detailInfo);
			setFormData("wapContent", AppUtil.generateWapHtml(detailInfo));
			setFormData("detailInfoTxt", detailInfoTxt);
			setFormData("seoTitle", getFormData("seoTitle"));
			setFormData("seoKeyword", getFormData("seoKeyword"));
			setFormData("seoDescription", getFormData("seoDescription"));
			setFormData("propValueAlias", getFormData("newPropValueAlias"));
			
			DBProxy.update(getConnection(), "productDetailInfo", key, getFormDatas());
			
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("productID", getFormData("productID"));
			k.put("defaultFlag", "1");
			Hashtable<String, String> v = new Hashtable<String, String>();
			v.put("stock", getFormData("stock"));
			v.put("barCode", getFormData("productCode"));
			v.put("price", getFormData("price"));
			DBProxy.update(getConnection(), "sku", k, v);
		}
//		StockBillTool.resetProductStockNumber(getConnection(), getFormData("productID"));
	}
	
	private void setFormDataOfProps() throws Exception {
		StringBuffer propertiesInfoSb = new StringBuffer(",");
		Vector<Hashtable<String, String>> properties = getProperties(getFormData("bigTypeID"), getFormData("smallTypeID"), getFormData("tinyTypeID"));
		for (int i = 0; i < properties.size(); i++) {
			Hashtable<String, String> property = properties.get(i);
			String value = "";
			
			if (property.get("propTypeID").equals("1")) { 
				value = getFormData("properties_" + property.get("propertiesID"));
			} else if (property.get("propTypeID").equals("2")) { 
				value = getFormData("properties_SelectedValues_" + property.get("propertiesID"));
			} else if (property.get("propTypeID").equals("3")) { 
				if (!getFormData("properties_" + property.get("propertiesID")).equals("")) {
					value = property.get("propertiesID") + ":" + getFormData("properties_" + property.get("propertiesID"));
				}
			}
			if (!value.equals("")) {
				propertiesInfoSb.append(value).append(",");
			}
		}
		setFormData("propertiesInfo", propertiesInfoSb.toString());
	}
	private void operatorPropDatas() throws Exception {
		Hashtable<String, String> formDatas = getFormDatas();
		Vector<Hashtable<String, String>> datas = new Vector<Hashtable<String,String>>();
		for(String key: formDatas.keySet()) {
			if(key.startsWith("propName_")) {
				String[] split = StringUtil.split(key, "_");
				if(split.length <= 1) {
					continue;
				}
				String indexId = split[1];
				String propName = getFormData("propName_" + indexId);
				String propType = getFormData("propType_" + indexId);
				String propValue = getFormData("propValue_" + indexId);
				if(propName.equals("") && propType.equals("") && propValue.equals("")) {
					continue;
				}
				if(propName.equals("")) {
					continue;
				}
				if(propType.equals("")) {
					continue;
				}
				if(propType.equals("0") && propValue.equals("")) {
					continue;
				}
				Hashtable<String, String> data = new Hashtable<String, String>();
				data.put("propName", propName);
				data.put("propType", propType);
				data.put("sortIndex", indexId);
				if(propType.equals("0")) {
					data.put("propValue", propValue);
				} else {
					data.put("propValue", "");
				}
				datas.add(data);
			}
		}
		if(datas.size() == 0) {
			setFormData("definePara", "");
		} else {
			setFormData("definePara", JSON.toJSONString(datas));
		}
	}
	
	public void editViewAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("productID", getFormData("productID"));
		Vector<Hashtable<String, String>> products = DBProxy.query(getConnection(), "productDetailInfo_V", key);
		if (products.size() > 0) {
			setFormData(products.get(0));
		}

		String[] propertiesValue = StringUtil.split(getFormData("propertiesInfo"), ",");
		for (int i = 0; i < propertiesValue.length; i++) {
			String[] value = StringUtil.split(propertiesValue[i], ":");
			if (value.length == 2) {
				if ("1".equals(getProperties(value[0]).get("propTypeID"))) { 
					setFormData("properties_" + value[0], propertiesValue[i]);
				} else if ("2".equals(getProperties(value[0]).get("propTypeID"))) { 
					String oldPropertiesValue = getFormData("properties_SelectedValues_" + value[0]);
					setFormData("properties_SelectedValues_" + value[0], 
							((oldPropertiesValue.equals("") ? "" : (oldPropertiesValue + ",")) + propertiesValue[i]));
				} else if ("3".equals(getProperties(value[0]).get("propTypeID"))) { 
					setFormData("properties_" + value[0], value[1]);
				}
			}
		}
	}
	
	
	private Hashtable<String, String> getProperties(String propertiesID) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("propertiesID", propertiesID);
		Vector<Hashtable<String, String>> properties = DBProxy.query(getConnection(), "properties", key);
		if (properties.size() > 0) {
			return properties.get(0);
		}
		return new Hashtable<String, String>();
	}
	
	public void deleteAction() throws Exception {
		listAction();
		if (getFormData("productID").equals("")) {
			return;
		}
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("productID", getFormData("productID"));
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("deletedFlag", "1");
		DBProxy.update(getConnection(), "product", k, v);
	}
	
	public void productImageListAction() throws Exception {
	}
	
	private Vector<Hashtable<String, String>> getProductImages(String productID) throws Exception {
		if (productID.equals("")) {
			return new Vector<Hashtable<String,String>>();
		}
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("productID", productID);
		
		return DBProxy.query(getConnection(), "productImage", key);
	}
	
	public void batchUploadImageWindowAction() throws Exception {
	}
	
	public void productImageDeleteAction() throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("productImageID", getFormData("productImageID"));
		
		Vector<Hashtable<String, String>> imageDatas = DBProxy.query(getConnection(), "productImage", key);
		if (imageDatas.size() > 0) {
			deleteData("productImage");
			
			if (imageDatas.get(0).get("mainFlag").equals("1")) {
				key.clear();
				key.put("productID", getFormData("productID"));
				Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "productImage", key);
				
				if (datas.size() > 0) {
					key.clear();
					key.put("productImageID", datas.get(0).get("productImageID"));
					Hashtable<String, String> value = new Hashtable<String, String>();
					value.put("mainFlag", "1");
					DBProxy.update(getConnection(), "productImage", key, value);
				}
				updateProductMainImage(getConnection(), getFormData("productID"));
			}
		}
		
		setFormData("action", "productImageList");
	}
	
	public void setMainImageAction() throws Exception {
		String productImageID = getFormData("productImageID");
		String productID = getFormData("productID");
		
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("productID", productID);
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("mainFlag", "0");
		
		DBProxy.update(getConnection(), "productImage", key, value);
		
		key.clear();
		key.put("productImageID", productImageID);
		value.clear();
		value.put("mainFlag", "1");
		
		DBProxy.update(getConnection(), "productImage", key, value);
		updateProductMainImage(getConnection(), getFormData("productID"));
		
		setFormData("action", "productImageList");
	}
	
	public void productRelateListAction() throws Exception {
	}
	
	public void addProductRelateAction() throws Exception {
		String selectedVlues = getFormData("selectedValues");
		if (selectedVlues.length() == 0) {
			setErrorMessage("请选择商品");
			setReDispath();
			return;
		}
		
		String productID = getFormData("productID");
		
		String[] productIDs = StringUtil.split(selectedVlues, ",");
		
		for (int i = 0; i < productIDs.length; ++i) {
			String productIDTmp = productIDs[i];
			if (productID.equals(productIDTmp)) {
				continue;
			}
			String sql = "select count(*) as COUNT from productRelate where productID1 = ? and productID2 = ?";
			Vector<String> values = new Vector<String>();
			values.add(productID);
			values.add(productIDTmp);
			
			if (DBProxy.query(getConnection(), "count_V", sql, values).get(0).get("COUNT").equals("0")) {
				Hashtable<String, String> key = new Hashtable<String, String>();
				key.put("productRelateID", IndexGenerater.getTableIndex("productRelate", getConnection()));
				key.put("productID1", productID);
				key.put("productID2", productIDTmp);
				
				DBProxy.insert(getConnection(), "productRelate", key);
			}
		}
		
		setFormData("action", "productRelateList");
	}
	
	public void deleteProductRelateAction() throws Exception {
		setFormData("action", "productRelateList");
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("productRelateID", getFormData("productRelateID"));
		DBProxy.delete(getConnection(), "productRelate", k);
	}
	
	public void batchUpdateProductTagWindowAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (selectedValues.equals("")) {
			setErrorMessage("请选择要修改的商品");
			setReDispath();
			return;
		}
		
		setFormData("productTagSelect", makeSelectElementString("productTagID", 
				getConstantValues(getConnection(), "c_productTag"), "c_productTagID", "c_productTagName", ""));
	}
	
	public void batchUpdateProductTagAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (selectedValues.equals("")) {
			setErrorMessage("请选择要修改的商品");
			return;
		}
		
		StringBuffer sbf = new StringBuffer();
		Vector<String> value = new Vector<String>();
		value.add(getFormData("productTagID"));
		String[] productIDs = selectedValues.split(",");
		for (int i = 0; i < productIDs.length; i++) {
			sbf.append(i == 0 ? "?" : ",?");
			value.add(productIDs[i]);
		}
		
		String sql = "update product set productTagID = ? where productID in (" + sbf.toString() + ")";
		DBProxy.update(getConnection(), "product", sql, value);
		
		setAjaxJavascript("alert('操作成功');closeInfoWindow();postModuleAndAction('product', 'defaultView')");
	}
	
	public void changeEnableAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (selectedValues.endsWith(",")) {
			selectedValues = selectedValues.substring(0, selectedValues.length());
		}
		if (selectedValues.equals("")) {
			setErrorMessage("请选择一个商品");
			return;
		}
		
		StringBuffer sbf = new StringBuffer();
		Vector<String> value = new Vector<String>();
		value.add("1");
		String[] productIDs = selectedValues.split(",");
		for (int i = 0; i < productIDs.length; i++) {
			sbf.append(i == 0 ? "?" : ",?");
			value.add(productIDs[i]);
		}
	
		String sql = "update product set validFlag = ? where productID in (" + sbf.toString() + ")";
		DBProxy.update(getConnection(), "product", sql, value);
		
		setAjaxJavascript("alert('操作成功');postModuleAndAction('product', 'defaultView')");
	}
	
	public void changeDisableAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (selectedValues.endsWith(",")) {
			selectedValues = selectedValues.substring(0, selectedValues.length());
		}
		if (selectedValues.equals("")) {
			setErrorMessage("请选择一个商品");
			return;
		}
		
		StringBuffer sbf = new StringBuffer();
		Vector<String> value = new Vector<String>();
		value.add("0");
		String[] productIDs = selectedValues.split(",");
		for (int i = 0; i < productIDs.length; i++) {
			sbf.append(i == 0 ? "?" : ",?");
			value.add(productIDs[i]);
		}
		
		String sql = "update product set validFlag = ? where productID in (" + sbf.toString() + ")";
		DBProxy.update(getConnection(), "product", sql, value);
		
		setAjaxJavascript("alert('操作成功');postModuleAndAction('product', 'defaultView')");
	}
	
	private void setProductSkuPropInfo() {
		String[] skuPropInfoArray = StringUtil.split(getFormData("skuPropInfo"), ";");
		String skuPropIDs = "";
		for (int i = 0; i < skuPropInfoArray.length; ++i) {
			String skuPropInfo = skuPropInfoArray[i];
			String[] elements = StringUtil.split(skuPropInfo, ":");
			String skuPropID = elements[0];
			String skuPropValueIDs = elements.length == 2 ? elements[1] : "";
			setFormData("skuPropValueIDs_" + skuPropID, skuPropValueIDs);
			skuPropIDs += ((i == 0 ? "" : ",") + skuPropID);
		}
		setFormData("skuPropIDs", skuPropIDs);
	}
	
	private void setProductSkuPropValueAlias() {
		String[] skuPropValueAliasArray = StringUtil.split(getFormData("skuPropValueAlias"), ";");
		for (int i = 0; i < skuPropValueAliasArray.length; ++i) {
			String[] elements = StringUtil.split(skuPropValueAliasArray[i], ",");
			if (elements.length > 1) {
				String skuPropValueID = elements[0];
				String skuPropValueAlias = elements[1];
				setFormData("alias_" + skuPropValueID, skuPropValueAlias);
			}
		}
	}
	
	private void setProductSkuPropValueImg() {
		String[] skuPropValueImgArray = StringUtil.split(getFormData("skuPropValueImg"), ";");
		for (int i = 0; i < skuPropValueImgArray.length; ++i) {
			String[] elements = StringUtil.split(skuPropValueImgArray[i], ",");
			if (elements.length > 1) {
				String skuPropValueID = elements[0];
				String skuPropValueImg = elements[1];
				setFormData("skuImg_" + skuPropValueID, skuPropValueImg);
			}
		}
	}
	
	private void setSkuInfo() throws Exception {
		Hashtable<String, Hashtable<String, String>> skuHash = new Hashtable<String, Hashtable<String,String>>();
		if (!getFormData("productID").equals("")) {
			Hashtable<String, String> skuK = new Hashtable<String, String>();
			skuK.put("productID", getFormData("productID"));
			skuK.put("defaultFlag", "0");
			Vector<Hashtable<String, String>> skus = DBProxy.query(getConnection(), "sku", skuK);
			for (int i = 0; i < skus.size(); ++i) {
				skuHash.put(skus.get(i).get("props"), skus.get(i));
			}
		}
		
		String skuPropIDs = getFormData("skuPropIDs");
		String[] skuPropIDArray = StringUtil.split(skuPropIDs, ",");
		String[][] skuPropID_skuPropValueID = new String[skuPropIDArray.length][];
		
		for (int i = 0; i < skuPropIDArray.length; ++i) {
			String skuPropID = skuPropIDArray[i];
			String skuPropValueIDs = getFormData("skuPropValueIDs_" + skuPropID);
			String[] skuPropValueIDArray = StringUtil.split(skuPropValueIDs, ",");
			String[] skuPropID_skuPropValueIDArray = new String[skuPropValueIDArray.length];
			for (int j = 0; j < skuPropValueIDArray.length; ++j) {
				skuPropID_skuPropValueIDArray[j] = skuPropID + ":" +  skuPropValueIDArray[j];
			}
			skuPropID_skuPropValueID[i] = skuPropID_skuPropValueIDArray;
		}
		
		
		Vector<Hashtable<String, String>> newSkus = new Vector<Hashtable<String,String>>();
		String[] skuCombination = getCombination(skuPropID_skuPropValueID);
		for (int i = 0; i < skuCombination.length; ++i) {
			String skuProps = skuCombination[i];
			Hashtable<String, String> newSku = new Hashtable<String, String>();
			if (skuHash.get(skuProps) == null) {
				newSku.put("skuID", skuProps);
				newSku.put("price", getFormData("skuPrice_" + skuProps).equals("") ? getFormData("price") : getFormData("skuPrice_" + skuProps));
				newSku.put("settlementPrice", getFormData("skuSettlementPrice_" + skuProps).equals("") ? getFormData("settlementPrice") : getFormData("skuSettlementPrice_" + skuProps));
				newSku.put("stock", getFormData("skuStock_" + skuProps));
				newSku.put("props", skuProps);
				newSku.put("barCode", getFormData("skuBarCode_" + skuProps));
			} else {
				newSku = skuHash.get(skuProps);
			}
			newSkus.add(newSku);
		}
		setJSPData("skus", newSkus);
	}
	
	private  String[] getCombination(String[][] a) {
		String[] curArray = new String[0];
		for (int i = 0; i < a.length; ++i) {
			curArray = getCombination(curArray, a[i]);
		}
		
		return curArray;
	}
	
	private  String[] getCombination(String[] a, String [] b) {
		if (a.length == 0) {
			return b;
		}
		
		if (b.length == 0) {
			return a;
		}
		
		String[] result = new String[(a.length == 0 ? 1 : a.length) * (b.length == 0 ? 1 : b.length)];
		int index = 0;
		for (int i = 0; i < a.length; ++i) {
			for (int j = 0; j < b.length; ++j) {
				String c = a[i] + "," + b[j];
				result[index++] = c;
			}
		}
		
		return result;
	}
	
	public void skuListAction() throws Exception {
	}
	
	public void skuSettingAction() throws Exception {
		setSkuInfo();
		dispatch("product/skuSetting.jsp");
	}
	
	public void confirmSkuAction() throws Exception {
		CheckList list = getChecklist();
		Hashtable<String, String> formDatas = getFormDatas();
		Iterator<String> iter = formDatas.keySet().iterator();
		iter = formDatas.keySet().iterator();
		Hashtable<String, String> barCodeHash = new Hashtable<String, String>();
		while (iter.hasNext()) {
			String k = iter.next();
			if (k.startsWith("sku_")) {
				String skuID = k.replace("sku_", "");
				String settlementPrice = "skuSettlementPrice_" + skuID;
				String priceID = "skuPrice_" + skuID;
				String stockID = "skuStock_" + skuID;
				String barCode = getFormData("skuBarCode_" + skuID);
				if (!barCode.equals("")) {
					if (barCodeHash.get(barCode) != null) {
						setErrorMessage("商品条码" + barCode + "重复");
						setFocusItem("skuBarCode_" + skuID);
						return;
					} else {
						barCodeHash.put(barCode, barCode);
					}
					if (isExistsBarCode(barCode, "", skuID)) {
						setErrorMessage("商品条码" + barCode + "已存在");
						setFocusItem("skuBarCode_" + skuID);
						return;
					}
				}
				list.addCheckItem(new PriceCheckItem(settlementPrice, "sku结算价", false));
				list.addCheckItem(new PriceCheckItem(priceID, "sku价格", false));
				list.addCheckItem(new IntegerCheckItem(stockID, "sku库存", false));
			}
		}
		
		if (!list.check()) {
			return;
		}
		
		
		
		if (!checkSkuProps()) {
			return;
		}
		
		saveOrUpdateSku();
		
		setAjaxJavascript("postModuleAndAction('product', 'list')");
	}
	
	private boolean checkSkuProps() throws Exception {
		Hashtable<String, String> formDatas = getFormDatas();
		Iterator<String> iter = formDatas.keySet().iterator();
		iter = formDatas.keySet().iterator();
		String skuPropIDs = getFormData("skuPropIDs");
		String[] skuPropIDArray = StringUtil.split(skuPropIDs, ",");
		for (int i = 0; i < skuPropIDArray.length; ++i) {
			if (getFormData("skuPropValueIDs_" + skuPropIDArray[i]).equals("")) {
				setErrorMessage("请选择" + LocalDataCache.getInstance().getTableDataColumnValue("skuProp", skuPropIDArray[i], "name") + "的属性值");
				return false;
			}
		}
		while (iter.hasNext()) {
			String aliasK = iter.next();
			if (aliasK.startsWith("alias_")) {
				String skuPropValueID = aliasK.replace("alias_", "");
				String skuPropValueName = LocalDataCache.getInstance().getTableDataColumnValue("skuPropValue", skuPropValueID, "name");
				if (getFormData(aliasK).indexOf(",") != -1 
						 || getFormData(aliasK).indexOf(":") != -1
						 || getFormData(aliasK).indexOf(";") != -1) {
					setErrorMessageAndFocusItem(skuPropValueName + "的属性名不能包含,号和:号;号", aliasK);
					return false;
				}
			}
		}
		
		return true;
	}
	
	public void saveOrUpdateSku() throws Exception {
		setFormDataOfSkuPropInfos();
		
		String productID = getFormData("productID");
		
		Hashtable<String, String> productK = new Hashtable<String, String>();
		productK.put("productID", productID);
		
		Hashtable<String, String> product = DBProxy.query(getConnection(), "product", productK).get(0);
		
		getFormDatas().remove("detailInfo");
		DBProxy.update(getConnection(), "productDetailInfo", productK, getFormDatas());
		
		Hashtable<String, String> formDatas = getFormDatas();
		Iterator<String> iter = formDatas.keySet().iterator();
		
		StringBuffer allSkuIDs = new StringBuffer();
		while (iter.hasNext()) {
			String k = iter.next();
			if (k.startsWith("sku_")) {
				String skuID = k.replace("sku_", "");
				String props = getFormData("skuProp_" + skuID);
				String settlementPrice = getFormData("skuSettlementPrice_" + skuID);
				String price = getFormData("skuPrice_" + skuID);
				String barCode = getFormData("skuBarCode_" + skuID);
				if (price.equals("")) {
					price = product.get("price");
				}
				String stock = getFormData("skuStock_" + skuID);
				if (stock.equals("")) {
					stock = "0";
				}
				String validFlag = "1";

				Hashtable<String, String> skuK = new Hashtable<String, String>();
				skuK.put("skuID", skuID);
				if (DBProxy.query(getConnection(), "sku", skuK).size() == 0) {
					Hashtable<String, String> data = new Hashtable<String, String>();
					String newSkuID = IndexGenerater.getTableIndex("sku", getConnection());
					allSkuIDs.append("," + newSkuID);
					data.put("skuID", newSkuID);
					data.put("productID", productID);
					data.put("props", props);
					data.put("barCode", barCode);
					data.put("settlementPrice", settlementPrice);
					data.put("price", price);
					data.put("stock", stock);
					data.put("validFlag", validFlag);
					data.put("defaultFlag", "0");
					DBProxy.insert(getConnection(), "sku", data);

				} else {
					allSkuIDs.append("," + skuID);
					Hashtable<String, String> data = new Hashtable<String, String>();
					data.put("props", props);
					data.put("barCode", barCode);
					data.put("settlementPrice", settlementPrice);
					data.put("price", price);
					data.put("stock", stock);
					DBProxy.update(getConnection(), "sku", skuK, data);
				}
			}
		}
		String allSkuIDsStr = allSkuIDs.toString().replaceFirst(",", "");
		if (!allSkuIDsStr.equals("")) {
			String delSkuSql = "and skuID not in(" + allSkuIDsStr + ")";
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("productID", productID);
			DBProxy.delete(getConnection(), "sku", k, delSkuSql);
		} else {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("productID", productID);
			k.put("defaultFlag", "0");
			DBProxy.delete(getConnection(), "sku", k);
			
			insertDefaultSku(productID, product.get("productCode"), 
					product.get("stock"), product.get("price"), "");
		}
//		StockBillTool.resetProductStockNumber(getConnection(), productID);
		resetProductPrice(productID);
	}
	
	private void setFormDataOfSkuPropInfos() {
		String skuPropIDs = getFormData("skuPropIDs");
		String[] skuPropIDArray = StringUtil.split(skuPropIDs, ",");
		StringBuffer skuPropInfo = new StringBuffer();
		StringBuffer skuPropValueAlias = new StringBuffer();
		StringBuffer skuPropValueImg = new StringBuffer();
		for (int i = 0; i < skuPropIDArray.length; ++i) {
			String skuPropID = skuPropIDArray[i];
			String skuPropValueIDs = getFormData("skuPropValueIDs_" + skuPropID);
			skuPropInfo.append(i != 0 ? ";" : "").append(skuPropID + ":" + skuPropValueIDs);
			String[] skuPropValueIDArray = StringUtil.split(skuPropValueIDs, ",");
			for (int j = 0; j < skuPropValueIDArray.length; ++j) {
				String skuPropValueID = skuPropValueIDArray[j];
				String alias = getFormData("alias_" + skuPropValueID);
				String skuImg = getFormData("skuImg_" + skuPropValueID);
				if (!alias.equals("")) {
					skuPropValueAlias.append(!skuPropValueAlias.toString().equals("") ? ";" : "").append(skuPropValueID).append(",").append(alias);
				}
				if (!skuImg.equals("")) {
					skuPropValueImg.append(!skuPropValueImg.toString().equals("") ? ";" : "").append(skuPropValueID).append(",").append(skuImg);
				}
			}
		}
		setFormData("skuPropInfo", skuPropInfo.toString());
		setFormData("skuPropValueAlias", skuPropValueAlias.toString());
		setFormData("skuPropValueImg", skuPropValueImg.toString());
	}
	
	public void selectProductImageWindowAction() throws Exception {
		setJSPData("productImages", getProductImages(getFormData("productID")));
	}
	
	public void uploadSkuImageAction() throws Exception {
		String imageNameHolderID = getFormData("imageNameHolderID");
		String imageName = getFormData(imageNameHolderID);
		if (imageName.equals("")) {
			setAjaxJavascript("alert('请选择一张图片')");
			return;
		}
		String dir = AppKeys.UPLOAD_FILE_PATH + File.separator +  "product"
				+ File.separator;
		resizeSkuPicture(dir, new File(dir + imageName));
		
		setAjaxJavascript("closeInfoWindow()");
	}
	
	public void batchAuditProductWindowAction() throws Exception {
	}
	
	public void auditProductWindowAction() throws Exception {
		if (getFormData("product_opt").equals("hasAudit")) {
		String productID = getFormData("productID");
		String dataID = productID; 
		String sql1 = "select * from product where productID = ? and deletedFlag = ? ";
		String sql2 = "select * from auditlog where dataID = ? order by auditTime desc";
		Vector<String> values1 = new Vector<String>();
		Vector<String> values2 = new Vector<String>();
		values1.add(productID);
		values1.add("0");
		values2.add(dataID);
		Vector<Hashtable< String, String>> datas111 = 
			DBProxy.query(getConnection(), "product", sql1, values1);
		setJSPData("datas111", datas111);
		Vector<Hashtable< String, String>> datas112 = 
			DBProxy.query(getConnection(), "auditlog", sql2, values2);
		setJSPData("datas112", datas112);
		}
		
		
	}
	
	public void batchAuditProductAction() throws Exception {
		String selectedValues = getFormData("selectedValues");
		if (selectedValues.equals("")) {
			setAjaxInfoMessage("请选择要审核的商品");
			return;
		}
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("auditStatus", "审核结果", true));
		if (!list.check()) {
			return;
		}
		
		String[] productIDs = StringUtil.split(selectedValues, ",");
		for (int i = 0; i < productIDs.length; ++i) {
			String productID = productIDs[i];
			if (!auditProduct(productID, getFormData("auditStatus"), getFormData("auditNote"))) {
				setAjaxJavascript("alert('商品" + productID + "审核失败，将忽略后续的审核动作');closeInfoWindow();postModuleAndAction('product', 'list')");
				return;
			}
		}
		
		setAjaxJavascript("alert('审核完成');closeInfoWindow();postModuleAndAction('product', 'list')");
	}
	
	public void auditProductAction() throws Exception {
		String productID = getFormData("productID");
		if (productID.equals("")) {
			setAjaxInfoMessage("请选择要审核的商品");
			return;
		}
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("auditStatus", "审核结果", true));
		if (!list.check()) {
			return;
		}
		if (!auditProduct(productID, getFormData("auditStatus"), getFormData("auditNote"))) {
			setAjaxJavascript("alert('审核失败');closeInfoWindow();postModuleAndAction('product', 'list')");
			return;
		}
		if (getFormData("auditStatus").equals("20")) {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("auditStatus", getFormData("auditStatus"));
			Hashtable<String, String> value = new Hashtable<String, String>();
			value.put("validFlag", "1");
			DBProxy.update(getConnection(), "product", k, value);
			
		} else if (getFormData("auditStatus").equals("90")) {
			Hashtable<String, String> k = new Hashtable<String, String>();
			k.put("auditStatus", getFormData("auditStatus"));
			Hashtable<String, String> value = new Hashtable<String, String>();
			value.put("validFlag", "0");
			DBProxy.update(getConnection(), "product", k, value);
		}
		setAjaxJavascript("alert('审核完成');closeInfoWindow();postModuleAndAction('product', 'list')");
	}
	
	private boolean auditProduct(String productID, String auditStatus, String auditNote) throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("productID", productID);
		k.put("auditStatus", "10");
		Hashtable<String, String> v = new Hashtable<String, String>();
		v.put("auditStatus", auditStatus);
		int count = DBProxy.update(getConnection(), "product", k, v);
		if (count > 0) {
			insertAuditLog("1", (auditStatus.equals("20") ? "1" : "0"), auditNote, productID);
		}
		return count > 0;
	}
	
	private void makePriceDatas(String priceDetail) throws Exception {
		Vector<Hashtable<String, String>> priceDatas = new Vector<Hashtable<String,String>>();
		if (priceDetail.equals("")) {
			Hashtable<String, String> priceData = new Hashtable<String, String>();
			priceData.put("id", System.currentTimeMillis() + "");
			priceData.put("number", "1");
			priceData.put("price", "");
			priceDatas.add(priceData);
		} else {
			priceDatas = JSON.parseObject(priceDetail, new TypeReference<Vector<Hashtable<String, String>>>(){});
		}
		
		setJSPData("priceDatas", priceDatas);
	}
	
	public void confirmRecommendAction() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("recommendReason", "推荐理由", true));
		list.addCheckItem(new IntegerCheckItem("recommendNum", "推荐指数", true));
		if(!list.check()) {
			return;
		}
		Hashtable<String, String> keys = new Hashtable<String, String>(); 
		keys.put("productID", getFormData("productID"));
		Hashtable<String, String> values = new Hashtable<String, String>(); 
		values.put("isRecommendFlag", "1");
		values.put("recommendReason", getFormData("recommendReason"));
		values.put("recommendNum", getFormData("recommendNum"));
		DBProxy.update(getConnection(), "product", keys, values);
		setAjaxJavascript("alert('推荐成功');closeInfoWindow('infoWindow');");
	}
	
	public void cancelRecommendAction() throws Exception {
		Hashtable<String, String> keys = new Hashtable<String, String>(); 
		keys.put("productID", getFormData("productID"));
		Hashtable<String, String> values = new Hashtable<String, String>(); 
		values.put("isRecommendFlag", "0");
		values.put("recommendReason", "");
		values.put("recommendNum", "");
		DBProxy.update(getConnection(), "product", keys, values);
		setAjaxJavascript("alert('取消推荐成功');closeInfoWindow('infoWindow');");
	}
	
	public void recommendProductWindowAction() throws Exception {
		getData("product", DATA_TYPE_TABLE);
	}
	
	public void exportProductWindowAction() throws Exception {
		setFormData("productColumns-6", "," + getCookieData("productColumnGroup6").replace("$", ",") + ",");
	}
	
	public void exportAction() throws Exception {
		String columnGroup6 = getFormData("productColumns-6");
		String columns = "," + columnGroup6 + ",";
		String[] columnArray = StringUtil.split(columns, ",");
		if (columnArray.length == 0) {
			setAjaxJavascript("toastr.error('请选择要导出的列');$('#confirmBut').css('display', '');$('#hasNotSend_img').css('display', 'none');");
			return;
		}
		
		Cookie columnGroup6Cookie = new Cookie("productColumnGroup6", columnGroup6.replace(",", "$"));
		columnGroup6Cookie.setMaxAge(30 * 24 * 60 * 60);
		setCookieData(columnGroup6Cookie);
		
		Vector<String> exportColumnsInfo = new Vector<String>();
		for (int i = 0; i < columnArray.length; ++i) {
			String tmpColumn = columnArray[i];
			if (tmpColumn.equals("productID")) {
				exportColumnsInfo.add("商品ID-" + tmpColumn);
			} else if (tmpColumn.equals("name")) {
				exportColumnsInfo.add("商品名称-" + tmpColumn);
			} else if (tmpColumn.equals("supplierName")) {
				exportColumnsInfo.add("供应商-" + tmpColumn);
			} else if (tmpColumn.equals("productTypeName")) {
				exportColumnsInfo.add("商品分类-" + tmpColumn);
			} else if (tmpColumn.equals("brandName")) {
				exportColumnsInfo.add("品牌-" + tmpColumn);
			} else if (tmpColumn.equals("productCode")) {
				exportColumnsInfo.add("商品条码-" + tmpColumn);
			} else if (tmpColumn.equals("normalPrice")) {
				exportColumnsInfo.add("市场价-" + tmpColumn);
			} else if (tmpColumn.equals("price")) {
				exportColumnsInfo.add("商城价-" + tmpColumn);
			} else if (tmpColumn.equals("costPrice")) {
				exportColumnsInfo.add("成本价-" + tmpColumn);
			} else if (tmpColumn.equals("viewCount")) {
				exportColumnsInfo.add("浏览量-" + tmpColumn);
			} else if (tmpColumn.equals("stock")) {
				exportColumnsInfo.add("库存-" + tmpColumn);
			}  
		}
		
		String extendSql = "";
		if (getFormData("product_opt").equals("waitAudit")) {
			setFormData("q_auditStatus", "10");
		} else if (getFormData("product_opt").equals("hasAudit")) {
			extendSql = " auditStatus in (20, 90)";
		} else {
			setFormData("q_auditStatus", "20");
		}
		setFormData("q_deletedFlag", "0");
		initPageByQueryDataList("product_V", getFormDatas(), "datas", extendSql, new Vector<String>(), "order by productID desc");
		
		Vector<Hashtable<String, String>> exportProducts = new Vector<Hashtable<String,String>>();
		int pageCount = Integer.parseInt(getFormData("pageCount"));
		Vector<Hashtable<String, String>> firstPageDatas = (Vector<Hashtable<String, String>>) getJSPData("datas");
		exportProducts.addAll(firstPageDatas);
		
		for (int i = 2; i <= pageCount; ++i) {
			setFormData("pageIndex", i + "");
			initPageByQueryDataList("product_V", getFormDatas(), "datas", extendSql, new Vector<String>(), "order by productID desc");
			Vector<Hashtable<String, String>> curPageDatas = (Vector<Hashtable<String, String>>) getJSPData("datas");
			exportProducts.addAll(curPageDatas);
		}
		
		dealData(exportProducts);
		String fileName = ExcelUtils.export("导出商品", exportColumnsInfo, exportProducts);
		
		if(fileName == null) {
			setAjaxJavascript("toastr.error('导出失败，请重试');$('#confirmBut').css('display', '');$('#hasNotSend_img').css('display', 'none');");
			return;
		}
		String fileDirName = "default/tmp";
		String downLoadDir = "location.href='/download?dir=" + fileDirName + "&fileName=" + fileName + "'";
		setAjaxJavascript(downLoadDir + ";$('#confirmBut').css('display', '');$('#hasNotSend_img').css('display', 'none');");
	}
	
	private void dealData(Vector<Hashtable<String, String>> datas) throws Exception {
		for (Hashtable<String, String> data : datas) {
			data.put("productTypeName", data.get("bigTypeName") + "-" + data.get("smallTypeName") + "-" + data.get("tinyTypeName"));
		}
	}
	
	public void disableStatusAction() throws Exception {
		changeValidFlag(getFormData("module"), "10", true);
	}
	
	public void enableStatusAction() throws Exception {
		changeValidFlag(getFormData("module"), "20", true);
	}
	
	public void changeValidFlag(String tableName, String auditStatus,
			boolean setListAction) throws Exception {
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put(tableName + "ID", getFormData(tableName + "ID"));

		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("auditStatus", auditStatus);

		DBProxy.update(getConnection(), tableName, key, value);
		if (setListAction) {
			listAction();
		}
	}
}
