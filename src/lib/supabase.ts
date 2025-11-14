import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface TruckLoading {
  id: string;
  truck_id: string;
  cotacao: string;
  quantity: string;
  start_date: string;
  end_date: string;
  carrier: string;
  completed_date?: string;
  is_completed: boolean;
  status: 'pending' | 'completed' | 'cancelled';
  notes?: string;
  created_at: string;
  updated_at: string;
}
