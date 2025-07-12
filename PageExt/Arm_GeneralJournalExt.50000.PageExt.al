pageextension 50000 Arm_GeneralJournalExt extends "General Journal"
{
    layout
    {
        addafter("Transaction Information")
        {
            field(Memo; Rec.Memo)
            {
                ApplicationArea = all;
            }
            field("Memo 2"; Rec."Memo 2")
            {
                ApplicationArea = all;
            }
        }
    }
}