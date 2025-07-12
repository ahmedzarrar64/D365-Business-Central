pageextension 50005 Arm_PurchInvoiceSubExt extends "Purch. Invoice Subform"
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