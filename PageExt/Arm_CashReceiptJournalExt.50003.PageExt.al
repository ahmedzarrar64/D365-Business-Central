pageextension 50003 Arm_CashReceiptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Description")
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