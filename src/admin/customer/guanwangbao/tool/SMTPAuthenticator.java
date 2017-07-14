/**
 * 易框架
 *    
 * (C) Copyright 梁彦强 个人 2006-12-2
 * 本内容仅限于梁彦强授权使用，禁止转发.All Rights Reserved.
 */
package admin.customer.guanwangbao.tool;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

/**
 * SMTP权限验证。
 */
class SMTPAuthenticator extends Authenticator {
	private String username;

	private String password;

	SMTPAuthenticator(String username, String password) {
		super();
		this.username = username;
		this.password = password;
	}
	
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication(this.username, this.password);
	}
}
