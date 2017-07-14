package admin.customer.guanwangbao;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import simpleWebFrame.log.AppLogger;

public class DownloadEntry extends HttpServlet {
	
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		String fileName = request.getParameter("fileName");
		String dir = request.getParameter("dir");
		
		if (dir.indexOf("..") >= 0 || dir.toLowerCase().indexOf("web-inf") >= 0) {
			throw new ServletException("illegal access!");
		}
		
		if (fileName.indexOf("../") >= 0 || fileName.toLowerCase().indexOf("web-inf") >= 0) {
			throw new ServletException("illegal access!");
		}
		
		String rootPath = AppKeys.UPLOAD_FILE_PATH + File.separator;
		String downloadDir = rootPath + File.separator + dir + File.separator;
		
		response.setContentType("APPLICATION/OCTET-STREAM");
		response.setHeader("Content-Disposition", "attachment; filename=\""
				+ URLEncoder.encode(fileName, "UTF-8") + "\"");

		FileInputStream fileInputStream = null;
		try {
			// 打开指定文件的流信息
			fileInputStream = new java.io.FileInputStream(downloadDir
					+ fileName);

			// 写出流信息
			int i;
			while ((i = fileInputStream.read()) != -1) {
				response.getOutputStream().write(i);
			}
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("error happened when download file: " + fileName, e);
		} finally {
			try {
				if (fileInputStream != null) {
					fileInputStream.close();
				}
			} catch (Exception e) {
			}
			response.getOutputStream().close();
		}
	}

}
