pageextension 50010 Arm_SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Package Code"; Rec."Package Code")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
        }
    }
}

