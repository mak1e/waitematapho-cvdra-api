class CreateProgrammeElements < ActiveRecord::Migration
  def self.up
    create_table :programme_elements do |t|
      t.integer 'programme_id', :null => false
      t.column 'position', :integer, :null => false, :default => 0
      t.column 'description', :string, :limit => 38, :null => false
      t.column 'column_name', :string, :limit => 38, :null => false
      t.column 'data_type', :string, :limit => 8, :null => false
      t.column 'limit', :integer
      t.column 'choices', :string, :limit => 78
    end
    
    add_index :programme_elements, [:programme_id,:position]

    ProgrammeElement.create_with_id 20, :column_name => 'cvdr_cvd_risk',  :description => 'Cvd Risk',  :position => 0, :data_type => 'decimal', :programme_id => 2, :limit => 3
    ProgrammeElement.create_with_id 21, :column_name => 'diab_type_of_diabetes',  :description => 'Type Of Diabetes',  :choices => "No diabetes\r\nType 1\r\nType 2\r\nGestational\r\nStatus unknown", :position => 1, :data_type => 'string', :programme_id => 2, :limit => 4
    ProgrammeElement.create_with_id 22, :column_name => 'angi_angina_ami',  :description => 'Angina/Ami',  :choices => "No\r\nYes", :position => 2, :data_type => 'string', :programme_id => 2
    ProgrammeElement.create_with_id 23, :column_name => 'tia_stroke_tia',  :description => 'Stroke/Iia',  :choices => "No\r\nYes", :position => 3, :data_type => 'string', :programme_id => 2
    ProgrammeElement.create_with_id 24, :column_name => 'pvd_peripheral_vessel_disease',  :description => 'PVD',  :choices => "No\r\nYes", :position => 4, :data_type => 'string', :programme_id => 2
    ProgrammeElement.create_with_id 25, :column_name => 'atfi_atrial_fibrillation',  :description => 'Atrial Fibrillation',  :choices => "No\r\nYes", :position => 5, :data_type => 'string', :programme_id => 2
    ProgrammeElement.create_with_id 26, :column_name => 'mets_diagnosed_metabolic_syndrome',  :description => 'Metabolic Syndrome',  :choices => "No\r\nYes", :position => 6, :data_type => 'string', :programme_id => 2
    ProgrammeElement.create_with_id 27, :column_name => 'gld_genetic_lipid_disorder',  :description => 'Genetic Lipid Disorder',  :choices => "No\r\nYes", :position => 7, :data_type => 'string', :programme_id => 2

    ProgrammeElement.create_with_id 30, :column_name => 'diab_type_of_diabetes',  :description => 'Type Of Diabetes',  :choices => "No diabetes\r\nType 1\r\nType 2\r\nGestational\r\nStatus unknown", :position => 0, :data_type => 'string', :programme_id => 3
    ProgrammeElement.create_with_id 31, :column_name => 'smok_smoking_history',  :description => 'Smoking History',  :choices => "No\r\nPast\r\nRecently quit\r\nYes - up to 10 / day\r\nYes - 11-19 / day\r\nYes - 20+ / day\r\nYes", :position => 1, :data_type => 'string', :programme_id => 3
    ProgrammeElement.create_with_id 32, :column_name => 'retind_date_last_retinal_screening',  :description => 'Date Last Retinal',  :position => 2, :data_type => 'date', :programme_id => 3
    ProgrammeElement.create_with_id 33, :column_name => 'hba1c_hba1c',  :description => 'HBA1c',  :position => 3, :data_type => 'decimal', :programme_id => 3, :limit => 4
    ProgrammeElement.create_with_id 34, :column_name => 'tc_total_cholesterol',  :description => 'Total Cholesterol',  :position => 4, :data_type => 'decimal', :programme_id => 3, :limit => 4
    ProgrammeElement.create_with_id 35, :column_name => 'acei_ace_inhibitor',  :description => 'Ace Inhibitor',  :choices => "No\r\nContra-indicated\r\nDeclined\r\nYes", :position => 5, :data_type => 'string', :programme_id => 3
    ProgrammeElement.create_with_id 36, :column_name => 'statin_statin',  :description => 'Statin',  :choices => "No\r\nContra-indicated\r\nDeclined\r\nYes", :position => 6, :data_type => 'string', :programme_id => 3
  end

  def self.down
    drop_table :programme_elements
  end
end
