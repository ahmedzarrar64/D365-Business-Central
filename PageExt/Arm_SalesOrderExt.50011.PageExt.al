pageextension 50011 Arm_SalesOrderExt extends "Sales Order"
{
    layout
    {
        addafter(Control91)
        {
            field("Load Type"; Rec."Load Type")
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    salesLine: Record "Sales Line";
                    package: Record Arm_Package;
                    DialogResult: Boolean;
                begin
                    DialogResult := Confirm('Do you want to change the "Package Code" field for all lines associated with this "Sales Order" in the "Sales Line" table?', false);
                    if DialogResult then begin
                        package.SetFilter("Load Type", Rec."Load Type");
                        if package.FindSet() then begin
                            salesLine.SetFilter("Document No.", Rec."No.");
                            if salesLine.FindSet() then begin
                                repeat
                                    salesLine."Package Code" := package.Code;
                                    salesLine.Modify();
                                until salesLine.Next() = 0;
                            end;
                            rec."Delivery Sequence" := salesLine.GetDeliverySequence(Rec, Rec."Load Type");
                            Rec.Modify();
                        end;
                    end;
                end;
            }
            field("Delivery Sequence"; Rec."Delivery Sequence")
            {
                ApplicationArea = all;
            }
            field("Schedule Status"; Rec."Schedule Status")
            {
                ApplicationArea = all;
            }
        }
    }
}