package admin.customer.guanwangbao;

import java.util.Comparator;
import java.util.Map;

public class SortIndexComparator implements Comparator<Map> {
	public int compare(Map a, Map b) {
		if (a.get("sortIndex") == null) {
			a.put("sortIndex", "");
		}
		
		if (b.get("sortIndex") == null) {
			b.put("sortIndex", "");
		}
		return Integer.parseInt(a.get("sortIndex").equals("") ? "99999" : a.get("sortIndex").toString()) 
			- Integer.parseInt(b.get("sortIndex").equals("") ? "99999" : b.get("sortIndex").toString());
	}
}
