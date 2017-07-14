package admin.customer.guanwangbao.tool;

import java.util.Comparator;
import java.util.Hashtable;

public class SortIndexComparator implements Comparator<Hashtable<String, String>> {
	public int compare(Hashtable<String, String> a, Hashtable<String, String> b) {
		if (a.get("sortIndex") == null || b.get("sortIndex") == null) {
			return -1;
		}
		return Integer.parseInt(a.get("sortIndex").equals("") ? "99999" : a.get("sortIndex")) 
			- Integer.parseInt(b.get("sortIndex").equals("") ? "99999" : b.get("sortIndex"));
	}
}
