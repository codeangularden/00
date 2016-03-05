USE [NMUJ]
GO
/****** Object:  StoredProcedure [dbo].[REQV2_AddRequestProfileCorrection]    Script Date: 03/04/2016 12:42:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
--[dbo].[REQV2_AddRequestProfileCorrection]  '<newdataset><requestprofilecorrection><fk_uni_id>325</fk_uni_id><fk_year>2007</fk_year><fk_student_id>496</fk_student_id><section_name>Qualification Details</section_name><field_name>Grade</field_name><qualification_name>SSC-</qualification_name><old_value>A</old_value><new_value>D</new_value><created_by>0000005841</created_by></requestprofilecorrection></newdataset>'
ALTER PROCEDURE [dbo].[REQV2_AddRequestProfileCorrection] 
@RequestXML NTEXT    
AS     
DECLARE @hdoc INT    
IF (@RequestXML IS NOT NULL)     
   BEGIN    
    
      EXEC sp_xml_preparedocument @hDoc OUTPUT,@RequestXML    
    
--This code inserts new data.    
      INSERT   INTO REQV2_RequestProfileCorrection    
               (    
                fk_uni_id,    
                fk_Year,    
                fk_Student_ID,    
                Field_ID,    
                Qualification_Name,    
                Old_Value,    
                New_Value,    
              
                Date_Of_Request,  
                Created_By ,  
                  Status  
               )    
               SELECT   fk_Uni_ID,    
                        fk_Year,    
                        fk_Student_ID,    
                        (    
                         SELECT DISTINCT    
                                 (pk_Field_ID)    
                         FROM    REQV2_Mst_FieldName (NOLOCK)    
                         WHERE   Field_Name = XMLRequestProfileCorrection.Field_Name AND    
                                 Section_Name = XMLRequestProfileCorrection.Section_Name    
                        ),    
                        Qualification_Name,    
                        Old_Value,    
                        New_Value,    
                        
                        Date_Of_Request,Created_By ,  Status 
               FROM     OPENXML (@hdoc, '/NewDataSet/RequestProfileCorrection',2)    
WITH ( fk_Uni_ID SMALLINT, fk_Year SMALLINT, fk_Student_ID INT,     
 Section_Name VARCHAR(50),  Field_Name VARCHAR(50),Qualification_Name VARCHAR(200),     
 Old_Value NVARCHAR(300), New_Value NVARCHAR(300), Date_Of_Request DATETIME, Created_By varchar(10),Status char(1)) XMLRequestProfileCorrection    
    
      EXEC sp_xml_removedocument @hDoc    
    
   END    
    
    





