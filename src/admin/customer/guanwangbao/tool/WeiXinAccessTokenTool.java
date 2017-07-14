package admin.customer.guanwangbao.tool;

import admin.customer.guanwangbao.AppKeys;
import simpleWebFrame.log.AppLogger;
import weixin.popular.api.TokenAPI;
import weixin.popular.bean.Token;

public class WeiXinAccessTokenTool {
	/**
	 * 获得ACCESS_TOKEN
	 * @Title: getAccess_token
	 * @Description: 获得ACCESS_TOKEN
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @throws
	 */
	public static String getAccess_token(String weixinAppID, String weixinAppSecret) {
		String accessToken = AppKeys.accessToken;
		if (accessToken != null && !"".equals(accessToken)) {
			return accessToken;
		}
		
		try {
			Token token = TokenAPI.token(weixinAppID, weixinAppSecret);
			accessToken = token.getAccess_token();
			if (accessToken != null && !accessToken.equals("")) {
				AppKeys.accessToken = accessToken;
			}
		} catch (Exception e) {
			AppLogger.getInstance().errorLog("getAccess_token: " + e);
		}
		
		return accessToken == null ? "" : accessToken;
	}
}
