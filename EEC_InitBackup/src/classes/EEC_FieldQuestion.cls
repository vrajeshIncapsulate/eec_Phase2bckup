public class EEC_FieldQuestion extends EEC_Question {
    public String fieldName { get; set; }
    
    public override String getQuestionType() {
        return 'field';
    }
    
    public EEC_FieldQuestion (String fieldName, String label) {
        this.fieldName = fieldName;
        this.label = label;
    }
}