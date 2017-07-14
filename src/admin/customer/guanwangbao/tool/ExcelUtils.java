package admin.customer.guanwangbao.tool;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.WorkbookSettings;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

import simpleWebFrame.util.StringUtil;
import admin.customer.guanwangbao.AppKeys;



public class ExcelUtils {
	public static String export(String title, Vector<String> excelHeaders, Vector<Hashtable<String, String>> datas){
		HSSFWorkbook wb = new HSSFWorkbook();
	    HSSFSheet sheet = wb.createSheet("sheet1");

	    // 设置字体
	    HSSFFont titlefont = wb.createFont();
	    titlefont.setFontName("黑体");
	    titlefont.setFontHeightInPoints((short) 15);	// 字体大小
	    titlefont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);	// 加粗
	    
	    // 设置字体
	    HSSFFont headfont = wb.createFont();
	    headfont.setFontName("黑体");
	    headfont.setFontHeightInPoints((short) 11);	// 字体大小
	    headfont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);	// 加粗
	    
	    // 另一个样式    
	    HSSFCellStyle titlestyle = wb.createCellStyle();    
	    titlestyle.setFont(titlefont);    
	    titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中    
	    titlestyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中    
	    titlestyle.setLocked(true);    
	    titlestyle.setWrapText(false);// 自动换行
	    
	    // 另一个样式    
	    HSSFCellStyle headstyle = wb.createCellStyle();
	    headstyle.setFont(headfont);
	    headstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中    
	    headstyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中    
	    
	    // 创建第一行
	    HSSFRow row0 = sheet.createRow(0);
	    row0.setHeight((short) 700);	// 行高
	    HSSFCell cell0 = row0.createCell((excelHeaders.size() / 2) - (1 - excelHeaders.size() % 2));    
	    cell0.setCellValue(new HSSFRichTextString(title));    
	    cell0.setCellStyle(titlestyle);
	    
	    HSSFRow row1 = sheet.createRow(1);
	    row1.setHeight((short) 400);
	    for(int i = 0; i < excelHeaders.size(); i++){
	    	sheet.setColumnWidth(i, 4000);
	    	
	    	String[] column_value = StringUtil.split(excelHeaders.get(i), "-");
	    	HSSFCell columns_cell = row1.createCell(i);
	    	columns_cell.setCellStyle(headstyle);
	    	if(column_value.length == 1) {
	    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[0]);
	    	} else {
	    		columns_cell.setCellValue(column_value[0]);
	    	}
	    }
	    for (int i = 0; i < datas.size(); i++) {
	    	HSSFRow columnsDe = sheet.createRow(i + 2);
	    	sheet.setColumnWidth(i + 2, 4000);
	    	Hashtable<String, String> data = datas.get(i);
	    	for(int j = 0;j < excelHeaders.size(); j++){
	 	    	String[] column_value = StringUtil.split(excelHeaders.get(j), "-");
	 	    	HSSFCell columns_cell = columnsDe.createCell(j);
	 	    	StringBuffer column_valueAppend = new StringBuffer();
	 	    	if(column_value.length == 1) {
		    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[1]);
		    		continue;
		    	} 
	 	    	for(int k =0; k < column_value.length; k++) {
	 	    		if(k > 1) {
	 	    			column_valueAppend.append(data.get(column_value[k]));
	 	    		} else if(k == 1) {
	 	    			column_valueAppend.append(data.get(column_value[1])).append("(");
	 	    		}
	 	    	}
	 	    	columns_cell.setCellValue(column_valueAppend.toString().endsWith("(") 
	 	    			? column_valueAppend.toString().substring(0, column_valueAppend.length() -1)
	 	    					: column_valueAppend.append(")").toString());
	 	    }
	    }

	    String dirName = "default/tmp";
		String excelDir = AppKeys.UPLOAD_FILE_PATH + File.separator + dirName + File.separator;
	    if(!new File(excelDir).exists()) {
	    	new File(excelDir).mkdirs();
	    }
		String fileName = new Date().getTime()+".xls";
	    try {
	    	FileOutputStream os = new FileOutputStream(excelDir + fileName);
	    	wb.write(os);
			os.close();
			return fileName;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static String export(String title, String[] excelHeaders, Vector<Hashtable<String, String>> datas){
		HSSFWorkbook wb = new HSSFWorkbook();
	    HSSFSheet sheet = wb.createSheet("sheet1");

	    // 设置字体
	    HSSFFont titlefont = wb.createFont();
	    titlefont.setFontName("黑体");
	    titlefont.setFontHeightInPoints((short) 15);	// 字体大小
	    titlefont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);	// 加粗
	    
	    // 设置字体
	    HSSFFont headfont = wb.createFont();
	    headfont.setFontName("黑体");
	    headfont.setFontHeightInPoints((short) 11);	// 字体大小
	    headfont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);	// 加粗
	    
	    // 另一个样式    
	    HSSFCellStyle titlestyle = wb.createCellStyle();    
	    titlestyle.setFont(titlefont);    
	    titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中    
	    titlestyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中    
	    titlestyle.setLocked(true);    
	    titlestyle.setWrapText(false);// 自动换行
	    
	    // 另一个样式    
	    HSSFCellStyle headstyle = wb.createCellStyle();
	    headstyle.setFont(headfont);
	    headstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中    
	    headstyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中    
	    
	    // 创建第一行
	    HSSFRow row0 = sheet.createRow(0);
	    row0.setHeight((short) 700);	// 行高
	    HSSFCell cell0 = row0.createCell((excelHeaders.length / 2) - (1 - excelHeaders.length % 2));    
	    cell0.setCellValue(new HSSFRichTextString(title));    
	    cell0.setCellStyle(titlestyle);
	    
	    HSSFRow row1 = sheet.createRow(1);
	    row1.setHeight((short) 400);
	    for(int i = 0; i < excelHeaders.length; i++){
	    	sheet.setColumnWidth(i, 4000);
	    	
	    	String[] column_value = StringUtil.split(excelHeaders[i], "-");
	    	HSSFCell columns_cell = row1.createCell(i);
	    	columns_cell.setCellStyle(headstyle);
	    	if(column_value.length == 1) {
	    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[0]);
	    	} else {
	    		columns_cell.setCellValue(column_value[0]);
	    	}
	    }
	    for (int i = 0; i < datas.size(); i++) {
	    	HSSFRow columnsDe = sheet.createRow(i + 2);
	    	sheet.setColumnWidth(i + 2, 4000);
	    	Hashtable<String, String> data = datas.get(i);
	    	for(int j = 0;j < excelHeaders.length; j++){
	 	    	String[] column_value = StringUtil.split(excelHeaders[j], "-");
	 	    	HSSFCell columns_cell = columnsDe.createCell(j);
	 	    	StringBuffer column_valueAppend = new StringBuffer();
	 	    	if(column_value.length == 1) {
		    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[1]);
		    		continue;
		    	} 
	 	    	for(int k =0; k < column_value.length; k++) {
	 	    		if(k > 1) {
	 	    			column_valueAppend.append(data.get(column_value[k]));
	 	    		} else if(k == 1) {
	 	    			column_valueAppend.append(data.get(column_value[1])).append("(");
	 	    		}
	 	    	}
	 	    	columns_cell.setCellValue(column_valueAppend.toString().endsWith("(") 
	 	    			? column_valueAppend.toString().substring(0, column_valueAppend.length() -1)
	 	    					: column_valueAppend.append(")").toString());
	 	    }
	    }

	    String dirName = "default/tmp";
		String excelDir = AppKeys.UPLOAD_FILE_PATH + File.separator + dirName + File.separator;
	    if(!new File(excelDir).exists()) {
	    	new File(excelDir).mkdirs();
	    }
		String fileName = new Date().getTime()+".xls";
	    try {
	    	FileOutputStream os = new FileOutputStream(excelDir + fileName);
	    	wb.write(os);
			os.close();
			return fileName;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static String export(String[] excelHeaders, Vector<Hashtable<String, String>> datas){
		HSSFWorkbook wb = new HSSFWorkbook();
	    HSSFSheet sheet = wb.createSheet("sheet1");

	    HSSFRow columns = sheet.createRow(0);
	    
	    for(int i = 0;i < excelHeaders.length; i++){
	    	sheet.setColumnWidth(i, 4000);
	    	
	    	String[] column_value = StringUtil.split(excelHeaders[i], "-");
	    	HSSFCell columns_cell = columns.createCell(i);
	    	if(column_value.length == 1) {
	    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[0]);
	    	} else {
	    		columns_cell.setCellValue(column_value[0]);
	    	}
	    }
	    for (int i = 0; i < datas.size(); i++) {
	    	HSSFRow columnsDe = sheet.createRow(i + 1);
	    	sheet.setColumnWidth(i + 1, 4000);
	    	Hashtable<String, String> data = datas.get(i);
	    	for(int j = 0;j < excelHeaders.length; j++){
	 	    	String[] column_value = StringUtil.split(excelHeaders[j], "-");
	 	    	HSSFCell columns_cell = columnsDe.createCell(j);
	 	    	StringBuffer column_valueAppend = new StringBuffer();
	 	    	if(column_value.length == 1) {
		    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[1]);
		    		continue;
		    	} 
	 	    	for(int k =0; k < column_value.length; k++) {
	 	    		if(k > 1) {
	 	    			column_valueAppend.append(data.get(column_value[k]));
	 	    		} else if(k == 1) {
	 	    			column_valueAppend.append(data.get(column_value[1])).append("(");
	 	    		}
	 	    	}
	 	    	columns_cell.setCellValue(column_valueAppend.toString().endsWith("(") 
	 	    			? column_valueAppend.toString().substring(0, column_valueAppend.length() -1)
	 	    					: column_valueAppend.append(")").toString());
	 	    }
	    }

	    String dirName = "default/tmp";
		String excelDir = AppKeys.UPLOAD_FILE_PATH + File.separator + dirName + File.separator;
	    if(!new File(excelDir).exists()) {
	    	new File(excelDir).mkdirs();
	    }
		String fileName = new Date().getTime()+".xls";
	    try {
	    	FileOutputStream os = new FileOutputStream(excelDir + fileName);
	    	wb.write(os);
			os.close();
			return fileName;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static Hashtable<String, Vector<Vector<String>>> readExcel(
			String filePath) throws Exception {
		Hashtable<String, Vector<Vector<String>>> datas = new Hashtable<String, Vector<Vector<String>>>();
		InputStream is = null;

		try {
			is = new FileInputStream(filePath);
			WorkbookSettings wkbkSet = new WorkbookSettings();
			wkbkSet.setSuppressWarnings(true);
			Workbook rwb = Workbook.getWorkbook(is, wkbkSet);
			Sheet st[] = rwb.getSheets();

			for (int a = 0; a < st.length; a++) {
				String sheetName = st[a].getName().trim();
				Vector<Vector<String>> sheetDatas = new Vector<Vector<String>>();

				for (int i = 0; i < st[a].getRows(); i++) {
					Vector<String> rowDatas = new Vector<String>();
					for (int j = 0; j < st[a].getColumns(); j++) {
						Cell c = st[a].getCell(j, i);
						String content = c.getContents().trim();
						rowDatas.add(content);
					}
					sheetDatas.add(rowDatas);
				}

				datas.put(sheetName, sheetDatas);
			}
			rwb.close();
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				if (is != null) {
					is.close();
				}
			} catch (Exception e) {
			}
		}
		return datas;
	}
	
	/**
	 * 导出订单数据到Excel，并合并单元格
	 * @param excelHeaders	Excel标题
	 * @param datas	需要导出到Excel中的数据
	 * @param mergeLines	需要合并的列，从0计数
	 * @return 
	 * @author caihaifeng
	 */
	public static String exportTableDataWithMergeCells(String title, Vector<String> excelHeaders, Vector<Hashtable<String, String>> datas, Vector<Integer> mergeLines, String distinguishID){
		HSSFWorkbook wb = new HSSFWorkbook();
	    HSSFSheet sheet = wb.createSheet("sheet1");
	    // 设置字体
	    HSSFFont titlefont = wb.createFont();
	    titlefont.setFontName("黑体");
	    titlefont.setFontHeightInPoints((short) 15);	// 字体大小
	    titlefont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);	// 加粗
	    
	    // 设置字体
	    HSSFFont headfont = wb.createFont();
	    headfont.setFontName("黑体");
	    headfont.setFontHeightInPoints((short) 11);	// 字体大小
	    headfont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);	// 加粗
	    
	    // 另一个样式    
	    HSSFCellStyle titlestyle = wb.createCellStyle();    
	    titlestyle.setFont(titlefont);    
	    titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中    
	    titlestyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中    
	    titlestyle.setLocked(true);    
	    titlestyle.setWrapText(false);// 自动换行
	    
	    // 另一个样式    
	    HSSFCellStyle headstyle = wb.createCellStyle();
	    headstyle.setFont(headfont);
	    headstyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中    
	    headstyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中    
	    
	    // 创建第一行
	    HSSFRow row0 = sheet.createRow(0);
	    row0.setHeight((short) 700);	// 行高
	    HSSFCell cell0 = row0.createCell((excelHeaders.size() / 2) - (1 - excelHeaders.size() % 2));    
	    cell0.setCellValue(new HSSFRichTextString(title));    
	    cell0.setCellStyle(titlestyle);
	    
	    HSSFRow row1 = sheet.createRow(1);
	    row1.setHeight((short) 400);
	    for(int i = 0; i < excelHeaders.size(); i++){
	    	sheet.setColumnWidth(i, 4000);
	    	
	    	String[] column_value = StringUtil.split(excelHeaders.get(i), "-");
	    	HSSFCell columns_cell = row1.createCell(i);
	    	columns_cell.setCellStyle(headstyle);
	    	if(column_value.length == 1) {
	    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[0]);
	    	} else {
	    		columns_cell.setCellValue(column_value[0]);
	    	}
	    }
	    for (int i = 0; i < datas.size(); i++) {
	    	HSSFRow columnsDe = sheet.createRow(i + 2);
	    	sheet.setColumnWidth(i + 2, 4000);
	    	Hashtable<String, String> data = datas.get(i);
	    	for(int j = 0;j < excelHeaders.size(); j++){
	 	    	String[] column_value = StringUtil.split(excelHeaders.get(j), "-");
	 	    	HSSFCell columns_cell = columnsDe.createCell(j);
	 	    	StringBuffer column_valueAppend = new StringBuffer();
	 	    	if(column_value.length == 1) {
		    		columns_cell.setCellValue(StringUtil.split(column_value[0], "=")[1]);
		    		continue;
		    	} 
	 	    	for(int k =0; k < column_value.length; k++) {
	 	    		if(k > 1) {
	 	    			column_valueAppend.append(data.get(column_value[k]));
	 	    		} else if(k == 1) {
	 	    			column_valueAppend.append(data.get(column_value[1])).append("(");
	 	    		}
	 	    	}
	 	    	columns_cell.setCellValue(column_valueAppend.toString().endsWith("(") 
	 	    			? column_valueAppend.toString().substring(0, column_valueAppend.length() -1)
	 	    					: column_valueAppend.append(")").toString());
	 	    }
	    }
	    // 合并单元格
	    for (int i = 0; i < mergeLines.size(); i++) {
	    	mergedCellsBydistinguishID(sheet, mergeLines.get(i), 2, distinguishID, datas);
	    }
	    String dirName = "default/tmp";
		String excelDir = AppKeys.UPLOAD_FILE_PATH + File.separator + dirName + File.separator;
	    if(!new File(excelDir).exists()) {
	    	new File(excelDir).mkdirs();
	    }
		String fileName = new Date().getTime()+".xls";
	    try {
	    	FileOutputStream os = new FileOutputStream(excelDir + fileName);
	    	wb.write(os);
			os.close();
			return fileName;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	
	private static void mergedCellsBydistinguishID(HSSFSheet sheet, int cellLine,
			int startRow, String distinguishID, Vector<Hashtable<String, String>> datas) {
		
		for (int i = 0; i < datas.size(); i++) {
			Hashtable<String, String> data = datas.get(i);
			if (!"".equals(data.get(distinguishID))) {
				int num = 1;
				try {
					num = Integer.parseInt(data.get("mergeCellsLineNumber"));
				} catch (Exception e) {
				}
				
				if (num > 1) {
					sheet.addMergedRegion(new CellRangeAddress(
							startRow, startRow + num -1, cellLine, cellLine));
				}
				
				startRow = startRow + num;
				
			}
			
		}
	}
	

//	/**  
//     * 合并单元格  
//     * @param sheet 要合并单元格的excel 的sheet
//     * @param cellLine  要合并的列 
//     * @param startRow  要合并列的开始行
//     * @param endRow    要合并列的结束行 
//     */  
//	private static void addMergedRegion(HSSFSheet sheet, int cellLine,
//			int startRow, int endRow, HSSFWorkbook workBook) {
//		String s_will = sheet.getRow(startRow).getCell(cellLine).getStringCellValue();
//		int count = 0;
//		boolean flag = false;
//		for (int i = 1; i <= endRow; i++) { 
//			String s_current = sheet.getRow(i).getCell(0).getStringCellValue();
//			if (s_will.equals(s_current)) { // 相邻两行的数据相同
//				s_will = s_current;
//				if (flag) {
//					sheet.addMergedRegion(new CellRangeAddress(
//							startRow - count, startRow, cellLine, cellLine));
//					HSSFRow row = sheet.getRow(startRow - count);
//					String cellValueTemp = sheet.getRow(startRow - count).getCell(0).getStringCellValue();
//					HSSFCell cell = row.createCell(0);
//					cell.setCellValue(cellValueTemp); // 跨单元格显示的数据
//					count = 0;
//					flag = false;
//				}
//				startRow = i;
//				count++;
//			} else { 
//				flag = true;
//				s_will = s_current;
//			}
//			// 由于上面循环中合并的单元放在有下一次相同单元格的时候做的，所以最后如果几行有相同单元格则要运行下面的合并单元格。
//			if (i == endRow && count > 0) {
//				sheet.addMergedRegion(new CellRangeAddress(endRow - count,
//						endRow, cellLine, cellLine));
//				String cellValueTemp = sheet.getRow(startRow - count).getCell(0).getStringCellValue();
//				HSSFRow row = sheet.getRow(startRow - count);
//				HSSFCell cell = row.createCell(0);
//				cell.setCellValue(cellValueTemp); // 跨单元格显示的数据
//			}
//		}
//	}
}