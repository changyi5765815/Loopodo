package admin.customer.guanwangbao;

import java.util.Comparator;
import java.util.Hashtable;

public class SortIndexComparatorHashtable implements Comparator<Hashtable<String, String>> {
	public int compare(Hashtable<String, String> a, Hashtable<String, String> b) {
		if (a.get("sortIndex") == null) {
			a.put("sortIndex", "");
		}
		
		if (b.get("sortIndex") == null) {
			b.put("sortIndex", "");
		}
		return Integer.parseInt(a.get("sortIndex").equals("") ? "99999" : a.get("sortIndex")) 
			- Integer.parseInt(b.get("sortIndex").equals("") ? "99999" : b.get("sortIndex"));
	}
}
