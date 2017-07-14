package admin.customer.guanwangbao.tool;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.Hashtable;
import java.util.Vector;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

public class JSONTool {
	public static void main(String[] args) throws Exception {
		BufferedReader bf = new BufferedReader(new InputStreamReader(new FileInputStream("C:\\Users\\thinkpad\\Desktop\\contact.txt"), "gbk"));
		
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("C:\\Users\\thinkpad\\Desktop\\contact_split.txt"), "gbk"));
		
		String line = "";
		while ((line = bf.readLine()) != null) {
			System.out.println(line);
			Hashtable<String, Object> dataHash = JSON.parseObject(line, 
					new TypeReference<Hashtable<String, Object>>(){});
			
			String listStr = dataHash.get("list").toString();
			
			Vector<Hashtable<String, Object>> listData = JSON.parseObject(listStr, 
					new TypeReference<Vector<Hashtable<String, Object>>>(){});
			
			for (int i = 0; i < listData.size(); ++i) {
				Hashtable<String, Object> data = listData.get(i);
				
				Hashtable<String, String> card = JSON.parseObject(data.get("card").toString(), 
						new TypeReference<Hashtable<String, String>>(){});
				
				String outputLine = "";
				String realname = card.get("realname");
				String company = card.get("company");
				String position = card.get("position");
				String phone = card.get("phone");
				
				outputLine = realname + "\t" + company + "\t" + position + "\t" + phone;
				
				bw.write(outputLine + "\n");
			}
		}
		
		bw.close();
		bf.close();
	}
}
