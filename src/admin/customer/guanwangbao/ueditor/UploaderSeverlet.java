package admin.customer.guanwangbao.ueditor;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import admin.customer.guanwangbao.AppKeys;

public class UploaderSeverlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException {
		String uri = request.getRequestURI();

		try {
			if (uri.equals("/ueditor/upload/image")) {
				imageUp(request, response);
			} else if (uri.equals("/ueditor/upload/scrawl")) {
				scrawlUp(request, response);
			} else if (uri.equals("/ueditor/upload/file")) {
				fileUp(request, response);
			} else if (uri.equals("/ueditor/upload/catcher")) {
				getRemoteImage(request, response);
			} else if (uri.equals("/ueditor/upload/imageManage")) {
				imageManager(request, response);
			} else if (uri.equals("/ueditor/upload/movie")) {
				getMovie(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void imageUp(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding(UploaderTool.ENCODEING);
		response.setCharacterEncoding(UploaderTool.ENCODEING);

		List<String> savePath = new ArrayList<String>();
		savePath.add("image");

		//获取存储目录结构
		if (request.getParameter("fetch") != null) {
			response.setHeader("Content-Type", "text/javascript");
			//构造json数据
			Iterator<String> iterator = savePath.iterator();
			String dirs = "[";
			while (iterator.hasNext()) {
				dirs += "'" + iterator.next() + "'";
				if (iterator.hasNext()) {
					dirs += ",";
				}
			}
			dirs += "]";
			response.getWriter().print("updateSavePath( " + dirs + " );");
			return;
		}

		UploaderTool up = new UploaderTool(request);

		// 获取前端提交的path路径
		String dir = request.getParameter("dir");

		//普通请求中拿不到参数， 则从上传表单中拿
		if (dir == null) {
			dir = up.getParameter("dir");
		}

		if (dir == null || "".equals(dir)) {
			//赋予默认值
			dir = savePath.get(0);
			//安全验证
		} else if (!savePath.contains(dir)) {
			response.getWriter().print("{'state':'\\u975e\\u6cd5\\u4e0a\\u4f20\\u76ee\\u5f55'}");
			return;
		}

		up.setSavePath(dir);
		String[] fileType = { ".gif", ".png", ".jpg", ".jpeg", ".bmp" };
		up.setAllowFiles(fileType);
		up.setMaxSize(500 * 1024); //单位KB
		up.upload();
		response.getWriter().print(
				"{'original':'" + up.getOriginalName() + "','url':'" + up.getUrl() + "','title':'" + up.getTitle()
						+ "','state':'" + up.getState() + "'}");
	}

	private void fileUp(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding(UploaderTool.ENCODEING);
		response.setCharacterEncoding(UploaderTool.ENCODEING);

		UploaderTool up = new UploaderTool(request);

		up.setSavePath("file"); //保存路径
		String[] fileType = { ".rar", ".doc", ".docx", ".zip", ".pdf", ".txt", ".swf", ".wmv", ".avi", ".rm", ".rmvb",
				".mpeg", ".mpg", ".ogg", ".mov", ".wmv", ".mp4" }; //允许的文件类型
		up.setAllowFiles(fileType);
		up.setMaxSize(500 * 1024); //允许的文件最大尺寸，单位KB
		up.upload();
		response.getWriter().print(
				"{'url':'" + up.getUrl() + "','fileType':'" + up.getType() + "','state':'" + up.getState()
						+ "','original':'" + up.getOriginalName() + "'}");
	}

	private void getMovie(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		StringBuffer readOneLineBuff = new StringBuffer();
		String content = "";
		String searchkey = request.getParameter("searchKey");
		String videotype = request.getParameter("videoType");
		try {
			searchkey = URLEncoder.encode(searchkey, "utf-8");
			URL url = new URL("http://api.tudou.com/v3/gw?method=item.search&appKey=myKey&format=json&kw=" + searchkey
					+ "&pageNo=1&pageSize=20&channelId=" + videotype + "&inDays=7&media=v&sort=s");
			URLConnection conn = url.openConnection();
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
			String line = "";
			while ((line = reader.readLine()) != null) {
				readOneLineBuff.append(line);
			}
			content = readOneLineBuff.toString();
			reader.close();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e2) {
			e2.printStackTrace();
		}
		response.getWriter().print(content);
	}

	private void getRemoteImage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		String url = request.getParameter("upfile");
		String state = "远程图片抓取成功！";

		String filePath = "remoteImage";
		String[] arr = url.split("ue_separate_ue");
		String[] outSrc = new String[arr.length];
		for (int i = 0; i < arr.length; i++) {

			//保存文件路径
			String str = request.getSession().getServletContext().getRealPath(request.getServletPath());
			File f = new File(str);
			String savePath = f.getParent() + "/" + filePath;
			//格式验证
			String type = getFileType(arr[i]);
			if (type.equals("")) {
				state = "图片类型不正确！";
				continue;
			}
			String saveName = Long.toString(new Date().getTime()) + type;
			//大小验证
			HttpURLConnection.setFollowRedirects(false);
			HttpURLConnection conn = (HttpURLConnection) new URL(arr[i]).openConnection();
			if (conn.getContentType().indexOf("image") == -1) {
				state = "请求地址头不正确";
				continue;
			}
			if (conn.getResponseCode() != 200) {
				state = "请求地址不存在！";
				continue;
			}
			File dir = new File(savePath);
			if (!dir.exists()) {
				dir.mkdirs();
			}
			File savetoFile = new File(savePath + "/" + saveName);
			outSrc[i] = filePath + "/" + saveName;
			try {
				InputStream is = conn.getInputStream();
				OutputStream os = new FileOutputStream(savetoFile);
				int b;
				while ((b = is.read()) != -1) {
					os.write(b);
				}
				os.close();
				is.close();
				// 这里处理 inputStream
			} catch (Exception e) {
				e.printStackTrace();
				System.err.println("页面无法访问");
			}
		}
		String outstr = "";
		for (int i = 0; i < outSrc.length; i++) {
			outstr += outSrc[i] + "ue_separate_ue";
		}
		outstr = outstr.substring(0, outstr.lastIndexOf("ue_separate_ue"));
		response.getWriter().print("{'url':'" + outstr + "','tip':'" + state + "','srcUrl':'" + url + "'}");
	}

	private String getFileType(String fileName) {
		String[] fileType = { ".gif", ".png", ".jpg", ".jpeg", ".bmp" };
		Iterator<String> type = Arrays.asList(fileType).iterator();
		while (type.hasNext()) {
			String t = type.next();
			if (fileName.endsWith(t)) {
				return t;
			}
		}
		return "";
	}

	private void imageManager(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//仅做示例用，请自行修改
		String imgStr = "";
		//String realpath = AppKeys.UPLOAD_FILE_PATH + "/default/ueditor/image/";
		String realpath = AppKeys.UPLOAD_FILE_PATH + "/ueditor/image/";
		List<File> files = getFiles(realpath, new ArrayList());
		for (File file : files) {
			imgStr += getRelatedPath(file.getPath()) + "ue_separate_ue";
		}
		if (imgStr != "") {
			imgStr = imgStr.substring(0, imgStr.lastIndexOf("ue_separate_ue")).replace(File.separator, "/").trim();
		}
		response.getOutputStream().print(imgStr);
	}
	
	private String getRelatedPath(String path) {
		int index = path.indexOf("ueditor");
		if (index != -1) {
			return path.substring(index + 8);
		}
		return path;
	}

	private List getFiles(String realpath, List files) {

		File realFile = new File(realpath);
		if (realFile.isDirectory()) {
			File[] subfiles = realFile.listFiles();
			for (File file : subfiles) {
				if (file.isDirectory()) {
					getFiles(file.getAbsolutePath(), files);
				} else {
					if (!getFileType(file.getName()).equals("")) {
						files.add(file);
					}
				}
			}
		}
		return files;
	}

//	private String getRealPath(HttpServletRequest request, String path) {
//		ServletContext application = request.getSession().getServletContext();
//		String str = application.getRealPath(request.getServletPath());
//		return new File(str).getParent();
//	}

	private void scrawlUp(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");

		String param = request.getParameter("action");
		UploaderTool up = new UploaderTool(request);
		String path = "scrawl";
		up.setSavePath(path);
		String[] fileType = { ".gif", ".png", ".jpg", ".jpeg", ".bmp" };
		up.setAllowFiles(fileType);
		up.setMaxSize(10000); //单位KB

		if (param != null && param.equals("tmpImg")) {
			up.upload();
			response.getOutputStream().print(
					"<script>parent.ue_callback('" + up.getUrl() + "','" + up.getState() + "')</script>");
		} else {
			up.uploadBase64("content");
			response.getWriter().print("{'url':'" + up.getUrl() + "',state:'" + up.getState() + "'}");
		}
	}
}
