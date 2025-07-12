table 50003 "Arm_Delivery Sequence"
{
    fields
    {
        field(1; "Customer Posting Group"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(2; "Sequence No."; Integer)
        {
        }
        field(3; "Load Type"; Code[20])
        {
            TableRelation = Arm_Package;
            trigger OnValidate()
            var
                package: Record Arm_Package;
            begin
                package.GET("Load Type");
                "Load Type" := package."Load Type";
            end;
        }
        field(4; "Date Calculation"; DateFormula)
        {
        }
    }

    keys
    {
        key(Key1; "Customer Posting Group", "Load Type")
        {
        }
        key(Key2; "Customer Posting Group", "Sequence No.")
        {
        }
    }

    fieldgroups
    {
    }
}

