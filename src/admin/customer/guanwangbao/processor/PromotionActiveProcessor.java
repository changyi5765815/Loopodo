package admin.customer.guanwangbao.processor;


import java.util.Hashtable;
import java.util.Vector;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.PriceCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.LocalDataCache;

public class PromotionActiveProcessor extends BaseProcessor {
	public PromotionActiveProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			String extendSql = "";
			if(getFormData("operationName").equals("0")) {
				extendSql = "supplierID = '0' or supplierID is null";
			} else {
				extendSql = "supplierID != '0'";
			}
			initPageByQueryDataList("promotionActive_V", getFormDatas(), "datas", 
					extendSql, new Vector<String>(), "order by promotionActiveID desc");
//			initPageByQueryDataList("promotionActive", getFormDatas(), "datas", "", new Vector<String>(), "order by promotionActiveTypeID");
		} else if (getFormData("action").equals("confirm")
				|| getFormData("action").equals("addView")
				|| getFormData("action").equals("editView")) {
			String promotionActiveTypeSelect = makeSelectElementString("promotionActiveTypeID", 
					LocalDataCache.getInstance().getTableDatas("c_promotionActiveType"), "c_promotionActiveTypeID", 
					"name", "refreshItem('promotionActive','refreshPromotionActivityPara','promotionActivityParas_div')", "form-control", true, "", "");
			
			setFormData("promotionActiveTypeSelect", promotionActiveTypeSelect);
		}
		
		if (!getFormData("action").equals("list")) {
			setFormData("queryConditionHtml", makeQueryConditionHtml("promotionActive_V"));
		}
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void addViewAction() throws Exception {
		String[] clearFormDatas = {"promotionActiveID"};
		clearDatas(clearFormDatas);
	}
	
	public void editViewAction() throws Exception {
		getData("promotionActive", DATA_TYPE_TABLE);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new IntegerCheckItem("promotionActiveTypeID", "促销活动类型", true));
		list.addCheckItem(new StringCheckItem("name", "活动名称", true));
		String promotionActiveTypeID = getFormData("promotionActiveTypeID");
		if (promotionActiveTypeID.equals("1")) {
			list.addCheckItem(new PriceCheckItem("value", "满多少元", true));
			list.addCheckItem(new PriceCheckItem("value2", "减多少元", true));
		} else if (promotionActiveTypeID.equals("2")) {
			list.addCheckItem(new PriceCheckItem("value", "满多少元", true));
			list.addCheckItem(new PriceCheckItem("value2", "赠多少元", true));
			list.addCheckItem(new PriceCheckItem("value3", "优惠券启用金额", true));
			list.addCheckItem(new PriceCheckItem("value4", "优惠券有效期", true));
		} else if (promotionActiveTypeID.equals("3") || promotionActiveTypeID.equals("4") || promotionActiveTypeID.equals("5")) {
			list.addCheckItem(new PriceCheckItem("value2", "赠多少元", true));
			list.addCheckItem(new PriceCheckItem("value3", "优惠券启用金额", true));
			list.addCheckItem(new PriceCheckItem("value4", "优惠券有效期", true));
		}
		
		if (list.check()) {
			if (promotionActiveTypeID.equals("1")) {
				list.addCheckItem(new PriceCheckItem("value", "满多少元", true));
				list.addCheckItem(new PriceCheckItem("value2", "减多少元", true));
				if (Float.parseFloat(getFormData("value")) <= Float.parseFloat(getFormData("value2"))) {
					setErrorMessage("满多少元的值必须大于减多少元的金额");
					return false;
				}
			} else if (promotionActiveTypeID.equals("2")) {
				list.addCheckItem(new PriceCheckItem("value", "满多少元", true));
				list.addCheckItem(new PriceCheckItem("value2", "赠多少元", true));
				list.addCheckItem(new PriceCheckItem("value3", "优惠券启用金额", true));
				list.addCheckItem(new IntegerCheckItem("value4", "优惠券有效期", true, 1));
				if (Float.parseFloat(getFormData("value")) <= Float.parseFloat(getFormData("value2"))) {
					setErrorMessage("满多少元的值必须大于赠多少元的金额");
					return false;
				}
				
			} else if (promotionActiveTypeID.equals("3") || promotionActiveTypeID.equals("4") || promotionActiveTypeID.equals("5")) {
				list.addCheckItem(new PriceCheckItem("value2", "赠多少元", true));
				list.addCheckItem(new PriceCheckItem("value3", "优惠券启用金额", true));
				list.addCheckItem(new IntegerCheckItem("value4", "优惠券有效期", true, 1));
			}
		}
		
		return list.check();
	}
	
	public void confirmAction() throws Exception {
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("promotionActiveTypeID", getFormData("promotionActiveTypeID"));
		String extendSql = "";
		if (!getFormData("promotionActiveID").equals("")) {
			extendSql = " and promotionActiveID != " + getFormData("promotionActiveID");
		}
		
		if (!getFormData("promotionActiveTypeID").equals("1") && !getFormData("promotionActiveTypeID").equals("2")) {
			Vector<Hashtable<String, String>> promotionActives = DBProxy.query(getConnection(), "promotionActive", k, extendSql);
			if(promotionActives.size() > 0) {
				setErrorMessage("该促销类型活动已存在，不能再添加！");
				return;
			} 
		}
		
		String curTime = DateTimeUtil.getCurrentDateTime();
		setFormData("lastMdfTime", curTime);
		if (getFormData("promotionActiveID").equals("")) {
			setFormData("addTime", curTime);
			setFormData("promotionActiveID", IndexGenerater.getTableIndex("promotionActive", getConnection()));
			setFormData("validFlag", "0");
			DBProxy.insert(getConnection(), "promotionActive", getFormDatas());
		} else {
			k = new Hashtable<String, String>();
			k.put("promotionActiveID", getFormData("promotionActiveID"));
			DBProxy.update(getConnection(), "promotionActive", k, getFormDatas());
		}
		
		
		listAction();
	}
	
	public void deleteAction() throws Exception {
		String promotionActiveID = getFormData("promotionActiveID");
		Hashtable<String, String> keys = new Hashtable<String, String>();
		keys.put("promotionActiveID", promotionActiveID);
		DBProxy.delete(getConnection(), "promotionActive", keys);
		
		listAction();
	}

	public void enableAction() throws Exception {
		listAction();
		
		Hashtable<String, String> k = new Hashtable<String, String>();
		k.put("promotionActiveID", getFormData("promotionActiveID"));
		Vector<Hashtable<String, String>> datas = DBProxy.query(getConnection(), "promotionActive", k);
		if (datas.size() > 0) {
			Hashtable<String, String> data = datas.get(0);
			String promotionActiveTypeID = data.get("promotionActiveTypeID");
			
			if (promotionActiveTypeID.equals("1") || promotionActiveTypeID.equals("2")) {
				String sql = "select count(*) as COUNT from promotionActive where promotionActiveTypeID in (?, ?) "
						+ "and promotionActiveTypeID != ? and validFlag = ?";
				Vector<String> p = new Vector<String>();
				p.add("1");
				p.add("2");
				p.add(promotionActiveTypeID);
				p.add("1");
				int count = Integer.parseInt(DBProxy.query(getConnection(), "count_V", sql, p).get(0).get("COUNT"));
				if (count > 0) {
					setErrorMessage("满减活动、满赠活动两者只能同时开启一种");
					return;
				}
			} 
			
			Hashtable<String, String> v = new Hashtable<String, String>();
			v.put("validFlag", "1");
			DBProxy.update(getConnection(), "promotionActive", k, v);
		}
	}
	
	public void refreshPromotionActivityParaAction() throws Exception {
		dispatch("promotionActivity/promotionActivityPara.jsp");
	}
	
}
