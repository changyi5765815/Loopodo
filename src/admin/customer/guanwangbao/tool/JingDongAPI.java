package admin.customer.guanwangbao.tool;

import java.util.Vector;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

public class JingDongAPI {

	public static Vector<JingDongProps> getProps(String url) throws Exception {
		Vector<JingDongProps> props = new Vector<JingDongProps>();
		
		Document doc = Jsoup.connect(url).get();

		Elements es = doc.select("div#select").select("dl");
		for (int i = 0; i < es.size(); i++) {
			String name = es.get(i).select("dt").get(0).text().replaceAll("：", "");
			Vector<String> values = new Vector<String>();
			Elements nodes = es.get(i).select("dd a");
			for (int j = 0; j < nodes.size(); j++) {
				String nodeValue = nodes.get(j).text();
				if (!nodeValue.equals("不限")) {
					values.add(nodeValue);
				}
			}
			JingDongProps prop = new JingDongProps(name, values);
			props.add(prop);
		}
		
		return props;
	}
}
