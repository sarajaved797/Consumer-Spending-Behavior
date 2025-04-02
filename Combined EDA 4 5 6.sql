use fraud_db;

-- EDA
-- General Data Inspection

DESCRIBE cc_trx;
-- or
SHOW COLUMNS FROM cc_trx;


-- b) Check for Data Integrity and Consistency
SELECT * FROM cc_trx LIMIT 10;

-- 2 Change column-- only renames the column based off on existing datatype
ALTER TABLE cc_trx  
CHANGE COLUMN Num Rec_num  varchar(255);

ALTER TABLE cc_trx
CHANGE COLUMN merchant Merchant Text;

ALTER TABLE cc_trx
CHANGE COLUMN category Category Text;

ALTER TABLE cc_trx
CHANGE COLUMN amt Amount INT;

ALTER TABLE cc_trx
CHANGE COLUMN city City Text;

ALTER TABLE cc_trx
CHANGE COLUMN state State Text;

ALTER TABLE cc_trx
CHANGE COLUMN zip Zip_code int;

ALTER TABLE cc_trx
CHANGE COLUMN city_pop City_pop int;

ALTER TABLE cc_trx
CHANGE COLUMN job Profession Text;

 ALTER TABLE cc_trx
 CHANGE COLUMN dob DOB date;
 
 ALTER TABLE cc_trx
 CHANGE COLUMN chunk_num Chunk_num int;



-- Modify column--------------- does everything else except renaming the column
ALTER TABLE cc_trx  
MODIFY COLUMN Rec_num INT;

-- Data Type Conversion

-- 1. Correcting trans_date column's  date format

UPDATE cc_trx 
SET 
    tran_date = STR_TO_DATE(tran_date, '%m/%d/%Y %H:%i:%s');


--  Changing data type from text to DATETIME after above format correction

ALTER TABLE cc_trx  
MODIFY COLUMN tran_date DATETIME ;



-- Converting column DOB to correct date format
 
UPDATE cc_trx
SET DOB = STR_TO_DATE(DOB, '%m/%d/%Y')
WHERE DOB IS NOT NULL;

-- Changing data type from text to DATE after above format correction
ALTER TABLE cc_trx
MODIFY COLUMN dob DATE;


-- Final verification
SELECT 
    tran_date
FROM
    cc_trx
LIMIT 10;

 
-- checking for data consistency-- storing data in correct data type
SHOW COLUMNS FROM cc_trx;


-- Remove the word 'fraud' from merchant column


UPDATE cc_trx 
SET 
    merchant = CASE
        WHEN merchant LIKE 'fraud_%' THEN SUBSTRING(merchant, 7)
        ELSE merchant
    END;

-- checking for null values

SELECT 
    COUNT(*)
FROM
    cc_trx
WHERE
    Num IS NULL;


-- Checking for inconsistent data
-- A.non-numeric values in numeric columns

SELECT 
    amount
FROM
    cc_trx
WHERE
    amount NOT REGEXP '^[0-9]+$';


-- B.Check for Blank or Null Values 

SELECT 
    *
FROM
    cc_trx
WHERE
    amount IS NULL OR amount = '';

-- C. Check for Outliers in Amount Spent
SELECT *
FROM cc_trx
WHERE amount > (SELECT AVG(amount) + 3 * STDDEV(amount) FROM cc_trx)
OR amount < (SELECT AVG(amount) - 3 * STDDEV(amount) FROM cc_trx);

-- D. •	Check for unique values in categorical columns

	SELECT DISTINCT
    profession
FROM
    cc_trx;
    
    
-- Checking for and deleting duplicate rows
-- Find duplicate rows based on key columns
-- Remove duplicates if any

DELETE FROM cc_trx
WHERE rec_num NOT IN (
  SELECT MIN(rec_num)
  FROM cc_trx
  GROUP BY number, tran_date, merchant, amount
);

-- Data validation--- all numeric columns have numeric data
SELECT *
FROM cc_trx
WHERE rec_num NOT REGEXP '^[0-9]+$'
   OR amount NOT REGEXP '^[0-9]+$'
   OR city_pop NOT REGEXP '^[0-9]+$';
  

-- Check for Date Range
SELECT MIN(tran_date) as start_date, MAX(tran_date) as end_date
FROM cc_trx;


-- Calculating Age from DOB for customer segmentation later--leap year included
-- TIMESTAMPDIFF function, returns the difference between two dates in a specified unit (e.g., years):

SELECT 
    rec_num, 
    tran_date, 
    merchant, 
    amount, 
    gender, 
    city, 
    state, 
    TIMESTAMPDIFF(YEAR, dob, CURRENT_DATE) AS Age
FROM 
    cc_trx;


-- now adding Age column to the table permanently

ALTER TABLE cc_trx
ADD COLUMN Age INT;


-- Updating the age column with calculated values

UPDATE cc_trx
SET Age = TIMESTAMPDIFF(YEAR, dob, CURRENT_DATE);


-- Step-by-Step Cleaning for gender Column

-- Checking for Distinct Values:
SELECT DISTINCT gender FROM cc_trx;


-- Checking for Null values
UPDATE cc_trx
SET gender = 'Unknown'  
WHERE gender IS NULL OR gender = '';


-- Trim Extra Spaces: Remove leading or trailing spaces from any values
UPDATE cc_trx
SET gender = TRIM(gender);




-- Advanced EDA
-- Distribution Analysis 
-- Categorical data

SELECT Merchant,Category,Gender,State,Age,COUNT(*) AS Frequency
FROM cc_trx
GROUP BY Merchant,Category,Gender,State,Age;


-- SQL doesn’t support direct histograms, but we can simulate it with GROUP BY and COUNT: 

	SELECT FLOOR(amount/10)*10 AS `range`, COUNT(*) 
FROM cc_trx 
GROUP BY `range`
ORDER BY `range`;


-- Alias range: Since range is a reserved word in MySQL, wrap it in backticks (`).
-- COUNT(*): This will count the number of records in each group.
-- *FLOOR(amount/10)10: This groups the amount into 10s (e.g., 10-19, 20-29, etc.).



SELECT FLOOR(amount/10)*10 AS `range`, COUNT(*) 
FROM cc_trx 
GROUP BY `range`
ORDER BY `range`;




-- Adding the newly created column Profession_Category to the main table permanently


ALTER TABLE cc_trx  
ADD COLUMN profession_category VARCHAR(50);  





-- Creating groups of profession for streamlined segmentation later. adding it to the main table permanently

UPDATE cc_trx 
SET 
    Profession_category = CASE
        WHEN
            profession IN ('Acupuncturist' , 'Ambulance person',
                'Animal nutritionist',
                'Animal technologist',
                'Child psychotherapist',
                'Chiropodist',
                'Clinical psychologist',
                'Community pharmacist',
                'Counselling psychologist',
                'Counsellor',
                'Dance movement psychotherapist',
                'Diagnostic radiographer',
                'Dispensing optician',
                'Doctor, general practice',
                'Doctor, hospital',
                'Embryologist, clinical',
                'Exercise physiologist',
                'Forensic psychologist',
                'General practice doctor',
                'Geneticist, molecular',
                'Health and safety adviser',
                'Health physicist',
                'Health promotion specialist',
                'Health service manager',
                'Health visitor',
                'Herbalist',
                'Homeopath',
                'Hospital doctor',
                'Hospital pharmacist',
                'Immunologist',
                'Learning disability nurse',
                'Medical physicist',
                'Medical sales representative',
                'Medical secretary',
                'Medical technical officer',
                'Mental health nurse',
                'Neurosurgeon',
                'Nurse, childrens',
                'Nurse, mental health',
                'Nutritional therapist',
                'Occupational hygienist',
                'Occupational psychologist',
                'Occupational therapist',
                'Oncologist',
                'Optometrist',
                'Orthoptist',
                'Osteopath',
                'Paediatric nurse',
                'Paramedic',
                'Pathologist',
                'Pharmacist, community',
                'Pharmacist, hospital',
                'Pharmacologist',
                'Physicist medical',
                'Nurse, children\'s',
                'Physiotherapist',
                'Physicist, medical',
                'Phytotherapist',
                'Optician, dispensing',
                'Podiatrist',
                'Psychiatric nurse',
                'Psychiatrist',
                'Psychologist, clinical',
                'Psychologist, counselling',
                'Psychologist, forensic',
                'Psychologist, sport and exercise',
                'Psychotherapist',
                'Psychotherapist, child',
                'Radio broadcast assistant',
                'Music therapist',
                'Radiographer, therapeutic',
                'Radiographer, diagnostic',
                'Radiographer, therapeutic\'Surgeon',
                'Tree surgeon',"Therapist, music",
                'Therapist, occupational','Therapist, horticultural',
                'Surgeon',
                'Veterinary surgeon')
        THEN
            'Healthcare'
        WHEN
            profession IN ('Academic librarian' , 'Administrator',
                'education',
                'Associate Professor',
                'Careers adviser',
                'Lecturer, higher education',
                'Careers information officer','Commissioning editor',
                'Community education officer',
                'Early years teacher',
                'Educational psychologist',
                'Education administrator',
                'Education officer, community',
                'Education officer, museum',
                'English as a foreign language teacher',
                'Environmental education officer',
                'Further education lecturer',
                'Higher education careers adviser',
                'Learning mentor',
                'Lecturer, further education',
                'Lecturer higher,education',
                'Librarian, academic',
                'Librarian, public',
                'Lexicographer',
                'Outdoor activities/education manager',
                'Primary school teacher',
                'Private music teacher',
                'Professor Emeritus',
                'Public librarian',
                'Secondary school teacher',
                'Science writer',
                'Special educational needs teacher',
                'Teacher, adult education',
                'Teacher, early years/pre',
                'Teacher, English as a foreign language',
                'Teacher, primary school',
                'Teacher, secondary school',
                'Music tutor','Secretary/administrator',
                'Teacher, special educational needs',
                'Teaching laboratory technician',
                'English as a second language teacher',
                'Writer',
                'TEFL teacher')
        THEN
            'Education'
        WHEN
            profession IN ('Applications developer' , 'Chief Technology Officer',
                'Administrator, education',
                'Information officer',
                'Information systems manager',
                'IT consultant','Intelligence analyst','Database administrator',
                'IT trainer',
                'Multimedia programmer',
                'Programmer, applications',
                'Programmer, multimedia',
                'Systems analyst',
                'Systems developer',
                'Web designer')
        THEN
            'Technology'
        WHEN
            profession IN ('Aeronautical engineer' , 'Biomedical engineer',
                'Broadcast engineer',
                'Building services engineer',
                'Chemical engineer',
                'Civil engineer, contracting',
                'Contracting civil engineer',
                'Communications engineer',
                'Control and instrumentation engineer',
                'Drilling engineer',
                'Electrical engineer',
                'Electronics engineer',
                'Energy engineer',
                'Engineer, aeronautical',
                'Engineer, agricultural',
                'Engineer, automotive',
                'Engineer, biomedical',
                'Materials engineer',
                'Engineer, broadcasting (operations)',
                'Engineer, building services',
                'Engineer, civil (consulting)',
                'Engineer, civil (contracting)',
                'Engineer, communications',
                'Engineer, control and instrumentation',
                'Engineer, drilling',
                'Engineer, electronics',
                'Engineer, land',
                'Engineer, maintenance',
                'Engineer, manufacturing',
                'Engineer, materials',
                'Engineer, mining',
                'Engineer, petroleum',
                'Engineer, production',
                'Engineer, site',
                'Engineering geologist',
                'Engineer, structural',
                'Engineer, technical sales',
                'Maintenance engineer',
                'Manufacturing engineer',
                'Manufacturing systems engineer',
                'Geologist, engineering',
                'Mechanical engineer',
                'Mining engineer',
                'Network engineer',
                'Petroleum engineer',
                'Production engineer','Colour technologist',
                'Operations geologist','Quantity surveyor',
                'Site engineer',
                'Wellsite geologist',
                'Structural engineer',
                'Structural engineer',
                'Contracting civil engineer',
                'Water engineer')
        THEN
            'Engineering'
        WHEN
            profession IN ('Accountant' , 'chartered,
                                                                Accountant',
                'chartered certified',
                'Accountant, \'chartered public finance',
                'Accounting technician',
                'Chartered accountant',
                'Chief Financial Officer',
                'Corporate investment banker','Economist',
                'Financial adviser',
                'Financial trader',
                'Investment analyst',
                'Investment banker, corporate',
                'Investment banker, operational',
                'Futures trader',
                'Pension scheme manager',
                'Pensions consultant',
                'Risk analyst',
                'Senior tax professional/tax inspector',
                'Equities trader',
                'Tax adviser',
                'Retail banker',
                'Chartered public finance accountant',
                'Tax inspector')
        THEN
            'Finance and Accounting'
        WHEN
            profession IN ('Animator' , 'Art gallery manager',
                'Administrator, arts',
                'Art therapist',
                'Accountant, chartered',
                'Accountant, chartered certified',
                'Accountant, chartered public finance',
                'Artist\'Arts development officer',
                'Broadcast journalist',
                'Broadcast presenter',
                'Community arts worker',
                'Conservator, museum/gallery',
                'Copywriter, advertising',
                'Curator',
                'Curator',
                'Magazine features editor',
                'Dancer',
                'Magazine journalist',
                'Designer, ceramics/pottery,',
                'Designer, exhibition/display',
                'Designer, furniture',
                'Designer, industrial/product',
                'Musician',
                'Designer, interior/spatial',
                'Designer, jewellery',
                'Designer, multimedia',
                'Designer, television/film set',
                'Designer, textile',
                'Editor, film/video',
                'Editor, magazine features',
                'Event organiser',
                'Exhibition designer',
                'Exhibitions officer, museum/gallery',
                'Film/video editor,\'Fine artist\', \'Illustrator',
                'Jewellery designer',
                'Ceramics designer',
                'Magazine features editor\'Magazine journalist',
                'Museum education officer',
                'Media buyer',
                'Media planner',
                'Museum/gallery conservator',
                'Museum/gallery exhibitions officer',
                'Presenter, broadcasting',
                'Press photographer',
                'Press sub',
                'Producer, radio',
                'Producer, television/film/video',
                'Product designer',
                'Product manager',
                'Production assistant, radio',
                'Production assistant, television',
                'Stage manager',
                'Designer, ceramics/pottery',
                'Film/video editor',
                'Fine artist',
                'Television camera operator',
                'Journalist, newspaper',
                'Television floor manager',
                'Television production assistant',
                'Interpreter',
                'Television/film/video producer',
                'Theatre director',
                'Theatre manager',
                'Theme park manager',
                'Therapist, art',
                'Therapist, drama',
                'Artist',
                'Radio producer',
                'Interior and spatial designer',
                'Textile designer',
                'Therapist, music, \'Video editor',
                'Video editor',
                'Set designer',
                'Camera operator','Archivist',
                'Arts development officer',"Glass blower/designer",
                'Production manager',
                'Special effects artist','Furniture designer',
                'Programme researcher, broadcasting/film/video')
        THEN
            'Art and Entertainment'
        WHEN
            profession IN ('Analytical chemist' , 'Audiological scientist',
                'Biochemist, clinical',
                'Biomedical scientist','Illustrator',
                'Chemist, analytical',
                'Cytogeneticist',
                'Clinical cytogeneticist',
                'Clinical biochemist',
                'Clinical research associate',
                'Data scientist',"Editor, commissioning",
                'Geochemist',
                'Geologist, wellsite',
                'Geophysicist/field seismologist',
                'Geoscientist',
                'Herpetologist','Energy manager',
                'Hydrogeologist',
                'Hydrographic surveyor',
                'Hydrologist',
                'Metallurgist',
                'Clothing/textile technologist',
                'Oceanographer',
                'Physiological scientist',
                'Product/process development scientist',
                'Research scientist (life sciences)',
                'Research scientist (maths)',
                'Research scientist (medical)',
                'Research scientist (physical sciences)','Operational researcher',
                'Scientific laboratory technician',
                'Scientist, audiological',
                'Scientist, biomedical',
                'Scientist, clinical (histocompatibility and immunogenetics)',
                'Scientist, marine',
                'Scientist, physiological',
                'Scientist, research (maths)',
                'Scientist, research (medical)',
                'Scientist, research (physical sciences)',
                'Soil scientist',
                'Social researcher',
                'Statistician','Technical brewer',
                'Ecologist','Garment/textile technologist',
                'Surveyor, hydrographic','Seismic interpreter',
                'Toxicologist','Telecommunications researcher',
                'Water quality scientist')
        THEN
            'Science'
        WHEN
            profession IN ('Barrister' , 'Barrister\'s clerk',
                'Chartered legal executive (England and Wales)',
                'Lawyer',
                'Legal secretary',
                'Patent attorney',
                'Probation officer',
                'Barrister',
                'Barrister\'s clerk',
                'Chartered legal executive (England and Wales)\'Lawyer',
                'Legal secretary',
                'Patent attorney',
                'Company secretary',
                'Solicitor',
                'Solicitor, Scotland',
                'Trade mark attorney')
        THEN
            'Legal'
        WHEN
            profession IN ('Administrator' , 'local government',
                'Armed forces logistics/support/administrative officer',
                'Armed forces’, technical officer',
                'Armed forces training and education officer',
                'Chief Civil Service administrator',
                'Civil Service fast streamer',
                'Chief of Staff',
                'Comptroller',
                'Politician\'s assistant',
                'Immigration officer',
                'Local government officer',
                'Police officer',
                'Prison officer',
                'Regulatory affairs officer',
                'Research officer, political party',
                'Public house manager',
                'Public affairs consultant',
                'Research officer',
                'Civil Service administrator',
                'Social research officer, government',
                'trade union',
                'Public relations officer',
                'Trading standards officer',
                'Administrator, local government',
                'Public relations account executive',
                'Armed forces technical officer',
                'Town planner\'Social research officer, government')
        THEN
            'Government'
        WHEN
            profession IN ('Buyer, industrial' , 'Buyer, retail',
                'Bookseller',
                'Barista',
                'Industrial buyer',
                'Industrial/product designer',
                'Merchandiser, retail',
                'Restaurant manager, fast food',
                'Retail buyer',
                'Retail manager',
                'Retail merchandiser',
                'Catering manager',
                'Sales executive',
                'Sales promotion account executive',
                'Sales professional, IT',
                'Dealer',
                'Purchasing manager','Visual merchandiser')
        THEN
            'Retail and Sales'
        WHEN
            profession IN ('Advertising account executive' , 'Advertising account planner',
                'Advertising copywriter',
                'Market researcher',
                'Marketing executive')
        THEN
            'Advertising'
        WHEN
            profession IN ('Aid worker' , 'Administrator, charities/voluntary organisations',
                'Advice worker',
                'Volunteer coordinator',
                'Charity fundraiser',
                'Charity officer',
                'Community development worker',
                'Development worker, community',
                'Development worker, international aid')
        THEN
            'Charity'
        WHEN
            profession IN ('Chief Executive Officer' , 'Chief Marketing Officer',
                'Chief Operating Officer',
                'Chief Strategy Officer')
        THEN
            'C_suite'
        WHEN
            profession IN ('Agricultural consultant' , 'Amenity horticulturist',
                'Arboriculturist',
                'Commercial horticulturist',
                'Commercial/residential surveyor',
                'Farm manager','Building control surveyor',
                'Fisheries officer',
                'Forest/woodland manager',
                'Horticultural consultant',
                'Horticultural therapist',
                'Horticulturist, commercial',
                'Land',
                'Land/geomatics surveyor',
                'Landscape architect',
                'Minerals surveyor',
                'Mudlogger',
                'Nature conservation officer',
                'Plant breeder/geneticist',
                'Surveyor, minerals',
                'Surveyor, land/geomatics',
                'Field seismologist',
                'Rural practice surveyor',
                'Surveyor, mining',
                'Waste management officer',
                'Planning and development surveyor',
                'Town planner',"Estate manager/land agent",
                'Warden/ranger')
        THEN
            'Land and Farm'
        WHEN
            profession IN ('Architect' , 'Architectural technologist',
                'Naval architect',
                'Historic buildings inspector/conservation officer','Surveyor, rural practice',
                'Conservation officer, historic buildings','Archaeologist','Cartographer',
                'Building surveyor')
        THEN
            'Architecture'
        WHEN
            profession IN ('Claims inspector/assessor' , 'Insurance underwriter',
                'Chartered loss adjuster',
                'Insurance risk surveyor',
                'Insurance broker',
                'Insurance claims handler',
                'Loss adjuster, chartered')
        THEN
            'Insurance'
        WHEN
            profession IN ('Environmental consultant' , 'Environmental health practitioner',
                'Environmental manager')
        THEN
            'Envoirnment'
        WHEN
            profession IN ('Travel agency manager' , 'Heritage manager',
                'Tourist information centre manager','Air broker',
                'Tourism officer','Cabin crew',
                'Tour manager',
                'Pilot, airline',
                'Airline pilot',
                'Transport planner','Leisure centre manager',
                'Air cabin crew',
                'Air traffic controller','Hotel manager','Field trials officer',
                'Ship broker')
        THEN
            'Tourism_Aviation'
            
            
       WHEN profession IN ('Personnel officer','Management consultant','Records manager','Training and development officer',
       
       'Emergency planning/management officer','Equality and diversity officer','Human resources officer',
       'Race relations officer') THEN 'Human Resources'       
            
		
		WHEN profession IN ('Therapist, sports','Sports development officer','Sport and exercise psychologist',
        'Sports administrator','Fitness centre manager') THEN 'Sports'              
		
		WHEN 
			profession IN ('Firefighter','Facilities manager','Call centre manager','Research officer,trade union',
		'Licensed conveyancer','Contractor','Gaffer','Location manager','Quarry manager','Freight forwarder',
			'Logistics and distribution manager',"Research officer, trade union","Conservator, furniture",
            'Furniture conservator/restorer') THEN 'Unskilled Labor'              
          
	            
             ELSE 'Other'
    END; 
    

-- Checking contents of the Other category 

SELECT profession, COUNT(*) AS count
FROM cc_trx
WHERE profession_category = 'Other'
GROUP BY profession
ORDER BY count DESC;


-- Checking for missing entries
SELECT profession, COUNT(*) 
FROM cc_trx
WHERE profession IS NULL OR profession = ''
GROUP BY profession;



-- Deleting the incomplete titles from profession/noise 
-- Calc % of total data
-- ((5439+4532+412)/1048575)*100= .99% very small

DELETE FROM cc_trx  
WHERE profession IN ('Sub', 'Make', 'Copy');  


-- Dropping the old profession column
ALTER TABLE cc_trx  
DROP COLUMN Profession;


-- Renaming column created by Case for clarity
ALTER TABLE cc_trx  
RENAME COLUMN profession_category TO Profession;

    

-- shows datatypes of columns
DESCRIBE cc_trx;
  


SELECT 
    DATE_FORMAT(tran_date, '%Y-%m') AS Month_Year,
    COUNT(*) AS Transaction_Count
FROM 
    cc_trx
GROUP BY 
    Month_Year
ORDER BY 
    Month_Year DESC;


