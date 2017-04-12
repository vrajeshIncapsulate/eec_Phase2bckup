public with sharing class EEC_DateUtil {
    public static String formatDate(String format, Date dt){
        return DateTime.newInstance(
            dt.year(), 
            dt.month(), 
            dt.day()).format(format);
    }
}