/*
  # CargaAgenda - Truck Loading Management System

  ## Overview
  Creates the core table for managing truck loading schedules with support for
  tracking loading windows, completion status, and cargo details.

  ## New Tables
  
  ### `truck_loadings`
  Main table for storing truck loading information:
  - `id` (uuid, primary key) - Unique identifier for each loading
  - `truck_id` (text) - Truck identification (license plate or ID)
  - `cotacao` (text) - Cotação or quote reference
  - `quantity` (text) - Amount to be loaded (flexible format)
  - `start_date` (date) - Beginning of loading window
  - `end_date` (date) - End of loading window
  - `carrier` (text) - Carrier name
  - `completed_date` (date, optional) - Actual completion date
  - `is_completed` (boolean) - Whether loading has been completed
  - `status` (text) - Current status: 'pending', 'completed', or 'cancelled'
  - `notes` (text, optional) - Additional notes or comments
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ## Security
  
  - Enable Row Level Security (RLS) on `truck_loadings` table
  - Only authenticated users can access the data
  
  ## Notes
  
  1. The `start_date` and `end_date` define the loading window
  2. Status is automatically set based on `is_completed` but can be manually overridden
  3. Uses timestamptz for proper timezone handling
  4. All text fields allow flexible data entry for various use cases
*/

CREATE TABLE IF NOT EXISTS truck_loadings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  truck_id text NOT NULL,
  cotacao text NOT NULL,
  quantity text NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  carrier text DEFAULT '',
  completed_date date,
  is_completed boolean DEFAULT false,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE truck_loadings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view all loadings"
  ON truck_loadings
  FOR SELECT
  TO authenticated
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can insert loadings"
  ON truck_loadings
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can update loadings"
  ON truck_loadings
  FOR UPDATE
  TO authenticated
  USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can delete loadings"
  ON truck_loadings
  FOR DELETE
  TO authenticated
  USING (auth.uid() IS NOT NULL);

CREATE INDEX IF NOT EXISTS idx_truck_loadings_dates ON truck_loadings(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_truck_loadings_status ON truck_loadings(status);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_truck_loadings_updated_at BEFORE UPDATE
  ON truck_loadings FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
