public class EEC_ProviderSearchQueryBuilder {
 
    public String providerName { get; set; }
    public String providerType { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String address { get; set; }
    public String city { get; set; }
    public List<String> validRoles = new List<String>{'Main Contact / Licensee', 'Director', 'Main Contact / Assistant'};

    public Boolean hasContactFieldsSet() {
        return !(String.isBlank(this.firstName) && String.isBlank(this.lastName)); 
    }

    public Boolean hasFieldsSet() {
        return !(String.isBlank(this.providerName) && 
                String.isBlank(this.providerType) && 
                String.isBlank(this.firstName) && 
                String.isBlank(this.lastName) && 
                String.isBlank(this.address) &&
                String.isBlank(this.city));
    }
    
    public static String PROVIDER_FIELDS = ''; 

    public String buildQuery() {
        return buildQuery(null);
    }

    public String buildQuery(Id accountID) {
        
        String query = 'SELECT Id, Name, RecordType.Id, RecordType.Name, Provider_Address_1__c, Provider_City__r.Name, ';  
        query += '(' + contactQuery() + ') ';
        query += 'FROM Account ';
        
        query += ' WHERE ' + (accountId == NULL ? whereQuery() : 'Id = \'' + accountId + '\'');
        query += 'ORDER BY Name';
            
        System.debug(query);
        return query;
    }

    public String whereQuery() { 
        String whereClause = likeClause('NAME', this.providerName); 
        whereClause += likeClause('Provider_Address_1__c', this.address);  
        whereClause += equalsClause('Provider_City__c', this.city);
        whereClause += equalsClause('RecordTypeId', this.providerType);
        whereClause += 'RecordType.Name <> \'Umbrella\' AND ';
         
        if(this.hasContactFieldsSet()){
            whereClause += 'Id IN (SELECT AccountId FROM Contact WHERE ';
            whereClause += 'Role__c IN ' + inClause(validRoles);
            whereClause += likeClause('FirstName', this.firstName);
            whereClause += likeClause('LastName', this.lastName);
            whereClause = whereClause.substringBeforeLast(' AND '); 
            whereClause += ') AND ';
        }
        
        whereClause = whereClause.substringBeforeLast(' AND ');  

        return whereClause + ' ';
    }

    public String contactQuery() {
        String contactQuery = 'SELECT Name ';
        contactQuery += 'FROM Contacts ';
        contactQuery += 'WHERE ';
        contactQuery += 'Role__c IN ' + inClause(validRoles);
        contactQuery += likeClause('FirstName', this.firstName);
        contactQuery += likeClause('LastName', this.lastName);
        contactQuery = contactQuery.substringBeforeLast(' AND ');
        contactQuery += ' LIMIT 1';
        return contactQuery;
    }

    private String inClause(List<String> items) {
        String clause = '(';

        for (String i : items) {
            clause += '\'' + i + '\',';
        }
            
        clause = clause.substringBeforeLast(',');

        return clause + ') AND ';
    }

    private String equalsClause(String field, String term) {
        return String.isEmpty(term) ? '' : field + ' = \'' + term + '\' AND ';
    }

    private String likeClause(String field, String term) {
        return String.isEmpty(term) ? '' : field + ' LIKE \'%' + term + '%\' AND ';
    }
}