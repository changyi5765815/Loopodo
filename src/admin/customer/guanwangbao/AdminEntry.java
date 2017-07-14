package admin.customer.guanwangbao;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import simpleWebFrame.log.AppLogger;
import simpleWebFrame.web.AbstractEntry;
import simpleWebFrame.web.FrameKeys;

public class AdminEntry extends AbstractEntry {
	public boolean checkPriority(String moduleName, String actionName, HttpServletRequest request) {
		if (!moduleName.equals("adminLogin") && !moduleName.equals("ajax") && !moduleName.equals("smsClient")) {
			if (request.getSession().getAttribute(FrameKeys.LOGIN_USER) == null) {
				return false;
			}
		}
		
		return true;
	}

	public String getPriorityErorrPage() {
		return "expired.jsp";
	}

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (request.getRequestURI().equals("/sendMessage.do")) {
			getServletContext().getRequestDispatcher(
					"/admin?module=smsClient&action=sendMessage").forward(
					request, response);
		}
		else if (request.getParameter("module") != null
				&& request.getParameter("action") != null) {
			doPost(request, response);
		} else {
			if (request.getSession().getAttribute(FrameKeys.LOGIN_USER) != null) {
				getServletContext().getRequestDispatcher(
						"/admin?module=index&action=defaultView").forward(
						request, response);
			} else {
				getServletContext().getRequestDispatcher("/jsp/adminLogin.jsp")
						.forward(request, response);
			}
		}
	}

	@Override
	public void entryInit() {
		LocalDataCache.getInstance().loadData();
//		ShopOrderThread.getInstance().start();
//		SystemSignLogThread.getInstance().start();
//		GroupBuyThread.getInstance().start();
		CommentThread.getInstance().start();
	}
	
	@Override
	@SuppressWarnings("deprecation")
	/**该方法是tomcat关闭或者重新加载应用程序的时候执行的方法
	 * 该方法主要工作是清除该应用所占用的系统资源,包括缓存,守护线程
	 * 为了使得JVM能更快的清理掉缓存中的数据,程序应该显示的将缓存类中声明的对象以及缓存类对象本身设置为null,
	 * 如果应用启动了线程,那么必须在tomcat关闭或者重新加载的时候,杀掉已启动的线程,否则jvm中可能存在有多个同样的线程
	 * 应该先关闭线程,在清理缓存,因为线程中可能使用到了缓存中的数据.
	 * **/
	public void destroy() {
		try {
			LocalDataCache.getInstance().clear();
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("destroy error", e);
		}
	}
}
