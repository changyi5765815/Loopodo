package admin.customer.guanwangbao.processor;

import java.io.File;

import simpleWebFrame.config.Module;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.util.PictureUtil;
import simpleWebFrame.web.CheckList;
import simpleWebFrame.web.DataHandle;
import simpleWebFrame.web.validate.StringCheckItem;
import admin.customer.guanwangbao.AppKeys;
import admin.customer.guanwangbao.AppUtil;

public class SupplierThemeProcessor extends BaseProcessor {

	public SupplierThemeProcessor(Module module, DataHandle dataHandle) {
		super(module, dataHandle);
	}

	@Override
	public void makeView() throws Exception {
		if (getFormData("action").equals("list")) {
			setJSPData("datas", DBProxy.query(getConnection(), "supplierTheme"));
		}
	}
	
	public void defaultViewAction() throws Exception {
		listAction();
	}
	
	public void editeViewAction() throws Exception {
		getData("supplierTheme", DATA_TYPE_TABLE);
	}
	
	public void addViewAction() throws Exception {
		String[] datas = {"supplierThemeID"}; 
		clearDatas(datas);
	}
	
	public boolean confirmActionCheck() throws Exception {
		CheckList che = getChecklist();
		che.addCheckItem(new StringCheckItem("name", "名称", true));
		che.addCheckItem(new StringCheckItem("image", "图片", true));
		che.addCheckItem(new StringCheckItem("content", "内容", true));
		return che.check();
	}
	
	public void confirmAction() throws Exception {
		String oldImage = getFormData("oldImage");
		String image = getFormData("image");
		if(!image.equals("") && !oldImage.equals(image)) {
			resizePicture(AppKeys.UPLOAD_FILE_PATH + File.separator, image);
		}
		
		if (getFormData("supplierThemeID").equals("")) {
			setFormData("validFlag", "1");
		}
		confirmValue("supplierTheme");
		
		listAction();
	}
	
	private void resizePicture(String imageDir, String imgFileName) throws Exception {
		String srcImage = imageDir + imgFileName;
		String destImage = imageDir + AppUtil.getDirName(imgFileName) 
				+ File.separator + AppKeys.SUPPLIER_THEME_IMAGE_SIZE + "_" + AppUtil.getFileName(imgFileName);
		if (!(new File(destImage).exists())) {
			PictureUtil.resizePicture(srcImage, destImage, AppKeys.SUPPLIER_THEME_IMAGE_SIZE);
		}
	}
}
