public with sharing class EEC_UploadExcelController {
    public Inspection__c insp;
    public Blob csvFileBody {get; set;}
    public String csvAsString {get; set;}
    
    public EEC_UploadExcelController(ApexPages.StandardController controller){
         insp = (Inspection__c) controller.getRecord();
    }
    private void addError(String msg)
    {
        if (Apexpages.currentPage() != null) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
        }
    }
    public PageReference uploadExcel(){
        Integer counter = 0;
        if(insp != null && csvFileBody != null){
            System.debug('********* csvFileBody -- '+csvFileBody);
            List<List<String>> excelList = parseCSV(csvFileBody.toString(),false);
            System.debug('********* excelList -- '+excelList);
            if(excelList == null || excelList.size() <= 1)
            {
                addError('Invalid data: Please make sure your file has headers and data.');        
            }
            else{
                Map<String, Integer> headerMap = new Map<String, Integer>();
                List<String> headerList = excelList.remove(0);
                Integer i = 0;
                for(String header : headerList)
                {
                    headerMap.put(header, i);
                    i++;
                }
                
                System.debug('********* HeaderMAP -- '+headerMap);
                Inspection_Item__c iItem;
                List<Inspection_Item__c> insertIItemList = new List<Inspection_Item__c>();
                Map<String,Inspection_Item__c> iItemMap = new Map<String,Inspection_Item__c>();
                List<Inspection_Item__c> iItemList = new List<Inspection_Item__c>();
                Set<String> resultSet = new Set<String>();
                Set<String> categorySet = new Set<String>();
                List<Inspection_Item__c> updateIIList = new List<Inspection_Item__c>();
                
                for(Schema.PicklistEntry ple : Inspection_Item__c.Inspection_Result__c.getDescribe().getPicklistValues()){
                    resultSet.add(ple.getLabel());
                }
                for(Schema.PicklistEntry ple : Inspection_Item__c.Category_additional__c.getDescribe().getPicklistValues()){
                    categorySet.add(ple.getLabel());
                }
                
                System.debug('Result Set' + resultSet);
                System.debug('Category Set' + categorySet);
                for(List<String> row : excelList)
                {
                    System.debug('Count' + row.size());
                    iItem = new Inspection_Item__c();
                    String description = '';
                    for(String header : headerList)
                    {
                        Integer rowIndex = headerMap.get(header);
                        //System.debug('Header Name ---- > ' + header);
                        if(row.size() >= rowIndex+1){
                            if(header == 'Technical Assistance')
                            {
                                System.debug('Tech assistance--->' + row[rowIndex]);
                                iItem.Technical_Assistance__c = row[rowIndex];
                            }
                            if(header == 'Observations')
                            {
                                System.debug('Observation--->' + row[rowIndex]);
                                iItem.Observations__c = row[rowIndex];
                            }
                            if(header == 'Domain (list)')
                            {
                                System.debug('Domain List ----- > ' + row[rowIndex]);
                                iItem.Category_additional__c = row[rowIndex];
                            }
                            if(header == 'Visit Item Name')
                            {
                                //iItem.Inspection_Item_Name__c = row[rowIndex];
                            }
                            if(header == 'Description')
                            {
                                System.debug('Description List ----- > ' + row[rowIndex]);
                                description = row[rowIndex];
                            }
                            if(header == 'Correction Plan')
                            {
                                iItem.Correction_Plan__c = row[rowIndex];
                            }
                            if(header == 'Visit Item Name for list' || header == 'Visit Item Name for List')
                            {
                                iItem.Additional_Inspection_Item_Name__c = row[rowIndex];
                            }
                            if(header == 'Date Implemented')
                            {
                                if(String.isNotBlank(row[rowIndex])){
                                    
                                    iItem.Date_Implemented__c = Date.parse(row[rowIndex]);
                                }
                            }
                            if(header == 'Result')
                            {
                                System.debug('Result--->' + row[rowIndex]);
                                if(String.isBlank(row[rowIndex])){
                                    iItem.Inspection_Result__c = 'Compliant';
                                }
                                else if(resultSet.contains(row[rowIndex])){
                                     //Add a result mapping here
                                     iItem.Inspection_Result__c = row[rowIndex];
                                }
                                else if(row[rowIndex] == 'C' || row[rowIndex] == 'c'){
                                    iItem.Inspection_Result__c = 'Compliant';
                                }
                                else if(row[rowIndex] == 'NC' || row[rowIndex] == 'nc' || row[rowIndex] == 'Non Compliant'){
                                    iItem.Inspection_Result__c = 'Non-Compliant';
                                }
                                else if(row[rowIndex] == 'NA' || row[rowIndex] == 'na' || row[rowIndex] == 'Not Applicable'){
                                    iItem.Inspection_Result__c = 'Not Applicable';
                                }
                            }
                            if(header == 'Visit Item No')
                            {
                                System.debug('Header Val--->' + row[rowIndex]);
                                if(String.isNotBlank(row[rowIndex])){
                                    iItemMap.put(row[rowIndex],iItem);
                                }
                                else{
                                    iItem.Inspection_No__c = insp.Id;
									iItem.Description_of_additional_inspection__c = description;
                                    iItem.RecordTypeId = (EEC_RecordTypeUtil.findByName('Inspection_Item__c.Additional_Inspection_Item')).Id;
                                    iItemList.add(iItem);
                                }
                            }
                        }
                    }
                }
                System.debug('********* iItemMap -- '+iItemMap);
                
                if(iItemMap != null && iItemMap.size() > 0){
                    Inspection_Item__c uii;
                    
                    for(Inspection_Item__c ii :[select Id,Inspection_Result__c,Non_Assessed_Item__c,Date_Implemented__c,Name,Correction_Plan__c,Observations__c,
                                                       Technical_Assistance__c from Inspection_Item__c where Name in :iItemMap.keySet()]){
                        if(iItemMap.containsKey(ii.Name)){
                            uii = iItemMap.get(ii.Name);
                            ii.Technical_Assistance__c = uii.Technical_Assistance__c;
                            ii.Observations__c = uii.Observations__c;
                            //ii.Category_additional__c = '';
                            //ii.Category_additional__c = uii.Category_additional__c;
                            ii.Description_of_additional_inspection__c = uii.Description_of_additional_inspection__c;
                            ii.Correction_Plan__c = uii.Correction_Plan__c;
                            ii.Date_Implemented__c = uii.Date_Implemented__c;
                            if(!ii.Non_Assessed_Item__c){
                                ii.Inspection_Result__c = uii.Inspection_Result__c;
                            }
                            
                            updateIIList.add(ii);
                        }                       
                    }
                }
                System.debug('********* iItemList -- '+iItemList);
                System.debug('********* updateIIList -- '+updateIIList);
                try{
                    if(iItemList != null && iItemList.size() > 0){
                        //insert iItemList; //We Must not be inserting new visit items coming in csv file.
                    }
                    if(updateIIList != null && updateIIList.size() > 0 ){
                        update updateIIList;
                    } 
                }catch(Exception e){
                    addError('Invalid data: Exception occured while upserting the data.'+e.getMessage());    
                }
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Data Uploaded'));
            }
        }
        return null;
    }
    private static List<List<String>> parseCSV(String contents,Boolean skipHeaders) 
    {
        List<List<String>> allFields = new List<List<String>>();
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        contents = contents.replaceAll('""','DBLQT');
        boolean hasN = contents.contains('\n');
        boolean hasR = contents.contains('\r');
        
        String split_char = '';
        
        if (hasN && hasR)
        {
            split_char = '\r\n';
        }
        else if (hasN)
        {
            split_char = '\n';
        }
        else // Either using \r OR empty file. Possibly also single line?
        {
            split_char = '\r';
        }           
        
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try 
        {
            lines = contents.split(split_char);
        } 
        catch (System.ListException e) 
        {
            System.debug('Limits exceeded?' + e.getMessage());
        }

        //Adding support for multi-line fields, if a field has comma in it, this solution may still break
        String compositeLine;
        Boolean makeCompositeLine = false;
        String headerLine;
        Integer headerNumber = 0;

        for(String line : lines) 
        {
            // check for blank CSV lines (only commas)
            System.debug('********Processing Line: ' +line);
            if (line.replaceAll(',','').trim().length() == 0) 
            {
                break;
            }
            if(String.isBlank(headerLine)){
                headerLine = line;
            }
            if( !makeCompositeLine && line.split(',').size() < headerNumber ){
                makeCompositeLine = true;
                compositeLine = line;
                break;
            }
            if(makeCompositeLine && compositeLine.split(',').size() < headerNumber){
                compositeLine += ' ' + line;
                if(compositeLine.split(',').size() >= headerNumber && (compositeLine.indexOf(',0,') > -1 || compositeLine.indexOf(',1,') > -1) ){
                    makeCompositeLine = false;
                } else { break;}
            }
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            
            for(String field : fields) 
            {
                if (field.startsWith('"') && field.endsWith('"')) 
                {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } 
                else if (field.startsWith('"'))
                {
                    makeCompositeField = true;
                    compositeField = field;
                } 
                else if (field.endsWith('"'))
                {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } 
                else if (makeCompositeField) 
                {
                    compositeField +=  ',' + field;
                }
                /*
                else if (String.isBlank(field) || field == null)
                {
                    cleanFields.add('""');
                }
                */
                else 
                {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }
            allFields.add(cleanFields);
        }
        if (skipHeaders) 
        {
            allFields.remove(0);
        }
        return allFields;
    }

}