pageextension 50002 Arm_JobGLJourExt extends "Job G/L Journal"
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