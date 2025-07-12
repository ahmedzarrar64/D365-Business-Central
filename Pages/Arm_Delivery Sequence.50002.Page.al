page 50002 "Arm_Delivery Sequence"
{
    Caption = 'Delivery Sequence';
    ApplicationArea = all;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Arm_Delivery Sequence";
    SourceTableView = SORTING("Customer Posting Group", "Sequence No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                }
                field("Load Type"; Rec."Load Type")
                {
                }
                field("Date Calculation"; Rec."Date Calculation")
                {
                }
            }
        }
    }
}