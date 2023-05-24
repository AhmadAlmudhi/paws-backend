import 'package:supabase/supabase.dart';

class SupabaseEnv {
  final _url = "https://vurdjrvrryxroweyouqt.supabase.co";
  final _key =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1cmRqcnZycnl4cm93ZXlvdXF0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4NDIzMDY0MiwiZXhwIjoxOTk5ODA2NjQyfQ.ZUOe6mdifZKciLPMSdSC5FHxbT70spld4gbX2cCDGbI";
  final _jwt =
      'bvEk152DIHg7yQd5a35frDw+jGM5xioKuXe8s1ah98+ducarE+35veK0adPdZBnH2GqCGHhg/R7RDYjIP2KjHQ==';

  get jwt {
    return _jwt;
  }

  SupabaseClient get supabase {
    return SupabaseClient(_url, _key);
  }
}
