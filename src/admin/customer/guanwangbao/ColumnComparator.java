package admin.customer.guanwangbao;

import java.util.Comparator;
import java.util.Map;

public class ColumnComparator implements Comparator<Map<String, String>> {
	private String compareColumn;
	public ColumnComparator(String compareColumn) {
		this.compareColumn = compareColumn;
	}
	
	public int compare(Map<String, String> a, Map<String, String> b) {
		return a.get(compareColumn).compareTo(b.get(compareColumn));
	}
}
