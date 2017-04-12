public with sharing class GenerateCertificatePDF {

	//private ApexPages.StandardController controller;
	public Id inspectionId {get;set;}

	public GenerateCertificatePDF() {
		
	}

	public GenerateCertificatePDF(ApexPages.StandardController controller) {
		//this.controller = controller;
		inspectionId = controller.getId();
		//pagePdf.getParameters().put('id', controller.getId());
		//GeneratePDF();
	}

	public pagereference GeneratePDF(){

		  PageReference pagePdf = new PageReference('/apex/EEC_GeneratePDFNC');
		  system.debug('********inspectionId '+inspectionId);
          pagePdf.getParameters().put('id', inspectionId);
          //pagePdf.getParameters().put('doSave', 'No');
          Blob pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();

          Attachment a = new Attachment();
          a.Body = pdfPageBlob;
          a.ParentID = inspectionId;
          a.Name = 'TerryTestAttach1.pdf';
          a.Description = 'TestDescription1';
          insert a;
      	  return new PageReference('/' + inspectionId);
	}

	/*public void attachAndSendEmail() {

		//Get the opportunity Id and name
		String cId = '003j0000009HoHG';
		Contact contact = [SELECT id, name FROM Contact WHERE Id = :cId];

		//Create PDF
		// Reference the page, pass in a parameter to force PDF
		PageReference pdf = Page.GeneratePDF;

		// Grab the PDF!
		Blob b = pdf.getContent();

		Attachment a = new Attachment(parentId = contact.id, name=contact.name + '- test.pdf', body = b);

		insert a;

		// Create an email
		String[] toAddress = new String[1];
		toAddress[0] = 'sgullapalli@incapsulate.com';
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage ();
		email.setSaveAsActivity(true);
		email.setToAddresses(toAddress);
		email.setSenderDisplayName('New Order');
		email.setSubject('Testing PDF Email');
		email.setPlainTextBody('*********Testing PDF Email.');

		// Create an email attachment
		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		// Set name of PDF
		efa.setFileName('TestPDFEmail.pdf');
		// Set body of PDF
		efa.setBody(b);
		// Attach the PDF to your email
		email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

		// Send email & return to Opportunity
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	}

}
public with sharing class GenerateCertificatePDF
{

    public static final String FORM_HTML_START = '<HTML><BODY>';
    public static final String FORM_HTML_END = '</BODY></HTML>';

    public static void generateContactPDF()
    {
    	Contact contact = [select Id, Title, CreatedDate,Name from Contact where Id = '003j0000009HoHG'];
        String pdfContent = '' + FORM_HTML_START;
        try
        {
            //pdfContent = '' + FORM_HTML_START;
            //pdfContent = pdfContent + '<img src= \"data:image/jpeg;base64,dGVzdA==\" height=\'90\' width=\'600\'/>';
            pdfContent = pdfContent + '<div style=\'padding: 40px;\'>';
            pdfContent = pdfContent + '<br/><br/><br/><p style=\'color:Orange;font-size:6px;\'>MASSACHUSETTS DEPARTMENT OF</p>';
    		pdfContent = pdfContent + '<p style=\'color:DarkBlue;font-size:8px;\'>ELEMENTARY AND SECONDARY</p>';
    		pdfContent = pdfContent + '<p style=\'color:DarkBlue;font-size:18px;\'>EDUCATION</p><br/><br/>';
            pdfContent = pdfContent + '<H2 align=\'center\' style=\'color:DarkBlue\'>CERTIFICATE OF COMPLETION</H2><br/><br/><H3 align=\'center\'>Collaborative Board Member Training </H3><br/><br/><p>This certifies that ';
            pdfContent = pdfContent+contact.Title+contact.Name+' completed the online course entitled \'An Overview of Requirements for Educational Collaborative Board Members," as required by M.G.L. c. 40 ';
            pdfContent = pdfContent+'§ 4E(c) and 603 CMR 50.00, on '+contact.CreatedDate +'<br/><br/><br/><br/>Office of Regional Governance<br/>Massachusetts Department of Elementary and Secondary Education' + FORM_HTML_END;
          	pdfContent = pdfContent + '</div>';

        }catch(Exception e)
        {
            pdfContent = '' + FORM_HTML_START;
            pdfContent = pdfContent + '<P>THERE WAS AN ERROR GENERATING PDF: ' + e.getMessage() + '</P>';
            pdfContent = pdfContent + FORM_HTML_END;
        }
        attachPDF(contact,pdfContent);
        sendEmail(contact,pdfContent);
    }

    public static void attachPDF(Contact contact, String pdfContent)
    {
        try
        {
            Attachment attachmentPDF = new Attachment();
            attachmentPDF.parentId = contact.Id;
            attachmentPDF.Name = contact.Name + '.pdf';
            attachmentPDF.body = Blob.toPDF(pdfContent); //This creates the PDF content
            insert attachmentPDF;
        }catch(Exception e)
        {
            //account.addError(e.getMessage());
        }
    }

    public static void sendEmail(Contact contact, String pdfContent){

    	String[] toAddress = new String[1];
		toAddress[0] = 'sgullapalli@incapsulate.com';
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage ();
		email.setSaveAsActivity(true);
		email.setToAddresses(toAddress);
		email.setSenderDisplayName('New Order');
		email.setSubject('Testing PDF Email');
		email.setPlainTextBody('*********Testing PDF Email.****');
    	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setFileName('TestPDFEmail.pdf');
		efa.setBody(Blob.toPDF(pdfContent));
		email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }*/



}