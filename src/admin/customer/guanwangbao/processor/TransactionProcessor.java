package admin.customer.guanwangbao.processor;

import java.util.Vector;

import admin.customer.guanwangbao.AppKeys;

import simpleWebFrame.config.Module;
import simpleWebFrame.web.DataHandle;

public class TransactionProcessor extends BaseProcessor {
	public TransactionProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			String q_fromPayTime = getFormData("q_fromPayTime");
			String q_toPayTime = getFormData("q_toPayTime");
			if (!getFormData("q_fromPayTime").equals("")) {
				setFormData("q_fromPayTime", getFormData("q_fromPayTime") + " 00:00:00");
			}
			if (!getFormData("q_toPayTime").equals("")) {
				setFormData("q_toPayTime", getFormData("q_toPayTime") + " 23:59:59");
			}
			String sortSql = getFormData(AppKeys.ORDER_SQL);
			if (sortSql.equals("")) {
				sortSql = "order by transactionID desc";
			}
			initPageByQueryDataList("transaction", getFormDatas(), "datas", "", 
					new Vector<String>(), sortSql);
			
			setFormData("queryPayTypeSelect", getQueryPayTypeSelect());
			setFormData("q_fromPayTime", q_fromPayTime);
			setFormData("q_toPayTime", q_toPayTime);
			setFormData("queryTransactionStatusSelect", getQueryTransactionStatusSelect());
			setFormData("queryTransactionTypeSelect", getQueryTransactionTypeSelect());
		}
		if (!getFormData("action").equals("list")) { 
			setFormData("queryConditionHtml", makeQueryConditionHtml("transaction"));
		}
	}

	public void defaultViewAction() throws Exception {
		listAction();
	}
	
}
