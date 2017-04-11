public class EEC_DateFieldQuestion extends EEC_Question {
    public String fieldName { get; set; }
    
    public override String getQuestionType() {
        return 'date-field';
    }
    
    public EEC_DateFieldQuestion(String fieldName, String label) {
        this.label = label;
        this.fieldName = fieldName;
    }
}