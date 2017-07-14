package admin.customer.guanwangbao.tool;

import java.io.StringReader;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import org.jdom.input.SAXBuilder;

public class JdomUtil {
	private static org.jdom.Element toJDOMElement(String xmlString)
		throws Exception {
		StringReader sr = new StringReader(xmlString);
		SAXBuilder saxb = new SAXBuilder();
		org.jdom.Document doc = saxb.build(sr);
		org.jdom.Element root = doc.getRootElement();
		
		return root;
	}
	
	public static Hashtable<String, Vector<Hashtable<String, String>>> parse(String xmlString) throws Exception {
		Hashtable<String, Vector<Hashtable<String, String>>> dataHash = new Hashtable<String, Vector<Hashtable<String,String>>>();
		if ("".equals(xmlString)) {
			return dataHash;
		}
		org.jdom.Element document = toJDOMElement(xmlString);
		List dataList = document.getChildren("dataList");
		for (int i = 0; i < dataList.size(); ++i) {
			org.jdom.Element element = (org.jdom.Element) dataList.get(i);
			String dataListName = element.getAttributeValue("name");
			dataHash.put(dataListName, new Vector<Hashtable<String,String>>());
			
			List rowDatas = element.getChildren("row");
			for (int j = 0; j < rowDatas.size(); ++j) {
				org.jdom.Element rowData = (org.jdom.Element) rowDatas.get(j);
				List data = rowData.getChildren();
				Hashtable<String, String> attributeHash = new Hashtable<String, String>();
				for (int k = 0; k < data.size(); ++k) {
					org.jdom.Element attribute = (org.jdom.Element) data.get(k);
					attributeHash.put(attribute.getName(), attribute.getValue());
				}
				dataHash.get(dataListName).add(attributeHash);
			}
		}
		
		return dataHash;
	}
	
}
