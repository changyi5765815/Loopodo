package admin.customer.guanwangbao;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import admin.customer.guanwangbao.processor.BaseProcessor;

import simpleWebFrame.config.AppConfig;
import simpleWebFrame.database.DBConnectionPool;
import simpleWebFrame.database.DBProxy;
import simpleWebFrame.database.IndexGenerater;
import simpleWebFrame.util.DateTimeUtil;
import simpleWebFrame.util.FileUtil;
import simpleWebFrame.util.StringUtil;


public class BatchUploadImageSeverlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException {

		// 解析参数
		Hashtable<String, String> formDatas = new Hashtable<String, String>();
		Vector<File> uploadFiles = new Vector();
		try {
			String str1 = AppConfig.getInstance().getApplicationRoot() + File.separator + "upload" + File.separator;
			DiskFileItemFactory localDiskFileItemFactory = new DiskFileItemFactory();
			localDiskFileItemFactory.setRepository(new File(str1 + "tmp"));
			localDiskFileItemFactory.setSizeThreshold(4194304);
			ServletFileUpload localServletFileUpload = new ServletFileUpload(localDiskFileItemFactory);
			localServletFileUpload.setHeaderEncoding("UTF-8");
			List localList = localServletFileUpload.parseRequest(request);
			Iterator localIterator = localList.iterator();
			while (localIterator.hasNext()) {
				FileItem localFileItem = (FileItem) localIterator.next();
				 if (!localFileItem.isFormField()) {
					if (localFileItem.getName().equals(""))
						continue;
					File localFile = new File(str1 + getNewFileName(localFileItem.getName()));
					localFileItem.write(localFile);
					String str2 = localFileItem.getName();
					if ((str2.toLowerCase().endsWith(".jsp")) || (str2.toLowerCase().endsWith(".bat"))
							|| (str2.toLowerCase().endsWith(".exe")))
						localFile.delete();
					else
						uploadFiles.add(localFile);
				} else {
					formDatas.put(localFileItem.getFieldName(), localFileItem.getString("UTF-8").trim());
				}
			}
		} catch (Exception e) {
			
		}
		
		String res = "";
		Connection con = null;
		try {
			con = DBConnectionPool.getInstance().getConnection();
			con.setAutoCommit(false);
			String type = formDatas.get("type");
			if ("product".equals(type)) {
				res = uploadProductImage(request, formDatas, uploadFiles, con);
			}
			con.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (con != null)
				try {
					con.rollback();
					con.close();
				} catch (Exception localException3) {
				}
		}
		
		String url = "url";
		String title = "title";
		String state = "state";
		if (res.equals("")) {
			state = "SUCCESS";
		} else {
			url = "url上传的图片有误";
			title = "title上传的图片有误";
			state = res;
		}
		String info = "{'url':'" + url + "','title':'" + title + "','state':'" + state + "'}";
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(info);
	}
	
	/**
	 * 上传产品图片
	 * @param request
	 * @param formDatas
	 * @param uploadFiles
	 * @param con
	 * @return
	 * @throws Exception
	 */
	private String uploadProductImage(HttpServletRequest request, Hashtable<String, String> formDatas, Vector<File> uploadFiles, Connection con) throws Exception {
		String productID = formDatas.get("productID");
		for (int i = 0; i < uploadFiles.size(); ++i) {
			if (!isImageFile(uploadFiles.get(i))) {
				uploadFiles.get(i).delete();
				return "上传的图片格式有误，目前只支持.jpg、.jpeg、.png、.gif格式图片";
			}
		}
		Hashtable<String, String> key = new Hashtable<String, String>();
		key.put("productID", productID);
		int imageCount = BaseProcessor.getCountValue(con, "productImage", "*", key);
		
		if (imageCount >= AppKeys.MAX_PRODUCT_IMAGES) {
			uploadFiles.get(0).delete();
			return "一个商品最多能上传" + AppKeys.MAX_PRODUCT_IMAGES + "图片";
		}
		
		String dirName = "product";
		String imageDir = AppKeys.UPLOAD_FILE_PATH + File.separator + dirName 
		+ File.separator;
		File f = new File(imageDir);
		if (!f.exists()) {
			f.mkdirs();
		}
		
		FileUtil.moveFile(uploadFiles.get(0), imageDir);
		
		BaseProcessor.resizeProductPicture(imageDir, uploadFiles.get(0));
		
		Hashtable<String, String> value = new Hashtable<String, String>();
		value.put("productImageID", IndexGenerater.getTableIndex("productImage", con));
		value.put("productID", productID);
		value.put("image", "product/" + uploadFiles.get(0).getName());
		value.put("addTime", DateTimeUtil.getCurrentDateTime());
		value.put("mainFlag", imageCount == 0 ? "1" : "0");
		value.put("sortIndex", "1");
		DBProxy.insert(con, "productImage", value);
		
		if (imageCount == 0) {
			BaseProcessor.updateProductMainImage(con, productID);
		}
		
		return "";
	}
	
	public boolean isImageFile(File f) {
		String fileName = f.getName().toLowerCase();
		if (!fileName.endsWith(".jpeg") && !fileName.endsWith(".gif")
				&& !fileName.endsWith(".png")
				&& !fileName.endsWith(".jpg")) {
			f.delete();
			return false;
		}
		return true;
	}

	/**
	 * 重新命名图片
	 * @param paramString
	 * @return
	 * @throws Exception
	 */
	private String getNewFileName(String paramString) throws Exception {
		int i = paramString.lastIndexOf('.');
		String str = StringUtil.getRandomString(10);
		return str + DateTimeUtil.getCurrentDateTime().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")
				+ paramString.substring(i);
	}
}
