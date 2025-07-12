pageextension 50006 Arm_PurchCrMemoSubExt extends "Purch. Cr. Memo Subform"
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