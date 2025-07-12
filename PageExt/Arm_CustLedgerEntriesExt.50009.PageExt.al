pageextension 50009 Arm_CustLedgerEntriesExt extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Load Type"; Rec."Load Type")
            {
                ApplicationArea = all;
            }
        }
    }
}