import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://xkzbaaxjdpncfgfflvxa.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhremJhYXhqZHBuY2ZnZmZsdnhhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2NTE1NzcsImV4cCI6MjA3OTIyNzU3N30.EvXHOA8rOv0NyksEpvlz-r-X9chCV7MGWYxWyWFs9ZU';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
