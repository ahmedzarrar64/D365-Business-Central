page 50001 "Arm_Schedule Statuses"
{
    Caption = 'Schedule Statuses';
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Arm_Schedule Status";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}

