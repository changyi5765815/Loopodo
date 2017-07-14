package admin.customer.guanwangbao;

import java.util.Comparator;
import java.util.Hashtable;

public class SortIndexComparator2 implements Comparator<Hashtable<String, Object>> {
	public int compare(Hashtable<String, Object> a, Hashtable<String, Object> b) {
		if (a.get("sortIndex") == null) {
			a.put("sortIndex", "");
		}
		
		if (b.get("sortIndex") == null) {
			b.put("sortIndex", "");
		}
		return Integer.parseInt(a.get("sortIndex").toString().equals("") ? "99999" : a.get("sortIndex").toString()) 
			- Integer.parseInt(b.get("sortIndex").toString().equals("") ? "99999" : b.get("sortIndex").toString());
	}
}
