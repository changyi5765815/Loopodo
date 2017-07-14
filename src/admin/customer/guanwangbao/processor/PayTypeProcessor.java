package admin.customer.guanwangbao.processor;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.IntegerCheckItem;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;

public class PayTypeProcessor extends BaseProcessor {

	public PayTypeProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list"));
		setJSPData("datas", DBProxy.query(getConnection(), "payType"));
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void payTypeAddViewAction() throws Exception {
		String[] items = {"payTypeID", "name"};
		clearDatas(items);
	}
	
	public boolean payTypeConfirmActionCheck() throws Exception {
		CheckList list = getChecklist();
		list.addCheckItem(new StringCheckItem("name", "付款方式名称", true));
		list.addCheckItem(new StringCheckItem("image", "付款方式LOGO", false));
		list.addCheckItem(new StringCheckItem("payTypeDisplayTypeIDs", "显示端", true));
		list.addCheckItem(new IntegerCheckItem("onlinePayFlag", "是否在线支付", true));
		
		String payTypeID = getFormData("payTypeID");
		boolean isApliyPay = payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_JSDZ) 
			|| payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_JSDZ_WAP) 
			|| payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_DBJY) 
			|| payTypeID.equals(AppKeys.PAY_TYPE_ID_ALIPAY_SBZ);
		if (isApliyPay) {
			list.addCheckItem(new StringCheckItem("payAccountID", "合作者ID", true));
			list.addCheckItem(new StringCheckItem("payAccountName", "账号邮箱", true));
			list.addCheckItem(new StringCheckItem("payPrivateKey", "密钥", true));
		} else if (payTypeID.equals(AppKeys.PAY_TYPE_ID_WEIXIN) || payTypeID.equals(AppKeys.PAY_TYPE_ID_WEIXIN_APP)) {
			list.addCheckItem(new StringCheckItem("payAccountName", "微信appid", true));
			list.addCheckItem(new StringCheckItem("payPara1", "微信appsecret", true));
			list.addCheckItem(new StringCheckItem("payAccountID", "微信商户支付号", true));
			list.addCheckItem(new StringCheckItem("payPrivateKey", "微信支付商户密钥", true));
		} else if (payTypeID.equals(AppKeys.PAY_TYPE_ID_TENCENT)) {
			list.addCheckItem(new StringCheckItem("payAccountID", "商户号", true));
			list.addCheckItem(new StringCheckItem("payPrivateKey", "密钥", true));
		}
		return list.check();
	}
	
	public void payTypeConfirmAction() throws Exception {
		confirmValue("payType");
		setFormData("action", "list");
	}
	
	public void payTypeEditViewAction() throws Exception {
		getData("payType", DATA_TYPE_TABLE);
	}
	
	public void payTypeDisableAction() throws Exception {
		changeValidFlag("payType", "0");
	}
	
	public void payTypeEnableAction() throws Exception {
		changeValidFlag("payType", "1");
	}
}
