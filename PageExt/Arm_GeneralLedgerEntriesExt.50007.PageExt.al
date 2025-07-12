pageextension 50007 Arm_GeneralLedgerEntriesExt extends "General Ledger Entries"
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