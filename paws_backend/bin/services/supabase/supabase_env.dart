import 'package:supabase/supabase.dart';

class SupabaseEnv {
  final _url = "https://ugyetukhwfmbnopxgjoi.supabase.co";
  final _key =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVneWV0dWtod2ZtYm5vcHhnam9pIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4NTAyNTgyNSwiZXhwIjoyMDAwNjAxODI1fQ.5oAKqfkPEpUt_SkIYDyZ4dXeCY1xBC0Gv_V23KF7o7g";
  final _jwt =
      'DC8kRNBzoH+AJZf6J4GiuSYJf4rMk1395ZG1MmltysZM+lykLJliiKxp3YjXujOkey+Y1w3HkPCHZJQxNx7h2Q==';

  get jwt {
    return _jwt;
  }

  SupabaseClient get supabase {
    return SupabaseClient(_url, _key);
  }
}
