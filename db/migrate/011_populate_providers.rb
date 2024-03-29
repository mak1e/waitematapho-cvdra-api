class PopulateProviders < ActiveRecord::Migration
  def self.up
    Provider.create_with_id 100, :organisation_id => 30, :name => 'Marcus Platts-Mills', :registration_no => '19583'
    Provider.create_with_id 101, :organisation_id => 30, :name => 'Martin Denby', :registration_no => '20346'
    Provider.create_with_id 102, :organisation_id => 30, :name => 'Warren Groarke', :registration_no => '32339'
    Provider.create_with_id 103, :organisation_id => 30, :name => 'Aideen Hawkins', :registration_no => '8356'
    Provider.create_with_id 104, :organisation_id => 36, :name => 'Clare Dudding', :registration_no => '15866'
    Provider.create_with_id 105, :organisation_id => 36, :name => 'John Pollock', :registration_no => '7584'
    Provider.create_with_id 106, :organisation_id => 36, :name => 'David Thompson', :registration_no => '12199'
    Provider.create_with_id 107, :organisation_id => 36, :name => 'Rosalind Reid', :registration_no => '21323'
    Provider.create_with_id 108, :organisation_id => 36, :name => 'Lynda Thwaites', :registration_no => '21460'
    Provider.create_with_id 109, :organisation_id => 36, :name => 'Steve Taylor', :registration_no => '10576'
    Provider.create_with_id 110, :organisation_id => 17, :name => 'Barbara Westra', :registration_no => '6995'
    Provider.create_with_id 111, :organisation_id => 20, :name => 'Bruce Sutherland', :registration_no => '16450'
    Provider.create_with_id 112, :organisation_id => 20, :name => 'Kate Baddock', :registration_no => '12258'
    Provider.create_with_id 113, :organisation_id => 20, :name => 'Stephen Barker', :registration_no => '16229'
    Provider.create_with_id 114, :organisation_id => 20, :name => 'Warwick Palmer', :registration_no => '10742'
    Provider.create_with_id 115, :organisation_id => 20, :name => 'Clinton Anderson', :registration_no => '38825'
    Provider.create_with_id 116, :organisation_id => 20, :name => 'Christopher Miller', :registration_no => '29052'
    Provider.create_with_id 117, :organisation_id => 20, :name => 'Diana Makeran', :registration_no => '37772'
    Provider.create_with_id 118, :organisation_id => 23, :name => 'Andrew Macgill', :registration_no => '15791'
    Provider.create_with_id 119, :organisation_id => 23, :name => 'Elspeth Dickson', :registration_no => '16915'
    Provider.create_with_id 120, :organisation_id => 23, :name => 'Steve Maric', :registration_no => '16831'
    Provider.create_with_id 121, :organisation_id => 27, :name => 'Audrey Thorpe', :registration_no => '15380'
    Provider.create_with_id 122, :organisation_id => 27, :name => 'Mark Groen', :registration_no => '14048'
    Provider.create_with_id 123, :organisation_id => 27, :name => 'Matthew Gentry', :registration_no => '17253'
    Provider.create_with_id 124, :organisation_id => 29, :name => 'Beverley Howcroft', :registration_no => '14861'
    Provider.create_with_id 125, :organisation_id => 29, :name => 'John Russell', :registration_no => '8469'
    Provider.create_with_id 126, :organisation_id => 29, :name => 'Tracy Opperman', :registration_no => '17092'
    Provider.create_with_id 127, :organisation_id => 29, :name => 'Rebecca Palmer', :registration_no => '23689'
    Provider.create_with_id 128, :organisation_id => 34, :name => 'Philip Railton', :registration_no => '7959'
    Provider.create_with_id 129, :organisation_id => 35, :name => 'Paul Hunter', :registration_no => '12633'
    Provider.create_with_id 130, :organisation_id => 35, :name => 'Bharati Narothum', :registration_no => '12858'
    Provider.create_with_id 131, :organisation_id => 33, :name => 'Monica Huerta', :registration_no => '15770'
    Provider.create_with_id 132, :organisation_id => 33, :name => 'Angela Konings', :registration_no => '17256'
    Provider.create_with_id 133, :organisation_id => 33, :name => 'Vivienne Nickels', :registration_no => '12659'
    Provider.create_with_id 134, :organisation_id => 33, :name => 'Patricia Shieff', :registration_no => '13207'
    Provider.create_with_id 135, :organisation_id => 33, :name => 'Gee Hing Wong', :registration_no => '28995'
    Provider.create_with_id 136, :organisation_id => 6, :name => 'Michael Hoogerbrug', :registration_no => '10266'
    Provider.create_with_id 137, :organisation_id => 6, :name => 'Trudy Warin', :registration_no => '13978'
    Provider.create_with_id 138, :organisation_id => 6, :name => 'Richard Hursthouse', :registration_no => '11154'
    Provider.create_with_id 139, :organisation_id => 6, :name => 'Veronica Spencer', :registration_no => '12099'
    Provider.create_with_id 140, :organisation_id => 6, :name => 'Bronwyn Armstrong', :registration_no => '21478'
    Provider.create_with_id 141, :organisation_id => 22, :name => 'Peter Cunningham', :registration_no => '13912'
    Provider.create_with_id 142, :organisation_id => 22, :name => 'Vanessa Fardon', :registration_no => '15530'
    Provider.create_with_id 143, :organisation_id => 22, :name => 'Margaret Wanty', :registration_no => '12276'
    Provider.create_with_id 144, :organisation_id => 22, :name => 'Fiona Brow', :registration_no => '18437'
    Provider.create_with_id 145, :organisation_id => 22, :name => 'Denise Watt', :registration_no => '12692'
    Provider.create_with_id 146, :organisation_id => 25, :name => 'Lincoln Wong', :registration_no => '12110'
    Provider.create_with_id 147, :organisation_id => 9, :name => 'Brett Roche', :registration_no => '18950'
    Provider.create_with_id 148, :organisation_id => 9, :name => 'Warren Paykel', :registration_no => '6573'
    Provider.create_with_id 149, :organisation_id => 9, :name => 'Geoffrey Norcliffe', :registration_no => '9096'
    Provider.create_with_id 150, :organisation_id => 9, :name => 'John Mcilwraith', :registration_no => '5787'
    Provider.create_with_id 151, :organisation_id => 9, :name => 'Margaret Field', :registration_no => '15139'
    Provider.create_with_id 152, :organisation_id => 9, :name => 'Linda Lum', :registration_no => '18934'
    Provider.create_with_id 153, :organisation_id => 9, :name => 'David Hopcroft', :registration_no => '17071'
    Provider.create_with_id 154, :organisation_id => 11, :name => 'Chris Dominick', :registration_no => '9200'
    Provider.create_with_id 155, :organisation_id => 11, :name => 'Susan Loughlin', :registration_no => '17533'
    Provider.create_with_id 156, :organisation_id => 12, :name => 'Satish Chandra', :registration_no => '7422'
    Provider.create_with_id 157, :organisation_id => 12, :name => 'Siobhan Trevallyan', :registration_no => '28712'
    Provider.create_with_id 158, :organisation_id => 12, :name => 'Bharati Narothum', :registration_no => '12858'
    Provider.create_with_id 159, :organisation_id => 13, :name => 'John Richmond', :registration_no => '11361'
    Provider.create_with_id 160, :organisation_id => 13, :name => 'Michaela Gerrard', :registration_no => '22085'
    Provider.create_with_id 161, :organisation_id => 13, :name => 'Anne O\'Reilly', :registration_no => '23539'
    Provider.create_with_id 162, :organisation_id => 15, :name => 'Jane Seeley', :registration_no => '13997'
    Provider.create_with_id 163, :organisation_id => 15, :name => 'Richard Mules', :registration_no => '13539'
    Provider.create_with_id 164, :organisation_id => 15, :name => 'Denise Lucas', :registration_no => '12598'
    Provider.create_with_id 165, :organisation_id => 15, :name => 'Anna Catherwood', :registration_no => '18184'
    Provider.create_with_id 166, :organisation_id => 15, :name => 'Robyn Parker', :registration_no => '22192'
    Provider.create_with_id 167, :organisation_id => 19, :name => 'Simon Mayhew', :registration_no => '16430'
    Provider.create_with_id 168, :organisation_id => 19, :name => 'Alison Sorley', :registration_no => '16651'
    Provider.create_with_id 169, :organisation_id => 19, :name => 'John Mayhew', :registration_no => '10737'
    Provider.create_with_id 170, :organisation_id => 19, :name => 'Michele Foster', :registration_no => '19289'
    Provider.create_with_id 171, :organisation_id => 19, :name => 'Valentina Kirova-Veljanovska', :registration_no => '28754'
    Provider.create_with_id 172, :organisation_id => 21, :name => 'Tsui Wen Chen', :registration_no => '14461'
    Provider.create_with_id 173, :organisation_id => 21, :name => 'Elizabeth Chesterfield', :registration_no => '11733'
    Provider.create_with_id 174, :organisation_id => 21, :name => 'Fiona Kerr', :registration_no => '23077'
    Provider.create_with_id 175, :organisation_id => 37, :name => 'Andrew Murley', :registration_no => '13540'
    Provider.create_with_id 176, :organisation_id => 37, :name => 'Neil Hutchison', :registration_no => '7825'
    Provider.create_with_id 177, :organisation_id => 8, :name => 'Christopher Diggle', :registration_no => '8505'
    Provider.create_with_id 178, :organisation_id => 8, :name => 'Phillipa Leys', :registration_no => '13228'
    Provider.create_with_id 179, :organisation_id => 8, :name => 'Jennifer Waddell', :registration_no => '13512'
    Provider.create_with_id 180, :organisation_id => 7, :name => 'David Arcus', :registration_no => '9813'
    Provider.create_with_id 181, :organisation_id => 7, :name => 'Odette Phillips', :registration_no => '12755'
    Provider.create_with_id 182, :organisation_id => 1, :name => 'Sheryl Howarth', :registration_no => '19646'
    Provider.create_with_id 183, :organisation_id => 1, :name => 'Peter Boot', :registration_no => '12142'
    Provider.create_with_id 184, :organisation_id => 1, :name => 'Eugeen Ong', :registration_no => '23824'
    Provider.create_with_id 185, :organisation_id => 1, :name => 'Marcus Platts Mills', :registration_no => '19583'
    Provider.create_with_id 186, :organisation_id => 1, :name => 'Nicola Ford', :registration_no => '23227'
    Provider.create_with_id 187, :organisation_id => 5, :name => 'Shirley Wallace', :registration_no => '13569'
    Provider.create_with_id 188, :organisation_id => 5, :name => 'Shashikala Bhutoji', :registration_no => '22344'
    Provider.create_with_id 189, :organisation_id => 5, :name => 'Cecil Armstrong', :registration_no => '16378'
    Provider.create_with_id 190, :organisation_id => 5, :name => 'Lynne Potter', :registration_no => '12996'
    Provider.create_with_id 191, :organisation_id => 5, :name => 'Michaela Gerrard', :registration_no => '22085'
    Provider.create_with_id 192, :organisation_id => 14, :name => 'Jon Wilcox', :registration_no => '11213'
    Provider.create_with_id 193, :organisation_id => 2, :name => 'Wendy Marshall', :registration_no => '13166'
    Provider.create_with_id 194, :organisation_id => 2, :name => 'John Kyle', :registration_no => '11756'
    Provider.create_with_id 195, :organisation_id => 2, :name => 'Paul Milton', :registration_no => '10786'
    Provider.create_with_id 196, :organisation_id => 2, :name => 'Jacqueline Tam', :registration_no => '18165'
    Provider.create_with_id 197, :organisation_id => 2, :name => 'Phillip Gluckman', :registration_no => '11900'
    Provider.create_with_id 198, :organisation_id => 2, :name => 'Nelly Steinemann', :registration_no => '8981'
    Provider.create_with_id 199, :organisation_id => 4, :name => 'Susan Smith', :registration_no => '12195'
    Provider.create_with_id 200, :organisation_id => 4, :name => 'Eddie Gelbart', :registration_no => '19313'
    Provider.create_with_id 201, :organisation_id => 4, :name => 'Shreeram Mayadeo', :registration_no => '15916'
    Provider.create_with_id 202, :organisation_id => 4, :name => 'Kantilal Kanji', :registration_no => '11262'
    Provider.create_with_id 203, :organisation_id => 31, :name => 'Julian Roberts', :registration_no => '10088'
    Provider.create_with_id 204, :organisation_id => 31, :name => 'Jennifer Cartwright', :registration_no => '29371'
    Provider.create_with_id 205, :organisation_id => 16, :name => 'Heidi Macrae', :registration_no => '29752'
    Provider.create_with_id 206, :organisation_id => 16, :name => 'Richard Rax', :registration_no => '8811'
    Provider.create_with_id 207, :organisation_id => 16, :name => 'Arthur Young', :registration_no => '5915'
    Provider.create_with_id 208, :organisation_id => 16, :name => 'P J Watt', :registration_no => '6788'
    Provider.create_with_id 209, :organisation_id => 16, :name => 'Annie Si', :registration_no => '23177'
    Provider.create_with_id 210, :organisation_id => 16, :name => 'Janice Brown', :registration_no => '13904'
    Provider.create_with_id 211, :organisation_id => 16, :name => 'Alan Dickie', :registration_no => '12008'
    Provider.create_with_id 212, :organisation_id => 16, :name => 'Amanda Henderson', :registration_no => '33558'
    Provider.create_with_id 213, :organisation_id => 16, :name => 'Vesna Mitic', :registration_no => '23523'
    Provider.create_with_id 214, :organisation_id => 16, :name => 'Aubai Said', :registration_no => '23360'
    Provider.create_with_id 215, :organisation_id => 3, :name => 'Pramod Giri', :registration_no => '11100'
    Provider.create_with_id 216, :organisation_id => 3, :name => 'Simon Hammond', :registration_no => '8592'
    Provider.create_with_id 217, :organisation_id => 3, :name => 'Stuart Jenkins', :registration_no => '22296'
    Provider.create_with_id 218, :organisation_id => 3, :name => 'Helen Macdonald', :registration_no => '16095'
    Provider.create_with_id 219, :organisation_id => 3, :name => 'Alison Sorley', :registration_no => '16651'
    Provider.create_with_id 220, :organisation_id => 3, :name => 'Michelle Trumpelmann', :registration_no => '20230'
    Provider.create_with_id 221, :organisation_id => 3, :name => 'Kevin Walters', :registration_no => '18170'
    Provider.create_with_id 222, :organisation_id => 3, :name => 'David Bassett', :registration_no => '9837'
    Provider.create_with_id 223, :organisation_id => 3, :name => 'Lynne Coleman', :registration_no => '13482'
    Provider.create_with_id 224, :organisation_id => 3, :name => 'Anwar Hoosen', :registration_no => '14100'
    Provider.create_with_id 225, :organisation_id => 3, :name => 'Hendrik Swart', :registration_no => '19453'
    Provider.create_with_id 226, :organisation_id => 3, :name => 'Johanne Egan', :registration_no => '21705'
    Provider.create_with_id 227, :organisation_id => 3, :name => 'Caroline Allum', :registration_no => '22699'
    Provider.create_with_id 228, :organisation_id => 3, :name => 'Susan Smith', :registration_no => '12195'
    Provider.create_with_id 229, :organisation_id => 3, :name => 'John Wellingham', :registration_no => '9539'
    Provider.create_with_id 230, :organisation_id => 3, :name => 'Gabrielle Schnider', :registration_no => '29315'
    Provider.create_with_id 231, :organisation_id => 24, :name => 'Jane Lockwood', :registration_no => '13186'
    Provider.create_with_id 232, :organisation_id => 24, :name => 'Michael Lockwood', :registration_no => '12171'
    Provider.create_with_id 233, :organisation_id => 18, :name => 'Serene Hu', :registration_no => '7918'
    Provider.create_with_id 234, :organisation_id => 28, :name => 'Gary Johnstone', :registration_no => '5207'
    Provider.create_with_id 235, :organisation_id => 28, :name => 'Deborah Hay', :registration_no => '13503'
    Provider.create_with_id 236, :organisation_id => 28, :name => 'Prakash Apanna', :registration_no => '16748'
    Provider.create_with_id 237, :organisation_id => 28, :name => 'Oliver Samin', :registration_no => '31728'
    Provider.create_with_id 238, :organisation_id => 10, :name => 'Ivan Gannaway', :registration_no => '15760'
    Provider.create_with_id 239, :organisation_id => 10, :name => 'Zina Emmanuel', :registration_no => '23419'
    Provider.create_with_id 240, :organisation_id => 10, :name => 'Margaret Bryant', :registration_no => '13707'
    Provider.create_with_id 241, :organisation_id => 10, :name => 'Rex Sinclair', :registration_no => '3243'
    Provider.create_with_id 242, :organisation_id => 10, :name => 'Rosemary Room', :registration_no => '7779'
    Provider.create_with_id 243, :organisation_id => 26, :name => 'Caroline Meade', :registration_no => '20922'
    Provider.create_with_id 244, :organisation_id => 26, :name => 'David Scott', :registration_no => '5468'
    Provider.create_with_id 245, :organisation_id => 26, :name => 'Glenda Lowe', :registration_no => '15161'
    Provider.create_with_id 246, :organisation_id => 26, :name => 'Lesley Yan', :registration_no => '19580'
    Provider.create_with_id 247, :organisation_id => 26, :name => 'Robin Kelly', :registration_no => '10370'
    Provider.create_with_id 248, :organisation_id => 26, :name => 'Shashikala Bhuthoji', :registration_no => '22344'
  end

  def self.down
  end
end
