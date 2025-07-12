table 50000 Arm_Package
{
    LookupPageID = Arm_Packages;

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Load Type"; Code[20])
        {
        }
    }
    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Load Type")
        {
        }
    }
}

