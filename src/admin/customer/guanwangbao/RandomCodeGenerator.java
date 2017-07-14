package admin.customer.guanwangbao;

import java.util.Random;

public class RandomCodeGenerator {
	private static char codeSequence[] = {
			'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 
			'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 
			'W', 'X', 'Y', 'Z', '2', '3', '4', '5', '6', '7', 
			'8', '9'
		};
	
	private static char intSequence[] = {
		'2', '3', '4', '5', '6', '7', 
		'8', '9'
	};
	
	private static char stringSequence[] = {
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 
		'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 
		'W', 'X', 'Y', 'Z'
	};
	public static String generateCode(int length) {
		StringBuffer sb = new StringBuffer();
		Random random = new Random();
		for (int i = 0; i < codeSequence.length && i < length; ++i) {
			sb.append(codeSequence[random.nextInt(codeSequence.length)]);
		}
		
		return sb.toString();
	}
	
	public static String generateCodeInt(int length) {
		StringBuffer sb = new StringBuffer();
		Random random = new Random();
		for (int i = 0; i < intSequence.length && i < length; ++i) {
			sb.append(intSequence[random.nextInt(intSequence.length)]);
		}
		
		return sb.toString();
	}
	
	public static String generateCodeString(int length) {
		StringBuffer sb = new StringBuffer();
		Random random = new Random();
		for (int i = 0; i < stringSequence.length && i < length; ++i) {
			sb.append(stringSequence[random.nextInt(stringSequence.length)]);
		}
		
		return sb.toString();
	}
}
