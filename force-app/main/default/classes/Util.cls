public with sharing class Util {
    public static Boolean validaCNPJ(String numeroConta) {
        Pattern p = Pattern.compile('([0-9]{2}[\\.]?[0-9]{3}[\\.]?[0-9]{3}[\\/]?[0-9]{4}[-]?[0-9]{2})');
        Matcher pm = p.matcher( numeroConta );
        return pm.matches(); 
    }
    public static Boolean validaCPF(String numeroConta) {
        Pattern p = Pattern.compile('([0-9]{3}[\\.]?[0-9]{3}[\\.]?[0-9]{3}[-]?[0-9]{2})');
        Matcher pm = p.matcher( numeroConta );
        return pm.matches(); 
    }
    
}