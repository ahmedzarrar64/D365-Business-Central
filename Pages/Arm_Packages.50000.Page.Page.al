page 50000 Arm_Packages
{
    Caption = 'Packages';
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = Arm_Package;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field("Load Type"; Rec."Load Type")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}